"
I am ZnWebSocketFrame, the elementary, low-level unit of data transfer in the WebSocket protocol.

A frame has an opcode (a type), a flag indicating whether it is the final frame in a sequence, a flag indicating whether it is masked and a body (a ByteArray).

The wire encoding of a frame consists minimally of 2 bytes: the first holds the opcode and final bit, the second the size and masked bit. Sizes strictly smaller than 126 are encoded directly. If the first byte is 126, the size is encoded in 2 successive bytes. If the first byte is 127, the size is encoded in 8 successive bytes. Client to server messages are masked. A 4 byte mask is XOR-ed with all body bytes. See #readFrom: and #writeOn: for the details.

This implementation follows RFC 6455. See also:

	http://en.wikipedia.org/wiki/Websockets
	http://tools.ietf.org/html/rfc6455

Part of Zinc HTTP Components.
"
Class {
	#name : 'ZnWebSocketFrame',
	#superclass : 'Object',
	#instVars : [
		'opcode',
		'final',
		'masked',
		'body'
	],
	#category : 'Zinc-WebSocket-Core',
	#package : 'Zinc-WebSocket-Core'
}

{ #category : 'instance creation' }
ZnWebSocketFrame class >> bytes: byteArray [
	^ self new
		opcode: 2;
		final: true;
		body: byteArray;
		yourself
]

{ #category : 'instance creation' }
ZnWebSocketFrame class >> close [
	^ self new
		opcode: 8;
		final: true;
		yourself
]

{ #category : 'instance creation' }
ZnWebSocketFrame class >> ping: bytes [
	^ self new
		opcode: 9;
		final: true;
		body: bytes;
		yourself
]

{ #category : 'instance creation' }
ZnWebSocketFrame class >> pong: bytes [
	^ self new
		opcode: 10;
		final: true;
		body: bytes;
		yourself
]

{ #category : 'instance creation' }
ZnWebSocketFrame class >> readFrom: stream [
	^ self new
		readFrom: stream;
		yourself
]

{ #category : 'instance creation' }
ZnWebSocketFrame class >> text: string [
	^ self new
		opcode: 1;
		final: true;
		text: string;
		yourself
]

{ #category : 'accessing' }
ZnWebSocketFrame >> body [
	^ body
]

{ #category : 'accessing' }
ZnWebSocketFrame >> body: anObject [
	body := anObject
]

{ #category : 'accessing' }
ZnWebSocketFrame >> closeCode [
	self assert: self isClose.
	self assert: self isEmpty not.
	^ (body readStream next: 2) asInteger
	
]

{ #category : 'accessing' }
ZnWebSocketFrame >> closeReason [
	self assert: self isClose.
	self assert: self isEmpty not.
	^ ZnUTF8Encoder new decodeBytes: (body allButFirst: 2)
	
]

{ #category : 'accessing' }
ZnWebSocketFrame >> contents [
	self assert: self isControl not.
	^ self isText
		ifTrue: [ self text ]
		ifFalse: [ body ]
]

{ #category : 'accessing' }
ZnWebSocketFrame >> final [
	^ final
]

{ #category : 'accessing' }
ZnWebSocketFrame >> final: anObject [
	final := anObject
]

{ #category : 'initialize-release' }
ZnWebSocketFrame >> initialize [
	super initialize.
	final := true
]

{ #category : 'testing' }
ZnWebSocketFrame >> isBinary [
	^ opcode = 2
]

{ #category : 'testing' }
ZnWebSocketFrame >> isClose [
	^ opcode = 8
]

{ #category : 'testing' }
ZnWebSocketFrame >> isContinuation [
	^ opcode = 0
]

{ #category : 'testing' }
ZnWebSocketFrame >> isControl [
	^ opcode > 7
]

{ #category : 'testing' }
ZnWebSocketFrame >> isEmpty [
	^ self size = 0
]

{ #category : 'testing' }
ZnWebSocketFrame >> isFinal [
	^ final
]

{ #category : 'testing' }
ZnWebSocketFrame >> isMasked [
	^ masked
]

{ #category : 'testing' }
ZnWebSocketFrame >> isPing [
	^ opcode = 9
]

{ #category : 'testing' }
ZnWebSocketFrame >> isPong [
	^ opcode = 10
]

{ #category : 'testing' }
ZnWebSocketFrame >> isText [
	^ opcode = 1
]

{ #category : 'accessing' }
ZnWebSocketFrame >> masked [
	^ masked
]

{ #category : 'accessing' }
ZnWebSocketFrame >> masked: anObject [
	masked := anObject
]

{ #category : 'accessing' }
ZnWebSocketFrame >> opcode [
	^ opcode
]

{ #category : 'accessing' }
ZnWebSocketFrame >> opcode: anObject [
	opcode := anObject
]

{ #category : 'accessing' }
ZnWebSocketFrame >> opcodeName [
	| name |
	self assert: (opcode between: 0 and: 15).
	name := #(continuation text binary nil nil nil nil nil close ping pong nil nil nil nil nil) at: opcode + 1.
	^ name ifNil: [ opcode asString ] ifNotNil: [ name ]
]

{ #category : 'printing' }
ZnWebSocketFrame >> printOn: stream [
	super printOn: stream.
	stream 
		nextPut: $(; 
		print: self opcodeName;
		space;
		print: self size; nextPut: $B; 
		space;
		nextPutAll: (final ifTrue: [ 'final' ] ifFalse: [ 'non-final' ]);
		nextPut: $)
]

{ #category : 'private' }
ZnWebSocketFrame >> readBodyOfSize: size from: stream [
	| mask |
	masked 
		ifTrue: [ 
			mask := stream next: 4.
			body := ByteArray new: size streamContents: [ :out |
				1 to: size do: [ :index |
					out nextPut: (stream next bitXor: (mask at: ((index - 1) \\ 4) + 1)) ] ] ]
		ifFalse: [
			body := stream next: size ]
]

{ #category : 'reading' }
ZnWebSocketFrame >> readFrom: stream [
	| byte size mask |
	(byte := stream next) ifNil: [ ConnectionClosed signal ].
	final := (byte bitAt: 8) = 1.
	opcode := byte bitAnd: 127.
	(byte := stream next) ifNil: [ ConnectionClosed signal ].
	masked := (byte bitAt: 8) = 1.
	size := byte bitAnd: 127.
	size < 126
		ifFalse: [
			size = 126
				ifTrue: [ size := (stream next: 2) asInteger ]
				ifFalse: [ size := (stream next: 8) asInteger ].
			size = 0 ifTrue: [ ConnectionClosed signal ] ].
	self readBodyOfSize: size from: stream
]

{ #category : 'accessing' }
ZnWebSocketFrame >> size [
	"Return the body size in bytes"
	
	^ body 
		ifNil: [ 0 ] 
		ifNotNil: [ body size ].
]

{ #category : 'accessing' }
ZnWebSocketFrame >> text [
	^ ZnUTF8Encoder new decodeBytes: body
]

{ #category : 'accessing' }
ZnWebSocketFrame >> text: string [
	self body: (ZnUTF8Encoder new encodeString: string)

]

{ #category : 'private' }
ZnWebSocketFrame >> writeBodyOfSize: size on: stream [
	| mask |
	masked
		ifTrue: [
			mask := ZnWebSocketUtils newMask.
			stream nextPutAll: mask ].
	size = 0 ifTrue: [ ^ self ].
	masked 
		ifTrue: [
			body doWithIndex: [ :each :index |
				stream nextPut: (each bitXor: (mask at: ((index - 1) \\ 4) + 1)) ] ] 
		ifFalse: [ self writeRawBodyOn: stream ]
]

{ #category : 'writing' }
ZnWebSocketFrame >> writeOn: stream [
	| byte size |
	byte := (final ifTrue: [ 128 ] ifFalse: [ 0 ]) + opcode.
	stream nextPut: byte.
	byte := (masked ifTrue: [ 128 ] ifFalse: [ 0 ]).
	(size := self size) < 126
		ifTrue: [ stream nextPut: (byte + size) ]
		ifFalse: [
			size < 65536
				ifTrue: [ stream nextPut: (byte + 126); nextPutAll: (size asByteArrayOfSize: 2) ]
				ifFalse: [
					self assert: size < (2 raisedTo: 31).
					stream nextPut: (byte + 127); nextPutAll: (size asByteArrayOfSize: 8) ] ].
	self writeBodyOfSize: size on: stream 
]

{ #category : 'private' }
ZnWebSocketFrame >> writeRawBodyOn: stream [
	self isEmpty
		ifFalse: [ stream nextPutAll: body ]
]
