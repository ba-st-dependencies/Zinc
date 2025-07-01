Extension { #name : #GsSocket }

{ #category : #'*zodiac-gemstone-core' }
GsSecureSocket class >> newTCP [
  ^ self new
]

{ #category : #'*zodiac-gemstone-core' }
GsSecureSocket >>closeAndDestroy [
  ^ self close
]

{ #category : #'*zodiac-gemstone-core' }
GsSecureSocket >>connectTo: hostAddress port: portNumber waitForConnectionFor: timeOutSeconds [
  | theAddress |
  theAddress := hostAddress.
  (hostAddress isKindOf: ByteArray)
    ifTrue: [ 
      theAddress := ''.
      1 to: hostAddress size - 1 do: [ :index | theAddress := theAddress , (hostAddress at: index) printString , '.' ].
      theAddress := theAddress , (hostAddress at: hostAddress size) printString ].
  (self connectTo: portNumber on: theAddress timeoutMs: timeOutSeconds * 1000)
    ifFalse: [ 
      self close.
      self halt: 'Unable to connect to port ' , portNumber asString ]
]

{ #category : #'*zodiac-gemstone-core' }
GsSecureSocket >>dataAvailable [
  self isConnected
    ifFalse: [ ^ false ].
  ^ self readyForRead
]

{ #category : #'*zodiac-gemstone-core' }
GsSecureSocket >>isValid [
  ^ self isActive
]

{ #category : #'*zodiac-gemstone-core' }
GsSecureSocket >>listenOn: port backlogSize: listenBacklogSize [
  (self makeServer: listenBacklogSize atPort: port)
    ifNil: [ 
      | errStr |
      errStr := self lastErrorString asString.
      self close.
      self error: errStr ]
]

{ #category : #'*zodiac-gemstone-core' }
GsSecureSocket >>localPort [
  ^ self port
]

{ #category : #'*zodiac-gemstone-core' }
GsSecureSocket >>readInto: aByteArray startingAt: startIndex for: aNumberOfBytes [
  | result |
  result := self read: aNumberOfBytes into: aByteArray startingAt: startIndex.
  result isNil
    ifTrue: [ SocketError signal: 'Unexpected and unknown socket error occured.' ].
  ^ result
]

{ #category : #'*zodiac-gemstone-core' }
GsSecureSocket >>readyForRead [
  ^ self readWillNotBlock
]

{ #category : #'*zodiac-gemstone-core' }
GsSecureSocket >>receiveDataSignallingTimeout: timeout into: aStringOrByteArray startingAt: aNumber [
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

{ #category : #'*zodiac-gemstone-core' }
GsSecureSocket >>sendData: buffer count: n [
  "Send the amount of data from the given buffer"
  | sent |
  sent := 0.
  [ sent < n ]
    whileTrue: [ sent := sent + (self sendSomeData: buffer startIndex: sent + 1 count: n - sent) ]
]

{ #category : #'*zodiac-gemstone-core' }
GsSecureSocket >>sendSomeData: aStringOrByteArray startIndex: startIndex count: count [
  ^ self writeFrom: aStringOrByteArray startingAt: startIndex for: count
]

{ #category : #'*zodiac-gemstone-core' }
GsSecureSocket >>waitForAcceptFor: timeout [
  "Wait and accept an incoming connection. Return nil if it falis"
  ^ self waitForConnectionFor: timeout ifTimedOut: [ ^ nil ]
]

{ #category : #'*zodiac-gemstone-core' }
GsSecureSocket >>waitForConnectionFor: timeoutSeconds ifTimedOut: timeoutBlock [
  "Wait up until the given deadline for a connection to be established. Return true if it is established by the deadline, false if not."
  | aSocket |
  aSocket := self acceptTimeoutMs: timeoutSeconds * 1000.
  aSocket
    ifNil: [ 
      self close.
      self error: 'accept error: ' , self lastErrorString ].
  ^ aSocket
]

{ #category : #'*zodiac-gemstone-core' }
GsSecureSocket >>waitForDataFor: timeout [
  "Wait for the given nr of seconds for data to arrive.
	Signal a time out or connection close exception if either happens before data becomes available."
  ^ self
    waitForDataFor: timeout
    ifClosed: [ ConnectionClosed signal: 'Connection closed while waiting for data.' ]
    ifTimedOut: [ ConnectionTimedOut signal: 'Data receive timed out.' ]
]

{ #category : #'*zodiac-gemstone-core' }
GsSecureSocket >>waitForDataFor: timeout ifClosed: closedBlock ifTimedOut: timedOutBlock [
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

{ #category : #'*zodiac-gemstone-core' }
GsSecureSocket >>waitForNonBlockingReadActivityUpToMs: aNumberOfMilliseconds [
  | ans |
  (ans := self readWillNotBlockWithin: aNumberOfMilliseconds) == nil
    ifTrue: [ ^ true ].
  ^ ans
]

{ #category : #'*zodiac-gemstone-core' }
GsSecureSocket >>writeFrom: aByteArray startingAt: startIndex for: length [
  | result |
  result := self write: length from: aByteArray startingAt: startIndex.
  result isNil
    ifTrue: [ self error: self lastErrorString asString ].
  ^ result
]
