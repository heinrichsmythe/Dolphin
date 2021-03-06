﻿"Filed out from Dolphin Smalltalk 7"!

String variableByteSubclass: #UtfEncodedString
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
UtfEncodedString guid: (GUID fromString: '{f19f0843-d636-4c39-8815-afe452d16cb0}')!
UtfEncodedString isNullTerminated: true!
UtfEncodedString isAbstract: true!
UtfEncodedString comment: '`UtfEncodedString` is the abstract class of variable-width UTF-encoded strings. It has specialised subclasses for UTF-8, and UTF-16.

Like `AnsiString` and (as yet hypothetical) `Utf32String`, the elements of a `UtfEncodedString` are represented by `Character` instances when enumerating or accessing by index, but unlike those fixed-width encodings the values of the elements are really code units rather than whole code points. Consequently the `Character` instances may represent surrogate (partial) characters from the encoding. This is a compromise required to represent the variable-width UTF encodings within the Smalltalk `SequenceableCollection` hierarchy, which was designed  for fixed-width elements long before UTF-8 and UTF-16 were imagined, yet which also requires that the elements of `String`s be `Character`s. ANSI Smalltalk did nothing to address this issue; the `<readableString>` protocol is a sub-protocol of `<sequencedReadableCollection>` and contains many indexed access messages that cannot really be implemented efficiently against a variable width string. Even calculating the result for `#size` would require counting the characters and the count could be invalidated by any `#at:put:` operation, which might also require the string to be resized and its contents shuffled. Given the difficulty of squaring this circle, and the limited scenarios that really require direct indexing into strings, we have opted to interpret the requirement that the elements of strings be `Character`s by including surrogate characters as valid elements. 

In practice, therefore, the implementation of `<readableString>` on `UtfEncodeString`s may return surrogate (partial) characters, for example:
```
	(Character dolphin asUtf16String at: 1) isSurrogate "true"
```
When working with compatible encodings (e.g. two `Utf16String`s), the fact that the standard collection protocols will enumerate multi-part `Character`s as the individual surrogates often does not matter. With mixed encodings you will run into difficulties if trying to use the sequenceable collection block-copy and replace operations, since the number of code units required to represent the same characters may vary between encodings.  Issues may also arise when attempting to perform random access into the string without due regard to the actual character start position. For example the following expression loses the lead byte, resulting in an invalid string:
```
	(Character dolphin asUtf8String copyFrom: 2)
```
In order to enumerate the actual Unicode code points of a `UtfEncodedString` it is necessary to either be prepared to assemble complete code points from surrogate code units, or `Stream`s should be used. In general it is much easier to use streams, and the string streams have efficient primitive operations for working with different string encodings. When streaming over a `UtfEncodedString`, the `#next` and `#nextPut:` messages will return a `Character` representing a whole code point, or store one, respectively. As an example:
```
	multi := Character dolphin asUtf8String.
	multi size. "4"
	stream := multi readStream.
	stream next "$\x1F42C"
	stream position "4"
```
And an example of writing into a `UtfEncodedString`:
```
	stream := Utf8String writeStream.
	stream nextPut: Character dolphin.
	stream position. "4"
	stream contents. 
```
The fact that `Character`s may actually occupy more than one code unit element of a `UtfEncodeString` does give rise to some inconsistencies in both the `Stream` and `String` hierarchies. When working with the `PositionableStream` hierarchy one must be careful when recording or adjusting the position, and remember that relative positioning (e.g. with `#skip:`) always works in terms of the code-unit elements of the streamed over collection, not necessarily whole characters. In the case of `UtfEncodeString`s the underlying elements are code unit integers of 8 or 16 bits for UTF-8 and UTF-16 respectively. The position of a stream over a UtfEncodedString is the position in terms of code units, not Characters. The use of relative positioning either through `#skip:` or by directly adjusting the position to a point calculated without regard to the encoding is likely to lead to positioning errors. It is safe to reset the position to step back (for example) by using a previously recorded position. To advance the stream the next and peek family of messagess should be used unless to a previously recorded position at the start of an encoded character. It is generally not a good idea to mix position or size calculations based on the fixed width code units used as indices and sizes for the collection itself and for the stream position with the variable width code points read and written by the streams. '!
!UtfEncodedString categoriesForClass!Collections-Text! !
!UtfEncodedString methodsFor!

asArray
	"Answer an <Array> whose elements are the Characters of the receiver in the same sequence.
	Note that this may not be of the same size as the receiver as any Characters of the receiver
	represented by multiple code-unit elements of the receiver will be decoded."

	| chars stream ch |
	chars := Array writeStream: self size.
	stream := self readStream.
	[(ch := stream nextAvailable) isNil] whileFalse: [chars nextPut: ch].
	^chars contents!

bom
	"Answer a <ByteArray> which is the byte-order mark for the receiver's encoding."

	^self subclassResponsibility!

copyWith: newElement
	"Answer a <sequencedReadableCollection> which is a copy of 
	the receiver that has newElement concatenated to its end."

	^self, (self class with: newElement)!

decodeFrom: aReadStream upTo: anObject
	"Private - Answer the future sequence values of the <ReadStream>, aReadStream, up to but not including, the <Object>, anObject.
	The stream is left positioned after anObject. If there are no occurrences of anObject in the future sequence values of the
	stream, then the remainder of the future sequence is answered and the stream is left at end."

	^anObject isCharacter
		ifTrue: 
			[anObject isAscii
				ifTrue: [aReadStream basicUpTo: anObject]
				ifFalse: 
					[| newStream ch |
					newStream := self class writeStream: 128.
					[(ch := aReadStream nextAvailable) isNil or: [ch = anObject]] whileFalse: [newStream nextPut: ch].
					^newStream contents]]
		ifFalse: [aReadStream upToEnd]!

emitEncodingMarkerOn: aPositionableStream
	"Emit any encoding marker used for the stream encoding this collection represents onto the
	<PositionableStream> argument, which is assumed to be at the start of its sequence. This
	typically only relevant to string encodings, so there is nothing to do by default."

	self bom do: [:each | aPositionableStream basicNextPut: each]!

encodedAt: anInteger put: aCharacter
	"Private - Encode the specified <Character> beginning at the specified position in the receiver.
	Answer the <integer> index of the last code unit updated."

	^self subclassResponsibility!

encodedSizeOf: anObject
	"Private - Answer the number of basic slots occupied by the argument when encoded in the receiver."

	^self subclassResponsibility!

encodeOn: aWriteStream next: sizeInteger putAll: aSequenceableCollection startingAt: startInteger
	aSequenceableCollection class == self class
		ifTrue: 
			[aWriteStream
				basicNext: sizeInteger
				putAll: aSequenceableCollection
				startingAt: startInteger]
		ifFalse: 
			[startInteger to: startInteger + sizeInteger - 1
				do: [:i | self encodeOn: aWriteStream put: (aSequenceableCollection at: i)]].
	^aSequenceableCollection!

growSize
	"Private - Answer the number of elements by which the receiver should grow, when growing!!
	(at least 2, in case the receiver is currently empty)"

	^self size max: self maxEncoding!

length
	"Answer the number of Unicode code-points in the receiver."

	^self subclassResponsibility!

maxEncoding
	^self subclassResponsibility!

skipEncodingMarkerFrom: aPositionableStream
	"Private - Skip over any encoding marker used for the stream encoding this collection represents on the <PositionableStream> argument, which 
	is assumed to be at the start of its sequence."

	"For UTF-8, we advance over the BOM, if present"

	| anInteger bom |
	bom := self bom.
	anInteger := bom size.
	aPositionableStream size >= bom size
		ifTrue: 
			[| preamble |
			preamble := bom class new: anInteger.
			aPositionableStream
				basicNext: anInteger
				into: preamble
				startingAt: 1.
			preamble = bom ifFalse: [aPositionableStream position: 0]]! !
!UtfEncodedString categoriesFor: #asArray!converting!public! !
!UtfEncodedString categoriesFor: #bom!constants!encode/decode!private! !
!UtfEncodedString categoriesFor: #copyWith:!copying!public! !
!UtfEncodedString categoriesFor: #decodeFrom:upTo:!encode/decode!private! !
!UtfEncodedString categoriesFor: #emitEncodingMarkerOn:!accessing!public! !
!UtfEncodedString categoriesFor: #encodedAt:put:!accessing!encode/decode!private! !
!UtfEncodedString categoriesFor: #encodedSizeOf:!encode/decode!private! !
!UtfEncodedString categoriesFor: #encodeOn:next:putAll:startingAt:!encode/decode!private! !
!UtfEncodedString categoriesFor: #growSize!accessing!private! !
!UtfEncodedString categoriesFor: #length!accessing!public! !
!UtfEncodedString categoriesFor: #maxEncoding!constants!private! !
!UtfEncodedString categoriesFor: #skipEncodingMarkerFrom:!encode/decode!private! !

!UtfEncodedString class methodsFor!

codePage
	"Answer the Windows code page constant for the receiver's encoding."

	^self subclassResponsibility!

new: anInteger withAll: aCharacter
	"Answer a new instance of the receiver with <integer>, anInteger, elements, each of which is initialized to the <Character>, aCharacter.
	Note that the result will be of size elementCount * codeUnitsFor(elementValue)."

	| stream |
	stream := self writeStream: anInteger.
	anInteger timesRepeat: [stream nextPut: aCharacter].
	^stream contents! !
!UtfEncodedString class categoriesFor: #codePage!constants!public! !
!UtfEncodedString class categoriesFor: #new:withAll:!instance creation!public! !

