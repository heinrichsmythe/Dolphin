﻿"Filed out from Dolphin Smalltalk 7"!

UtfEncodedString variableByteSubclass: #Utf16String
	instanceVariableNames: ''
	classVariableNames: 'Bom LeadOffset SurrogateOffset'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
Utf16String guid: (GUID fromString: '{87b4c51e-026e-11d3-9fd7-00a0cc3e4a32}')!
Utf16String isNullTerminated: true!
Utf16String addClassConstant: 'Bom' value: #[255 254 ]!
Utf16String addClassConstant: 'LeadOffset' value: 55232!
Utf16String addClassConstant: 'SurrogateOffset' value: 56613888!
Utf16String comment: 'Utf16String is the class of <Strings>s that use a the two or four byte UTF-16 LE encoding. UTF-16 is the standard encoding used for strings in the Windows APIs. Most of the time it is not necessary to worry about converting to UTF-16, however, since the class library and VM will normally be able to provide automatic conversions when required. However, it is recommended that Utf8String be used internally for all strings, and that conversion to/from UTF-16 be performed at interface boundaries where necessary.

The cautionary notes in the abstract superclass (UtfEncodedString) should be read carefully to understand the compromises made in introducing a variable width encoding into the SequenceableCollection hierarchy.'!
!Utf16String categoriesForClass!Collections-Text! !
!Utf16String methodsFor!

_beginsString: aString
	^(CRTLibrary default
		wcsncmp: aString asUtf16String
		string2: self
		count: self size) == 0!

asByteString: aClass
	"Private - Answer a byte-string encoded <String> of the specified class containing the same characters as the receiver."

	| bytes buf size |
	(size := self size) == 0 ifTrue: [^aClass empty].	"Avoid 'The Parameter is Incorrect' error"
	buf := aClass new: size * 4.
	bytes := KernelLibrary default
				wideCharToMultiByte: aClass codePage
				dwFlags: 0
				lpWideCharStr: self
				cchWideChar: size
				lpMultiByteStr: buf
				cchMultiByte: buf size
				lpDefaultChar: nil
				lpUsedDefaultChar: nil.
	bytes == 0 ifTrue: [^KernelLibrary default systemError].
	buf resize: bytes.
	^buf!

asLowercase
	"Answer a <readableString> which is a copy of the receiver but with the contents converted
	to lowercase."

	| copy |
	copy := self copy.
	UserLibrary default charLowerBuffW: copy cchLength: copy size.
	^copy!

asSymbol
	^Symbol intern: self asUtf8String!

asUppercase
	"Answer a <readableString> which is a copy of the receiver but with the contents converted
	to uppercase."

	| copy |
	copy := self copy.
	UserLibrary default charUpperBuffW: copy cchLength: copy size.
	^copy!

asUtf16String
	"Answer a UTF16-encoded equivalent of the receiver."

	^self!

at: anInteger
	"Answer the character at index, anInteger, in the receiver."

	<primitive: 63>
	^Character utf16Value: (self wordAtOffset: anInteger + anInteger - 2)!

bom
	^Bom!

byteSize
	"Private - Answer the size in bytes of this object, including the null terminator."

	^(self basicSize + 1) << 1!

copyToBuffer: anAddress ofSize: anInteger
	CRTLibrary default
		wcsncpy_s: anAddress
		bufferSize: anInteger
		strSource: self
		count: CRTConstants._TRUNCATE!

decodeNextFrom: aReadStream
	"Private - Read the next <Character> in the receiver's encoding from the <ReadStream> argument, which
	is assumed to be over a Utf16String (or a stream over a double-byte object) ."

	^aReadStream basicNextAvailable
		ifNotNil: 
			[:c |
			^(c bitAnd: 16rFFFFC00) == 16rD800
				ifTrue: 
					["Lead surrogate encountered"
					aReadStream basicNextAvailable
						ifNil: 
							["Lead surrogate but no trailing surrogate, answer the replacement character"
							Character replacement]
						ifNotNil: 
							[:c2 |
							(c2 bitAnd: 16rFFFFFC00) == 16rDC00
								ifTrue: 
									["Valid surrogate pair"
									Character codePoint: (c << 10) + c2 - SurrogateOffset]
								ifFalse: 
									["No trailing surrogate, answer the replacement character"
									aReadStream pop.
									Character replacement]]]
				ifFalse: [Character utf16Value: c]]!

displayOn: aStream
	"Append the receiver in end-user form to aStream.
	We must convert to mbcs for display."

	aStream nextPutAll: self asString!

encodedAt: anInteger put: aCharacter
	"Private - Encode the specified <Character> beginning at the specified position in the receiver.
	Answer the <integer> index of the last code unit updated."

	| codePoint |
	codePoint := aCharacter asInteger.
	^codePoint <= 16rFFFF
		ifTrue: 
			[self basicAt: anInteger put: codePoint.
			anInteger]
		ifFalse: 
			[codePoint <= Win32Constants.MAX_UCSCHAR
				ifTrue: 
					[codePoint := codePoint - 16r10000.
					self
						basicAt: anInteger put: (codePoint bitShift: -10) + 16rD800;
						basicAt: anInteger + 1 put: (codePoint bitAnd: 16r3FF) + 16rDC00.
					anInteger + 1]
				ifFalse: [self class errorInvalidCodePoint: codePoint]]!

encodedSizeOf: aCharacter
	"Private - Answer the number of basic slots occupied by the argument when encoded in the receiver."

	^aCharacter codePoint <= 16rFFFF ifTrue: [1] ifFalse: [2]!

encodeOn: aPuttableStream put: aCharacter
	"Private - Encode the <Character> argument onto the <WriteStream> argument using the UTF-16
	encoding. This requires either one or two 2-byte code units be written to the stream, depending
	on whether the code point is in the basic multi-lingual plane (one code unit), or beyond the BMP
	(two code units). An error is raised if the <Character> has an invalid code point."

	| codePoint |
	codePoint := aCharacter codePoint.
	^codePoint <= 16rFFFF
		ifTrue: [aPuttableStream basicNextPut: codePoint]
		ifFalse: 
			[codePoint <= Win32Constants.MAX_UCSCHAR
				ifTrue: 
					[#todo.	"http://www.unicode.org/faq/utf_bom.html suggests there might be a simpler (more efficient) calculation, but it looks incorrect to me"
					codePoint := codePoint - 16r10000.
					aPuttableStream
						basicNextPut: (codePoint bitShift: -10) + 16rD800;
						basicNextPut: (codePoint bitAnd: 16r3FF) + 16rDC00]
				ifFalse: [self class errorInvalidCodePoint: codePoint]]!

findString: aString startingAt: anInteger 
	"Answer the index of the <String> argument within the receiver, starting at the <integer>
	argument. If the receiver does not contain aString, answer 0."

	| size subSize firstElement |
	subSize := aString size.
	subSize == 0 ifTrue: [^0].
	firstElement := aString at: 1.
	size := self size.
	subSize == 1 
		ifTrue: 
			[^self 
				nextIndexOf: firstElement
				from: anInteger
				to: size].
	anInteger to: size - subSize + 1
		do: 
			[:i | 
			(self at: i) = firstElement 
				ifTrue: 
					[| j |
					j := 2.
					[(self at: i + j - 1) = (aString at: j)] whileTrue: 
							[j = subSize ifTrue: [^i].
							j := j + 1]]].
	^0!

indexOfSubCollection: targetSequence startingAt: start 
	"Answer the <integer> index of the next occurrence within the 
	receiver of the <sequencedReadableCollection> targetSequence,
	starting at the <integer> index start. If there are no such occurrences
	(or the search sequence is empty), answer 0."

	^self findString: targetSequence startingAt: start!

maxEncoding
	^2!

nextIdentityIndexOf: anElement from: start to: stop
	"Answer the index of the next occurrence of anElement in the receiver's indexable
	variables between startIndex and stopIndex inclusive. If there are no such occurrences, answer 0."

	#todo.	"Remove when primitive is fixed"
	start to: stop do: [:i | (self at: i) = anElement ifTrue: [^i]].
	^0!

nextIndexOf: anElement from: start to: stop
	"Answer the index of the next occurrence of anElement in the receiver between 
	startIndex and stopIndex inclusive. If there are no such occurrences, answer 0."

	| codePoint |
	anElement class ~~ Character
		ifTrue: 
			["Strings can only contain Characters"
			^0].
	codePoint := anElement codePoint.
	codePoint < 16r80
		ifTrue: 
			[^self
				nextIdentityIndexOf: anElement
				from: start
				to: stop].
	codePoint <= 16rFFFF
		ifTrue: 
			[anElement isUtf8Surrogate
				ifFalse: [start to: stop do: [:i | (self at: i) = anElement ifTrue: [^i]]].
			^0]
		ifFalse: 
			[| lead trail current |
			codePoint := codePoint - 16r10000.
			lead := Character utf16Value: (codePoint bitShift: -10) + 16rD800.
			trail := Character utf16Value: (codePoint bitAnd: 16r3FF) + 16rDC00.
			current := self
						nextIndexOf: lead
						from: start
						to: stop - 1.
			[current ~~ 0 and: [current < stop and: [(self at: current + 1) ~= trail]]] whileTrue: 
					[current := self
								nextIndexOf: lead
								from: current + 1
								to: stop - 1].
			^current]!

replaceFrom: startInteger to: stopInteger with: aReadableString startingAt: startAtInteger
	"Replace the characters of the receiver at index positions startInteger through stopInteger
	inclusive with consecutive characters of the <readableString>, aReadableString, beginning at
	index position startAtInteger. Answer the receiver."

	| offset |
	#todo.	"Fix the block copy primitive to work with double-byte objects, then this can be removed."
	offset := startAtInteger - startInteger.
	"Perform overlapping moves backwards, otherwise forwards"
	(self == aReadableString and: [startAtInteger < startInteger])
		ifTrue: 
			[stopInteger to: startInteger
				by: -1
				do: [:i | self at: i put: (aReadableString at: offset + i)]]
		ifFalse: [startInteger to: stopInteger do: [:i | self at: i put: (aReadableString at: offset + i)]]!

resize: anInteger
	^super resize: anInteger * 2!

reverse
	"Answer a copy of the receiver but with its elements in reverse order."

	| reversed i j size |
	j := size := self size.
	reversed := self species new: size.
	i := 1.
	[i <= size] whileTrue: 
			[| ch |
			ch := self at: i.
			ch isSurrogate
				ifTrue: 
					[reversed
						at: j put: (self at: i + 1);
						at: j - 1 put: ch.
					j := j - 2.
					i := i + 2]
				ifFalse: 
					[reversed at: j put: ch.
					i := i + 1.
					j := j - 1]].
	^reversed!

shallowCopy
	"Implemented here to ensure that copied Utf16Strings are correctly terminated with a double null"

	^self class fromAddress: self yourAddress length: self size!

skipEncodingMarkerFrom: aGettableStream
	"Private - Skip over any encoding marker used for the stream encoding this collection represents on the <gettableStream> argument, which 
	is assumed to be at the start of its sequence."

	^Error notYetImplemented!

stbSaveOn: anSTBOutFiler
	"At present this is needed because STB doesn't work correctly with double-byte objects. It
	is may be desirable, anyway, to save as UTF-8 to save space, and the intention is that
	Utf8String and Utf16String instances be largely interchangeable."

	^self asUtf8String stbSaveOn: anSTBOutFiler!

strcspn: aString start: anInteger
	^CRTLibrary default wcscspn: self yourAddress + ((anInteger - 1) * 2)
		strCharSet: aString asUtf16String!

strlen
	"Answer the length of the receiver (in characters) up to the first null terminator. This may
	be less than its size if it contains embedded nulls. It can never be greater than the
	receiver's size."

	^KernelLibrary default lstrlenW: self!

wordAtOffset: anInteger
	"Private - Answer the unsigned 2 byte integer at offset (i.e. zero relative) anInteger in the receiver. 
	On iX86 the high and low order bytes are reversed; i.e. the bytes are ordered least 
	significant first.

	Primitive failure reasons:
		0 -	anInteger is not a SmallInteger.
		1 -	anInteger is out of bounds."

	| answer |
	<primitive: 124>
	answer := 0.
	2 to: 1 by: -1 do: [:i |
		answer := (answer bitShift: 8) + (self basicAt: anInteger + i)].
	^answer!

wordAtOffset: anInteger put: anObject
	"Private - Store an unsigned 16-bit value at byte offset anInteger within the receiver.
	If anObject is not representable as a 16-bit unsigned (Small)Integer, then 
	raise a 'cannot hold' error.

	Primitive failure reasons:
		0 -	anInteger is not a SmallInteger.
		1 -	anInteger is out of bounds.
		2 -	anObject is not a SmallInteger
		3 -	anObject is not in the range -32768..32767 (i.e. out of signed 16-bit range)."

	<primitive: 125>
	^self primitiveFailed! !
!Utf16String categoriesFor: #_beginsString:!comparing!double dispatch!private! !
!Utf16String categoriesFor: #asByteString:!converting!private! !
!Utf16String categoriesFor: #asLowercase!converting!public! !
!Utf16String categoriesFor: #asSymbol!converting!public! !
!Utf16String categoriesFor: #asUppercase!converting!public! !
!Utf16String categoriesFor: #asUtf16String!converting!public! !
!Utf16String categoriesFor: #at:!accessing!public! !
!Utf16String categoriesFor: #bom!constants!encode/decode!private! !
!Utf16String categoriesFor: #byteSize!accessing!private! !
!Utf16String categoriesFor: #copyToBuffer:ofSize:!copying!private! !
!Utf16String categoriesFor: #decodeNextFrom:!encode/decode!private! !
!Utf16String categoriesFor: #displayOn:!printing!public! !
!Utf16String categoriesFor: #encodedAt:put:!accessing!encode/decode!private! !
!Utf16String categoriesFor: #encodedSizeOf:!encode/decode!private! !
!Utf16String categoriesFor: #encodeOn:put:!encode/decode!private! !
!Utf16String categoriesFor: #findString:startingAt:!public!searching! !
!Utf16String categoriesFor: #indexOfSubCollection:startingAt:!public!searching! !
!Utf16String categoriesFor: #maxEncoding!constants!private! !
!Utf16String categoriesFor: #nextIdentityIndexOf:from:to:!public!searching! !
!Utf16String categoriesFor: #nextIndexOf:from:to:!public!searching! !
!Utf16String categoriesFor: #replaceFrom:to:with:startingAt:!public!replacing! !
!Utf16String categoriesFor: #resize:!mutating!public! !
!Utf16String categoriesFor: #reverse!copying!public! !
!Utf16String categoriesFor: #shallowCopy!copying!public! !
!Utf16String categoriesFor: #skipEncodingMarkerFrom:!encode/decode!private! !
!Utf16String categoriesFor: #stbSaveOn:!binary filing!public! !
!Utf16String categoriesFor: #strcspn:start:!private!searching! !
!Utf16String categoriesFor: #strlen!accessing!private! !
!Utf16String categoriesFor: #wordAtOffset:!accessing!primitives!private! !
!Utf16String categoriesFor: #wordAtOffset:put:!accessing!primitives!private! !

!Utf16String class methodsFor!

codePage
	"Answer the Windows code page constant for the receiver's encoding."

	"Note: This is not a real code page, and cannot be used with most APIs expecting a code page
	identifier. It's main purpose is to distinguish UTF-16 in some circumstances."

	^Win32Constants.CP_UNICODE!

elementSize
	"Answer the size of the elements of the receiver in bytes."

	^2!

fromAddress: anAddress
	"Answer a new String instantiated from the null terminated string at anAddress."

	| len |
	len := KernelLibrary default lstrlenW: anAddress.
	^self fromAddress: anAddress length: len!

fromAddress: anAddress length: anInteger
	"Answer a new <Utf16String>, of length anInteger, copied from the first anInteger
	code units pointed at by anAddress."

	^anAddress isNull
		ifFalse: 
			[| answer |
			answer := self new: anInteger.
			anAddress asExternalAddress
				replaceBytesOf: answer
				from: 1
				to: anInteger * 2
				startingAt: 1.
			answer]!

fromAtomId: anInteger
	"Answer a new string which is a copy of the atom with id anInteger."

	| atomName |
	^(atomName := self new: 255)
		leftString: (KernelLibrary default getAtomName: anInteger lpBuffer: atomName nSize: atomName size)!

fromBytes: aByteArray codePage: anInteger
	"Answer an instance of the receiver constructed from the specified byte-string assumed to be encoded per the specified code page."

	| kernel cch cb answer |
	kernel := KernelLibrary default.
	cb := aByteArray size.
	cb = 0 ifTrue: [^self empty].
	cch := kernel
				multiByteToWideChar: anInteger
				dwFlags: 0
				lpMultiByteStr: aByteArray
				cchMultiByte: cb
				lpWideCharStr: nil
				cchWideChar: 0.
	cch <= 0 ifTrue: [^kernel systemError].
	answer := self new: cch.
	kernel
		multiByteToWideChar: anInteger
		dwFlags: 0
		lpMultiByteStr: aByteArray
		cchMultiByte: cb
		lpWideCharStr: answer
		cchWideChar: cch.
	^answer!

fromString: aString
	"Answer an instance of the receiver containing the same characters as the <String>
	argument."

	^aString asUtf16String!

fromUtf16String: anAddressOrUtf16String
	"Answer a new instance of the receiver which is a copy of the the UTF-16 string pointed at by the argument."

	^self fromAddress: anAddressOrUtf16String yourAddress!

initialize
	empty := self new
				isImmutable: true;
				yourself.
	VMLibrary default registryAt: #Utf16String put: self.
	self extraInstanceSpec: EncodingUtf16.
	self addClassConstant: 'LeadOffset' value: 16rD800 - (16r10000 >> 10).
	self addClassConstant: 'SurrogateOffset' value: (16rD800 << 10) + 16rDC00 - 16r10000.
	self addClassConstant: 'Bom' value: #[255 254]
!

with: aCharacter
	"Answer a new instance of the receiver containing the single <Character> element,
	aCharacter."

	| cp |
	^(cp := aCharacter codePoint) <= 16rFFFF
		ifTrue: 
			[(self new: 1)
				basicAt: 1 put: cp;
				yourself]
		ifFalse: 
			[(self new: 2)
				encodedAt: 1 put: cp;
				yourself]! !
!Utf16String class categoriesFor: #codePage!constants!public! !
!Utf16String class categoriesFor: #elementSize!constants!public! !
!Utf16String class categoriesFor: #fromAddress:!instance creation!public! !
!Utf16String class categoriesFor: #fromAddress:length:!instance creation!public! !
!Utf16String class categoriesFor: #fromAtomId:!instance creation!public! !
!Utf16String class categoriesFor: #fromBytes:codePage:!instance creation!public! !
!Utf16String class categoriesFor: #fromString:!instance creation!public! !
!Utf16String class categoriesFor: #fromUtf16String:!instance creation!public! !
!Utf16String class categoriesFor: #initialize!development!initializing!public! !
!Utf16String class categoriesFor: #with:!instance creation!public! !
