Extension { #name : #ZnUTF8Encoder }

{ #category : #'*Zinc-Character-Encoding-GS64' }
ZnUTF8Encoder >> backOnStream: stream [
	"Move back one character on stream"

	[ (stream back bitAnd: 2r11000000) == 2r10000000 ] whileTrue
]

{ #category : #'*Zinc-Character-Encoding-GS64' }
ZnUTF8Encoder >> decodeBytes: bytes [
	"Decode bytes and return the resulting string"

	| bom decoded decodedWithoutBOM |
	bom := Character withValue: self byteOrderMark.
	decoded := bytes decodeFromUTF8.
	decodedWithoutBOM := decoded reject: [ :character | character = bom ].
	(decodedWithoutBOM size ~= decoded size and: [
		 decodedWithoutBOM isEmpty ]) ifTrue: [ self errorIncomplete ].
	^ decodedWithoutBOM
]

{ #category : #'*Zinc-Character-Encoding-GS64' }
ZnUTF8Encoder >> decodeBytesIntoWideString: bytes [

	^ self decodeBytes: bytes
]

{ #category : #'*Zinc-Character-Encoding-GS64' }
ZnUTF8Encoder >> encodeCodePoints: codePoints [
	"Encode codePoints and return the resulting byte array"

	^ self handleArgumentErrorDuring: [
		  codePoints asByteArray asUnicodeString encodeAsUTF8 ]
]

{ #category : #'*Zinc-Character-Encoding-GS64' }
ZnUTF8Encoder >> encodeString: string [
	"Encode string and return the resulting Utf8 instance"

	^ self handleArgumentErrorDuring: [ string encodeAsUTF8 asByteArray ]
]

{ #category : #'*Zinc-Character-Encoding-GS64' }
ZnUTF8Encoder >> encodedByteCountFor: character [
	"Return how many bytes are needed to encode character"

	^ self handleArgumentErrorDuring: [
		  character asString encodeAsUTF8 size ]
]

{ #category : #'*Zinc-Character-Encoding-GS64' }
ZnUTF8Encoder >> encodedByteCountForCodePoint: codePoint [
	"Return how many bytes are needed to encode integer code point"

	codePoint < 128 ifTrue: [ ^ 1 ].
	codePoint < 2048 ifTrue: [ ^ 2 ].
	codePoint < 65535 ifTrue: [ ^ 3 ].
	codePoint <= self maximumUTFCode ifTrue: [ ^ 4 ].
	self errorOutsideRange.
	^ 0
]

{ #category : #'*Zinc-Character-Encoding-GS64' }
ZnUTF8Encoder >> ensureAtBeginOfCodePointOnStream: stream [
	"Ensure that the current position of stream is a the beginning of an encoded code point,
	if not move further backwards. This is necessary when a position in the binary stream is set,
	not knowing if that position is on a proper encoded character boundary."

	"If we are at end-of-stream, we can't be in the middle of an encoded codepoint
	(unless that codepoint is incomplete and thus invalid, which we won't worry about)"
	stream atEnd ifTrue: [ ^ self ].
	"Back up until we are not longer on a continuation byte but on a leading byte"
	[ (stream peek bitAnd: 2r11000000) == 2r10000000 ] whileTrue: [ stream back ]
]

{ #category : #'*Zinc-Character-Encoding-GS64' }
ZnUTF8Encoder >> errorIllegalLeadingByte [
	^ self error: 'Illegal leading byte for utf-8 encoding'
]

{ #category : #'*Zinc-Character-Encoding-GS64' }
ZnUTF8Encoder >> handleArgumentErrorDuring: aBlock [

	^ aBlock
		  on: ArgumentError
		  do: [ :error | ZnInvalidUTF8 signal: error messageText ]
]

{ #category : #'*Zinc-Character-Encoding-GS64' }
ZnUTF8Encoder >> identifier [
	^ 'utf8'
]

{ #category : #'*Zinc-Character-Encoding-GS64' }
ZnUTF8Encoder >> isSurrogateCodePoint: codePoint [
	"Surrogate Code Points should not be encoded or decoded because they are not Unicode scalar values"

	^ codePoint between: 16rD800 and: 16rDFFF
]

{ #category : #'*Zinc-Character-Encoding-GS64' }
ZnUTF8Encoder class >> knownEncodingIdentifiers [
	^ #( 'utf8' )
]

{ #category : #'*Zinc-Character-Encoding-GS64' }
ZnUTF8Encoder >> maximumUTFCode [

	^ 16r10FFFF
]

{ #category : #'*Zinc-Character-Encoding-GS64' }
ZnUTF8Encoder >> next: count putAll: string startingAt: offset toStream: stream [
	"Write count characters from string starting at offset to stream."

	self handleArgumentErrorDuring: [
		stream nextPutAll: (string copyFrom: offset to: offset + count - 1) encodeAsUTF8 asByteArray ]
]

{ #category : #'*Zinc-Character-Encoding-GS64' }
ZnUTF8Encoder >> nextCodePointFromStream: stream [
	"Read and return the next integer code point from stream"

	| code byte next |
	(byte := stream next ifNil: [ ^ self errorIncomplete ]) < 128
		ifTrue: [ ^ byte ].
	(byte bitAnd: 2r11100000) == 2r11000000
		ifTrue: [
			code := byte bitAnd: 2r00011111.
			((next := stream next ifNil: [ ^ self errorIncomplete ]) bitAnd: 2r11000000) == 2r10000000
				ifTrue: [ code := (code bitShift: 6) + (next bitAnd: 2r00111111) ]
				ifFalse: [ ^ self errorIllegalContinuationByte ].
			code < 128 ifTrue: [ ^ self errorOverlong ].
			^ code ].
	(byte bitAnd: 2r11110000) == 2r11100000
		ifTrue: [
			code := byte bitAnd: 2r00001111.
			2 timesRepeat: [
				((next := stream next ifNil: [ ^ self errorIncomplete ]) bitAnd: 2r11000000) == 2r10000000
					ifTrue: [ code := (code bitShift: 6) + (next bitAnd: 2r00111111) ]
					ifFalse: [ ^ self errorIllegalContinuationByte ] ].
			code < 2048 ifTrue: [ ^ self errorOverlong ].
			(self isSurrogateCodePoint: code) ifTrue: [ ^ self errorOutsideRange ].
			code = 65279 "Unicode Byte Order Mark" ifTrue: [
				stream atEnd ifTrue: [ ^ self errorIncomplete ].
				^ self nextCodePointFromStream: stream ].
			^ code ].
	(byte bitAnd: 2r11111000) == 2r11110000
		ifTrue: [
			code := byte bitAnd: 2r00000111.
			3 timesRepeat: [
				((next := stream next ifNil: [ ^ self errorIncomplete ]) bitAnd: 2r11000000) == 2r10000000
					ifTrue: [ code := (code bitShift: 6) + (next bitAnd: 2r00111111) ]
					ifFalse: [ ^ self errorIllegalContinuationByte ] ].
			code < 65535 ifTrue: [ ^ self errorOverlong ].
			code > self maximumUTFCode ifTrue: [ self errorOutsideRange ].
			^ code ].
	^ self errorIllegalLeadingByte
]

{ #category : #'*Zinc-Character-Encoding-GS64' }
ZnUTF8Encoder >> nextPutCodePoint: codePoint toStream: stream [
	"Write the encoding for Integer code point to stream"

	^ self handleArgumentErrorDuring: [
		stream nextPutAll: (Character codePoint: codePoint) asString encodeAsUTF8 ]
]
