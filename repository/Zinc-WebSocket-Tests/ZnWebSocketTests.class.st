"
I am ZnWebSocketTests.
"
Class {
	#name : 'ZnWebSocketTests',
	#superclass : 'TestCase',
	#category : 'Zinc-WebSocket-Tests',
	#package : 'Zinc-WebSocket-Tests'
}

{ #category : 'testing' }
ZnWebSocketTests >> assertWebSocketClientReceivesEchoedStringWithPrefix: aPrefixString [
	
	| sentMessage clientWebSocket receivedMessage |
	sentMessage := 'Hey there'.

	self shouldnt: [ clientWebSocket := ZnWebSocket to: 'ws://localhost:1701', aPrefixString ] 
			raise: ZnWebSocketFailed.
	
	clientWebSocket sendMessage: sentMessage.
   receivedMessage := clientWebSocket readMessage.

	self assert: sentMessage equals: receivedMessage.
	
	"should be in a proper tearDown"
	clientWebSocket close. 
	
]

{ #category : 'testing' }
ZnWebSocketTests >> testChatroom [
	| webSocket1 message1 inbox1 webSocket2 message2 inbox2 |
	ZnServer startDefaultOn: 1701.
	ZnServer default 
		delegate: (ZnWebSocketDelegate map: 'ws-chatroom' to: ZnWebSocketChatroomHandler new).
	webSocket1 := ZnWebSocket to: 'ws://localhost:1701/ws-chatroom'.
	message1 := 'Message 1 @ ', DateAndTime now printString.
	webSocket2 := ZnWebSocket to: 'ws://localhost:1701/ws-chatroom'.
	message2 := 'Message 2 @ ', DateAndTime now printString.
	webSocket1 sendMessage: message1.
	webSocket2 sendMessage: message2.
	inbox1 := { webSocket1 readMessage. webSocket1 readMessage }.
	inbox2 := { webSocket2 readMessage. webSocket2 readMessage }.
	self assert: (inbox1 includes: message1).
	self assert: (inbox1 includes: message2).
	self assert: (inbox2 includes: message1).
	self assert: (inbox2 includes: message2).
	webSocket1 close.
	webSocket2 close.
	ZnServer stopDefault.
]

{ #category : 'testing' }
ZnWebSocketTests >> testEcho [
	| webSocket message |
	ZnServer startDefaultOn: 1701.
	ZnServer default 
		delegate: (ZnWebSocketDelegate map: 'ws-echo' to: ZnWebSocketEchoHandler new).
	webSocket := ZnWebSocket to: 'ws://localhost:1701/ws-echo'.
	message := 'Greetings from Pharo Smalltalk @ ', DateAndTime now printString.
	webSocket sendMessage: message.
	self assert: webSocket readMessage equals: message.
	webSocket close.
	ZnServer stopDefault.
]

{ #category : 'testing' }
ZnWebSocketTests >> testStatus [
	| webSocket message |
	ZnServer startDefaultOn: 1701.
	ZnServer default 
		delegate: (ZnWebSocketDelegate map: 'ws-status' to: ZnWebSocketStatusHandler new).
	webSocket := ZnWebSocket to: 'ws://localhost:1701/ws-status'.
	message := webSocket readMessage.
	self assert: (#('Pharo' 'memory' 'GC' 'Process') allSatisfy: [ :each | message includesSubstring: each ]).
	webSocket close.
	ZnServer stopDefault.
]

{ #category : 'testing' }
ZnWebSocketTests >> testWebSocketServerWithEmptyStringPrefix [

  | echoServer |
	
	echoServer := ZnWebSocket
  					startServerOn: 1701 
					prefix: ''
  					do: [ :webSocket | 
						[ 
      						webSocket runWith: [ :message |
        					webSocket sendMessage: message ] ]
      					on: ConnectionClosed 
      					do: [ ] ].

 	self assertWebSocketClientReceivesEchoedStringWithPrefix: ''.

	"should be in a proper tearDown"
	echoServer stop

]

{ #category : 'testing' }
ZnWebSocketTests >> testWebSocketServerWithRootStringPrefix [

  | echoServer |
	
	echoServer := ZnWebSocket
  					startServerOn: 1701 
					prefix: '/'
  					do: [ :webSocket | 
						[ 
      						webSocket runWith: [ :message |
        					webSocket sendMessage: message ] ]
      					on: ConnectionClosed 
      					do: [ ] ].

	self assertWebSocketClientReceivesEchoedStringWithPrefix: '/'.

	"should be in a proper tearDown"
	echoServer stop

]
