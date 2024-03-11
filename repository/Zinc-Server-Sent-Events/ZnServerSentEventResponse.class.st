"
A ZnServerSentEventResponse is a ZnResponse that will continue using the open HTTP connection by passing it to handler's #run: method.

This response is actual not Server-Sent Event specific and could be used in other scenarios as well (WebSockets, Comet).

Part of Zinc HTTP Components.

"
Class {
	#name : 'ZnServerSentEventResponse',
	#superclass : 'ZnResponse',
	#instVars : [
		'handler'
	],
	#category : 'Zinc-Server-Sent-Events',
	#package : 'Zinc-Server-Sent-Events'
}

{ #category : 'accessing' }
ZnServerSentEventResponse >> handler: anObject [
	handler := anObject
]

{ #category : 'accessing' }
ZnServerSentEventResponse >> useConnection: connection [
	"Hook method overwritten to give the receiver the chance to 
	keep using connection in the current thread/process after the server wrote the response.
	We pass control to our handler."
	
	[ handler run: connection ]
		on: ConnectionClosed, ConnectionTimedOut
		do: [ "ignore" ]
]

{ #category : 'testing' }
ZnServerSentEventResponse >> wantsConnectionClose [
	"After we are done, the server can close the connection we were using"
	 
	^ true
]
