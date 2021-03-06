﻿"Filed out from Dolphin Smalltalk 7"!

VariableRefactoring subclass: #CreateAccessorsForVariableRefactoring
	instanceVariableNames: 'getterMethod setterMethod classVariable needsReturn'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
CreateAccessorsForVariableRefactoring guid: (GUID fromString: '{c3f653b0-6efe-4cb6-a2a6-781aac3447ec}')!
CreateAccessorsForVariableRefactoring comment: ''!
!CreateAccessorsForVariableRefactoring categoriesForClass!Refactory-Refactorings! !
!CreateAccessorsForVariableRefactoring methodsFor!

classVariable: aBoolean 
	classVariable := aBoolean!

createGetterAccessor
	getterMethod := self findGetterMethod.
	getterMethod isNil ifTrue: [getterMethod := self defineGetterMethod]!

createSetterAccessor
	setterMethod := self findSetterMethod.
	setterMethod isNil ifTrue: [setterMethod := self defineSetterMethod]!

defineGetterMethod
	| selector definingClass |
	definingClass := self definingClass.
	selector := self safeMethodNameFor: definingClass
				basedOn: variableName asString.
	#rbFix. "Add private category"
	definingClass 
		compile: ('<1s><n><t>^<2s>' expandMacrosWith: selector with: variableName)
		classified: #(#accessing #private).
	^selector!

defineSetterMethod
	| selector definingClass string |
	definingClass := self definingClass.
	string := self needsReturnForSetter 
				ifTrue: ['<1s> anObject<n><t>^<2s> := anObject']
				ifFalse: ['<1s> anObject<n><t><2s> := anObject'].
	selector := self safeMethodNameFor: definingClass
				basedOn: variableName asString , ':'.
	#rbFix. "Add private category"
	definingClass 
		compile: (string expandMacrosWith: selector with: variableName)
		classified: #(#accessing #private).
	^selector!

definingClass
	^classVariable ifTrue: [class metaclass] ifFalse: [class]!

findGetterMethod
	| definingClass matcher |
	definingClass := self definingClass.
	matcher := ParseTreeSearcher getterMethod: variableName.
	^self possibleGetterSelectors detect: 
			[:each | 
			(self 
				checkClass: definingClass
				selector: each
				using: matcher) notNil 
				and: [(definingClass subclassRedefines: each) not]]
		ifNone: [nil]!

findSetterMethod
	| definingClass matcher |
	definingClass := self definingClass.
	matcher := self needsReturnForSetter 
				ifTrue: [ParseTreeSearcher returnSetterMethod: variableName]
				ifFalse: [ParseTreeSearcher setterMethod: variableName].
	^self possibleSetterSelectors detect: 
			[:each | 
			(self 
				checkClass: definingClass
				selector: each
				using: matcher) notNil 
				and: [(definingClass subclassRedefines: each) not]]
		ifNone: [nil]!

getterMethod
	^getterMethod!

methodsReferencingVariable
	^classVariable 
		ifTrue: [self definingClass whichSelectorsReferToClassVariable: variableName]
		ifFalse: 
			[self definingClass whichSelectorsReferToInstanceVariable: variableName]!

needsReturnForSetter
	needsReturn isNil 
		ifTrue: 
			[needsReturn := self 
						usesAssignmentOf: variableName
						in: class
						classVariable: classVariable].
	^needsReturn!

possibleGetterSelectors
	^self methodsReferencingVariable select: [:each | each argumentCount == 0]!

possibleSetterSelectors
	^self methodsReferencingVariable select: [:each | each argumentCount == 1]!

preconditions
	^classVariable 
		ifTrue: [RBCondition definesClassVariable: variableName asSymbol in: class]
		ifFalse: [RBCondition definesInstanceVariable: variableName in: class]!

setterMethod
	^setterMethod!

storeOn: aStream 
	aStream nextPut: $(.
	self class storeOn: aStream.
	aStream nextPutAll: ' variable: '.
	variableName storeOn: aStream.
	aStream nextPutAll: ' class: '.
	class storeOn: aStream.
	aStream nextPutAll: ' classVariable: '.
	classVariable storeOn: aStream.
	aStream nextPut: $)!

transform
	self
		createGetterAccessor;
		createSetterAccessor!

usesAssignmentOf: aString in: aClass classVariable: isClassVar 
	| matcher definingClass |
	matcher := ParseTreeSearcher new.
	matcher
		answer: false;
		matches: aString , ' := ``@object' do: [:aNode :answer | answer or: [aNode isUsed]].
	definingClass := isClassVar ifTrue: [aClass nonMetaclass] ifFalse: [aClass].
	^definingClass withAllSubclasses 
		, (isClassVar ifTrue: [definingClass metaclass withAllSubclasses] ifFalse: [#()]) 
			anySatisfy: 
				[:each | 
				(isClassVar 
					ifTrue: [each whichSelectorsReferToClassVariable: aString]
					ifFalse: [each whichSelectorsReferToInstanceVariable: aString]) anySatisfy: 
							[:sel | 
							self 
								checkClass: each
								selector: sel
								using: matcher]]! !
!CreateAccessorsForVariableRefactoring categoriesFor: #classVariable:!initialize/release!public! !
!CreateAccessorsForVariableRefactoring categoriesFor: #createGetterAccessor!public!transforming! !
!CreateAccessorsForVariableRefactoring categoriesFor: #createSetterAccessor!public!transforming! !
!CreateAccessorsForVariableRefactoring categoriesFor: #defineGetterMethod!public!transforming! !
!CreateAccessorsForVariableRefactoring categoriesFor: #defineSetterMethod!public!transforming! !
!CreateAccessorsForVariableRefactoring categoriesFor: #definingClass!private/accessing!public! !
!CreateAccessorsForVariableRefactoring categoriesFor: #findGetterMethod!private/accessing!public! !
!CreateAccessorsForVariableRefactoring categoriesFor: #findSetterMethod!private/accessing!public! !
!CreateAccessorsForVariableRefactoring categoriesFor: #getterMethod!private/accessing!public! !
!CreateAccessorsForVariableRefactoring categoriesFor: #methodsReferencingVariable!private/accessing!public! !
!CreateAccessorsForVariableRefactoring categoriesFor: #needsReturnForSetter!public!testing! !
!CreateAccessorsForVariableRefactoring categoriesFor: #possibleGetterSelectors!private/accessing!public! !
!CreateAccessorsForVariableRefactoring categoriesFor: #possibleSetterSelectors!private/accessing!public! !
!CreateAccessorsForVariableRefactoring categoriesFor: #preconditions!preconditions!public! !
!CreateAccessorsForVariableRefactoring categoriesFor: #setterMethod!private/accessing!public! !
!CreateAccessorsForVariableRefactoring categoriesFor: #storeOn:!printing!public! !
!CreateAccessorsForVariableRefactoring categoriesFor: #transform!public!transforming! !
!CreateAccessorsForVariableRefactoring categoriesFor: #usesAssignmentOf:in:classVariable:!public!testing! !

!CreateAccessorsForVariableRefactoring class methodsFor!

model: aRBNamespace variable: aVarName class: aClass classVariable: aBoolean 
	^(self 
		model: aRBNamespace
		variable: aVarName
		class: aClass)
		classVariable: aBoolean;
		yourself!

variable: aVarName class: aClass classVariable: aBoolean 
	^(self variable: aVarName class: aClass)
		classVariable: aBoolean; yourself! !
!CreateAccessorsForVariableRefactoring class categoriesFor: #model:variable:class:classVariable:!instance creation!public! !
!CreateAccessorsForVariableRefactoring class categoriesFor: #variable:class:classVariable:!instance creation!public! !

