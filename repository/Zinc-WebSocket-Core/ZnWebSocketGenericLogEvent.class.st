"
I am ZnWebSocketGenericLogEvent communicating about a subject.

"
Class {
	#name : 'ZnWebSocketGenericLogEvent',
	#superclass : 'ZnWebSocketLogEvent',
	#instVars : [
		'subject'
	],
	#category : 'Zinc-WebSocket-Core',
	#package : 'Zinc-WebSocket-Core'
}

{ #category : 'printing' }
ZnWebSocketGenericLogEvent >> printContentsOn: stream [
	super printContentsOn: stream.

	stream << 'WebSocket Generic Log Event ';  print: subject
]

{ #category : 'accessing' }
ZnWebSocketGenericLogEvent >> subject [
	^ subject
]

{ #category : 'accessing' }
ZnWebSocketGenericLogEvent >> subject: anObject [
	subject := anObject
]
