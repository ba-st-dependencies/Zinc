"
I am ZnWebSocketEchoHandler, implementing an echo service conversation as a WebSocket server: reading messages and echoing them back until ConnectionClosed.

See the class comment of ZnWebSocketDelegate for an example using ZnWebSocketEchoHandler.

Part of Zinc HTTP Components.
"
Class {
	#name : 'ZnWebSocketEchoHandler',
	#superclass : 'Object',
	#category : 'Zinc-WebSocket-Core',
	#package : 'Zinc-WebSocket-Core'
}

{ #category : 'constants' }
ZnWebSocketEchoHandler class >> clientHtml [
	^ '<!DOCTYPE html>
<meta charset="utf-8" />
<title>WebSocket Test</title>

<script language="javascript" type="text/javascript">

  var wsUri = "ws://" + location.host + "/ws-echo";
  var output;

  function init() {
    output = document.getElementById("output");
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
    doSend("WebSocket rocks");
  }

  function onClose(evt) {
    writeToScreen("DISCONNECTED");
  }

  function onMessage(evt) {
    writeToScreen("<span style=''color: blue;''>RESPONSE: " + evt.data+"</span>");
    websocket.close();
  }

  function onError(evt) {
    writeToScreen("<span style=''color: red''>ERROR:</span> " + evt.data);
  }

  function doSend(message) {
    writeToScreen("SENT: " + message); 
    websocket.send(message);
  }

  function writeToScreen(message) {
    var pre = document.createElement("p");
    pre.style.wordWrap = "break-word";
    pre.innerHTML = message;
    output.appendChild(pre);
  }

  window.addEventListener("load", init, false);

</script>

<h2>WebSocket Test</h2>
<div id="output"></div>

</html> '
]

{ #category : 'constants' }
ZnWebSocketEchoHandler class >> clientHtmlRemote [
	^ '<!DOCTYPE html>
<meta charset="utf-8" />
<title>WebSocket Test</title>

<script language="javascript" type="text/javascript">

  var wsUri = "ws://echo.websocket.org";
  var output;

  function init() {
    output = document.getElementById("output");
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
    doSend("WebSocket rocks");
  }

  function onClose(evt) {
    writeToScreen("DISCONNECTED");
  }

  function onMessage(evt) {
    writeToScreen("<span style=''color: blue;''>RESPONSE: " + evt.data+"</span>");
    websocket.close();
  }

  function onError(evt) {
    writeToScreen("<span style=''color: red''>ERROR:</span> " + evt.data);
  }

  function doSend(message) {
    writeToScreen("SENT: " + message); 
    websocket.send(message);
  }

  function writeToScreen(message) {
    var pre = document.createElement("p");
    pre.style.wordWrap = "break-word";
    pre.innerHTML = message;
    output.appendChild(pre);
  }

  window.addEventListener("load", init, false);

</script>

<h2>WebSocket Test</h2>
<div id="output"></div>

</html> '
]

{ #category : 'accessing' }
ZnWebSocketEchoHandler >> value: webSocket [
	"I implement an echo service conversation as a server:
	reading messages and echoing them back until ConnectionClosed"
	
	[ 
		webSocket runWith: [ :message |
			webSocket logGeneric: 'Received message: ', message printString, ', echoing'.
			webSocket sendMessage: message ] ] 
		on: ConnectionClosed 
		do: [ webSocket logGeneric: 'Ignoring connection close, done' ]
]
