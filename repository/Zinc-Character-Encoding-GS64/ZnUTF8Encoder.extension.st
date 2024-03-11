Extension { #name : #ZnUTF8Encoder }

{ #category : #'*Zinc-Character-Encoding-GS64' }
ZnUTF8Encoder >> decodeBytesIntoWideString: bytes [

	^ self decodeBytes: bytes
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
ZnUTF8Encoder >> isSurrogateCodePoint: codePoint [
	"Surrogate Code Points should not be encoded or decoded because they are not Unicode scalar values"

	^ codePoint between: 16rD800 and: 16rDFFF
]

{ #category : #'*Zinc-Character-Encoding-GS64' }
ZnUTF8Encoder >> maximumUTFCode [

	^ 16r10FFFF
]
