Extension { #name : 'Socket' }

{ #category : '*Zinc-HTTP-UnixSocket' }
Socket >> connectTo: socketAddress [
	| status |
	status := self primSocketConnectionStatus: socketHandle.
	status == Unconnected
		ifFalse: [ InvalidSocketStatusException
				signal: 'Socket status must be unconnected before opening a new connection' ].

	self primSocket: socketHandle connectTo: socketAddress
]

{ #category : '*Zinc-HTTP-UnixSocket' }
Socket >> initialize: socketType withDomain: socketDomain [
	"Initialize a new socket handle. If socket creation fails, socketHandle will be set to nil."

	| semaIndex readSemaIndex writeSemaIndex |
	socketHandle ifNotNil: [^Error signal: 'The socket is already bound'].
	semaphore := Semaphore new.
	readSemaphore := Semaphore new.
	writeSemaphore := Semaphore new.
	semaIndex := Smalltalk registerExternalObject: semaphore.
	readSemaIndex := Smalltalk registerExternalObject: readSemaphore.
	writeSemaIndex := Smalltalk registerExternalObject: writeSemaphore.
	socketHandle := self
		primSocketCreateNetwork: socketDomain
		type: socketType
		receiveBufferSize: 8000
		sendBufSize: 8000
		semaIndex: semaIndex
		readSemaIndex: readSemaIndex
		writeSemaIndex: writeSemaIndex.
	socketHandle 
		ifNil: [ 
			"socket creation failed"
			Smalltalk unregisterExternalObject: semaphore.
			Smalltalk unregisterExternalObject: readSemaphore.
			Smalltalk unregisterExternalObject: writeSemaphore.
			readSemaphore := writeSemaphore := semaphore := nil ]
		ifNotNil: [ self register ]
]

{ #category : '*Zinc-HTTP-UnixSocket' }
Socket class >> newIPC [
	"Create a socket and initialise it for IPC aka Unix domain."

	self initializeNetwork.
	^ [ super new initialize: TCPSocketType withDomain: 1 ]
		repeatWithGCIf: [ :socket | socket isValid not ]
]
