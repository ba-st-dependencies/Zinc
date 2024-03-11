"
I am ZnExampleSumRestCall.
I am a ZnAutoMatchedRestCall.

I handle REST requests for /sum

For a GET request, I accept numbers as path elements or as a query parameter.

	GET /sum/1/2/3
	GET /sum?numbers=1,2,3
	
For a POST requests, I accept a text/plain entity containing numbers.

	POST /sum '1,2,3'
	
To install me, try:

	ZnServer startDefaultOn: 1701.
	ZnServer default logToTranscript.

	ZnServer default delegate
		map: 'sum' 
		to: (ZnRestServerDelegate new 
				uriSpace: (ZnCallHierarchyRestUriSpace new 
								rootClass: ZnExampleSumRestCall;
								yourself); 
				yourself).
			
	ZnServer stopDefault.
	
Here are some example invocations:

	ZnClient new
		url: ZnServer default localUrl;
		addPathSegment: #sum;
		queryAt: #numbers put: '1,2,3'; 
		get.
		
	ZnClient new
		url: ZnServer default localUrl;
		addPathSegment: #sum;
		addPathSegment: '1';
		addPathSegment: '2';
		addPathSegment: '3';
		get.
		
	ZnClient new
		url: ZnServer default localUrl;
		addPathSegment: #sum;
		entity: (ZnEntity text: '1,2,3'); 
		post.
"
Class {
	#name : 'ZnExampleSumRestCall',
	#superclass : 'ZnAutoMatchedRestCall',
	#category : 'Zinc-REST-Tests',
	#package : 'Zinc-REST',
	#tag : 'Tests'
}

{ #category : 'public' }
ZnExampleSumRestCall class >> match: request [
	^ request uri firstPathSegment = 'sum'
		ifTrue: [ request uri pathSegments allButFirst ]
		ifFalse: [ nil ]    
]

{ #category : 'public' }
ZnExampleSumRestCall >> get [
	| sum |
	sum := self numbersForGet inject: 0 into: [ :sub :next | sub + next ].
	self response: (ZnResponse ok: (ZnEntity with: sum asString))
]

{ #category : 'accessing' }
ZnExampleSumRestCall >> numbersForGet [
	variables isEmpty ifFalse: [ ^ variables collect: [ :each | 
			[ each asNumber ] on: Error do: [ 0 ] ] ].
	(self request uri queryAt: #numbers ifAbsent: [ nil ])
		ifNotNil: [ :numbers | 
			^ (numbers findTokens: { Character space. Character tab. $, }) collect: [ :each | 
				[ each asNumber ] on: Error do: [ 0 ] ] ].
	^ #()
]

{ #category : 'accessing' }
ZnExampleSumRestCall >> numbersForPost [
	(self request hasEntity and: [ self request entity contentType = ZnMimeType textPlain])
		ifNotNil: [ :numbers | 
			^ (self request entity contents findTokens: { Character space. Character tab. Character cr. Character lf. $, }) collect: [ :each | 
				[ each asNumber ] on: Error do: [ 0 ] ] ].
	^ #()
]

{ #category : 'public' }
ZnExampleSumRestCall >> post [
	| sum |
	sum := self numbersForPost inject: 0 into: [ :sub :next | sub + next ].
	self response: (ZnResponse ok: (ZnEntity with: sum asString))
]
