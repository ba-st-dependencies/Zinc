"
ZnWebWorkspaceAccessor accesses workspace contents shared using the http://ws.stfx.eu web service.

Example usage:

	ZnWebWorkspaceAccessor new get: 'http://ws.stfx.eu/1WS4U'.

or

	ZnWebWorkspaceAccessor new get: '1WS4U'.

This global setting helps when testing:

	ZnWebWorkspaceAccessor defaultEndpoint: 'http://localhost:1701'.
"
Class {
	#name : 'ZnWebWorkspaceAccessor',
	#superclass : 'Object',
	#instVars : [
		'endpoint'
	],
	#classVars : [
		'DefaultEndpoint'
	],
	#category : 'Zinc-WWS-Client',
	#package : 'Zinc-WWS-Client'
}

{ #category : 'accessing' }
ZnWebWorkspaceAccessor class >> defaultEndpoint [
	^ DefaultEndpoint ifNil: [ DefaultEndpoint := 'http://ws.stfx.eu' asZnUrl ]
]

{ #category : 'accessing' }
ZnWebWorkspaceAccessor class >> defaultEndpoint: aUrlObject [
	DefaultEndpoint := aUrlObject ifNotNil: [ aUrlObject asZnUrl ]
]

{ #category : 'public' }
ZnWebWorkspaceAccessor >> endpoint [
	^ endpoint ifNil: [ endpoint := self class defaultEndpoint ]
]

{ #category : 'initialize-release' }
ZnWebWorkspaceAccessor >> endpoint: anUrlObject [
	endpoint := anUrlObject asZnUrl 
]

{ #category : 'public' }
ZnWebWorkspaceAccessor >> get: url [
	"Access the shared web workspace at url 
	and return its contents as a String.
	Signals an error when something goes wrong."
	
	| contents |
	contents := self httpClient get: url.
	^ String new: contents size streamContents: [ :stream |
		contents linesDo: [ :each | stream nextPutAll: each; cr ] ]
]

{ #category : 'private' }
ZnWebWorkspaceAccessor >> httpClient [
	^ ZnClient new
		systemPolicy;
		beOneShot;
		accept: ZnMimeType textPlain;
		url: self endpoint;
		yourself
]

{ #category : 'public' }
ZnWebWorkspaceAccessor >> post: string [
	"Publish the string as a new shared web workspace
	and return the newly created url.
	Signals an error when something goes wrong."
	
	| entity client url |
	entity := ZnEntity text: string asString.
	(client := self httpClient)
		entity: entity; 
		post.
	url := client response location.
	^ url asZnUrl inContextOf: self endpoint 
]
