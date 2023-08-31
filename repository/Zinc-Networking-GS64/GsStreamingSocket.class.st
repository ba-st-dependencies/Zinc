Class {
	#name : #GsStreamingSocket,
	#superclass : #Object,
	#instVars : [
		'nativeSocketHolder'
	],
	#classVars : [
		'OptionMappings'
	],
	#category : #'Zinc-Networking-GS64'
}

{ #category : #connecting }
GsStreamingSocket class >> connectToServerOnHost: hostName port: portNumber [

	| newSocket |
	newSocket := self newTCP.
	newSocket connectTo:
		(GsSocketAddress hostName: hostName port: portNumber).
	^ newSocket
]

{ #category : #'class initialization' }
GsStreamingSocket class >> initialize [

	OptionMappings := Dictionary new.
	OptionMappings at: 'O_NONBLOCK' put: 'NONBLOCKING'.     " Value is Boolean , set state of non-blocking for socket."
	OptionMappings at: 'SO_SNDBUF' put: 'SNDBUF'.           "Value is SmallInt; buffer size for output."
	OptionMappings at: 'SO_RCVBUF' put: 'RCVBUF'.           "Value is SmallInt; buffer size for input."
	OptionMappings at: 'SO_BROADCAST' put: 'BROADCAST'.     "Value is Boolean; permission to transmit broadcast messages."
	OptionMappings at: 'SO_KEEPALIVE' put: 'KEEPALIVE'.     "Value is Boolean; detect broken connections."
	OptionMappings at: 'SO_OOBINLINE' put: 'OOBINLINE'.     "Value is Boolean; reception of out-of-band data inband."
	OptionMappings at: 'SO_DEBUG' put: 'DEBUG'.             "Value is Boolean; records debugging information."
	OptionMappings at: 'SO_DONTROUTE' put: 'DONTROUTE'.     "Value is Boolean; routing bypass for outgoing messages."
	OptionMappings at: 'SO_REUSEADDR' put: 'REUSEADDR'.     "Value is Boolean; allows local address reuse."
	OptionMappings at: 'SO_REUSEPORT' put: 'REUSEPORT'.     "Value is Boolean, multiple binds to same address, see SO_REUSEPORT in OS man pages"
	OptionMappings at: 'SO_USELOOPBACK' put: 'USELOOPBACK'. "Value is Boolean; bypass network card if possible."
	OptionMappings at: 'SOCK_CLOEXEC' put: 'CLOSEONEXEC'.   "Value is Boolean; close when system exec() is done."
	OptionMappings at: 'TCP_NODELAY' put: 'NODELAY'.        "Value is Boolean; disables nagle algorithm for send coalescing"

]

{ #category : #private }
GsStreamingSocket class >> isBooleanOption: anOptionName [

	^ (OptionMappings includesKey: anOptionName) and: [
		  (#( 'SO_RCVBUF' 'SO_SNDBUF' ) includes: anOptionName) not ]
]

{ #category : #private }
GsStreamingSocket class >> mapOptionNamed: anOption [

	^ OptionMappings at: anOption ifAbsent: [ anOption ]
]

{ #category : #'instance creation' }
GsStreamingSocket class >> newTCP [

	^ self onNativeSocket: GsSocket new
]

{ #category : #private }
GsStreamingSocket class >> onNativeSocket: aNativeSocket [

	^ self new onNativeSocket: aNativeSocket
]

{ #category : #utilities }
GsStreamingSocket class >> standardTimeout [

	^ 0
]

{ #category : #connection }
GsStreamingSocket >> close [
	"^self
	The same as the close() posix function."

	self nativeSocket close.
	^self
]

{ #category : #connection }
GsStreamingSocket >> connectTo: aSocketAddress [

	(self nativeSocket
		 connectTo: aSocketAddress portNumber
		 on: aSocketAddress hostAddress) ifFalse: [
		self signalWithLastErrorIn: 'Socket connect error: <1s>' ].
	^ self
]

{ #category : #connection }
GsStreamingSocket >> connectTo: host port: portNumber timeout: timeoutSeconds [

	^ self nativeSocket
		  connectTo: portNumber
		  on: host
		  timeoutMs: timeoutSeconds * 1000
]

{ #category : #testing }
GsStreamingSocket >> dataAvailable [
	self isConnected ifFalse:[^false].
	^self readyForRead
]

{ #category : #connection }
GsStreamingSocket >> destroy [

	self close
]

{ #category : #testing }
GsStreamingSocket >> isActive [

	^ self nativeSocket isActive
]

{ #category : #testing }
GsStreamingSocket >> isConnected [
	^self nativeSocket isConnected
]

{ #category : #testing }
GsStreamingSocket >> isValid [
  ^ self nativeSocket notNil and: [ self nativeSocket isActive ]
]

{ #category : #connection }
GsStreamingSocket >> listenOn: portNum backlogSize: queueLength [

	^self nativeSocket makeServer: queueLength atPort: portNum
]

{ #category : #connection }
GsStreamingSocket >> listenOn: portNum backlogSize: queueLength interface: address [

	^self nativeSocket makeServer: queueLength atPort: portNum atAddress: address
]

{ #category : #accessing }
GsStreamingSocket >> localPort [

	^ self port
]

{ #category : #private }
GsStreamingSocket >> nativeSocket [

	^ nativeSocketHolder value
]

{ #category : #initialization }
GsStreamingSocket >> onNativeSocket: aNativeSocket [

	self _setNoStubbing. "as long as I am in memory prevent stubbing of my instance variables ... I will stay in memory as long as I am referenced from stack.."
	nativeSocketHolder := TransientStackValue value: aNativeSocket
]

{ #category : #accessing }
GsStreamingSocket >> port [

	^ self nativeSocket port
]

{ #category : #receiving }
GsStreamingSocket >> readInto: aByteArray startingAt: startIndex for: aNumberOfBytes [
	"^an Integer
I return the number of bytes actually read."

	| result |
	result := self nativeSocket
		          read: aNumberOfBytes
		          into: aByteArray
		          startingAt: startIndex.
	result isNil ifTrue: [
		NetworkError signal: 'Unexpected and unknown socket error occured.' ].
	^ result
]

{ #category : #testing }
GsStreamingSocket >> readyForRead [
	"^a Boolean
I return true if a read operation will return some number of bytes."

	^ self nativeSocket readWillNotBlock ifNil: [ false ]
]

{ #category : #receiving }
GsStreamingSocket >> receiveDataSignallingClosedInto: aStringOrByteArray startingAt: aNumber [
	"Receive data into the given buffer and return the number of bytes received. 
	Note the given buffer may be only partially filled by the received data.
	Waits for data until something is read or the socket is closed, upon which
	we signal."

	| bytesRead |
	bytesRead := 0.
	[bytesRead == 0]
		whileTrue: [
			self waitForData.
			bytesRead := self  readInto: aStringOrByteArray startingAt: aNumber for: (aStringOrByteArray size  -aNumber +1) ].
	^bytesRead
]

{ #category : #receiving }
GsStreamingSocket >> receiveDataSignallingTimeout: timeout into: aStringOrByteArray startingAt: aNumber [
  "Receive data into the given buffer and return the number of bytes received. 
	Note the given buffer may be only partially filled by the received data.
	Wait for data once for the specified nr of seconds.  This method will
	throw exceptions on timeout or the socket closing."

  | result |
  self waitForDataFor: timeout.
  result := self
    readInto: aStringOrByteArray
    startingAt: aNumber
    for: aStringOrByteArray size - aNumber + 1.
  result == 0
    ifTrue: [ ConnectionClosed signal: 'Connection closed while waiting for data.' ].
  ^ result
]

{ #category : #receiving }
GsStreamingSocket >> receiveSomeDataInto: aStringOrByteArray startingAt: aNumber [

	^self readInto: aStringOrByteArray startingAt: aNumber for: (aStringOrByteArray size  -aNumber +1)
]

{ #category : #accessing }
GsStreamingSocket >> remoteAddress [

	^ self nativeSocket peerAddress
]

{ #category : #sending }
GsStreamingSocket >> sendData: buffer count: n [
	"Send the amount of data from the given buffer"
	| sent |
	sent := 0.
	[sent < n] whileTrue:[
		sent := sent + (self sendSomeData: buffer startIndex: sent+1 count: (n-sent))].
]

{ #category : #private }
GsStreamingSocket >> sendSomeData: aStringOrByteArray startIndex: startIndex count: count [

	^ self
		  writeFrom: aStringOrByteArray
		  startingAt: startIndex
		  for: count
]

{ #category : #accessing }
GsStreamingSocket >> setOption: anOption value: aValue [

	self nativeSocket
		option: (self class mapOptionNamed: anOption)
		put: ((self class isBooleanOption: anOption)
				 then: [ 1 strictlyPositive ]
				 otherwise: [ aValue ])
]

{ #category : #private }
GsStreamingSocket >> signalWithLastErrorIn: stringTemplate [

	^ NetworkError signal: (stringTemplate expandMacrosWith:
			   self nativeSocket lastErrorString asString)
]

{ #category : #waiting }
GsStreamingSocket >> waitForAcceptFor: timeoutInSeconds [
	"Wait and accept an incoming connection"

	^ (self nativeSocket acceptTimeoutMs: timeoutInSeconds * 1000)
		  ifNil: [ self signalWithLastErrorIn: 'Error during accept: <1s>' ]
		  ifNotNil: [ :newSocket | self class onNativeSocket: newSocket ]
]

{ #category : #private }
GsStreamingSocket >> waitForData [
	"Wait for data to arrive.  This method will block until
	data is available or the socket is closed.  If the socket is closed
	a ConnectionClosed exception will be signaled."

	^self waitForDataIfClosed:
		[ConnectionClosed signal: 'Connection close while waiting for data.']
]

{ #category : #private }
GsStreamingSocket >> waitForDataFor: timeout [
	"Wait for the given nr of seconds for data to arrive.
	Signal a time out or connection close exception if either happens before data becomes available."

	^self
		waitForDataFor: timeout
		ifClosed: [ConnectionClosed signal: 'Connection closed while waiting for data.']
		ifTimedOut: [ConnectionTimedOut signal: 'Data receive timed out.']
]

{ #category : #private }
GsStreamingSocket >> waitForDataFor: timeout ifClosed: closedBlock ifTimedOut: timedOutBlock [
  "Wait for the given nr of seconds for data to arrive."

  | startTime msecsDelta |
  startTime := Time millisecondClockValue.
  msecsDelta := (timeout * 1000) truncated.
  [ (Time millisecondsSince: startTime) < msecsDelta ]
    whileTrue: [ 
      self readyForRead
        ifTrue: [ ^ self ].
      self isConnected
        ifFalse: [ ^ closedBlock value ].
      self
        waitForNonBlockingReadActivityUpToMs:
          (msecsDelta - (Time millisecondsSince: startTime) max: 0) ].
  self readyForRead
    ifFalse: [ 
      self isConnected
        ifTrue: [ ^ timedOutBlock value ]
        ifFalse: [ ^ closedBlock value ] ]
]

{ #category : #private }
GsStreamingSocket >> waitForDataIfClosed: closedBlock [
	"Wait indefinitely for data to arrive.  This method will block until
	data is available or the socket is closed."

	[true]
		whileTrue: [
			self isConnected
				ifFalse: [^closedBlock value].
			(self readyForRead)
				ifTrue: [
					^self].

			self nativeSocket readWillNotBlockWithin: -1].
]

{ #category : #private }
GsStreamingSocket >> waitForNonBlockingReadActivityUpToMs: aNumberOfMilliseconds [
	"^a Boolean
I return true if there has been some read related activity on my underlying socket, otherwise false.  Note that activity may not mean that data is available.  It may just mean that the socket is in a new (perhaps error) state."

	| ans |
	(ans := self nativeSocket readWillNotBlockWithin:
		        aNumberOfMilliseconds) == nil ifTrue: [ ^ true ].
	^ ans
]

{ #category : #private }
GsStreamingSocket >> writeFrom: aByteArray startingAt: startIndex for: length [
	"^an Integer
I return the number of bytes actually written.  A GemStone socket may return nil.  This indicates that an error of some kind has occured."

	| result |
	result := self nativeSocket
		          write: length
		          from: aByteArray
		          startingAt: startIndex.
	result isNil ifTrue: [
		NetworkError signal: 'Unexpected and unknown socket error occured.' ].
	^ result
]
