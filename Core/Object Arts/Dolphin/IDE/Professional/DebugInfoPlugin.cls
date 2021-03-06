﻿"Filed out from Dolphin Smalltalk 7"!

ClassBrowserPlugin subclass: #DebugInfoPlugin
	instanceVariableNames: 'disassemblyPresenter sourcePresenter textMapPresenter toggleDebugPresenter toggleOptimisedPresenter method'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
DebugInfoPlugin guid: (GUID fromString: '{d76ccba1-7398-4191-9068-fb4bcb1afb88}')!
DebugInfoPlugin comment: '`DebugInfoPlugin` is a `<classBrowserPlugin>` that shows a debug view of the currently selected method. It has 3 panes:
 - The left pane is the text map built by the compiler and used by the debugger to relate instruction pointer positions to the corresponding expression in the source text.
 - The middle pane displays the source of the method. Note that this is not intended for editing.
 - The right pane displays a bytecode disassembly for the method.
	
Selecting a row will make corresponding source and instruction selections in the next two panes using essentially the same code as the Debugger. The Debug and Optimized checkboxes can be toggled to see the effect on the generated bytecodes, although note that Debug methods are never optimized.

Since this facility is probably not of interest to most developers it is not installed as one of the default plugins. If you wish to add this plugin to all browsers please evaluate:
```
	ClassBrowserAbstract allSubclasses do: [:each | each plugins add: self]
```
Alternatively Tools/Options/Inspect Options, then double click plugins, press the * button, and choose DebugInfoPlugin from the list, Ok out. The plugin will appear in any subsequently opened browser.'!
!DebugInfoPlugin categoriesForClass!Browser-Plugins! !
!DebugInfoPlugin methodsFor!

clear
	disassemblyPresenter text: ''.
	sourcePresenter text: ''.
	textMapPresenter list: #()!

createComponents
	"Create the presenters contained by the receiver"

	super createComponents.
	disassemblyPresenter := self add: Smalltalk developmentSystem workspaceClass new name: 'disassembly'.
	sourcePresenter := self add: Smalltalk developmentSystem methodWorkspaceClass new name: 'source'.
	sourcePresenter isAutoParseEnabled: false.
	textMapPresenter := self add: ListPresenter new name: 'textMap'.
	toggleDebugPresenter := self add: BooleanPresenter new name: 'debugToggle'.
	toggleOptimisedPresenter := self add: BooleanPresenter new name: 'optimisedToggle'.
	toggleOptimisedPresenter value: true!

createSchematicWiring
	"Create the trigger wiring for the receiver"

	super createSchematicWiring.
	(self model)
		when: #methodSelected
			send: #onBrowserMethodSelected
			to: self;
		when: #classSelected
			send: #onBrowserClassSelected
			to: self.
	textMapPresenter 
		when: #selectionChanged
		send: #onTextMapEntrySelected
		to: self.
	toggleDebugPresenter 
		when: #valueChanged
		send: #toggleDebug
		to: self.
	toggleOptimisedPresenter 
		when: #valueChanged
		send: #toggleDebug
		to: self!

displayMethod
	| debugInfo |
	method := self selectedMethod.
	method isNil 
		ifTrue: 
			[self clear.
			^self].
	sourcePresenter text: method getSource.
	debugInfo := self getDebugInfoFor: method.
	method := debugInfo method.
	method isNil 
		ifTrue: 
			[self clear.
			^self].
	disassemblyPresenter text: method disassembly.
	textMapPresenter list: debugInfo textMap!

displayOn: aStream
	"Append, to aStream, a String whose characters are a representation of the receiver as a user
	would want to see it. This will be used as the label for the tab when the receiver is being displayed
	as a plugin within the Class Browser"

	aStream nextPutAll: 'Debug Info.'!

getDebugInfoFor: aCompiledMethod 
	| methodClass compiler flags |
	methodClass := aCompiledMethod methodClass.
	compiler := aCompiledMethod compilerClass.
	flags := methodClass defaultCompilationFlags 
				| (compiler debugInfoFlags: toggleDebugPresenter value).
	flags := flags mask: CompilerFlags.NoOptimize set: toggleOptimisedPresenter value not.
	^compiler 
		compile: aCompiledMethod getSource
		in: methodClass
		flags: flags!

onBrowserClassSelected
	self isCurrentCard ifTrue: [self browser ensureDefinitionVisible]!

onBrowserMethodSelected
	self displayMethod!

onTextMapEntrySelected
	"Private - Similar to the logic in Debugger"

	| ip mapEntry |
	mapEntry := textMapPresenter selectionOrNil.
	mapEntry isNil 
		ifTrue: 
			[disassemblyPresenter selectionRange: (1 to: 0).
			sourcePresenter selectionRange: (1 to: 0).
			^self].
	ip := mapEntry key.
	"There are two lines of header text before the bytecode disassembly starts"
	disassemblyPresenter selectLine: (method indexOfIP: ip) + 2.
	disassemblyPresenter view ensureCaretVisible.
	sourcePresenter selectionRange: mapEntry value!

parseContext
	^self browser parseContext!

selectedMethod
	^self browser selectedMethod 
		ifNotNil: [:m | toggleDebugPresenter value ifTrue: [m asDebugMethod] ifFalse: [m]]!

toggleDebug
	| sel |
	sel := textMapPresenter selectionByIndex.
	self displayMethod.
	textMapPresenter selectionByIndex: sel ifAbsent: []! !
!DebugInfoPlugin categoriesFor: #clear!private! !
!DebugInfoPlugin categoriesFor: #createComponents!initializing!public! !
!DebugInfoPlugin categoriesFor: #createSchematicWiring!initializing!public! !
!DebugInfoPlugin categoriesFor: #displayMethod!private! !
!DebugInfoPlugin categoriesFor: #displayOn:!displaying!public! !
!DebugInfoPlugin categoriesFor: #getDebugInfoFor:!private! !
!DebugInfoPlugin categoriesFor: #onBrowserClassSelected!event handling!public! !
!DebugInfoPlugin categoriesFor: #onBrowserMethodSelected!event handling!public! !
!DebugInfoPlugin categoriesFor: #onTextMapEntrySelected!private! !
!DebugInfoPlugin categoriesFor: #parseContext!public! !
!DebugInfoPlugin categoriesFor: #selectedMethod!public! !
!DebugInfoPlugin categoriesFor: #toggleDebug!public! !

!DebugInfoPlugin class methodsFor!

icon
	"Answers an Icon that can be used to represent this class"

	^##(self) defaultIcon!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.ContainerView) 34 15 nil nil 34 2 8 1409286144 131073 416 nil nil nil 5 nil nil nil 416 1180166 ##(Smalltalk.ProportionalLayout) 170 176 34 8 410 ##(Smalltalk.ScintillaView) 34 50 nil 416 34 2 8 1445007684 1 544 nil 786694 ##(Smalltalk.ColorDefault) 8 4278190080 nil 21 265030 4 ##(Smalltalk.Menu) nil true 34 17 984134 2 ##(Smalltalk.CommandMenuItem) 1 1180998 4 ##(Smalltalk.CommandDescription) #accept 8 '&Accept' 1 1 nil nil nil 706 1 738 #reformatAccept 8 'Ref&ormat/Accept' 1 1 nil nil nil 983366 1 ##(Smalltalk.DividerMenuItem) 4097 658 nil true 8 #() 8 'Auto-&correct' #autoCorrectMenu 134217729 nil nil nil nil nil 658 nil true 34 16 706 1 738 #renameNode 8 'Re&name <1d>...' 1 1 nil nil nil 834 4097 706 1 738 #extractToTemporary 8 'Extract to &Temporary...' 1 1 nil nil nil 706 1 738 #extractMethod 8 'E&xtract Method...' 1 1 nil nil nil 706 1 738 #extractToComponent 8 'Extract to &Component...' 1 5 nil nil nil 834 4097 706 1 738 #inlineMessage 8 'Inline &Message' 1 1 nil nil nil 658 nil true 8 #() 8 'Impl&ement Message In' #implementMessageMenu 134217729 nil nil nil nil nil 834 4097 706 1 738 #inlineTemporary 8 '&Inline Temporary' 1 1 nil nil nil 706 1 738 #moveTempToInnerScope 8 'Move to Inner &Scope' 1 1 nil nil nil 706 1 738 #convertTempToInstVar 8 'Con&vert to Instance Variable' 1 1 nil nil nil 834 4097 706 1 738 #addParameterToMessage 8 '&Add Parameter to <1d>...' 1 1 nil nil nil 706 1 738 #inlineParameter 8 'In&line Parameter' 1 1 nil nil nil 706 1 738 #removeParameter 8 'Remove &Parameter' 1 1 nil nil nil 8 'Refactorin&gs' #codeRefactoringsMenu 1 263494 3 ##(Smalltalk.Icon) nil true 1572870 ##(Smalltalk.ImageRelativeFileLocator) 8 'Refactoring.ico' 2032142 ##(Smalltalk.STBExternalResourceLibraryProxy) 8 'dolphindr7.dll' nil nil nil nil nil 658 nil true 34 2 706 1 738 #reformatSource 8 '&Source' 1 1 nil nil nil 706 1 738 #reformatComment 8 '&Comment' 1 1 nil nil nil 8 'Re&format' #reformatMenu 1 nil nil nil nil nil 834 4097 658 nil true 34 8 706 1 738 #undo 8 '&Undo' 1 1 1602 nil true 1648 8 'EditUndo.ico' 1696 nil nil 834 4097 706 1 738 #cutSelection 8 'Cu&t' 1 1 1602 nil true 1648 8 'EditCut.ico' 1696 nil nil 706 1 738 #copySelection 8 '&Copy' 1 1 1602 nil true 1648 8 'EditCopy.ico' 1696 nil nil 706 1 738 #pasteClipboard 8 '&Paste' 1 1 1602 nil true 1648 8 'EditPaste.ico' 1696 nil nil 706 1 738 #clearSelection 8 'De&lete' 1 1 1602 nil true 1648 8 'EditClear.ico' 1696 nil nil 834 4097 706 1 738 #selectAll 8 '&Select All' 1 1 nil nil nil 8 '&Edit' nil 134217729 nil nil nil nil nil 658 nil true 34 10 706 1 738 #inspectWorkspacePool 8 'Variab&les' 1 1 nil nil nil 706 1 738 #cloneNew 8 'Clo&ne' 1 1 1602 nil true 1648 8 'SmalltalkWorkspace.ico' 1696 nil nil 834 4097 706 1 738 #toggleAutoCompletion 8 'Auto-complete' 1 1 nil nil nil 706 1 738 #toggleIndentationGuides 8 'Indentation &Guides' 1 1 nil nil nil 706 1 738 #toggleLineNumbers 8 'Line N&umbers' 1 1 nil nil nil 706 1 738 #toggleLineEndings 8 'Line &Endings' 1 1 nil nil nil 706 1 738 #toggleStyling 8 '&Syntax Coloring' 1 1 nil nil nil 706 1 738 #toggleWhitespace 8 'W&hitespace' 1 1 nil nil nil 706 1 738 #toggleWordWrap 8 '&Word Wrap' 1 1 nil nil nil 8 'Wor&kspace' nil 134217729 nil nil nil nil nil 834 4097 706 1 738 #browseIt 8 'Bro&wse It' 1 1 1602 nil true 1648 8 'ClassBrowserShell.ico' 1696 nil nil 706 1 738 #displayIt 8 '&Display It' 1 1 1602 nil true 1648 8 'DisplayIt.ico' 1696 nil nil 706 1 738 #evaluateIt 8 'E&valuate It' 1 1 1602 nil true 1648 8 'EvaluateIt.ico' 1696 nil nil 706 1 738 #inspectIt 8 '&Inspect It' 1 1 1602 nil true 1648 8 'InspectIt.ico' 1696 nil nil 706 1 738 #debugIt 8 'Deb&ug It' 1 1 1602 nil true 1648 8 'Debugger.ico' 1696 nil nil 834 4097 658 nil true 34 4 706 2097153 738 #browseDefinitions 8 'Defi&nitions of <1d>' 1 1 nil nil nil 706 1 738 #browseReferences 8 '&References to <1d>' 1 1 nil nil nil 834 4097 706 1 738 #browseMessage 8 '<1d>' 1 1 nil nil nil 8 '&Browse' nil 1 nil nil nil nil nil 8 '&Workspace' nil 134217729 nil nil nil nil nil nil nil 544 nil 523476179 852486 ##(Smalltalk.NullConverter) nil nil 11 nil 170 192 34 4 #callTip 1182790 1 ##(Smalltalk.ScintillaTextStyle) 77 786694 ##(Smalltalk.IndexedColor) 33554457 3698 33554471 1 nil nil nil nil #callTip nil nil nil #normal 3666 1 nil nil 1 nil nil nil nil #normal nil nil nil 34 256 3744 nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil 3680 nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil 1377542 ##(Smalltalk.SmalltalkMethodStyler) 1 nil nil false 138 144 8 #() 170 192 34 2 #default 1641542 1 ##(Smalltalk.ScintillaMarkerDefinition) 1 nil nil nil 544 #circle nil nil nil nil nil nil 138 ##(Smalltalk.IdentitySet) 3824 nil 170 176 3824 9215 nil nil nil nil 3698 33554447 nil nil 65 nil nil 170 192 34 6 #literalArray 8 '()' #literalBytes 8 '[]' #specialCharacter 8 '()[]<>' 8 '' 3 170 192 34 2 #container 3632 nil nil nil nil 3 nil 170 192 34 4 #Warning 1510470 2 ##(Smalltalk.ScintillaIndicatorStyle) 17 544 33554465 3 false #Warning nil nil nil nil nil nil #Error 4114 19 544 33554459 3 false #Error nil nil nil nil nil nil nil nil 170 192 34 6 #Notification 3666 1029 nil 196934 1 ##(Smalltalk.RGB) 31185883 1 nil nil nil nil #Notification nil nil nil #Warning 3666 1027 4210 60239 4210 31326207 1 nil nil nil nil #Warning nil nil nil #Error 3666 1031 4210 335 4210 31317503 1 nil nil nil nil #Error nil nil nil nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 10 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 328198 ##(Smalltalk.Point) 323 1 4450 619 741 544 4402 #contextMenu: 34 1 672 544 4402 #textLimit: 8 #(1073741823) 544 4402 #modificationEventMask: 8 #(4607) 544 4402 #hoverTime: 8 #(500) 544 4402 #caretPeriod: 8 #(530) 544 4402 #wordWrap: 8 #(true) 544 4402 #margins: 34 1 34 3 985158 2 ##(Smalltalk.ScintillaMargin) 1 544 33 3 nil nil nil nil 4738 3 544 1 nil nil 67108863 nil nil 4738 5 544 1 nil nil nil nil nil 544 4402 #backspaceUnindents: 8 #(true) 544 4402 #maxCompletionListHeight: 8 #(9) 544 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 161 0 0 0 0 0 0 0 214 1 0 0 114 1 0 0] 8 #() 4450 193 193 nil 29 9 410 ##(Smalltalk.StaticRectangle) 34 14 nil 416 34 2 8 1140850952 1 4944 nil 624 nil 5 nil nil nil 4944 nil 8 1915124368 4338 138 144 34 2 4402 #createAt:extent: 34 2 4450 321 1 4450 3 741 4944 4402 #isEnabled: 8 #(false) 4944 4866 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 160 0 0 0 0 0 0 0 161 0 0 0 114 1 0 0] 8 #() 4928 nil 27 1 410 ##(Smalltalk.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 5216 nil nil nil 5 nil nil nil 5216 788230 ##(Smalltalk.BorderLayout) 1 1 410 ##(Smalltalk.ContainerView) 34 15 nil 5216 34 2 8 1140850688 131073 5312 nil nil nil 5 nil nil nil 5312 656198 1 ##(Smalltalk.FlowLayout) 1 1 1 170 192 34 4 410 ##(Smalltalk.CheckBox) 34 16 nil 5312 34 2 8 1409363203 1 5440 721990 2 ##(Smalltalk.ValueHolder) nil nil 1114118 ##(Smalltalk.NeverSearchPolicy) false nil nil 5 nil nil nil 5440 nil 8 1915188384 3602 nil nil nil 4338 138 144 34 2 4402 #createAt:extent: 34 2 4450 5 1 4450 131 51 5440 4402 #text: 34 1 8 'Debug?' 5440 4866 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 2 0 0 0 0 0 0 0 67 0 0 0 25 0 0 0] 8 #() 4928 nil 27 8 'debugToggle' 410 ##(Smalltalk.CheckBox) 34 16 nil 5312 34 2 8 1409363203 1 5824 5506 nil nil 5552 false nil nil 5 nil nil nil 5824 nil 8 1915188384 3602 nil nil nil 4338 138 144 34 2 4402 #createAt:extent: 34 2 4450 135 1 4450 171 51 5824 4402 #text: 34 1 8 'Optimised?' 5824 4866 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 67 0 0 0 0 0 0 0 152 0 0 0 25 0 0 0] 8 #() 4928 nil 27 8 'optimisedToggle' 590342 ##(Smalltalk.Rectangle) 4450 5 1 4450 1 1 4338 138 144 34 1 4402 #createAt:extent: 34 2 4450 1 1 4450 317 51 5312 4866 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 158 0 0 0 25 0 0 0] 34 2 5440 5824 4928 nil 27 nil nil nil 410 ##(Smalltalk.ListView) 34 30 nil 5216 34 2 8 1409388621 1 6384 590662 2 ##(Smalltalk.ListModel) 138 144 3824 nil 1310726 ##(Smalltalk.IdentitySearchPolicy) 624 nil 5 nil nil nil 6384 nil 8 1915211424 459270 ##(Smalltalk.Message) #displayString 8 #() nil 1049926 1 ##(Smalltalk.IconImageManager) nil nil nil nil nil nil 138 144 34 2 920646 5 ##(Smalltalk.ListViewColumn) 8 'IP' 87 #left 6546 #displayString 6576 6546 #<= 8 #() 787814 3 ##(Smalltalk.BlockClosure) 0 nil 1180966 ##(Smalltalk.CompiledExpression) 2 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:each | each key]' 8 #[30 105 226 0 106] #key 6768 7 257 nil nil 6384 nil 1 nil nil 6658 8 'Range' 223 #left 6546 #displayString 8 #() 6546 #<= 6912 6754 0 nil 6786 1 83886081 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:each | each value]' 8 #[29 105 17 142 106] 6944 7 257 nil nil 6384 nil 3 nil nil #report 3824 nil 131169 nil 34 4 nil nil 4450 1 1 nil 4338 138 144 34 2 4402 #createAt:extent: 34 2 4450 1 51 4450 317 691 6384 4402 #text: 34 1 8 'IP' 6384 4866 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 25 0 0 0 158 0 0 0 114 1 0 0] 8 #() 4928 nil 27 170 192 34 2 6384 8 'textMap' 6162 4450 1 1 4450 5 1 4338 138 144 34 1 4402 #createAt:extent: 34 2 4450 1 1 4450 321 741 5216 4866 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 160 0 0 0 114 1 0 0] 34 2 5312 6384 4928 nil 27 1 410 ##(Smalltalk.ScintillaView) 34 50 nil 416 34 2 8 1174475012 1 7520 5506 nil false 1310726 ##(Smalltalk.EqualitySearchPolicy) nil 721158 ##(Smalltalk.SystemColor) 41 nil 1045 nil nil nil 7520 nil 523476179 3602 nil nil 11 nil 170 192 34 10 #indentGuide 3666 75 nil nil 1 nil nil nil nil #indentGuide nil nil nil #whitespace 3666 3 nil nil 1 nil nil nil nil #whitespace nil nil nil #callTip 3666 77 3712 3728 1 nil nil nil nil #callTip nil nil nil #normal 3666 1 nil nil 1 nil nil nil nil #normal nil nil nil #lineNumber 3666 67 nil nil 1 nil nil nil nil #lineNumber nil nil nil 170 192 34 8 1 7760 3 7728 75 7712 67 7776 1245510 1 ##(Smalltalk.NullScintillaStyler) #normal 170 192 34 2 #default 3874 1 nil nil nil 7520 #circle nil nil nil nil nil nil 138 ##(Smalltalk.IdentitySet) 3824 nil 170 176 3824 9215 nil nil nil nil 3936 nil nil 65 nil nil nil 8 '' 1 170 192 34 2 #container 7680 nil nil nil nil 1 nil 170 192 3824 nil nil 170 192 34 6 #Notification 3666 1029 nil 4210 31185883 1 nil nil nil nil #Notification nil nil nil #Warning 3666 1027 4210 60239 4210 31326207 1 nil nil nil nil #Warning nil nil nil #Error 3666 1031 4210 335 4210 31317503 1 nil nil nil nil #Error nil nil nil nil 4338 138 144 34 8 4402 #createAt:extent: 34 2 4450 951 1 4450 621 741 7520 4402 #textLimit: 8 #(1073741823) 7520 4402 #modificationEventMask: 8 #(4607) 7520 4402 #caretPeriod: 8 #(530) 7520 4402 #wordWrap: 8 #(true) 7520 4402 #margins: 34 1 34 3 4738 1 7520 1 3 nil nil nil nil 4738 3 7520 1 nil nil 67108863 nil nil 4738 5 7520 1 nil nil nil nil nil 7520 4402 #canHScroll: 8 #(false) 7520 4402 #maxCompletionListHeight: 8 #(9) 7520 4866 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 219 1 0 0 0 0 0 0 17 3 0 0 114 1 0 0] 8 #() 4928 nil 29 9 false 170 192 34 4 544 8 'source' 7520 8 'disassembly' nil 4338 138 144 34 1 4402 #createAt:extent: 34 2 4450 3839 21 4450 1571 741 416 4866 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 127 7 0 0 10 0 0 0 144 10 0 0 124 1 0 0] 34 5 5216 4944 544 410 ##(Smalltalk.Splitter) 34 12 nil 416 34 2 8 1140850688 1 8832 nil nil nil 517 nil nil nil 1510470 1 ##(Smalltalk.DraggableViewInteractor) 8832 nil 1 #left nil nil nil 4450 1 1 4450 9 9 nil 8928 nil 4338 138 144 34 1 4402 #createAt:extent: 34 2 4450 941 1 4450 11 741 8832 4866 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 214 1 0 0 0 0 0 0 219 1 0 0 114 1 0 0] 8 #() 4928 nil 27 7520 4928 nil 27 )! !
!DebugInfoPlugin class categoriesFor: #icon!constants!public! !
!DebugInfoPlugin class categoriesFor: #resource_Default_view!public!resources-views! !

