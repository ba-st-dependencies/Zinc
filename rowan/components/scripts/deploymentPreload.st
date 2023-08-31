| symbolDictionary |
symbolDictionary := Rowan image 
	symbolDictNamed: 'Zinc'
	ifAbsent: [
			Rowan image symbolList createDictionaryNamed: 'Zinc' at: Rowan image symbolList size + 1.
			Rowan image symbolDictNamed: 'Zinc'
	].
symbolDictionary at: #PrimitiveFailed put: ArgumentError.
symbolDictionary at: #ByteString put: String.
symbolDictionary at: #WideString put: String.
"Just to make code compile, later is configured in a post-load script"
symbolDictionary at: #SocketAddress put: nil.
symbolDictionary at: #Socket put: nil.
symbolDictionary at: #SocketStream put: nil.

ZnUTF8Encoder class
compileMethod:
'knownEncodingIdentifiers
	^ #( ''utf8'' )'
 dictionaries: GsCurrentSession currentSession symbolList
 category: 'accessing'.
ZnUTF8Encoder
compileMethod: 
'backOnStream: stream
	"Move back one character on stream"

	[ (stream back bitAnd: 2r11000000) == 2r10000000 ] whileTrue'
 dictionaries: GsCurrentSession currentSession symbolList
 category: 'converting';
compileMethod:
'decodeBytes: bytes
	"Decode bytes and return the resulting string"

	| bom decoded decodedWithoutBOM |
	bom := Character withValue: self byteOrderMark.
	decoded := bytes decodeFromUTF8.
	decodedWithoutBOM := decoded reject: [ :character | character = bom ].
	(decodedWithoutBOM size ~= decoded size and: [
		 decodedWithoutBOM isEmpty ]) ifTrue: [ self errorIncomplete ].
	^ decodedWithoutBOM'
 dictionaries: GsCurrentSession currentSession symbolList
 category: 'convenience';
compileMethod:
'encodedByteCountFor: character
	"Return how many bytes are needed to encode character"
		
	^ self handleArgumentErrorDuring: [
      character asString encodeAsUTF8 size ]'
 dictionaries: GsCurrentSession currentSession symbolList
 category: 'encoding - decoding';
compileMethod:
'encodeCodePoints: codePoints
	"Encode codePoints and return the resulting byte array"

	^ self handleArgumentErrorDuring: [
		  codePoints asByteArray asUnicodeString encodeAsUTF8 ]'
dictionaries: GsCurrentSession currentSession symbolList
 category: 'encoding - decoding';
compileMethod:
'encodeString: string
	"Encode string and return the resulting Utf8 instance"
	
	^ self handleArgumentErrorDuring: [ string encodeAsUTF8 asByteArray]'
dictionaries: GsCurrentSession currentSession symbolList
 category: 'encoding - decoding';
compileMethod:
'next: count putAll: string startingAt: offset toStream: stream
	"Write count characters from string starting at offset to stream."
	
	self handleArgumentErrorDuring: [
    stream nextPutAll: (string copyFrom: offset to: offset + count - 1) encodeAsUTF8 asByteArray ]'
 dictionaries: GsCurrentSession currentSession symbolList
 category: 'encoding - decoding';
compileMethod:
'nextPutCodePoint: codePoint toStream: stream
	"Write the encoding for Integer code point to stream"

	^ self handleArgumentErrorDuring: [
      stream nextPutAll: (Character codePoint: codePoint) asString encodeAsUTF8]'
dictionaries: GsCurrentSession currentSession symbolList
 category: 'encoding - decoding';
 compileMethod:
 'nextCodePointFromStream: stream
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
	^ self errorIllegalLeadingByte'
 dictionaries: GsCurrentSession currentSession symbolList
 category: 'encoding - decoding';
compileMethod:
  'readInto: string startingAt: offset count: requestedCount fromStream: stream
	"Read requestedCount characters into string starting at offset,
	returning the number read, there could be less available when stream is atEnd."

	| stringBuffer |
	stringBuffer := string.
	offset to: offset + requestedCount - 1 do: [ :index | | codePoint |
		stream atEnd ifTrue: [ ^ index - offset ].
		codePoint := self nextCodePointFromStream: stream.
		stringBuffer at: index put: (Character value: codePoint) ].
	^ requestedCount'
 dictionaries: GsCurrentSession currentSession symbolList
 category: 'convenience'.
ByteArray
compileMethod:
'decodeFromUTF8
"Decode receiver from UTF8 format.
 Returns either a Unicode7 , Unicode16 or Unicode32 ,
 using the minimum character size needed to represent decoded result."

^ self handleArgumentErrorDuring: [
    self _decodeUtf8StartingAt: 1 unicodeResult: true maxSize: nil bytesConsumed: nil]'
 dictionaries: GsCurrentSession currentSession symbolList
 category: 'Encoding'.
CharacterCollection
 compileMethod:
 'asZnCharacterEncoder
	"Return a ZnCharacterEncoder instance using the receiver as identifier"

	^ ZnCharacterEncoder newForEncoding: self'
 dictionaries: GsCurrentSession currentSession symbolList
 category: '*filesystem-gemstone-kernel'.
ZnCharacterEncoder
compileMethod:
'encodedByteCountForCodePoints: codePoints
	"Return the exact number of bytes it would take to encode codePoints as a byte array"

	^ codePoints
		inject: 0
		into: [ :sum :each |
			sum + (self encodedByteCountForCodePoint: each) ]'
 dictionaries: GsCurrentSession currentSession symbolList
 category: 'Encoding';
 compileMethod:
 'encodeCodePoints: codePoints
	"Encode codePoints and return the resulting byte array"

	^ ByteArray streamContents: [ :stream |
		codePoints do: [ :each |
			self nextPutCodePoint: each toStream: stream ] ]'
 dictionaries: GsCurrentSession currentSession symbolList
 category: 'Encoding';
compileMethod:
 'decodeAsCodePoints: bytes
	"Decode bytes and return the resulting code points"

	| byteStream |
	byteStream := bytes readStream.
	^ Array streamContents: [ :stream |
		[ byteStream atEnd ] whileFalse: [
			stream nextPut: (self nextCodePointFromStream: byteStream) ] ]'
 dictionaries: GsCurrentSession currentSession symbolList
 category: 'Decoding'.
 ZnCharacterEncoder class compileMethod:
  'newForEncoding: string
	"Return a new character encoder object for an encoding described by string.
	Search for a subclass that handles it and delegate (subclassResponsibility)."

	| concreteSubclass |
	concreteSubclass := self allSubclasses
		detect: [ :each | each handlesEncoding: string ]
		ifNone: [ ^ self default ].
	^ concreteSubclass newForEncoding: string'
 dictionaries: GsCurrentSession currentSession symbolList
 category: 'instance creation'.
ZnCharacterReadStream compileMethod:
  'nextLine
	"Read a CR, LF or CRLF terminated line, returning the contents of the line without the EOL. Return nil when the receiver is #atEnd."

	self atEnd ifTrue: [ ^ nil ].
	^ self collectionSpecies streamContents: [ :out | | eol char |
		eol := false.
		[ eol ] whileFalse: [
			char := self next.
			(char isNil or: [ char = Character lf ])
				ifTrue: [ eol := true ]
				ifFalse: [
					char = Character cr
						ifTrue: [ eol := true. self peekFor: Character lf ]
						ifFalse: [ out nextPut: char ] ] ] ]'
 dictionaries: GsCurrentSession currentSession symbolList
 category: 'accessing';
compileMethod: 
'upToAll: aCollection
	"Answer a subcollection from the current access position to the occurrence (if any, but not inclusive) of aCollection. If aCollection is not in the stream, answer the entire rest of the stream."

	^ self collectionSpecies streamContents: [ :out | | pattern |
		pattern := aCollection readStream.
		([ self atEnd or: [ pattern atEnd ] ]) whileFalse: [
			self peek = pattern peek
				ifTrue: [
					self next. pattern next ]
				ifFalse: [
					pattern position = 0
						ifTrue: [ out nextPut: self next ]
						ifFalse: [ out next: pattern position putAll: aCollection ].
					pattern reset ] ].
		pattern atEnd
			ifFalse: [ out next: pattern position putAll: aCollection ] ]
'
 dictionaries: GsCurrentSession currentSession symbolList
 category: 'accessing'.
ZnBufferedReadStream compileMethod:
  'setToEnd
    
  self position: stream size'
 dictionaries: GsCurrentSession currentSession symbolList
 category: 'accessing'.
ZnEncodedReadStream compileMethod:
  'position: aPosition
	"Set the byte position in the underlying/wrapped binary stream to aPosition.
	This is not a character based position! Positions are zero based.
	I will move further backward if aPosition is not at the beginning of a code point."

	super position: aPosition.
	self encoder ensureAtBeginOfCodePointOnStream: stream.
	peeked := nil'
 dictionaries: GsCurrentSession currentSession symbolList
 category: 'accessing'.