"
I am ZnAutoMatchedRestCall.
I am a ZnRestCall.

My class side knows if I match a certain request.
A default implementation uses #pattern specification.
"
Class {
	#name : 'ZnAutoMatchedRestCall',
	#superclass : 'ZnRestCall',
	#category : 'Zinc-REST-Server',
	#package : 'Zinc-REST',
	#tag : 'Server'
}

{ #category : 'accessing' }
ZnAutoMatchedRestCall class >> isAbstract [
	^ self = ZnAutoMatchedRestCall 
]

{ #category : 'accessing' }
ZnAutoMatchedRestCall class >> match: request [
	self isAbstract ifTrue: [ ^ nil ].
	^ ZnRestServerUtils 
		matchPath: request uri pathSegments 
		pattern: self pattern   
]

{ #category : 'accessing' }
ZnAutoMatchedRestCall class >> order [
	^ 50
]

{ #category : 'accessing' }
ZnAutoMatchedRestCall class >> pattern [
	^ self subclassResponsibility 
]

{ #category : 'public' }
ZnAutoMatchedRestCall >> acceptMethods: allowedMethods [
	"Allow and execute allowedMethods (#put or #delete) as POST ? method=put"
	
	| method |
	method := (request uri queryAt: 'method' ifAbsent: [ #error ]) asLowercase asSymbol.
	(allowedMethods includes: method)
		ifTrue: [
			self perform: method ]
		ifFalse: [ 
			self wrongMethod ]    	
]

{ #category : 'error handling' }
ZnAutoMatchedRestCall >> badRequest: message [
	response := self delegate 
		errorResponse: request 
		code: 400 
		message: message
]

{ #category : 'error handling' }
ZnAutoMatchedRestCall >> callUnauthorized [
	response := self delegate 
		errorResponse: request 
		code: 401
		message: 'Unauthorized during ', self class name
]

{ #category : 'public' }
ZnAutoMatchedRestCall >> created: uri [
	^ (response := ZnResponse new)
		statusLine: ZnStatusLine created;
		headers: ZnHeaders defaultResponseHeaders;
		setLocation: uri;
		yourself
]

{ #category : 'error handling' }
ZnAutoMatchedRestCall >> notFound [
	response := self delegate 
		errorResponse: request 
		code: 404 
		message: 'Resource not found during ', self class name
]

{ #category : 'accessing' }
ZnAutoMatchedRestCall >> queryAt: key ifAbsent: block [
	^ self request uri queryAt: key ifAbsent: block
]

{ #category : 'error handling' }
ZnAutoMatchedRestCall >> serverError: message [
	response := self delegate 
		serverError: request 
		exception: message
]

{ #category : 'error handling' }
ZnAutoMatchedRestCall >> wrongMethod [
	response := self delegate 
		errorResponse: request 
		code: 405
		message: 'Wrong method'
]
