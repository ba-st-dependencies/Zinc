"
I am ZnRestCall.

I represent the actual execution of a REST call.

"
Class {
	#name : 'ZnRestCall',
	#superclass : 'Object',
	#instVars : [
		'request',
		'response',
		'variables',
		'delegate',
		'principal',
		'credentials'
	],
	#category : 'Zinc-REST-Server',
	#package : 'Zinc-REST',
	#tag : 'Server'
}

{ #category : 'accessing' }
ZnRestCall >> credentials [
	^ credentials
]

{ #category : 'initialize-release' }
ZnRestCall >> credentials: anObject [
	credentials := anObject
]

{ #category : 'accessing' }
ZnRestCall >> delegate [
	^ delegate
]

{ #category : 'initialize-release' }
ZnRestCall >> delegate: anObject [
	delegate := anObject
]

{ #category : 'public' }
ZnRestCall >> execute [
	^ (self respondsTo: self method)	
		ifTrue: [ (self perform: self method) response ] 
		ifFalse: [ self delegate wrongMethod: request ]  
]

{ #category : 'testing' }
ZnRestCall >> isAuthorized [
	^ true    
]

{ #category : 'accessing' }
ZnRestCall >> method [
	^ request method asLowercase asSymbol 
]

{ #category : 'accessing' }
ZnRestCall >> principal [
	^ principal
]

{ #category : 'initialize-release' }
ZnRestCall >> principal: anObject [
	principal := anObject
]

{ #category : 'accessing' }
ZnRestCall >> request [
	^ request
]

{ #category : 'initialize-release' }
ZnRestCall >> request: anObject [
	request := anObject
]

{ #category : 'accessing' }
ZnRestCall >> response [
	^ response
]

{ #category : 'accessing' }
ZnRestCall >> response: anObject [
	response := anObject
]

{ #category : 'accessing' }
ZnRestCall >> variables [
	^ variables
]

{ #category : 'initialize-release' }
ZnRestCall >> variables: anObject [
	variables := anObject
]
