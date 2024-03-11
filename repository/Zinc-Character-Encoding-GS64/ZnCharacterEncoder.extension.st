Extension { #name : #ZnCharacterEncoder }

{ #category : #'*Zinc-Character-Encoding-GS64' }
ZnCharacterEncoder >> = anObject [
	^ self class == anObject class
]

{ #category : #'*Zinc-Character-Encoding-GS64' }
ZnCharacterEncoder class >> ascii [
	^ self newForEncoding: 'ASCII'
]

{ #category : #'*Zinc-Character-Encoding-GS64' }
ZnCharacterEncoder >> beLenient [
	"Don't be strict, which is the default"
]

{ #category : #'*Zinc-Character-Encoding-GS64' }
ZnCharacterEncoder >> byteOrderMark [
	"The code point of the Unicode Byte-Order-Mark or BOM character.
	See https://en.wikipedia.org/wiki/Byte_order_mark"

	^ 16rFEFF
]

{ #category : #'*Zinc-Character-Encoding-GS64' }
ZnCharacterEncoder >> decodeBytes: bytes [
	"Decode bytes and return the resulting string"

	| byteStream |
	byteStream := bytes readStream.
	^ String streamContents: [ :stream |
		[ byteStream atEnd ] whileFalse: [
			stream nextPut: (self nextFromStream: byteStream) ] ]
]

{ #category : #'*Zinc-Character-Encoding-GS64' }
ZnCharacterEncoder class >> default [
	"Return the default ZnCharacterEncoder to be used
	when none is otherwise specified."

	^ ZnDefaultCharacterEncoder value
]

{ #category : #'*Zinc-Character-Encoding-GS64' }
ZnCharacterEncoder class >> detectEncoding: bytes [
	"Return one of my instances capable of decoding bytes.
	This is done by successively trying known encodings in a specific order.
	If no one is found, signal ZnCharacterEncodingError.
	This is a heuristic and unreliable [https://en.wikipedia.org/wiki/Charset_detection]."

	| candidates |
	"Set up an ordered candidates list, 7-bit ascii and utf8 are reasonably reliable, iso88591 is a reasonable default"
	candidates := #(ascii utf8 iso88591).
	candidates := candidates , (ZnByteEncoder knownEncodingIdentifiers difference: candidates).
	candidates := candidates , (self knownEncodingIdentifiers difference: candidates).
	"Try each and return the first one that succeeeds."
	candidates do: [ :identifier | | encoder |
		encoder := self newForEncoding: identifier.
		[ ^ encoder decodeBytes: bytes; yourself ] on: ZnCharacterEncodingError do: [ ] ].
	ZnCharacterEncodingError signal: 'No suitable encoder found'
]

{ #category : #'*Zinc-Character-Encoding-GS64' }
ZnCharacterEncoder >> encodeString: string [
	"Encode string and return the resulting byte array"

	^ ByteArray streamContents: [ :stream |
		self next: string size putAll: string startingAt: 1 toStream: stream ]
]

{ #category : #'*Zinc-Character-Encoding-GS64' }
ZnCharacterEncoder >> encodeStringWithByteOrderMark: string [
	"Encode string and return the resulting byte array.
	Always add a Unicode byte order mark (BOM) in front."

	^ ByteArray streamContents: [ :stream |
		self nextPutByteOrderMarkToStream: stream.
		self next: string size putAll: string startingAt: 1 toStream: stream ]
]

{ #category : #'*Zinc-Character-Encoding-GS64' }
ZnCharacterEncoder >> encodedByteCountForCodePoint: codePoint [
	"Return how many bytes are needed to encode integer code point"

	self subclassResponsibility
]

{ #category : #'*Zinc-Character-Encoding-GS64' }
ZnCharacterEncoder >> error: message [
	^ ZnCharacterEncodingError signal: message
]

{ #category : #'*Zinc-Character-Encoding-GS64' }
ZnCharacterEncoder >> errorIncomplete [
	^ ZnIncomplete signal: 'Incomplete input for character decoding'
]

{ #category : #'*Zinc-Character-Encoding-GS64' }
ZnCharacterEncoder >> errorOutsideRange [
	^ self error: 'Character Unicode code point outside encoder range'
]

{ #category : #'*Zinc-Character-Encoding-GS64' }
ZnCharacterEncoder >> hash [
	^ self class hash
]

{ #category : #'*Zinc-Character-Encoding-GS64' }
ZnCharacterEncoder class >> iso88591 [
	^ self newForEncoding: 'iso-8859-1'
]

{ #category : #'*Zinc-Character-Encoding-GS64' }
ZnCharacterEncoder >> nextPutByteOrderMarkToStream: stream [
	"Write the encoded byte-order-mark (BOM) to stream"

	self nextPutCodePoint: self byteOrderMark toStream: stream
]

{ #category : #'*Zinc-Character-Encoding-GS64' }
ZnCharacterEncoder class >> utf8 [
	^ ZnUTF8Encoder default
]
