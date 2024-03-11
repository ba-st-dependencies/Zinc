"
I am ZnWebSocket, a bi-directional, full-duplex communication channel over a single TCP connection.

WebSockets send reliable messages to each other, a String or ByteArrat.
Each message is one-way (does not have a direct synchroneous reply). 
Each party, both client and/or server can take the initiative.

This implementation follows RFC 6455. See also:

	http://en.wikipedia.org/wiki/Websockets
	http://tools.ietf.org/html/rfc6455

Here is a client side example taking to a public echo service: 

| webSocket |
webSocket := ZnWebSocket to: 'ws://echo.websocket.org'.
[ webSocket 
	sendMessage: 'Pharo Smalltalk using Zinc WebSockets !';
	readMessage ] ensure: [ webSocket close ].

Here is the same example using secure web sockets:

| webSocket |
webSocket := ZnWebSocket to: 'wss://echo.websocket.org'.
[ webSocket 
	sendMessage: 'Pharo Smalltalk using Zinc WebSockets & Zodiac !';
	readMessage ] ensure: [ webSocket close ].

Here is how to start a local server running in the image implementing the same echo service:

ZnWebSocket startServerOn: 8080 do: ZnWebSocketEchoHandler new.

A full inline implementation of the echo handler would look like:

ZnWebSocket 
	startServerOn: 8080 
	do: [ :webSocket | 
		[ 
			webSocket runWith: [ :message |
				self crLog: 'Received message: ', message printString, ' echoing...'.
				webSocket sendMessage: message ] ] 
			on: ConnectionClosed 
			do: [ self crLog: 'Ignoring connection close, done' ] ].

Part of Zinc HTTP Components.
"
Class {
	#name : 'ZnWebSocket',
	#superclass : 'Object',
	#instVars : [
		'stream',
		'role'
	],
	#category : 'Zinc-WebSocket-Core',
	#package : 'Zinc-WebSocket-Core'
}

{ #category : 'protocol' }
ZnWebSocket class >> isValidWebSocketResponse: client [
	"Return true when client contains a valid WebSocket response for its WebSocket request"

	| acceptKey response |
	acceptKey := ZnWebSocketUtils handshake: (client request headers at: 'Sec-WebSocket-Key').
	response := client response.
	^ response code = 101
		and: [
			(response headers at: 'Upgrade') asLowercase = 'websocket' 
				and: [
					(ZnWebSocketUtils containsConnectionUpgrade: response headers)
						and: [ 
							(response headers at: 'Sec-WebSocket-Accept') = acceptKey ] ] ]
]

{ #category : 'instance creation' }
ZnWebSocket class >> onClient: client [
	"Create and return a functioning ZnWebSocket object based on an HTTP client,
	assuming the initial upgrade handshake was executed. The validity of the response is checked.
	Signals a ZnWebSocketFailed error when unsuccessful."

	(self isValidWebSocketResponse: client)
		ifTrue: [
			^ (self onStream: client connection)
				role: #client;
				yourself ]
		ifFalse: [
			client close.
			(ZnWebSocketFailed response: client response) signal ]
]

{ #category : 'instance creation' }
ZnWebSocket class >> onStream: socketStream [
	"Return a new ZnWebSocket instance on socketStream.
	It is assumed that the initial handshake was successful."
	
	^ self new
		onStream: socketStream;
		yourself
]

{ #category : 'instance creation' }
ZnWebSocket class >> startServerOn: port do: handler [
	"Start and return a new ZnServer listening on port and / for client WebSocket connections.
	After a successful initial handshake, sent #value: to handler with a server side ZnWebSocket instance."
	
	^ self startServerOn: port prefix: '' do: handler  
]

{ #category : 'instance creation' }
ZnWebSocket class >> startServerOn: port prefix: prefix do: handler [
	"Start and return a new ZnServer listening on port and /prefix for client WebSocket connections.
	After a successful initial handshake, sent #value: to handler with a server side ZnWebSocket instance."
	
	^ (ZnServer on: port)
		delegate: (ZnWebSocketDelegate map: prefix to: handler);
		start;
		yourself
]

{ #category : 'instance creation' }
ZnWebSocket class >> to: urlObject [
	"Attempt to create a new client WebSocket to urlObject.
	Do the initial upgrade handshake and return a functioning ZnWebSocket object.
	Signals a ZnWebSocketFailed error when unsuccessful."

	^ self to: urlObject config: [ :httpClient | ]
]

{ #category : 'instance creation' }
ZnWebSocket class >> to: urlObject config: block [
	"Attempt to create a new client WebSocket to urlObject.
	Execute block to further configure the HTTP client before the upgrade request.
	Do the initial upgrade handshake and return a functioning ZnWebSocket object.
	Signals a ZnWebSocketFailed error when unsuccessful."

	| client |
	client := self webSocketClientTo: urlObject asZnUrl.
	block value: client.
	client execute.
	^ self onClient: client
]

{ #category : 'protocol' }
ZnWebSocket class >> webSocketClientTo: url [
	"Create and return a new ZnClient instance ready for the initial client side WebSocket setup request"
	
	| client |
	self assert: (#(ws wss) includes: url scheme).
	(client := ZnClient new)
		url: url;
		method: #GET;
		headerAt: 'Upgrade' put: 'websocket';
		headerAt: 'Connection' put: 'Upgrade';
		headerAt: 'Sec-WebSocket-Version' put: '13';
		headerAt: 'Sec-WebSocket-Key' put: ZnWebSocketUtils newClientKey.
	^ client   
	
]

{ #category : 'initialize-release' }
ZnWebSocket >> close [
	"Send a close frame and close the connection"

	self sendFrame: ZnWebSocketFrame close.
	stream close.
]

{ #category : 'private' }
ZnWebSocket >> handleControlFrame: frame [
	"Handle a control frame. ConnectionClosed is signalled when the other end closes."
	
	frame isClose 
		ifTrue: [ 
			self logControlFrameHandled: #close.
			self close. 
			^ self signalClosed: frame ].
	frame isPing 
		ifTrue: [ 
			self logControlFrameHandled: #ping.
			self pong: frame body ].
	frame isPong 
		ifTrue: [
			self logControlFrameHandled: #pong ]
]

{ #category : 'protocol' }
ZnWebSocket >> handleControlFrameNoWait [
	"Peek for a control frame if any and handle it. Do not wait.
	Return true when a control frame was handled, false otherwise."
	
	(stream isDataAvailable and: [ (stream peek bitAnd: 127) > 7 ])
		ifTrue: [ | frame |
			frame := ZnWebSocketFrame readFrom: stream.
			self handleControlFrame: frame.
			^ true ].
	^ false
]

{ #category : 'initialize-release' }
ZnWebSocket >> initialize [
	super initialize.
	role := #server
]

{ #category : 'testing' }
ZnWebSocket >> isClient [
	"Return true if the receiver is the client in a WebSocket conversation"
	
	^ role = #client
]

{ #category : 'testing' }
ZnWebSocket >> isConnected [
	"Return true when I am connected, 
	i.e. not closed and still connected at the socket level"

	^ stream notNil and: [ stream isConnected ]
]

{ #category : 'testing' }
ZnWebSocket >> isServer [
	"Return true if the receiver is the server in a WebSocket conversation"

	^ role = #server
]

{ #category : 'private' }
ZnWebSocket >> logControlFrameHandled: type [
	ZnWebSocketControlFrameHandledEvent new
		type: type;
		emit
]

{ #category : 'accessing' }
ZnWebSocket >> logGeneric: subject [
	ZnWebSocketGenericLogEvent new
		subject: subject;
		emit
]

{ #category : 'initialize-release' }
ZnWebSocket >> onStream: socketStream [
	"Initialize the receiver on socketStream"
	
	stream := socketStream 
]

{ #category : 'protocol' }
ZnWebSocket >> ping [
	"Send a generic ping (with an empty payload).
	Ping messages are sent automatically from #runWith: as a keep alive
	whenever the connection times out and loops. 
	The interval is thus the connection's read time out"
	
	self pingEmpty
]

{ #category : 'protocol' }
ZnWebSocket >> ping: payload [
	"Send a ping frame with payload"

	| frame |
	frame := ZnWebSocketFrame ping: payload.
	self sendFrame: frame
]

{ #category : 'protocol' }
ZnWebSocket >> pingEmpty [
	"Send a ping with an empty payload."

	self ping: #[ ]
]

{ #category : 'protocol' }
ZnWebSocket >> pingRandom [
	"Send a ping with a 4-byte random payload."

	self ping: ZnWebSocketUtils newPingPayload
]

{ #category : 'private' }
ZnWebSocket >> pong: payload [
	"Send a pong frame containing payload (in reply to a ping with that payload)"
	
	| frame |
	frame := ZnWebSocketFrame pong: payload.
	self sendFrame: frame 
]

{ #category : 'printing' }
ZnWebSocket >> printOn: aStream [
	super printOn: aStream.
	aStream 
		nextPut: $(; 
		print: role;
		nextPut: $)
]

{ #category : 'private' }
ZnWebSocket >> readFrame [
	"Read and return the next non-control frame. Wait.
	Control frames are handled. ConnectionClosed is signalled when the other end closes."
	
	| frame |
	frame := ZnWebSocketFrame readFrom: stream.
	frame isControl 
		ifTrue: [
			self handleControlFrame: frame.
			^ self readFrame ].
	^ frame
]

{ #category : 'protocol' }
ZnWebSocket >> readMessage [
	"Read and return a complete message String or ByteArray, joining frames. 
	ConnectionClosed is signalled when the other end closes."
	
	| frame bytes isText |
	frame := self readFrame.
	frame isFinal ifTrue: [ ^ frame contents ].
	isText := frame isText.
	bytes := ByteArray new: frame size * 2 streamContents: [ :output |
		frame writeRawBodyOn: output.
		[ 
			frame := self readFrame.
			self assert: frame isContinuation. 
			frame writeRawBodyOn: output.
			frame isFinal ] whileFalse ].
	^ isText 
		ifTrue: [ ZnUTF8Encoder new decodeBytes: bytes ]
		ifFalse: [ bytes ]
]

{ #category : 'accessing' }
ZnWebSocket >> role [
	"Return the role of the receiver, either #client or #server"
	
	^ role
]

{ #category : 'initialize-release' }
ZnWebSocket >> role: symbol [
	"Set the role of the receiver, either #client or #server"
	
	self assert: (#(client server) includes: symbol).
	role := symbol
]

{ #category : 'protocol' }
ZnWebSocket >> runWith: block [
	"Start a run loop handling the WebSocket protocol.
	When a message is received, block will be passed a String or ByteArray.
	ConnectionClosed will be signalled when the other end closes."
	
	[ | message |
		message := nil.
		[ message := self readMessage ] 
			on: ConnectionTimedOut 
			do: [ "Ignore & continue" self ping ].
		message ifNotNil: [
			block value: message ] ] repeat
]

{ #category : 'protocol' }
ZnWebSocket >> sendByteFrames: sequenceableCollection [
	"Send a binary message consisting of sequenceableCollection byte array frames"

	| frame |
	self assert: sequenceableCollection size > 1.
	(frame := ZnWebSocketFrame bytes: sequenceableCollection first)
		final: false.
	self sendFrame: frame.
	2 to: sequenceableCollection size - 1 do: [ :each |
		(frame := ZnWebSocketFrame bytes: (sequenceableCollection at: each))
			final: false; opcode: 0.
		self sendFrame: frame ].
	(frame := ZnWebSocketFrame bytes: sequenceableCollection last)
		final: true; opcode: 0.
	self sendFrame: frame
	
]

{ #category : 'private' }
ZnWebSocket >> sendBytes: bytes [
	"Send bytes in one binary frame"

	| frame |
	frame := ZnWebSocketFrame bytes: bytes.
	self sendFrame: frame
]

{ #category : 'private' }
ZnWebSocket >> sendFrame: frame [
	"Send a single frame, masked when I am in a client role, flush"
	
	frame masked: self isClient.
	frame writeOn: stream.
	stream flush.
]

{ #category : 'protocol' }
ZnWebSocket >> sendMessage: stringOrByteArray [
	"Send stringOrByteArray in one textual or binary frame"

	stringOrByteArray isString
		ifTrue: [ self sendText: stringOrByteArray ] 
		ifFalse: [ self sendBytes: stringOrByteArray ]
]

{ #category : 'private' }
ZnWebSocket >> sendText: string [
	"Send string in one textual frame"

	| frame |
	frame := ZnWebSocketFrame text: string.
	self sendFrame: frame
]

{ #category : 'protocol' }
ZnWebSocket >> sendTextFrames: sequenceableCollection [
	"Send a textual message consisting of sequenceableCollection string frames"

	| frame |
	self assert: sequenceableCollection size > 1.
	(frame := ZnWebSocketFrame text: sequenceableCollection first)
		final: false.
	self sendFrame: frame.
	2 to: sequenceableCollection size - 1 do: [ :each |
		(frame := ZnWebSocketFrame text: (sequenceableCollection at: each))
			final: false; opcode: 0.
		self sendFrame: frame ].
	(frame := ZnWebSocketFrame text: sequenceableCollection last)
		final: true; opcode: 0.
	self sendFrame: frame
	
]

{ #category : 'private' }
ZnWebSocket >> signalClosed: frame [
	"Turn a close frame that we received into a ZnWebSocketClosed exception and signal it."
	
	| exception |
	exception := ZnWebSocketClosed new.
	frame isEmpty 
		ifFalse: [
			exception 
				code: frame closeCode;
				reason: frame closeReason ].
	exception signal.
]

{ #category : 'accessing' }
ZnWebSocket >> stream [
	^ stream
]
