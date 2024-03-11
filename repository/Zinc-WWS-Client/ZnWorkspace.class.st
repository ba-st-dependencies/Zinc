"
ZnWorkspace is an experimental subclass of Workspace that adds the ability to access workspaces shared using the http://ws.stfx.eu web service.

For example, try:

	ZnWorkspace openUrl: 'http://ws.stfx.eu/1WS4U'.

"
Class {
	#name : 'ZnWorkspace',
	#superclass : 'Workspace',
	#instVars : [
		'url'
	],
	#category : 'Zinc-WWS-Client',
	#package : 'Zinc-WWS-Client'
}

{ #category : 'instance creation' }
ZnWorkspace class >> openUrl: url [
	"Open a new workspace with the contents of the resource at url."
	
	"self openUrl: 'http://ws.stfx.eu/1WS4U'' "
	
	^ self new
		open;
		openUrl: url;
		yourself
]

{ #category : 'window menu' }
ZnWorkspace >> addModelItemsToWindowMenu: aMenu [ 
	super addModelItemsToWindowMenu: aMenu.
	
	aMenu addLine.
	
	aMenu
		add: 'Open web workspace...'
		target: self
		action: #openWWSCommand.
	aMenu lastItem icon: self theme smallOpenIcon.

	aMenu
		add: 'Save as web workspace...'
		target: self
		action: #saveAsWWSCommand.
	aMenu lastItem icon: self theme smallSaveAsIcon.
	
	url ifNotNil: [
		aMenu
			add: 'Reload web workspace'
			target: self
			action: #reloadWWSCommand.
			
		aMenu
			add: 'Copy web workspace URL'
			target: self
			action: #copyWWSUrlCommand ]

]

{ #category : 'window menu' }
ZnWorkspace >> copyWWSUrlCommand [
	Clipboard clipboardText: url asString
]

{ #category : 'initialize-release' }
ZnWorkspace >> openUrl: urlObject [
	| accessor |
	(urlObject isNil or: [ urlObject isEmpty ]) 
		ifTrue: [ ^ self ].
	accessor := ZnWebWorkspaceAccessor new.
	url := urlObject asZnUrl inContextOf: accessor endpoint.
	self contents: (accessor get: url).
	self label: url asString.
	self changed: #contents
]

{ #category : 'window menu' }
ZnWorkspace >> openWWSCommand [
	| userWarned |
	userWarned := true.
	(url isNil and: [ self contents isEmpty not or: [self hasUnacceptedEdits ]])
		ifTrue: [ userWarned := self warnUser ].
	(url isNil not and: [self hasUnacceptedEdits])
		ifTrue: [ userWarned := self warnUser ].
	userWarned 
		ifTrue: [ | input |
			input := UIManager default request: 'URL or key' initialAnswer: '' title: 'http://ws.stfx.eu'. 
			self openUrl: input ]
]

{ #category : 'window menu' }
ZnWorkspace >> reloadWWSCommand [
	self warnUser
		ifTrue: [ self openUrl: url ]
]

{ #category : 'window menu' }
ZnWorkspace >> saveAsWWSCommand [
	(UIManager default confirm: 'Are you sure you want to publish the contents of this workspace ?')
		ifFalse: [ ^ self ].
	self codeTextMorph 
		ifNotNil: [ :morph | | stringToSave |
			stringToSave :=  morph text string.
			url := ZnWebWorkspaceAccessor new post: stringToSave.
			self label: url asString.
			self contents: stringToSave.
			self changed: #contents ]
]
