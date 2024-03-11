"
I am ZnWebSocketUtils.

Part of Zinc HTTP Components.
"
Class {
	#name : 'ZnWebSocketUtils',
	#superclass : 'Object',
	#category : 'Zinc-WebSocket-Core',
	#package : 'Zinc-WebSocket-Core'
}

{ #category : 'accessing' }
ZnWebSocketUtils class >> containsConnectionUpgrade: headers [
	^ (((headers at: 'Connection' ifAbsent: [ ^ false ]) 
			findTokens: ',') 
				collect: [ :each | each trimBoth asLowercase ]) 
					includes: 'upgrade'
]

{ #category : 'protocol' }
ZnWebSocketUtils class >> handshake: clientKey [
	"Perform the WebSocket key handshake"
	
	"self handshake: 'dGhlIHNhbXBsZSBub25jZQ=='"
	
	| string hash |
	string := clientKey, self serverGUID.
	hash := SHA1 hashMessage: string.
	^ ZnUtils encodeBase64: hash
]

{ #category : 'protocol' }
ZnWebSocketUtils class >> newClientKey [
	"Generate a new WebSocket client key"
	
	| rawKey |
	rawKey := self randomByteArrayOfSize: 16.
	^ ZnUtils encodeBase64: rawKey
]

{ #category : 'accessing' }
ZnWebSocketUtils class >> newMask [
	^ self randomByteArrayOfSize: 4
]

{ #category : 'accessing' }
ZnWebSocketUtils class >> newPingPayload [
	^ self randomByteArrayOfSize: 4
]

{ #category : 'accessing' }
ZnWebSocketUtils class >> randomByteArrayOfSize: size [
	^ ByteArray new: size streamContents: [ :stream |
		size timesRepeat: [ 
			stream nextPut: 256 atRandom - 1 ] ].

]

{ #category : 'constants' }
ZnWebSocketUtils class >> serverGUID [
	"This is the special WebSocket server GUID"
	
	^ '258EAFA5-E914-47DA-95CA-C5AB0DC85B11'
]
