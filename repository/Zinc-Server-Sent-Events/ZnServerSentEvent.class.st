"
A ZnServerSentEvent is used to send data from a server to an HTTP client, on the initiative of the server, often called a push notification.

ZnServerEvents are written out according to the text/event-stream MIME type.

Instances variables

 data <String> the actual data without LF, CR or CRLF
 event <String> optional event type tag
 id <String> optional event id tag
 retry <Integer> optional number of milliseconds for connection retry

References

 http://en.wikipedia.org/wiki/Server-sent_events
 http://dev.w3.org/html5/eventsource/
 https://developer.mozilla.org/en-US/docs/Server-sent_events/Using_server-sent_events

  ZnServerSentEvent type: 'counter' data: 100.

Part of Zinc HTTP Components
"
Class {
	#name : 'ZnServerSentEvent',
	#superclass : 'Object',
	#instVars : [
		'data',
		'event',
		'id',
		'retry'
	],
	#category : 'Zinc-Server-Sent-Events',
	#package : 'Zinc-Server-Sent-Events'
}

{ #category : 'instance creation' }
ZnServerSentEvent class >> data: string [
	^ self new
		data: string;
		yourself
]

{ #category : 'instance creation' }
ZnServerSentEvent class >> id: id data: string [
	^ self new
		id: id;
		data: string;
		yourself
]

{ #category : 'accessing' }
ZnServerSentEvent class >> mimeType [
	^ 'text/event-stream' asZnMimeType
]

{ #category : 'instance creation' }
ZnServerSentEvent class >> type: tag data: string [
	^ self new
		event: tag;
		data: string;
		yourself
]

{ #category : 'instance creation' }
ZnServerSentEvent class >> type: tag id: id data: string [
	^ self new
		event: tag;
		id: id;
		data: string;
		yourself
]

{ #category : 'accessing' }
ZnServerSentEvent >> data [
	^ data
]

{ #category : 'accessing' }
ZnServerSentEvent >> data: string [
	"string cannot contain CR, LF or CRLF"
	
	data := string
]

{ #category : 'accessing' }
ZnServerSentEvent >> event [
	^ event
]

{ #category : 'accessing' }
ZnServerSentEvent >> event: typeString [
	event := typeString
]

{ #category : 'accessing' }
ZnServerSentEvent >> id [
	^ id
]

{ #category : 'accessing' }
ZnServerSentEvent >> id: idString [
	id := idString
]

{ #category : 'printing' }
ZnServerSentEvent >> printOn: stream [
	| first |
	super printOn: stream.
	stream nextPut: $( .
	first := true.
	#( 'event' 'id' 'retry' 'data' ) 
		do: [ :field |
			(self instVarNamed: field) 
				ifNotNil: [ :value | 
					first ifTrue: [ first := false ] ifFalse: [ stream << ', '  ].
					stream << field; nextPut: $= ; << value ] ].
	stream nextPut: $)
]

{ #category : 'accessing' }
ZnServerSentEvent >> retry [
	^ retry
]

{ #category : 'accessing' }
ZnServerSentEvent >> retry: milliseconds [
	retry := milliseconds
]

{ #category : 'writing' }
ZnServerSentEvent >> writeOn: stream [
	| encoder  |
	encoder := ZnCharacterWriteStream on: stream.
	#( 'data' 'event' 'id' 'retry' ) do: [ :field |
		(self instVarNamed: field) 
			ifNotNil: [ :value | 
				encoder << field; nextPut: $: ; << value; << String crlf ] ].
	encoder << String crlf; flush.
	ZnCurrentServer value 
		ifNotNil: [ :server | server logServerGeneric: 'Wrote ', self printString ]
]
