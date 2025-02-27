Class {
	#name : 'ZnChunkedStreamTest',
	#superclass : 'TestCase',
	#category : 'Zinc-Tests',
	#package : 'Zinc-Tests'
}

{ #category : 'private' }
ZnChunkedStreamTest >> nextPutAll: collection on: stream chunked: size [
	| written |
	written := 0.
	[ written < collection size ] whileTrue: [ | chunkSize |
		chunkSize := size min: (collection size - written).
		stream nextPutAll: chunkSize printStringHex.
		stream nextPutAll: String crlf.
		chunkSize timesRepeat: [ stream nextPut: (collection at: (written := written + 1)) ].
		stream nextPutAll: String crlf ].
	stream print: 0; nextPutAll: String crlf; nextPutAll: String crlf
]

{ #category : 'testing' }
ZnChunkedStreamTest >> testBinaryWriteRead [
	| data written read |
	data := ByteArray new: 1024 streamContents: [ :out |
		1024 timesRepeat: [ out nextPut: 256 atRandom - 1 ] ].
	written := ByteArray streamContents: [ :out |
		| stream |
		stream := ZnBufferedWriteStream on: (ZnChunkedWriteStream on: out).
		stream sizeBuffer: 256.
		1 to: 1024 by: 256 do: [ :each |
			stream next: 256 putAll: data startingAt: each ].
		stream close ].
	read := (ZnChunkedReadStream on: written readStream) upToEnd.
	self assert: read equals: data
]

{ #category : 'testing' }
ZnChunkedStreamTest >> testReading [
	| data chunked plain |
	data := 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ'.
	chunked := String streamContents: [ :stream |
		self nextPutAll: data on: stream chunked: 16 ].
	plain := (ZnChunkedReadStream on: chunked readStream) upToEnd.
	self assert: plain equals: data
]

{ #category : 'testing' }
ZnChunkedStreamTest >> testReadingBuffered [
	| data chunked plain buffer readStream |
	data := 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ'.
	chunked := String streamContents: [ :stream |
		self nextPutAll: data on: stream chunked: 16 ].
	readStream := ZnChunkedReadStream on: chunked readStream.
	buffer := String new: 11.
	plain := String streamContents: [ :output | | readCount |
		[ readStream atEnd ] whileFalse: [
			readCount := readStream readInto: buffer startingAt: 1 count: buffer size.
			output next: readCount putAll: buffer ] ].
	self assert: plain equals: data
]

{ #category : 'testing' }
ZnChunkedStreamTest >> testReadingNext [
	| data chunked plain |
	data := 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ'.
	chunked := String streamContents: [ :stream |
		self nextPutAll: data on: stream chunked: 16 ].
	plain := (ZnChunkedReadStream on: chunked readStream) next: 26 + 26.
	self assert: plain equals: data
]

{ #category : 'testing' }
ZnChunkedStreamTest >> testReadingNextInto [
	| data chunked plain |
	data := 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ'.
	chunked := String streamContents: [ :stream |
		self nextPutAll: data on: stream chunked: 16 ].
	plain := String new: 26 + 26.
	(ZnChunkedReadStream on: chunked readStream) next: 26 + 26 into: plain.
	self assert: plain equals: data
]

{ #category : 'testing' }
ZnChunkedStreamTest >> testWriting [
	| chunks result reference |
	chunks := #( 'ABC' 'DEF' 'GHI' 'JKL' ).
	result := String streamContents: [ :out |
		| stream |
		stream := ZnChunkedWriteStream on: out.
		chunks do: [ :each | stream nextPutAll: each ].
		stream finish ].
	reference := String streamContents: [ :out |
		self nextPutAll: (String new join: chunks) on: out chunked: 3 ].
	self assert: result equals: reference
]

{ #category : 'testing' }
ZnChunkedStreamTest >> testWritingBuffered [
	| data written read |
	data := 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ'.
	written := String streamContents: [ :out |
		| stream |
		stream := ZnBufferedWriteStream on: (ZnChunkedWriteStream on: out).
		stream sizeBuffer: 16.
		stream nextPutAll: data.
		stream close ].
	read := (ZnChunkedReadStream on: written readStream) upToEnd.
	self assert: read equals: data
]
