"
I am ZnNullEncoder, a concrete subclass of ZnCharacterEncoder.
I perform no encoding or decoding at all for all characters with a code value below 256.

Note that in principle I could handle Latin1 (ISO-8859-1) or ASCII, although that is not completely correct. To get maximum efficiency, it remains an option.
	
Part of Zinc HTTP Components.
"
Class {
	#name : 'ZnNullEncoder',
	#superclass : 'ZnCharacterEncoder',
	#category : 'Zinc-Character-Encoding-Core',
	#package : 'Zinc-Character-Encoding-Core'
}

{ #category : 'accessing' }
ZnNullEncoder class >> handlesEncoding: string [
	"Return true when my instances handle the encoding described by string.
	Note that in principle I could handle latin1 (iso-8859-1) and ASCII,
	although that is not completely correct.
	To get maximum efficiency, it remains an option."

	^ (self canonicalEncodingIdentifier: string) = 'null'
]

{ #category : 'accessing' }
ZnNullEncoder class >> knownEncodingIdentifiers [
	^ #( 'null' )
]

{ #category : 'instance creation' }
ZnNullEncoder class >> newForEncoding: string [
	"No further parametrization needed"

	^ self new
]

{ #category : 'encoding - decoding' }
ZnNullEncoder >> backOnStream: stream [
	"Move back one character on stream"

	stream back
]

{ #category : 'convenience' }
ZnNullEncoder >> encodeString: string [
	"Encode string and return the resulting byte array"
	"Overwritten for performance reasons"

	^ string asByteArray
]

{ #category : 'encoding - decoding' }
ZnNullEncoder >> encodedByteCountFor: character [
	"Return how many bytes are needed to encode character"
	"Overwritten for performance reasons"

	^ 1
]

{ #category : 'encoding - decoding' }
ZnNullEncoder >> encodedByteCountForCodePoint: codePoint [
	"Return how many bytes are needed to encode integer code point"

	^ 1
]

{ #category : 'convenience' }
ZnNullEncoder >> encodedByteCountForCodePoints: codePoints [
	"Return the exact number of bytes it would take to encode codePoints as a byte array"
	"Overwritten for performance reasons"

	^ codePoints size
]

{ #category : 'convenience' }
ZnNullEncoder >> encodedByteCountForString: string [
	"Return the exact number of bytes it would take to encode string as a byte array"
	"Overwritten for performance reasons"

	^ string size
]

{ #category : 'encoding - decoding' }
ZnNullEncoder >> ensureAtBeginOfCodePointOnStream: stream [
	"Ensure that the current position of stream is a the beginning of an encoded code point,
	if not move further backwards. This is necessary when a position in the binary stream is set,
	not knowing if that position is on a proper encoded character boundary."

	"Nothing to be done, I am a byte encoding: each code point is encoded in a single byte"
]

{ #category : 'accessing' }
ZnNullEncoder >> identifier [
	^ 'null'
]

{ #category : 'convenience' }
ZnNullEncoder >> next: count putAll: string startingAt: offset toStream: stream [
	"Write count bytes from string starting at offset to stream."
	"Overwritten for performance reasons"

	string isByteString
		ifTrue: [
			offset to: offset + count - 1 do: [ :index |
				stream nextPut: (string byteAt: index) ] ]
		ifFalse: [
			super next: count putAll: string startingAt: offset toStream: stream ]
]

{ #category : 'encoding - decoding' }
ZnNullEncoder >> nextCodePointFromStream: stream [
	"Read and return the next integer code point from stream"

	^ stream next
]

{ #category : 'encoding - decoding' }
ZnNullEncoder >> nextPutCodePoint: codePoint toStream: stream [
	"Write the encoding for Integer code point to stream"

	codePoint < 256
		ifTrue: [ stream nextPut: codePoint ]
		ifFalse: [ self errorOutsideRange ]
]

{ #category : 'convenience' }
ZnNullEncoder >> readInto: string startingAt: offset count: requestedCount fromStream: stream [
	"Read requestedCount characters into string starting at offset,
	returning the number read, there could be less available when stream is atEnd"
	"Overwritten for performance reasons"

	offset to: offset + requestedCount - 1 do: [ :index |
		stream atEnd ifTrue: [ ^ index - offset ].
		string byteAt: index put: stream next ].
	^ requestedCount
]

{ #category : 'encoding - decoding' }
ZnNullEncoder >> skipToBeginOfCodePointOnStream: stream [
	"Ensure that the current position of stream is a the beginning of an encoded code point,
	if not move further forward. This is necessary when a position in the binary stream is set,
	not knowing if that position is on a proper encoded character boundary."

	"Nothing to be done, I am a byte encoding: each code point is encoded in a single byte"
]
