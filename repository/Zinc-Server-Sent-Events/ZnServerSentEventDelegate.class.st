"
ZnServerSentEventDelegate is a ZnServer delegate that acts as a Server-Sent Events resource.

See ZnServerSentEvent's class comment for an introduction and some references.

I will check my prefix (if any), and initiate a Server-Sent Events response where a handler will #run: on the HTTP connection, using ZnServerSentEvent>>#writeOn: to push events to the client.

Without further configuration, I implement a simple example where a status string containing the time and memory usage are sent every 2 seconds.

My #clientHtml listens to simple status update event sent by the server, using ZnServerSentEventStatusHandler.

Installation

  ZnServerSentEventDelegate installInServer: ZnServer default.

Usage

  /sse-status-client - the HTML page with Javascript code
  /sse-status - the actual SSE resource

Part of Zinc HTTP Components.
"
Class {
	#name : 'ZnServerSentEventDelegate',
	#superclass : 'Object',
	#instVars : [
		'prefix',
		'handler'
	],
	#category : 'Zinc-Server-Sent-Events',
	#package : 'Zinc-Server-Sent-Events'
}

{ #category : 'accessing' }
ZnServerSentEventDelegate class >> clientHtml [
	^ '<html>
	<head>
	<title>Zinc Server-Side Events Status Demo</title>
	<script language="javascript" type="text/javascript">
	var source, statusElement;
	function init() {
		statusElement = document.getElementById("status");
		var source = new EventSource(''sse-status'');
		source.addEventListener(
			''status-update'', 
			function(event) {
				setStatus(event.data); 
			},
			false);
	}
	function setStatus(text) {
		statusElement.innerHTML = text;
	}
	window.addEventListener("load", init, false);
	</script>
	</head>
	<body>
	<h1>Zinc Server-Side Events Status Demo</h1>
	<div><pre id="status"></pre></div>
	</body>
	</html>'
]

{ #category : 'convenience' }
ZnServerSentEventDelegate class >> installInServer: server [
	"Install the demo application in a ZnServer with a ZnDefaultServerDelegate"
	
	server delegate
		map: 'sse-status-client'
		to: [ :request | ZnResponse ok: (ZnEntity html: self clientHtml) ];
		map: 'sse-status'
		to: self new
]

{ #category : 'public' }
ZnServerSentEventDelegate >> handleRequest: request [
	(prefix isNil or: [ prefix = request uri pathSegments ])
		ifFalse: [ ^ ZnResponse notFound: request uri ].
	^ self serverSentEventResponse
]

{ #category : 'accessing' }
ZnServerSentEventDelegate >> handler [
	"Default to our demo"
	
	^ handler ifNil: [ handler := ZnServerSentEventStatusHandler new ]
]

{ #category : 'initialize-release' }
ZnServerSentEventDelegate >> handler: object [
	handler := object
]

{ #category : 'accessing' }
ZnServerSentEventDelegate >> prefix [
	"Default to our demo"
	
	^ prefix ifNil: [ prefix := 'sse-status' ]
]

{ #category : 'initialize-release' }
ZnServerSentEventDelegate >> prefix: string [
	prefix := string
]

{ #category : 'accessing' }
ZnServerSentEventDelegate >> serverSentEventResponse [
	"Create and return a proper Server-Sent Events response.
	I pass my handler to the response as a continuation.
	After the response is written out, the handler with be sent #run: 
	with the open HTTP connection as argument."
	
	^ ZnServerSentEventResponse new
		statusLine: ZnStatusLine ok;
		headers: ZnHeaders defaultResponseHeaders;
		handler: self handler;
		setContentType: ZnServerSentEvent mimeType;
		yourself
]

{ #category : 'public' }
ZnServerSentEventDelegate >> value: request [
	^ self handleRequest: request
]
