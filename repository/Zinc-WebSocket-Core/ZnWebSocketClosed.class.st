"
I am ZnWebSocketClosed, signalled when WebSocket close frame is received.
I am a ConnectionClosed and a NetworkError.

Part of Zinc HTTP Components.

"
Class {
	#name : 'ZnWebSocketClosed',
	#superclass : 'ConnectionClosed',
	#instVars : [
		'code',
		'reason'
	],
	#category : 'Zinc-WebSocket-Core',
	#package : 'Zinc-WebSocket-Core'
}

{ #category : 'accessing' }
ZnWebSocketClosed >> code [
	^ code
]

{ #category : 'accessing' }
ZnWebSocketClosed >> code: anObject [
	code := anObject
]

{ #category : 'accessing' }
ZnWebSocketClosed >> reason [
	^ reason
]

{ #category : 'accessing' }
ZnWebSocketClosed >> reason: anObject [
	reason := anObject
]
