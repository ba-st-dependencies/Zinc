"
I am ZnWebSocketFrameTests.

"
Class {
	#name : 'ZnWebSocketFrameTests',
	#superclass : 'TestCase',
	#category : 'Zinc-WebSocket-Tests',
	#package : 'Zinc-WebSocket-Tests'
}

{ #category : 'testing' }
ZnWebSocketFrameTests >> testReading256ByteSingleFrameUnmaskedBinaryMessage [
	"Fifth example from RFC 6455 section 5.7"

	| payload bytes frame |
	payload := ZnWebSocketUtils randomByteArrayOfSize: 256.
	bytes := (ByteArray readHexFrom: '827e0100'), payload.
	frame := ZnWebSocketFrame readFrom: bytes readStream.
	self assert: frame isBinary.
	self deny: frame isMasked.
	self assert: frame isFinal.
	self assert: frame size equals: 256.
	self assert: frame body equals: payload.

]

{ #category : 'testing' }
ZnWebSocketFrameTests >> testReading256KiBSingleFrameUnmaskedBinaryMessage [
	"Fifth example from RFC 6455 section 5.7"

	| payload bytes frame |
	payload := ZnWebSocketUtils randomByteArrayOfSize: (2 raisedTo: 16).
	bytes := (ByteArray readHexFrom: '827f0000000000010000'), payload.
	frame := ZnWebSocketFrame readFrom: bytes readStream.
	self assert: frame isBinary.
	self deny: frame isMasked.
	self assert: frame isFinal.
	self assert: frame size equals: (2 raisedTo: 16).
	self assert: frame body equals: payload.

]

{ #category : 'testing' }
ZnWebSocketFrameTests >> testReadingFragmentedUnmaskedTextMessage [
	"Third example from RFC 6455 section 5.7"

	| bytes stream frame |
	bytes := ByteArray readHexFrom: '010348656c80026c6f'.
	stream := bytes readStream.
	frame := ZnWebSocketFrame readFrom: stream.
	self assert: frame isText.
	self deny: frame isMasked.
	self deny: frame isFinal.
	self assert: frame text equals: 'Hel'.
	self deny: stream atEnd.
	frame := ZnWebSocketFrame readFrom: stream.
	self assert: frame isContinuation.
	self deny: frame isMasked.
	self assert: frame isFinal.
	self assert: frame text equals: 'lo'.
	self assert: stream atEnd.
	
]

{ #category : 'testing' }
ZnWebSocketFrameTests >> testReadingPing [
	"Fourth example from RFC 6455 section 5.7"

	| bytes frame |
	bytes := ByteArray readHexFrom: '890548656c6c6f'.
	frame := ZnWebSocketFrame readFrom: bytes readStream.
	self assert: frame isPing.
	self deny: frame isMasked.
	self assert: frame isFinal.
	self assert: frame text equals: 'Hello'.

]

{ #category : 'testing' }
ZnWebSocketFrameTests >> testReadingPong [
	"Fourth example from RFC 6455 section 5.7"

	| bytes frame |
	bytes := ByteArray readHexFrom: '8a8537fa213d7f9f4d5158'.
	frame := ZnWebSocketFrame readFrom: bytes readStream.
	self assert: frame isPong.
	self assert: frame isMasked.
	self assert: frame isFinal.
	self assert: frame text equals: 'Hello'.

]

{ #category : 'testing' }
ZnWebSocketFrameTests >> testReadingSingleFrameMaskedTextMessage [
	"Second example from RFC 6455 section 5.7"
	
	| bytes frame |
	bytes := ByteArray readHexFrom: '818537fa213d7f9f4d5158'.
	frame := ZnWebSocketFrame readFrom: bytes readStream.
	self assert: frame isText.
	self assert: frame isMasked.
	self assert: frame isFinal.
	self assert: frame contents equals: 'Hello'
]

{ #category : 'testing' }
ZnWebSocketFrameTests >> testReadingSingleFrameUnmaskedTextMessage [
	"First example from RFC 6455 section 5.7"

	| bytes frame |
	bytes := ByteArray readHexFrom: '810548656c6c6f'.
	frame := ZnWebSocketFrame readFrom: bytes readStream.
	self assert: frame isText.
	self deny: frame isMasked.
	self assert: frame isFinal.
	self assert: frame contents equals: 'Hello'
]

{ #category : 'testing' }
ZnWebSocketFrameTests >> testWriting256ByteSingleFrameUnmaskedBinaryMessage [
	"Fifth example from RFC 6455 section 5.7"

	| payload reference bytes frame |
	payload := ZnWebSocketUtils randomByteArrayOfSize: 256.
	reference := (ByteArray readHexFrom: '827e0100'), payload.
	frame := ZnWebSocketFrame bytes: payload.
	frame masked: false.
	bytes := ByteArray streamContents: [ :stream | frame writeOn: stream ].
	self assert: bytes equals: reference

]

{ #category : 'testing' }
ZnWebSocketFrameTests >> testWriting256KiBSingleFrameUnmaskedBinaryMessage [
	"Fifth example from RFC 6455 section 5.7"

	| reference payload bytes frame |
	payload := ZnWebSocketUtils randomByteArrayOfSize: (2 raisedTo: 16).
	reference := (ByteArray readHexFrom: '827f0000000000010000'), payload.
	frame := ZnWebSocketFrame bytes: payload.
	frame masked: false.
	bytes := ByteArray streamContents: [ :stream | frame writeOn: stream ].
	self assert: bytes equals: reference

]

{ #category : 'testing' }
ZnWebSocketFrameTests >> testWritingPing [
	"Fourth example from RFC 6455 section 5.7"

	| reference bytes frame |
	reference := ByteArray readHexFrom: '890548656c6c6f'.
	frame := ZnWebSocketFrame ping: 'Hello' asByteArray.
	frame masked: false.
	bytes := ByteArray streamContents: [ :stream | frame writeOn: stream ].
	self assert: bytes equals: reference

]

{ #category : 'testing' }
ZnWebSocketFrameTests >> testWritingSingleFrameUnmaskedTextMessage [
	"First example from RFC 6455 section 5.7"

	| reference bytes frame |
	frame := ZnWebSocketFrame text: 'Hello'.
	frame masked: false.
	bytes := ByteArray streamContents: [ :stream | frame writeOn: stream ].
	reference := ByteArray readHexFrom: '810548656c6c6f'.
	self assert: bytes equals: reference
]
