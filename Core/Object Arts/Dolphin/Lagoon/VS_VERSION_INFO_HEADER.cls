﻿"Filed out from Dolphin Smalltalk 7"!

Win32Structure subclass: #VS_VERSION_INFO_HEADER
	instanceVariableNames: 'key valueOffset'
	classVariableNames: '_OffsetOf_wLength _OffsetOf_wType _OffsetOf_wValueLength'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
VS_VERSION_INFO_HEADER guid: (GUID fromString: '{efc64c05-aa07-41b8-ba73-60f7974c6e3f}')!
VS_VERSION_INFO_HEADER addClassConstant: '_OffsetOf_wLength' value: 16r0!
VS_VERSION_INFO_HEADER addClassConstant: '_OffsetOf_wType' value: 16r4!
VS_VERSION_INFO_HEADER addClassConstant: '_OffsetOf_wValueLength' value: 16r2!
VS_VERSION_INFO_HEADER comment: 'VS_VERSION_INFO_HEADER is an ExternalStructure class to represent the headers for version resource blocks. It is not a real Win32 structure.

See the VersionResource class.'!
!VS_VERSION_INFO_HEADER categoriesForClass!External-Data-Structured-Win32! !
!VS_VERSION_INFO_HEADER methodsFor!

childrenOffset
	"Answer the offset into the resource block pointed at by the receiver at which the 
	children start (if any - not all version blocks have children)."

	^(self valueOffset + self wValueLength) roundUpTo: 4!

key
	"Answer the <readableString> key of this version info block."

	key isNil ifTrue: [
		key := self szKey].
	^key!

szKey
	^Utf16String fromAddress: self yourAddress asInteger + 6!

valueBytes
	"Answer a <ByteArray> containing the value of this version info block."

	^ByteArray 
		fromAddress: self yourAddress asInteger + self valueOffset 
		length: self wValueLength!

valueDWORDs
	"Answer a <DWORDArray> containing the values of the receiver (assumes this is a Var block)."

	^DWORDArray fromAddress: self yourAddress asInteger + self valueOffset length: self wValueLength//4!

valueOffset
	"Answer the offset into the resource block pointed at by the receiver at which the value
	starts."

	valueOffset isNil ifTrue: [
		valueOffset := (self class byteSize + ((self key size+1)*2)) roundUpTo: 4].
	^valueOffset!

valueString
	"Answer the <Utf16String> value of the receiver (assumes this is a String block).
	Note that the string will be zero terminated if non-empty."

	| words |
	"wValueLength is in words (i.e. 16-bit units), not bytes. See https://msdn.microsoft.com/en-us/library/windows/desktop/ms646987(v=vs.85).aspx"
	words := self wValueLength.
	^words == 0
		ifTrue: [Utf16String new]
		ifFalse: [Utf16String fromAddress: self yourAddress asInteger + self valueOffset length: words - 1]!

wLength
	"Answer the <Integer> value of the receiver's 'wLength' field."

	^bytes wordAtOffset: _OffsetOf_wLength!

wType
	"Answer the <Integer> value of the receiver's 'wType' field."

	^bytes wordAtOffset: _OffsetOf_wType!

wValueLength
	"Answer the <Integer> value of the receiver's 'wValueLength' field."

	^bytes wordAtOffset: _OffsetOf_wValueLength! !
!VS_VERSION_INFO_HEADER categoriesFor: #childrenOffset!accessing!public! !
!VS_VERSION_INFO_HEADER categoriesFor: #key!accessing!public! !
!VS_VERSION_INFO_HEADER categoriesFor: #szKey!accessing!private! !
!VS_VERSION_INFO_HEADER categoriesFor: #valueBytes!accessing!public! !
!VS_VERSION_INFO_HEADER categoriesFor: #valueDWORDs!accessing!public! !
!VS_VERSION_INFO_HEADER categoriesFor: #valueOffset!accessing!public! !
!VS_VERSION_INFO_HEADER categoriesFor: #valueString!accessing!public! !
!VS_VERSION_INFO_HEADER categoriesFor: #wLength!**compiled accessors**!public! !
!VS_VERSION_INFO_HEADER categoriesFor: #wType!**compiled accessors**!public! !
!VS_VERSION_INFO_HEADER categoriesFor: #wValueLength!**compiled accessors**!public! !

!VS_VERSION_INFO_HEADER class methodsFor!

defineFields
	"Private - Define the layout of the Win32 VS_VERSION_INFO_HEADER structure.
	
		self compileDefinition
	"
 
	self
		defineField: #wLength type: WORDField readOnly;
		defineField: #wValueLength type: WORDField readOnly;
		defineField: #wType type: WORDField readOnly
		"All other fields are of variable length"!

getFieldNames
	^#(#wLength #wValueLength #wType)! !
!VS_VERSION_INFO_HEADER class categoriesFor: #defineFields!initializing!private! !
!VS_VERSION_INFO_HEADER class categoriesFor: #getFieldNames!**compiled accessors**!constants!private! !

