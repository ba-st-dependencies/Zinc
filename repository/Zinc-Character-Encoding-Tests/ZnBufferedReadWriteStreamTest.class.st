Class {
	#name : 'ZnBufferedReadWriteStreamTest',
	#superclass : 'TestCase',
	#category : 'Zinc-Character-Encoding-Tests',
	#package : 'Zinc-Character-Encoding-Tests'
}

{ #category : 'tests' }
ZnBufferedReadWriteStreamTest >> testBuffering [
	| stream |
	stream := ZnBufferedReadWriteStream on: '01234567890123456789' readStream.
	stream sizeBuffer: 8.
	self deny: stream atEnd.
	self assert: (stream next: 10) equals: '0123456789'.
	self deny: stream atEnd.
	self assert: (stream next: 10) equals: '0123456789'.
	self assert: stream atEnd
]

{ #category : 'tests' }
ZnBufferedReadWriteStreamTest >> testNextPutAllStartingAt [
	| string |
	string := String streamContents: [ :stringStream |
		ZnBufferedReadWriteStream on: stringStream do: [ : bufferedStream |
			bufferedStream sizeBuffer: 8.
			bufferedStream next: 5 putAll: '--012345--' startingAt: 3.
			bufferedStream next: 5 putAll: '0123456789XX' startingAt: 6.
			bufferedStream next: 5 putAll: '--012345--' startingAt: 3.
			bufferedStream next: 5 putAll: '0123456789XX' startingAt: 6.] ].
	self assert: string equals: '01234567890123456789'
]

{ #category : 'tests' }
ZnBufferedReadWriteStreamTest >> testPeek [
	| stream |
	stream := ZnBufferedReadWriteStream on: '0123456789' readStream.
	stream sizeBuffer: 8.
	'0123456789' do: [ :each |
		self deny: stream atEnd.
		self assert: stream peek equals: each.
		self assert: stream next equals: each ].
	self assert: stream atEnd.
	self assert: stream peek isNil.
	self assert: stream next isNil
]

{ #category : 'tests' }
ZnBufferedReadWriteStreamTest >> testReadInto [
	| stream buffer count |
	stream := ZnBufferedReadWriteStream on: '0123456789' readStream.
	stream sizeBuffer: 8.
	buffer := String new: 6 withAll: Character space.
	stream skip: 1.
	stream readInto: buffer startingAt: 4 count: 3.
	self assert: buffer equals: '   123'.
	stream readInto: buffer startingAt: 1 count: 3.
	self assert: buffer equals: '456123'.
	count := stream readInto: buffer startingAt: 1 count: 100.
	self assert: count equals: 3.
	self assert: buffer equals: '789123'
]

{ #category : 'tests' }
ZnBufferedReadWriteStreamTest >> testReadIntoLarger [
	| stream buffer count |
	stream := ZnBufferedReadWriteStream on: '0123456789' readStream.
	stream sizeBuffer: 4.
	buffer := String new: 10.
	count := stream readInto: buffer startingAt: 1 count: 10.
	self assert: count equals: 10.
	self assert: buffer equals: '0123456789'
]

{ #category : 'tests' }
ZnBufferedReadWriteStreamTest >> testReadThenWrite [
	| stream stringStream |

	stringStream := ReadWriteStream with: '0123456789' copy.
	stringStream reset.
	stream := ZnBufferedReadWriteStream on: stringStream.
	stream sizeBuffer: 8.

	stream next: 4.
	self assert: stream position equals: 4.

	stream nextPutAll: 'ABCD'.
	self assert: stream position equals: 8.

	self assert: stream peek equals: $8.
	self assert: stream upToEnd equals: '89'.
	self assert: stream atEnd.

	self assert: stringStream contents equals: '0123ABCD89'
]

{ #category : 'tests' }
ZnBufferedReadWriteStreamTest >> testReadUpTo [
	| stream |
	stream := ZnBufferedReadWriteStream on: '0123456789' readStream.
	stream sizeBuffer: 8.
	self assert: (stream upTo: $5) equals: '01234'.
	self assert: stream upToEnd equals: '6789'.
	self assert: stream atEnd
]

{ #category : 'tests' }
ZnBufferedReadWriteStreamTest >> testReadUpToEnd [
	| stream |
	stream := ZnBufferedReadWriteStream on: '0123456789' readStream.
	stream sizeBuffer: 4.
	stream next: 2.
	self assert: stream upToEnd equals: '23456789'.
	self assert: stream atEnd
]

{ #category : 'tests' }
ZnBufferedReadWriteStreamTest >> testWriteThenRead [
	| stream stringStream |

	stringStream := ReadWriteStream with: '0123456789' copy.
	stringStream reset.
	stream := ZnBufferedReadWriteStream on: stringStream.
	stream sizeBuffer: 8.

	stream nextPutAll: 'ABCD'.

	self assert: stream peek equals: $4.
	self assert: stream position equals: 4.
	self assert: stream upToEnd equals: '456789'.
	self assert: stream position equals: 10.
	self assert: stream atEnd.

	self assert: stringStream contents equals: 'ABCD456789'
]

{ #category : 'tests' }
ZnBufferedReadWriteStreamTest >> testWriting [
	| string |
	string := String streamContents: [ :stringStream | | bufferedStream |
		bufferedStream := ZnBufferedReadWriteStream on: stringStream.
		0 to: 9 do: [ :each | bufferedStream nextPut: (Character digitValue: each) ].
		bufferedStream flush ].
	self assert: string equals: '0123456789'
]

{ #category : 'tests' }
ZnBufferedReadWriteStreamTest >> testWritingOverflow [
	| string |
	string := String streamContents: [ :stringStream | | bufferedStream |
		bufferedStream := ZnBufferedReadWriteStream on: stringStream.
		bufferedStream sizeBuffer: 8.
		0 to: 9 do: [ :each | bufferedStream nextPut: (Character digitValue: each) ].
		bufferedStream nextPutAll: '0123'; nextPutAll: '4567'; nextPutAll: '89'.
		bufferedStream nextPutAll: '0123456789'; nextPutAll: '0123456789'.
		bufferedStream flush ].
	self assert: string equals: '0123456789012345678901234567890123456789'
]
