"
I am ZnLimitedReadStream, wrapping another read stream delegating to it 
but limiting reading to a fixed number of elements.

I can be atEnd while my wrapped stream is not.

I am binary if the stream that I wrap is binary, else I am textual.
 
Part of Zinc HTTP Components.
"
Class {
	#name : #ZnLimitedReadStream,
	#superclass : #Object,
	#instVars : [
		'stream',
		'position',
		'limit'
	],
	#category : 'Zinc-HTTP-Streaming'
}

{ #category : #'instance creation' }
ZnLimitedReadStream class >> on: stream limit: limit [
	^ self basicNew
		on: stream limit: limit;
		yourself
]

{ #category : #testing }
ZnLimitedReadStream >> atEnd [
	^ position >= limit or: [ stream atEnd ]
]

{ #category : #'initialize-release' }
ZnLimitedReadStream >> close [
	stream ifNotNil: [ stream close. stream := nil ]
]

{ #category : #accessing }
ZnLimitedReadStream >> collectionSpecies [
	"Delegate to our wrapped stream if possible."

	^ (stream respondsTo: #collectionSpecies)
			ifTrue: [ stream collectionSpecies ]
			ifFalse: [ stream isBinary ifTrue: [ ByteArray ] ifFalse: [ ByteString ] ]
]

{ #category : #accessing }
ZnLimitedReadStream >> contents [
	"This is technically not correct, but it is better than nothing"

	^ self upToEnd
]

{ #category : #accessing }
ZnLimitedReadStream >> contentsOfEntireFile [
	^ self upToEnd
]

{ #category : #testing }
ZnLimitedReadStream >> isBinary [
	^ stream isBinary
]

{ #category : #testing }
ZnLimitedReadStream >> isStream [
	^ true
]

{ #category : #accessing }
ZnLimitedReadStream >> match: subCollection [
	"Try to read and match the elements of subCollection.
	If successful return true and leave the me positioned after the match.
	If unsuccesful return false and leave me at end."

	| buffer pattern bufferPosition bufferLimit |
	pattern := subCollection readStream.
	"we have to use an internal buffer because we are not positionable"
	buffer := subCollection species new: subCollection size.
	bufferPosition := bufferLimit := 0.
	[ pattern atEnd ] whileFalse: [ | nextElement |
		self atEnd ifTrue: [ ^ false ].
		"get the next char to match either from the buffer or from the stream while buffering it"
		(bufferPosition < bufferLimit)
			ifTrue: [
				nextElement := buffer at: bufferPosition + 1 ]
			ifFalse: [
				nextElement := buffer at: bufferPosition + 1 put: self next.
				bufferLimit := bufferLimit + 1 ].
		bufferPosition := bufferPosition + 1.
		pattern next = nextElement
			ifFalse: [
				"shift the buffer down one element and restart"
				2 to: bufferLimit do: [ :each |
					buffer at: each - 1 put: (buffer at: each) ].
				bufferLimit := bufferLimit - 1.
				bufferPosition := 0.
				pattern position: 0 ] ].
	^ true
]

{ #category : #accessing }
ZnLimitedReadStream >> next [
	^ self atEnd
		ifTrue: [ nil ]
		ifFalse: [
			position := position + 1.
			stream next ]
]

{ #category : #accessing }
ZnLimitedReadStream >> next: requestedCount [
	"Read requestedCount elements into new collection and return it,
	 it could be that less elements were available"

	^ self
		next: requestedCount
		into: (self collectionSpecies new: requestedCount)
]

{ #category : #accessing }
ZnLimitedReadStream >> next: requestedCount into: collection [
	"Read requestedCount elements into collection,
	returning a copy if less elements are available"

	^ self
		next: requestedCount
		into: collection
		startingAt: 1
]

{ #category : #accessing }
ZnLimitedReadStream >> next: requestedCount into: collection startingAt: offset [
	"Read requestedCount elements into collection starting at offset,
	returning a copy if less elements are available"

	| readCount |
	readCount := self
		readInto: collection
		startingAt: offset
		count: requestedCount.
	^ requestedCount = readCount
		ifTrue: [ collection ]
		ifFalse: [ collection copyFrom: 1 to: offset + readCount - 1 ]
]

{ #category : #accessing }
ZnLimitedReadStream >> nextInto: collection [
	"Read the next elements of the receiver into collection,
	returning a copy if less elements are available"

	^ self
		next: collection size
		into: collection
]

{ #category : #'initialize-release' }
ZnLimitedReadStream >> on: readStream limit: integer [
	stream := readStream.
	limit := integer.
	position := 0
]

{ #category : #accessing }
ZnLimitedReadStream >> peek [
	^ self atEnd
		ifTrue: [ nil ]
		ifFalse: [ stream peek ]
]

{ #category : #accessing }
ZnLimitedReadStream >> peekFor: anElement [
	^ self peek = anElement and: [ self next. true ]
]

{ #category : #accessing }
ZnLimitedReadStream >> position [
	^ position
]

{ #category : #accessing }
ZnLimitedReadStream >> readInto: collection startingAt: offset count: count [
	"Read count elements and place them in collection starting at offset.
	Return the number of elements actually read."

	| target actual |
	target := count min: (limit - position).
	actual := stream
		readInto: collection
		startingAt: offset
		count: target.
	position := position + actual.
	^ actual
]

{ #category : #initialization }
ZnLimitedReadStream >> reset [
	"We don't allow it"
]

{ #category : #accessing }
ZnLimitedReadStream >> skip: count [
	count timesRepeat: [ self next ]
]

{ #category : #accessing }
ZnLimitedReadStream >> upTo: anObject [
	"We use our own collectionSpecies."

	^ self collectionSpecies streamContents: [ :out | | element |
		[ self atEnd or: [ (element := self next) = anObject ] ] whileFalse: [
			out nextPut: element ] ]
]

{ #category : #accessing }
ZnLimitedReadStream >> upToEnd [
	^ ZnUtils readUpToEnd: self limit: nil
]
