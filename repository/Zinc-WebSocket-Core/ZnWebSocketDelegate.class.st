"
I am ZnWebSocketDelegate, a plugin to allow a ZnServer to accept incoming WebSocket requests.

When accepted, the request is upgraded and a new WebSocket is created and handed to the handler block.

Here is how to get 3 examples up and running:

	ZnServer startDefaultOn: 1701.
	ZnServer default logToTranscript.
	ZnWebSocketDelegate installExamplesInDefaultServer.
	ZnServer stopDefault.

Part of Zinc HTTP Components.
"
Class {
	#name : 'ZnWebSocketDelegate',
	#superclass : 'Object',
	#instVars : [
		'prefix',
		'handler'
	],
	#category : 'Zinc-WebSocket-Core',
	#package : 'Zinc-WebSocket-Core'
}

{ #category : 'constants' }
ZnWebSocketDelegate class >> demoHtml [
	^ '<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html>
<head>
<title>Zinc WebSocket Demo</title>
<style type="text/css">
body {
  color: black;
  background: white;
  width: 900px;
  font-family: Verdana, Arial, Helvetica, sans-serif;
  font-size: 13px;
}
p {
  width: 600px;
  padding: 0 20px 10px 20px;
} 
ul,ol {
  width: 600px;
  padding: 0 5px 5px 30px;
} 
#logo {
  color: orange;
  font-family: Helvetica, sans-serif;
  font-weight: bold;
  font-size: 100px;
}
li {
  margin-bottom: 1em;
}
</style>
</head>
<body>
<div id="logo">Zn</div>
<h1>Zinc WebSocket Demo</h1>
<ul>
  <li><a href="ws-echo-client">Echo</a> - websocket hello world: client connects, sends one message, server does an echo, client receives and shows message and disconnects</li>
  <li><a href="ws-echo-client-remote">Echo Remote</a> - websocket hello world against ws://echo.websocket.org (<a href="http://websocket.org">http://websocket.org</a>) for reference</li>
  <li><a href="ws-status-client">Status</a> - server side pushes continuous updates to client web page</li>
  <li><a href="ws-chatroom-client">Chatroom</a> - very simple chatroom: pick a handle and talk to all connected browsers</li>
</ul>
<h4>May the Source be with you!</h4>
</body></html>'
]

{ #category : 'instance creation' }
ZnWebSocketDelegate class >> handler: handler [
	"Create and return a new ZnWebSocketDelegate that maps / to handler"

	^ self new
		handler: handler;
		yourself
]

{ #category : 'examples' }
ZnWebSocketDelegate class >> installExamplesInDefaultServer [
	"Install the WebSocket examples in ZnServer default, 
	provided it has a ZnDefaultServerDelegate"
	
	self installExamplesInServer: ZnServer default
]

{ #category : 'examples' }
ZnWebSocketDelegate class >> installExamplesInServer: znServer [
	"Install the WebSocket examples in znServer, provided it has a ZnDefaultServerDelegate"
	
	znServer delegate
	     map: 'ws-demo'
		to: [ :request | ZnResponse ok: (ZnEntity html: self demoHtml) ];
		map: 'ws-echo-client-remote' 
		to: [ :request | ZnResponse ok: (ZnEntity html: ZnWebSocketEchoHandler clientHtmlRemote) ];
		map: 'ws-echo-client' 
		to: [ :request | ZnResponse ok: (ZnEntity html: ZnWebSocketEchoHandler clientHtml) ];
		map: 'ws-echo'
		to: (self map: 'ws-echo' to: ZnWebSocketEchoHandler new);
		map: 'ws-chatroom-client' 
		to: [ :request | ZnResponse ok: (ZnEntity html: ZnWebSocketChatroomHandler clientHtml) ];
		map: 'ws-chatroom'
		to: (self map: 'ws-chatroom' to: ZnWebSocketChatroomHandler new);
		map: 'ws-status-client' 
		to: [ :request | ZnResponse ok: (ZnEntity html: ZnWebSocketStatusHandler clientHtml) ];
		map: 'ws-status'
		to: (self map: 'ws-status' to: ZnWebSocketStatusHandler new)
]

{ #category : 'instance creation' }
ZnWebSocketDelegate class >> map: prefix to: handler [
	"Create and return a new ZnWebSocketDelegate that maps prefix string to handler"

	^ self new
		prefixFromString: prefix;
		handler: handler;
		yourself
]

{ #category : 'protocol' }
ZnWebSocketDelegate >> continuation [
	"Return a block that defines what happens after a successful connection upgrade.
	We will receive a ready-to-use instanciated WebSocket.
	We delegate processing to our handler."

	^ [ :webSocket | self handler value: webSocket ]
]

{ #category : 'public' }
ZnWebSocketDelegate >> handleRequest: request [
	"Server delegate entry point"
	
	(prefix isNil or: [ prefix = request uri pathSegments ])
		ifFalse: [ ^ ZnResponse notFound: request uri ].
	^ (self isValidWebSocketRequest: request)
			ifTrue: [ self webSocketResponseForRequest: request ]
			ifFalse: [ ZnResponse badRequest: request ]
]

{ #category : 'accessing' }
ZnWebSocketDelegate >> handler [
	"Return the block that will deal with the server side WebSocket,
	once a new WebSocket connection is accepted.
	The block will be evaluated with an instanciated ZnWebSocket instance as argument."

	^ handler
]

{ #category : 'initialize-release' }
ZnWebSocketDelegate >> handler: block [
	"Set the block that will deal with the server side WebSocket"
	
	handler := block
]

{ #category : 'protocol' }
ZnWebSocketDelegate >> isValidWebSocketRequest: request [
	"Return true when request can be considered a valid WebSocket setup request"
	
	^ request method = #GET
			and: [ (request headers at: 'Upgrade' ifAbsent: [ ^ false ]) asLowercase = 'websocket' 
				and: [ (ZnWebSocketUtils containsConnectionUpgrade: request headers) 
					and: [ (request headers at: 'Sec-WebSocket-Version' ifAbsent: [ ^ false ]) = '13'
						and: [ request headers includesKey: 'Sec-WebSocket-Key' ] ] ] ]
]

{ #category : 'accessing' }
ZnWebSocketDelegate >> prefix [
	"Return my prefix, the path elements under which I should handle a request"
	
	^ prefix
]

{ #category : 'private' }
ZnWebSocketDelegate >> prefix: orderedCollection [
	"Set my prefix to orderedCollection, interpreted as path elements.
	I will only handle requests that match."
	
	orderedCollection isEmpty
		ifFalse: [ prefix := orderedCollection ]
]

{ #category : 'initialize-release' }
ZnWebSocketDelegate >> prefixFromString: string [
	"Set the path prefix under which I should be handling request to string,
	interpreting each /-separated token as a path element"

	self prefix: (string findTokens: '/')
]

{ #category : 'private' }
ZnWebSocketDelegate >> responseHeadersForKey: key [
	"Return the headers for a WebSocket setup response, given key"
	
	^ ZnHeaders defaultResponseHeaders
			at: 'Upgrade' put: 'websocket';
			at: 'Connection' put: 'Upgrade';
			at: 'Sec-WebSocket-Accept' put: key;
			yourself
]

{ #category : 'public' }
ZnWebSocketDelegate >> value: request [
	"I implement the generic #value: message as equivalent to #handleRequest:"
	
	^ self handleRequest: request
]

{ #category : 'protocol' }
ZnWebSocketDelegate >> webSocketResponseForRequest: request [
	"Given a valid WebSocket setup request, return the matching server response"
	
	| acceptKey |
	acceptKey := ZnWebSocketUtils handshake: (request headers at: 'Sec-WebSocket-Key').
	^ ZnWebSocketResponse new
		statusLine: (ZnStatusLine code: 101);
		headers: (self responseHeadersForKey: acceptKey);
		continuation: self continuation;
		yourself
		
]
