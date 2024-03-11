"
I am ZnWebSocketChatroomHandler, I send a copy of each incoming message over a WebSocket to all WebSockets currently open, thus implementing a simple chat room.

See the class comment of ZnWebSocketDelegate for an example using ZnWebSocketChatroomHandler.

Part of Zinc HTTP Components.
"
Class {
	#name : 'ZnWebSocketChatroomHandler',
	#superclass : 'Object',
	#instVars : [
		'webSockets',
		'lock'
	],
	#category : 'Zinc-WebSocket-Core',
	#package : 'Zinc-WebSocket-Core'
}

{ #category : 'constants' }
ZnWebSocketChatroomHandler class >> clientHtml [
	^ '<!DOCTYPE html>
<meta charset="utf-8" />
<title>WebSocket Chatroom</title>

<script language="javascript" type="text/javascript">

  var wsUri = "ws://" + location.host + "/ws-chatroom";
  var websocket;
  var output, handleInput, messageInput, sendButton, closeButton;

  function init() {
    output = document.getElementById("output");
    handleInput = document.getElementById("handleInput");
    messageInput = document.getElementById("messageInput");
    sendButton = document.getElementById("sendButton");
    closeButton = document.getElementById("closeButton");
    handleInput.value = "user-" + (new Date()).getMilliseconds();
    messageInput.onkeyup = function (evt) { if (evt.keyCode == 13) sendChatMessage(evt) }
    sendButton.onclick = function (evt) { sendChatMessage(evt) };
    closeButton.onclick = function (evt) { closeChat(evt) };
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
    doSend("Hi there !");
  }

  function onClose(evt) {
    writeToScreen("DISCONNECTED");
  }

  function onMessage(evt) {
    writeToScreen(evt.data);
   }

  function onError(evt) {
    writeToScreen("<span style=''color: red''>ERROR:</span> " + evt.data);
  }

  function doSend(message) {
     websocket.send(handleInput.value + ">>" + message);
  }

  function writeToScreen(message) {
    var pre = document.createElement("p");
    pre.style.wordWrap = "break-word";
    pre.innerHTML = message;
    output.appendChild(pre);
  }

  function sendChatMessage(evt) {
    doSend(messageInput.value);
    messageInput.value = "";
  }

  function closeChat(evt) {
    doSend("Bye!");
    websocket.close();
  }

  window.addEventListener("load", init, false);

</script>

<h2>WebSocket Chatroom</h2>
<div>
Handle: <input id="handleInput" type="text"/>
Message: <input id="messageInput" type="text" size="64"/> 
<input id="sendButton" type="submit" value="Send"/>
<input id="closeButton" type="submit" value="Close"/>
</div>
<div id="output"></div>

</html> '

]

{ #category : 'protocol' }
ZnWebSocketChatroomHandler >> distributeMessage: message [ 
	"Send message to all client WebSockets that we know."
	
	lock critical: [
		webSockets do: [ :each |
			[ each sendMessage: message ]
				on: NetworkError 
				do: [ :exception |
					"We can ignore this (instead of #unregister:-ing the offender), 
					since the listener process (see #value:) will do the right thing" 
					each logGeneric: exception printString, ' in ditributeMessage, ignoring' ] ] ]
]

{ #category : 'initialize-release' }
ZnWebSocketChatroomHandler >> initialize [
	webSockets := OrderedCollection new.
	lock := Mutex new
]

{ #category : 'protocol' }
ZnWebSocketChatroomHandler >> register: clientWebSocket [
	lock critical: [
		webSockets add: clientWebSocket ]
]

{ #category : 'protocol' }
ZnWebSocketChatroomHandler >> unregister: clientWebSocket [
	lock critical: [
		webSockets remove: clientWebSocket ifAbsent: [ ] ]
]

{ #category : 'accessing' }
ZnWebSocketChatroomHandler >> value: webSocket [
	"I implement a simple chat room service as a server:
	distributing incoming messages to all known clients"
	
	[
		self register: webSocket.
		webSocket runWith: [ :message |
			webSocket logGeneric: 'Received message: ', message printString.
			self distributeMessage: message ] ] 
		on: NetworkError 
		do: [
			webSocket logGeneric: 'Network error, cleaning up'.
			self unregister: webSocket ]
]
