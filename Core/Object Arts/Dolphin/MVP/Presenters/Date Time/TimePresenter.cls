﻿"Filed out from Dolphin Smalltalk 7"!

ValuePresenter subclass: #TimePresenter
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
TimePresenter guid: (GUID fromString: '{87b4c6d3-026e-11d3-9fd7-00a0cc3e4a32}')!
TimePresenter comment: 'TimePresenter is a <valuePresenter> that displays a <valueModel> onto <Time> value. A TimePresenter can be connected to any <valueView> capable of displaying <Time> values. When the ''Dolphin DateTimePicker Control'' package is installed this will be a <DateTimePicker>, but alternative views may be chosen with the installation of an appropriate <typeConverter>.'!
!TimePresenter categoriesForClass!MVP-Presenters!MVP-Resources-Time fields! !
!TimePresenter class methodsFor!

defaultView
	^'Picker view'!

icon
	"Answers an Icon that can be used to represent this class"

	^##(self) defaultIcon!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.TextEdit) 34 16 nil nil 34 2 8 1140916224 1025 416 nil 786694 ##(Smalltalk.ColorDefault) 8 4278190080 nil 5 nil nil nil 416 nil 8 1915280032 656134 ##(Smalltalk.TimeToText) nil nil nil 1 983302 ##(Smalltalk.MessageSequence) 138 144 34 1 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 328198 ##(Smalltalk.Point) 11 11 690 261 39 416 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 5 0 0 0 5 0 0 0 135 0 0 0 24 0 0 0] 8 #() 690 193 193 nil 27 )! !
!TimePresenter class categoriesFor: #defaultView!constants!public!views! !
!TimePresenter class categoriesFor: #icon!constants!public! !
!TimePresenter class categoriesFor: #resource_Default_view!public!resources-views! !

