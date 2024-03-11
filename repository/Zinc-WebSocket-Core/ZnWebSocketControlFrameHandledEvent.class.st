"
I am ZnWebSocketControlFrameHandledEvent.
I am a ZnLogEvent.

I am emitted when a WebSocket control frame is handled automatically. I know the type of frame that is being handled.
"
Class {
	#name : 'ZnWebSocketControlFrameHandledEvent',
	#superclass : 'ZnWebSocketLogEvent',
	#instVars : [
		'type'
	],
	#category : 'Zinc-WebSocket-Core',
	#package : 'Zinc-WebSocket-Core'
}

{ #category : 'printing' }
ZnWebSocketControlFrameHandledEvent >> printContentsOn: stream [
	super printContentsOn: stream.

	stream << 'WebSocket Control Frame Handled '; print: type
]

{ #category : 'accessing' }
ZnWebSocketControlFrameHandledEvent >> type [
	^ type
]

{ #category : 'accessing' }
ZnWebSocketControlFrameHandledEvent >> type: anObject [
	type := anObject
]
