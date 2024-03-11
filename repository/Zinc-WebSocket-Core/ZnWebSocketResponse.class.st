"
I am ZnWebSocketResponse used to continue the WebSocket conversation after the connection upgrade.
I am a ZnResponse.

Part of Zinc HTTP Components.
"
Class {
	#name : 'ZnWebSocketResponse',
	#superclass : 'ZnResponse',
	#instVars : [
		'continuation'
	],
	#category : 'Zinc-WebSocket-Core',
	#package : 'Zinc-WebSocket-Core'
}

{ #category : 'accessing' }
ZnWebSocketResponse >> continuation [
	"Return the block that represents the continuation 
	when the server call #useConnection: on me.
	The block will be evaluated with an instanciated WebSocket."

	^ continuation
]

{ #category : 'initialize-release' }
ZnWebSocketResponse >> continuation: block [
	"Set the block that represents the continuation 
	when the server call #useConnection: on me.
	The block will be evaluated with an instanciated WebSocket."
	
	continuation := block
]

{ #category : 'accessing' }
ZnWebSocketResponse >> useConnection: connection [
	"Hook method overwritten to give the receiver the chance to 
	keep using connection in the current thread/process after the server wrote the response.
	We start a conversation by instanciating a WebSocket and passing it to our continuation."
	
	| webSocket |
	webSocket := ZnWebSocket onStream: connection.
	self continuation value: webSocket
]

{ #category : 'testing' }
ZnWebSocketResponse >> wantsConnectionClose [
	"After we are done, the server can close the connection we were using"
	 
	^ true
]
