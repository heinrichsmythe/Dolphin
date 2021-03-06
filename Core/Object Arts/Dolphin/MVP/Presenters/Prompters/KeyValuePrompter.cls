﻿"Filed out from Dolphin Smalltalk 7"!

Dialog subclass: #KeyValuePrompter
	instanceVariableNames: 'promptPresenter keyPresenter valuePresenter validationBlock'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
KeyValuePrompter guid: (GUID fromString: '{a84461c7-be36-46c1-be33-5752489de6e5}')!
KeyValuePrompter comment: 'KeyValuePrompter is a <dialogPresenter> that can be used to prompt a user to enter or edit key-value pair strings in response to a question.

Instance Variables:
	promptPresenter	<TextPresenter> holding the prompt text.
	keyPresenter		<TextPresenter> holding the key text.
	valuePresenter	<TextPresenter> holding the value text.
	validationBlock	<dyadicValuable> evaluated to validate the key-value pair
'!
!KeyValuePrompter categoriesForClass!MVP-Prompters! !
!KeyValuePrompter methodsFor!

createComponents
	"Create the presenters contained by the receiver."

	super createComponents.
	promptPresenter := self add: TextPresenter new name: 'prompt'.
	keyPresenter := self add: TextPresenter new name: 'key'.
	valuePresenter := self add: TextPresenter new name: 'value'!

initialize
	"Private - Initialize the receiver"

	super initialize.
	validationBlock := [:key :value | true]!

model: pairSubjectModel 
	| buf |
	super model: pairSubjectModel.
	buf := self model.
	keyPresenter model: (buf aspectValue: #key).
	valuePresenter model: (buf aspectValue: #value)!

prompt: aString
	"Set the text to use as the description in the dialog box."

	promptPresenter value: aString
!

queryCommand: aCommandQuery 
	"Private - Enters details about a potential command for the receiver into 
	the <CommandQuery>."

	aCommandQuery commandSymbol == #ok 
		ifTrue: 
			[aCommandQuery 
				isEnabled: (self validationBlock value: keyPresenter value value: valuePresenter value) == true.
			^true].
	^super queryCommand: aCommandQuery!

validationBlock
	^validationBlock!

validationBlock: aDyadicValuable 
	validationBlock := aDyadicValuable! !
!KeyValuePrompter categoriesFor: #createComponents!initializing!public! !
!KeyValuePrompter categoriesFor: #initialize!initializing!private! !
!KeyValuePrompter categoriesFor: #model:!accessing!public! !
!KeyValuePrompter categoriesFor: #prompt:!accessing!public! !
!KeyValuePrompter categoriesFor: #queryCommand:!commands!private! !
!KeyValuePrompter categoriesFor: #validationBlock!accessing!public! !
!KeyValuePrompter categoriesFor: #validationBlock:!accessing!public! !

!KeyValuePrompter class methodsFor!

createOn: pairValueModel prompt: promptString caption: captionStringOrNil 
	"Creates an instance of the receiver on pairValueModel and promptString. The prompter is
	given a caption according to captionStringOrNil; if nil a default caption is used.. The
	initial value of the reply field will be the original value of the model The model must
	expose #key and #value aspects, e.g. an Association. The dialog is not shown."

	| answer |
	answer := self createOn: pairValueModel.
	answer prompt: promptString.
	captionStringOrNil notNil ifTrue: [answer caption: captionStringOrNil].
	^answer!

icon
	"Answers an Icon that can be used to represent this class and which is displayed in the
	caption of the dialog box."

	^Icon fromId: '!!APPLICATION'!

on: pairValueModel prompt: promptString caption: captionStringOrNil 
	"Creates an instance of the receiver on pairValueModel and promptString. The prompter is
	given a caption according to captionStringOrNil; if nil a default caption is used. The
	prompter is displayed modally, prompting for a key-value pair reply. The initial value of
	the reply field is the original value of the model The model must expose #key and #value
	aspects, e.g. an Association.

	Answer the reply or nil if the dialog is cancelled."

	^(self 
		createOn: pairValueModel
		prompt: promptString
		caption: captionStringOrNil) showModal!

prompt: promptString 
	"Creates an instance of the receiver with the specified prompt string and a default caption.
	The prompter is displayed modally, prompting for a key-value pair reply.

	Answer the reply or nil if the dialog is cancelled"

	^self prompt: promptString caption: nil!

prompt: promptString caption: captionStringOrNil 
	"Creates an instance of the receiver with the specified prompt string and caption.. If the
	captionStringOrNil is nil then a default caption is used. The prompter is displayed modally,
	prompting for a key-value pair reply.

	Answer the reply or nil if the dialog is cancelled."

	^self 
		on: Association new
		prompt: promptString
		caption: captionStringOrNil!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.DialogView) 34 30 nil nil 8 #(13107200 65536) 416 nil 655878 ##(Smalltalk.ThemeColor) #dialog nil 133 nil 263174 ##(Smalltalk.Font) nil true 524550 ##(Smalltalk.LOGFONTW) 8 #[244 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 83 0 101 0 103 0 111 0 101 0 32 0 85 0 73 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 328198 ##(Smalltalk.Point) 193 193 nil 416 788230 ##(Smalltalk.BorderLayout) 1 1 nil 410 ##(Smalltalk.ReferenceView) 34 14 nil 416 34 2 8 1140850688 131073 640 nil nil nil 5 nil nil nil 640 1180230 1 ##(Smalltalk.ResourceIdentifier) ##(Smalltalk.Presenter) #resource_OK_Cancel_button_block nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 1 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 578 21 251 578 539 63 640 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 125 0 0 0 23 1 0 0 156 0 0 0] 8 #() 578 193 193 nil 27 nil nil 410 ##(Smalltalk.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 960 nil nil nil 5 nil nil nil 960 852230 ##(Smalltalk.FramingLayout) 170 176 34 10 410 ##(Smalltalk.StaticText) 34 16 nil 960 34 2 8 1140850944 1 1088 nil nil nil 5 nil nil nil 1088 nil 8 1915124368 852486 ##(Smalltalk.NullConverter) nil nil nil 738 138 144 34 2 802 #createAt:extent: 34 2 578 21 91 578 91 41 1088 802 #text: 34 1 8 'Name:' 1088 882 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 45 0 0 0 55 0 0 0 65 0 0 0] 8 #() 944 nil 27 1181766 2 ##(Smalltalk.FramingConstraints) 1180678 ##(Smalltalk.FramingCalculation) #fixedParentLeft 21 1442 #fixedViewLeft 91 1442 #fixedPreviousBottom 21 1442 #fixedViewTop 41 410 ##(Smalltalk.TextEdit) 34 16 nil 960 34 2 8 1140916352 1025 1520 nil 786694 ##(Smalltalk.ColorDefault) 8 4278190080 nil 5 nil nil nil 1520 nil 8 1915280032 1170 nil nil 1 738 138 144 34 2 802 #createAt:extent: 34 2 578 131 83 578 409 45 1520 802 #setMarginWidths: 34 1 8 #(3 3) 1520 882 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 65 0 0 0 41 0 0 0 13 1 0 0 63 0 0 0] 8 #() 944 nil 27 1410 1442 #fixedPreviousRight 21 1442 #fixedParentRight 11 1442 #fixedPreviousTop -7 1504 45 410 ##(Smalltalk.StaticText) 34 16 nil 960 34 2 8 1140850944 1 1936 nil nil nil 5 nil nil nil 1936 nil 8 1915124368 1170 nil nil nil 738 138 144 34 2 802 #createAt:extent: 34 2 578 25 163 578 77 41 1936 802 #text: 34 1 8 'Value:' 1936 882 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 12 0 0 0 81 0 0 0 50 0 0 0 101 0 0 0] 8 #() 944 nil 27 1410 1456 25 1472 77 1488 37 1504 41 410 ##(Smalltalk.TextEdit) 34 16 nil 960 34 2 8 1140916352 1025 2256 nil 1600 nil 5 nil nil nil 2256 nil 8 1915280032 1170 nil nil 1 738 138 144 34 2 802 #createAt:extent: 34 2 578 131 155 578 409 45 2256 802 #setMarginWidths: 34 1 8 #(3 3) 2256 882 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 65 0 0 0 77 0 0 0 13 1 0 0 99 0 0 0] 8 #() 944 nil 27 1410 1888 31 1904 11 1920 -7 1504 45 410 ##(Smalltalk.StaticText) 34 16 nil 960 34 2 8 1140850944 1 2576 721990 2 ##(Smalltalk.ValueHolder) nil nil 1114118 ##(Smalltalk.NeverSearchPolicy) 8 '' nil nil 5 nil nil nil 2576 nil 8 1915124368 1170 nil nil true 738 138 144 34 1 802 #createAt:extent: 34 2 578 21 21 578 509 51 2576 882 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 10 0 0 0 8 1 0 0 35 0 0 0] 8 #() 944 nil 27 1410 1456 21 1904 1 1442 #fixedParentTop 21 1504 51 170 192 34 6 2576 8 'prompt' 1520 8 'key' 2256 8 'value' 590342 ##(Smalltalk.Rectangle) 578 1 1 578 11 1 738 138 144 34 1 802 #createAt:extent: 34 2 578 21 21 578 539 231 960 882 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 10 0 0 0 23 1 0 0 125 0 0 0] 34 5 2576 1088 1520 1936 2256 944 nil 27 170 192 928 3026 578 21 21 578 21 21 nil nil nil nil 11755 nil nil nil nil 1 nil nil 590598 ##(Smalltalk.Semaphore) nil nil 1 nil 8 2011052416 738 138 144 34 3 802 #createAt:extent: 34 2 578 1615 875 578 611 411 416 802 #text: 34 1 8 'Please respond:' 416 802 #updateMenuBar 928 416 882 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 39 3 0 0 181 1 0 0 88 4 0 0 130 2 0 0] 34 2 960 640 944 nil 27 )! !
!KeyValuePrompter class categoriesFor: #createOn:prompt:caption:!instance creation!public! !
!KeyValuePrompter class categoriesFor: #icon!constants!public! !
!KeyValuePrompter class categoriesFor: #on:prompt:caption:!instance creation!public! !
!KeyValuePrompter class categoriesFor: #prompt:!instance creation!public! !
!KeyValuePrompter class categoriesFor: #prompt:caption:!instance creation!public! !
!KeyValuePrompter class categoriesFor: #resource_Default_view!public!resources-views! !

