"
I am ZnRestServerDelegate.
I am a ZnServer delegate.

Based on my URI space I dispatch requests to REST call objects.
"
Class {
	#name : 'ZnRestServerDelegate',
	#superclass : 'Object',
	#instVars : [
		'uriSpace'
	],
	#category : 'Zinc-REST-Server',
	#package : 'Zinc-REST',
	#tag : 'Server'
}

{ #category : 'public' }
ZnRestServerDelegate >> authenticate: call [
	| authorization |
	authorization := ZnRestServerUtils extractBasicAuthorization: call request.
	^ (self isAuthorizationValid: authorization) 
		ifTrue: [
			authorization ifNotNil: [ 
				call 
					principal: authorization key; 
					credentials: authorization value ].
			call isAuthorized ] 
		ifFalse: [ false ]   
]

{ #category : 'error handling' }
ZnRestServerDelegate >> callUnauthorized: request [
	^ self 
		errorResponse: request 
		code: 401 
		message: 'Call unauthorized'
]

{ #category : 'error handling' }
ZnRestServerDelegate >> errorResponse: request code: code message: message [
	| statusLine text |
	statusLine := ZnStatusLine code: code.
	text := String streamContents: [ :stream | 
		stream << message; space; nextPut: $[; print: code; space; << statusLine reason; nextPut: $]; crlf ].
	^ ZnResponse new
		statusLine: statusLine;
		headers: ZnHeaders defaultResponseHeaders;
		entity: (ZnEntity with: text);
		yourself
]

{ #category : 'public' }
ZnRestServerDelegate >> execute: call [
	^ call execute
]

{ #category : 'error handling' }
ZnRestServerDelegate >> handleException: exception request: request [
	^request server debugMode
		ifTrue: [ exception pass ]
		ifFalse: [ 
			request server logServerHandlerError: exception.
			self serverError: request exception: exception ] 
]

{ #category : 'public' }
ZnRestServerDelegate >> handleRequest: request [
	| call |
	(call := self match: request) 
		ifNil: [ ^ self noHandlerFound: request ].
	(self authenticate: call)
		ifFalse: [ ^ self callUnauthorized: request ].
	^ [ self execute: call ]
		on: Error
		do: [ :exception | 
			self 
				handleException: exception 
				request: request ]
]

{ #category : 'public' }
ZnRestServerDelegate >> isAuthorizationValid: authorization [
	^ authorization isNil
		or: [ authorization key isEmptyOrNil not 
			and: [ authorization value isEmptyOrNil not ] ]
]

{ #category : 'public' }
ZnRestServerDelegate >> match: request [
	| call |
	(call := uriSpace match: request)
		ifNotNil: [
			call
				request: request; 
				delegate: self ].
	^ call
	
]

{ #category : 'error handling' }
ZnRestServerDelegate >> noHandlerFound: request [
	^ self 
		errorResponse: request 
		code: 404 
		message: 'No handler found'
]

{ #category : 'error handling' }
ZnRestServerDelegate >> serverError: request exception: exception [
	^ self 
		errorResponse: request 
		code: 500 
		message: exception asString
]

{ #category : 'accessing' }
ZnRestServerDelegate >> uriSpace [
	^ uriSpace
]

{ #category : 'initialize-release' }
ZnRestServerDelegate >> uriSpace: anObject [
	uriSpace := anObject
]

{ #category : 'public' }
ZnRestServerDelegate >> value: request [
	"I implement the generic #value: message as equivalent to #handleRequest:"
	
	^ self handleRequest: request
]

{ #category : 'error handling' }
ZnRestServerDelegate >> wrongMethod: request [
	^ self 
		errorResponse: request 
		code: 405 
		message: 'Wrong HTTP method'
]
