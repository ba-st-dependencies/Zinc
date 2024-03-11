"
I am ZnWebSocketFailed, an exception thrown when a client WebSocket cannot be created successfully.
I am an Error.

Part of Zinc HTTP Components. 
"
Class {
	#name : 'ZnWebSocketFailed',
	#superclass : 'Error',
	#instVars : [
		'response'
	],
	#category : 'Zinc-WebSocket-Core',
	#package : 'Zinc-WebSocket-Core'
}

{ #category : 'instance creation' }
ZnWebSocketFailed class >> response: response [
	^ self new
		response: response;
		yourself
]

{ #category : 'accessing' }
ZnWebSocketFailed >> response [
	^ response
]

{ #category : 'accessing' }
ZnWebSocketFailed >> response: anObject [
	response := anObject
]
