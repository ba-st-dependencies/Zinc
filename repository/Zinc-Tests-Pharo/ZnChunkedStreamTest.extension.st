Extension { #name : #ZnChunkedStreamTest }

{ #category : #'*Zinc-Tests-Pharo' }
ZnChunkedStreamTest >> testGzipWriteRead [
	| data written read |
	data := String streamContents: [ :out |
		{ Collection. Stream. Exception. Magnitude } do: [ :cls |
			cls allSubclassesDo: [ :each | out nextPutAll: each comment ] ] ].
	data := data asByteArray.
	written := ByteArray streamContents: [ :out |
		| stream chunkedStream |
		stream := GZipWriteStream on: (chunkedStream := ZnChunkedWriteStream on: out).
		stream nextPutAll: data.
		stream finish.
		chunkedStream finish ].
	read := (GZipReadStream on: (ZnChunkedReadStream on: written readStream)) upToEnd.
	self assert: read equals: data
]

{ #category : #'*Zinc-Tests-Pharo' }
ZnChunkedStreamTest >> testReadingGzip [
	| data gzipped chunked plain |
	data := String withAll: ($a to: $z), ($A to: $Z).
	gzipped := String streamContents: [ :stream |
		(GZipWriteStream on: stream) nextPutAll: data; close ].
	chunked := String streamContents: [ :stream |
		self nextPutAll: gzipped on: stream chunked: 16 ].
	plain := (GZipReadStream on: (ZnChunkedReadStream on: chunked readStream)) upToEnd.
	self assert: data equals: plain
]

{ #category : #'*Zinc-Tests-Pharo' }
ZnChunkedStreamTest >> testReadingGzipStepped [
	| data gzipped chunked unchunked ungzipped |
	data := String withAll: ($a to: $z), ($A to: $Z).
	gzipped := String streamContents: [ :stream |
		(GZipWriteStream on: stream) nextPutAll: data; close ].
	chunked := String streamContents: [ :stream |
		self nextPutAll: gzipped on: stream chunked: 16 ].
	unchunked := (ZnChunkedReadStream on: chunked readStream) upToEnd.
	ungzipped := (GZipReadStream on: unchunked) upToEnd.
	self assert: gzipped equals: unchunked.
	self assert: data equals: ungzipped
]
