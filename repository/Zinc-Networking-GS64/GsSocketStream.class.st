Class {
	#name : #GsSocketStream,
	#superclass : #Object,
	#instVars : [
		'inNextToWrite',
		'inBuffer',
		'lastRead',
		'outBuffer',
		'outNextToWrite',
		'binary',
		'autoFlush',
		'bufferSize',
		'recentlyRead',
		'timeout',
		'socketHolder'
	],
	#category : #'Zinc-Networking-GS64'
}

{ #category : #private }
GsSocketStream class >> on: socket [
	"Create a socket stream on a connected server socket."

	^ self basicNew initialize socket: socket
]

{ #category : #'instance creation' }
GsSocketStream class >> openConnectionToHost: host port: portNumber timeout: timeoutSeconds [

	| socket |
	socket := GsStreamingSocket newTCP.
	socket connectTo: host port: portNumber timeout: timeoutSeconds.
	^ (self on: socket)
		  timeout: timeoutSeconds;
		  yourself
]

{ #category : #'instance creation' }
GsSocketStream class >> openConnectionToHostNamed: hostName port: portNumber [

	| socket |
	socket := GsStreamingSocket
		          connectToServerOnHost: hostName
		          port: portNumber.
	^ self on: socket
]

{ #category : #'stream writing' }
GsSocketStream >> << items [

 	items putOn: self.
	
	^ self
]

{ #category : #private }
GsSocketStream >> adjustInBuffer: bytesRead [
	"Adjust markers and possibly grow inBuffer or move data down.
	Currently grows through doubling when less than 1024 bytes are left.
	Never shrinks. Returns the position in the buffer where any new
	data can be found."

	| old |
	bytesRead = 0 ifTrue: [^inNextToWrite].
	old := inNextToWrite.
	inNextToWrite := inNextToWrite + bytesRead.
	(inBuffer size - inNextToWrite) < 1024
		ifTrue: [
			"Hit the roof, move data down (if enough has been read) or do we grow?"
			(lastRead > 512)
				ifTrue: [^old - self moveInBufferDown]
				ifFalse: [self growInBuffer]].
	^old
]

{ #category : #private }
GsSocketStream >> adjustOutBuffer: bytesToWrite [
	"Possibly grow outBuffer to accommodate the new data.
	Currently grows through doubling when less
	than 1024 bytes are left. If bytesToWrite is even
	larger we double that instead. Never shrinks."

	(outBuffer size - outNextToWrite - bytesToWrite) < 1024 ifTrue: [
		outBuffer := (self streamBuffer: ((outBuffer size max: bytesToWrite) * 2))
						replaceFrom: 1 to: outBuffer size with: outBuffer startingAt: 1]
]

{ #category : #configuration }
GsSocketStream >> ascii [
	"Tell the SocketStream to send data
	as Strings instead of ByteArrays.
	This is default."

	binary := false.
	inBuffer
		ifNil: [self resetBuffers]
		ifNotNil:
			[inBuffer := inBuffer asString.
			outBuffer := outBuffer asString]
]

{ #category : #testing }
GsSocketStream >> atEnd [
	"There is nothing more to read when
	there is no more data in our inBuffer, the socket
	is disconnected and there is none available on the socket.
	Note that we need to check isConnected before isDataAvailable,
	otherwise data may sneak in in the meantime. But we check the
	buffer first, because it is faster."

	self isInBufferEmpty ifFalse: [^false].
	^self isConnected not
		and: [self isDataAvailable not]
]

{ #category : #configuration }
GsSocketStream >> autoFlush: aBoolean [
	"If autoFlush is enabled data will be sent through
	the socket (flushed) when the bufferSize is reached
	or the SocketStream is closed. Otherwise the user
	will have to send #flush manually.
	Close will always flush. Default is false."

	autoFlush := aBoolean
]

{ #category : #configuration }
GsSocketStream >> binary [
	"Tell the SocketStream to send data
	as ByteArrays instead of Strings.
	Default is ascii."

	binary := true.
	inBuffer
		ifNil: [self resetBuffers]
		ifNotNil:
			[inBuffer := inBuffer asByteArray.
			outBuffer := outBuffer asByteArray]
]

{ #category : #configuration }
GsSocketStream >> bufferSize: anInt [
	"Default buffer size is 4kb.
	increased from earlier 2000 bytes."

	bufferSize := anInt
]

{ #category : #private }
GsSocketStream >> checkFlush [
	"If autoFlush is true we flush if
	we have reached the bufferSize
	of data in the outBuffer."

	(autoFlush and: [outNextToWrite > bufferSize])
		ifTrue: [self flush]
]

{ #category : #control }
GsSocketStream >> close [
	"Flush any data still not sent
	and take care of the socket."

	[ self flush ] ensure: [ self destroy ]
]

{ #category : #'stream writing' }
GsSocketStream >> cr [

	self nextPutAll: String cr
]

{ #category : #'stream writing' }
GsSocketStream >> crlf [

	self nextPutAll: String crlf
]

{ #category : #control }
GsSocketStream >> destroy [
  "Destroy the receiver and its underlying socket. Does not attempt to flush the output buffers. For a graceful close use SocketStream>>close instead."

  socketHolder ifNotNil: [ self socket close ]
]

{ #category : #control }
GsSocketStream >> flush [
	"If the other end is connected and we have something
	to send, then we send it and reset the outBuffer."

	(outNextToWrite > 1 and: [ self socket isActive ]) ifTrue: [
		self socket sendData: outBuffer count: outNextToWrite - 1.
		outNextToWrite := 1 ]
]

{ #category : #private }
GsSocketStream >> growInBuffer [
	"Grows through doubling."

	self resizeInBuffer: inBuffer size * 2
]

{ #category : #accessing }
GsSocketStream >> inBufferSize [
	"Answers the current size of data in the inBuffer."

	^inNextToWrite - lastRead - 1
]

{ #category : #initialize }
GsSocketStream >> initialize [

	super initialize.
	self autoFlush: true.
	recentlyRead := 0.
	bufferSize := 4096.
	self ascii
]

{ #category : #testing }
GsSocketStream >> isBinary [

	^ binary
]

{ #category : #testing }
GsSocketStream >> isConnected [
  "The stream is connected if the socket is."

  ^ self socket isConnected
]

{ #category : #testing }
GsSocketStream >> isDataAvailable [
  "It the inbuffer is empty, we check the socket for data.
	If it claims to have data available to read, we try to read
	some once and recursively call this method again.
	If something really was available it is now in the inBuffer.
	This is because there has been spurious
	dataAvailable when there really is no data to get."

  self isInBufferEmpty
    ifFalse: [ ^ true ].
  ^ self socket dataAvailable
    ifFalse: [ false ]
    ifTrue: [ 
      self
        receiveDataIfAvailable;
        isDataAvailable ]
]

{ #category : #testing }
GsSocketStream >> isEmpty [
	"Test if there are more data to read."

	^self isInBufferEmpty and: [self isDataAvailable not]
]

{ #category : #private }
GsSocketStream >> isInBufferEmpty [
	"Any data in the buffer?"
 
	^lastRead + 1 = inNextToWrite
]

{ #category : #testing }
GsSocketStream >> isStream [
	^true
]

{ #category : #private }
GsSocketStream >> moveInBufferDown [
	"Move down contents of inBuffer to the start.
	Return distance moved."

	| sz distanceMoved |
	sz := inNextToWrite - lastRead - 1.
	inBuffer replaceFrom: 1 to: sz with: inBuffer startingAt: lastRead + 1.
	distanceMoved := lastRead.
	lastRead := 0.
	inNextToWrite := sz + 1.
	^distanceMoved
]

{ #category : #'stream reading' }
GsSocketStream >> next [
  "Return next byte, if inBuffer is empty
	we recieve some more data and try again."

  self atEnd
    ifTrue: [ ^ nil ].
  self isInBufferEmpty
    ifTrue: [ 
      self receiveData.
      self atEnd
        ifTrue: [ ^ nil ] ].
  lastRead := lastRead + 1.
  ^ inBuffer at: lastRead
]

{ #category : #'stream reading' }
GsSocketStream >> next: anInteger [
	"Answer anInteger bytes of data.

	NOTE: This method doesn't honor timeouts if shouldSignal is false!"

	| start |
	self receiveData: anInteger.
	start := lastRead + 1.
	lastRead := (lastRead + anInteger) min: inNextToWrite - 1.
	^inBuffer copyFrom: start to: lastRead
]

{ #category : #'stream reading' }
GsSocketStream >> next: n into: aCollection [
	"Read n objects into the given collection.
	Return aCollection or a partial copy if less than
	n elements have been read."
	^self next: n into: aCollection startingAt: 1
]

{ #category : #'stream reading' }
GsSocketStream >> next: anInteger into: aCollection startingAt: startIndex [
	"Read n objects into the given collection. 
	Return aCollection or a partial copy if less than
	n elements have been read."

	"Implementation note: This method DOES signal timeout if not 
	enough elements are received. It does NOT signal
	ConnectionClosed as closing the connection is the only way by
	which partial data can be read."

	| start amount |

	[self receiveData: anInteger] on: ConnectionClosed do:[:ex| ex return].

	"Inlined version of nextInBuffer: to avoid copying the contents"
	amount := anInteger min: (inNextToWrite - lastRead - 1).
	start := lastRead + 1.
	lastRead := lastRead + amount.
	aCollection 
		replaceFrom: startIndex 
		to: startIndex + amount-1 
		with: inBuffer 
		startingAt: start.
	^amount < anInteger 
		ifTrue:[aCollection copyFrom: 1 to:  startIndex + amount-1]
		ifFalse:[aCollection]
]

{ #category : #'stream writing' }
GsSocketStream >> next: n putAll: aCollection startingAt: startIndex [
	"Put a String or a ByteArray onto the stream.
	Currently a large collection will allocate a large buffer.
	Warning: this does not work with WideString: they have to be converted first."

	self adjustOutBuffer: n.
	outBuffer replaceFrom: outNextToWrite to: outNextToWrite + n - 1 with: aCollection startingAt: startIndex.
	outNextToWrite := outNextToWrite + n.
	self checkFlush.
	^aCollection
]

{ #category : #'stream reading' }
GsSocketStream >> nextInto: aCollection [
	"Read the next elements of the receiver into aCollection.
	Return aCollection or a partial copy if less than aCollection
	size elements have been read."
	^self next: aCollection size into: aCollection startingAt: 1.
]

{ #category : #'stream writing' }
GsSocketStream >> nextPut: char [
	"Put a single Character or byte onto the stream."

	| toPut |
	toPut := binary
		         ifTrue: [ char asInteger ]
		         ifFalse: [ char asCharacter ].
	self adjustOutBuffer: 1.
	outBuffer at: outNextToWrite put: toPut.
	outNextToWrite := outNextToWrite + 1.
	self checkFlush.
	^ char
]

{ #category : #'stream writing' }
GsSocketStream >> nextPutAll: aCollection [
	"Put a String or a ByteArray onto the stream.
	Currently a large collection will allocate a large buffer."

	| toPut |
	toPut := binary ifTrue: [aCollection asByteArray] ifFalse: [aCollection asString].
	self adjustOutBuffer: toPut size.
	outBuffer replaceFrom: outNextToWrite to: outNextToWrite + toPut size - 1 with: toPut startingAt: 1.
	outNextToWrite := outNextToWrite + toPut size.
	self checkFlush.
	^aCollection
]

{ #category : #'stream reading' }
GsSocketStream >> peek [
	"Return next byte, if inBuffer is empty
	we recieve some more data and try again.
	Do not consume the byte."

	self atEnd ifTrue: [^nil].
	self isInBufferEmpty ifTrue:
		[self receiveData.
		self atEnd ifTrue: [^nil]].
	^inBuffer at: lastRead+1
]

{ #category : #accessing }
GsSocketStream >> position [
	^lastRead
]

{ #category : #'stream writing' }
GsSocketStream >> print: anObject [
	anObject printOn: self
]

{ #category : #printing }
GsSocketStream >> printOn: aStream [
	"Display buffer sizes."

	aStream nextPutAll: self class name.
	inBuffer ifNotNil: [
		aStream
			nextPutAll: '[inbuf:';
			nextPutAll: (inBuffer size / 1024) rounded asString;
			nextPutAll: 'kb/outbuf:';
			nextPutAll: (outBuffer size / 1024) rounded asString;
			nextPutAll: 'kb]' ]
]

{ #category : #'stream reading' }
GsSocketStream >> readInto: aCollection startingAt: startIndex count: anInteger [
	"Read n objects into the given collection starting at startIndex. 
	Return number of elements that have been read."

	"Implementation note: This method DOES signal timeout if not 
	enough elements are received. It does NOT signal
	ConnectionClosed as closing the connection is the only way by
	which partial data can be read."

	| start amount |

	[self receiveData: anInteger] on: ConnectionClosed do:[:ex| ex return].

	"Inlined version of nextInBuffer: to avoid copying the contents"
	amount := anInteger min: (inNextToWrite - lastRead - 1).
	start := lastRead + 1.
	lastRead := lastRead + amount.
	aCollection 
		replaceFrom: startIndex 
		to: startIndex + amount-1 
		with: inBuffer 
		startingAt: start.
	^amount
]

{ #category : #'private - socket' }
GsSocketStream >> receiveData [
	"Receive data with timeout if it has been set.
	Return the position in the buffer where the
	new data starts, regardless if anything
	was read, see #adjustInBuffer."

	recentlyRead := self shouldTimeout
		                ifTrue: [
			                self socket
				                receiveDataSignallingTimeout: timeout
				                into: inBuffer
				                startingAt: inNextToWrite ]
		                ifFalse: [
			                self socket
				                receiveDataSignallingClosedInto: inBuffer
				                startingAt: inNextToWrite ].
	^ self adjustInBuffer: recentlyRead
]

{ #category : #'private - socket' }
GsSocketStream >> receiveData: nBytes [
	"Keep reading the socket until we have nBytes
	in the inBuffer or we reach the end. This method
	does not return data, but can be used to make sure
	data has been read into the buffer from the Socket
	before actually reading it from the FastSocketStream.
	Mainly used internally. We could also adjust the buffer
	to the expected amount of data and avoiding several
	incremental grow operations."

	[ self isConnected and: [ nBytes > self inBufferSize ] ] whileTrue: [
		self receiveData ]
]

{ #category : #'private - socket' }
GsSocketStream >> receiveDataIfAvailable [
  "Only used to check that there really is data to read
	from the socket after it signals dataAvailable.
	It has been known to signal true and then still
	not have anything to read. See also isDataAvailable.
	Return the position in the buffer where the
	new data starts, regardless if anything
	was read, see #adjustInBuffer."

  recentlyRead := self socket
    receiveSomeDataInto: inBuffer
    startingAt: inNextToWrite.
  ^ self adjustInBuffer: recentlyRead
]

{ #category : #private }
GsSocketStream >> resetBuffers [
	"Recreate the buffers with default start sizes."

	inBuffer := self streamBuffer: bufferSize.
	lastRead := 0.
	inNextToWrite := 1.
	outBuffer := self streamBuffer: bufferSize.
	outNextToWrite := 1
]

{ #category : #private }
GsSocketStream >> resizeInBuffer: newSize [
	"Resize the inBuffer by recreating it.
	This also has the effect of getting rid of
	dead data above inNextToWrite.
	<newSize> must >= inBuffer size!"

	inBuffer := (self streamBuffer: newSize)
					replaceFrom: 1 to: inNextToWrite - 1 with: inBuffer startingAt: 1
]

{ #category : #configuration }
GsSocketStream >> shouldSignal: aBoolean [
	"Ignore. We always wan't to signal errors"

	
]

{ #category : #testing }
GsSocketStream >> shouldTimeout [

	^ self timeout > 0
]

{ #category : #accessing }
GsSocketStream >> size [
	"This is just a guess, probably more was written."

	^ outNextToWrite
]

{ #category : #accessing }
GsSocketStream >> socket [

	^ socketHolder value
]

{ #category : #private }
GsSocketStream >> socket: aSocket [

	self _setNoStubbing.
	"As long as I am in memory prevent stubbing of my instance variables.
	I will stay in memory as long as I am referenced from stack."
	socketHolder := TransientStackValue value: aSocket
]

{ #category : #'stream writing' }
GsSocketStream >> space [

	self nextPut: Character space
]

{ #category : #private }
GsSocketStream >> streamBuffer: size [
	"Create a buffer of the correct class and given size."

	^(self isBinary
		ifTrue: [ByteArray]
		ifFalse: [String]) new: size
]

{ #category : #accessing }
GsSocketStream >> timeout [
	"Lazily initialized unless it has been set explicitly."

	timeout ifNil: [timeout := GsStreamingSocket standardTimeout].
	^timeout
]

{ #category : #configuration }
GsSocketStream >> timeout: seconds [

	timeout := seconds
]
