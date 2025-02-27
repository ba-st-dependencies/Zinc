"
I am a write stream wrapping a second stream. Whenever they ask me to write a cr, a lf, or a crlf I'll instead print a new line depending on a configured convention. By default I use the current platform convention. 

stream := '' writeStream.
converter := ZnNewLineWriterStream on: stream.
converter cr; cr; lf; nextPut: $a.
stream contents

A ZnNewLineWriterStream can be configured with the desired line ending convention using the methods 

converter forCr.
converter forLf.
converter forCrLf.
converter forPlatformLineEnding.
"
Class {
	#name : 'ZnNewLineWriterStream',
	#superclass : 'WriteStream',
	#instVars : [
		'stream',
		'cr',
		'lf',
		'previous',
		'lineEnding'
	],
	#category : 'Zinc-Character-Encoding-Core',
	#package : 'Zinc-Character-Encoding-Core'
}

{ #category : 'instance creation' }
ZnNewLineWriterStream class >> on: aStream [

	^ self basicNew
		initialize;
		stream: aStream;
		yourself
]

{ #category : 'open/close' }
ZnNewLineWriterStream >> close [
	stream close
]

{ #category : 'flushing' }
ZnNewLineWriterStream >> flush [
	^ stream flush
]

{ #category : 'accessing' }
ZnNewLineWriterStream >> forCr [

	lineEnding := String cr
]

{ #category : 'accessing' }
ZnNewLineWriterStream >> forCrLf [

	lineEnding := String crlf
]

{ #category : 'accessing' }
ZnNewLineWriterStream >> forLf [

	lineEnding := String lf
]

{ #category : 'accessing' }
ZnNewLineWriterStream >> forPlatformLineEnding [

	lineEnding := LanguagePlatform current os lineEnding
]

{ #category : 'initialization' }
ZnNewLineWriterStream >> initialize [

	super initialize.
	cr := Character cr.
	lf := Character lf.
	self forPlatformLineEnding
]

{ #category : 'accessing' }
ZnNewLineWriterStream >> newLine [
	previous := nil.
	stream nextPutAll: lineEnding
]

{ #category : 'accessing' }
ZnNewLineWriterStream >> nextPut: aCharacter [
	"Write aCharacter to the receivers stream.
	Convert all line end combinations, i.e cr, lf, crlf, to the platform convention"

	(previous == cr and: [ aCharacter == lf ]) ifFalse: [
		(aCharacter == cr or: [ aCharacter == lf ]) ifTrue:
			[ self newLine ]
		ifFalse:
			[ stream nextPut: aCharacter ] ].
	previous := aCharacter
]

{ #category : 'accessing' }
ZnNewLineWriterStream >> nextPutAll: aString [
	
	aString do: [ :character | self nextPut: character ]
]

{ #category : 'accessing' }
ZnNewLineWriterStream >> rawStream [
	"Answer the innermost stream wrapped by the receiver, e.g. a raw binary file stream,
	socket stream, or regular Read/WriteStream.
	Defer to the wrappedStream."

	^ self wrappedStream rawStream
]

{ #category : 'accessing' }
ZnNewLineWriterStream >> stream: aWriteStream [
	stream := aWriteStream
]

{ #category : 'accessing' }
ZnNewLineWriterStream >> wrappedStream [

	^ stream
]
