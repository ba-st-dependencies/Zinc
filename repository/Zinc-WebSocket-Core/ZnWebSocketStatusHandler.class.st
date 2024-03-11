"
I am ZnWebSocketStatusHandler, emitting some Smalltalk image status data every second as a stream of WebSocket messages.

See the class comment of ZnWebSocketDelegate for an example using ZnWebSocketStatusHandler.

Part of Zinc HTTP Components.
"
Class {
	#name : 'ZnWebSocketStatusHandler',
	#superclass : 'Object',
	#category : 'Zinc-WebSocket-Core',
	#package : 'Zinc-WebSocket-Core'
}

{ #category : 'constants' }
ZnWebSocketStatusHandler class >> clientHtml [
	^ '<!DOCTYPE html>
<meta charset="utf-8" />
<title>WebSocket Smalltalk Image Status Stream</title>

<script language="javascript" type="text/javascript">

  var wsUri = "ws://" + location.host + "/ws-status";
  var output, statusElement;

  function init() {
    output = document.getElementById("output");
    statusElement = document.getElementById("status");
    testWebSocket();
  }

  function testWebSocket() {
    writeToScreen(wsUri);
    websocket = new WebSocket(wsUri);
    websocket.onopen = function(evt) { onOpen(evt) };
    websocket.onclose = function(evt) { onClose(evt) };
    websocket.onmessage = function(evt) { onMessage(evt) };
    websocket.onerror = function(evt) { onError(evt) };
  }

  function onOpen(evt) {
    writeToScreen("CONNECTED");
    setStatus("Waiting for status data...");
   }

  function onClose(evt) {
    writeToScreen("DISCONNECTED");
  }

  function onMessage(evt) {
    setStatus(evt.data);
  }

  function onError(evt) {
    writeToScreen("<span style=''color: red''>ERROR:</span> " + evt.data);
  }

  function writeToScreen(message) {
    var pre = document.createElement("p");
    pre.style.wordWrap = "break-word";
    pre.innerHTML = message;
    output.appendChild(pre);
  }

  function setStatus(text) {
    statusElement.innerHTML = text;
  }

  window.addEventListener("load", init, false);

</script>

<h2>WebSocket Smalltalk Image Status Stream</h2>
<div><pre id="status"></pre></div>
<h3>Log</h3>
<div id="output"></div>

</html> '
]

{ #category : 'accessing' }
ZnWebSocketStatusHandler >> processes [
	| allProcesses |
	allProcesses := (Process allSubInstances
		reject: [ :each | each isTerminated or: [ each = Processor activeProcess ] ])
			sorted: [ :a :b | a priority >= b priority ].
	^ String streamContents: [ :out |
		allProcesses doWithIndex: [ :each :index |
			out 
				print: index; nextPut: $.; space; 
				nextPutAll: each name; space;
				nextPut: $[; print: each priority; nextPut: $]; space;
				print: each; cr ] ]
]

{ #category : 'accessing' }
ZnWebSocketStatusHandler >> status [
	^ String cr join: { 
		DateAndTime now printString. 
		self systemVersionInfo. 
		self vmStats. 
		self processes }

]

{ #category : 'accessing' }
ZnWebSocketStatusHandler >> systemVersionInfo [
	^ String streamContents: [ :stream |
			stream 
				print: SystemVersion current; 
				nextPutAll: ' - '; 
				nextPutAll: ZnConstants defaultServerString ]
]

{ #category : 'accessing' }
ZnWebSocketStatusHandler >> value: webSocket [
	"I stream status messages to a WebSocket client, once every second 
	until ConnectionClosed or no longer isConnected"
	
	[ 
		webSocket logGeneric: 'Started status streaming'.
		[ 
			webSocket sendMessage: self status.
			1 second asDelay wait.
			webSocket isConnected ] whileTrue ] 
		on: NetworkError  
		do: [ webSocket logGeneric: 'Ignoring network error' ].
	webSocket logGeneric: 'Stopping status streaming' 
]

{ #category : 'accessing' }
ZnWebSocketStatusHandler >> vmStats [
	^ SmalltalkImage current vm statisticsReport
]
