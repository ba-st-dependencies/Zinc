"
I am ZnClient.
I am ZnUnixSocketClient, an object to build, execute, and process HTTP client request over Unix Domain Sockets.

Simplest possible invocation:

ZnUnixSocketClient new 
	unixSocket: '/var/run/docker.sock';
	get: 'http://localhost/v1.43/containers/json'.

It is equivalent to the following cURL command:

	curl --unix-socket /var/run/docker.sock http://localhost/v1.43/containers/json
	
Part of Zinc HTTP Components.
"
Class {
	#name : 'ZnUnixSocketClient',
	#superclass : 'ZnClient',
	#category : 'Zinc-HTTP-UnixSocket-Client-Server',
	#package : 'Zinc-HTTP-UnixSocket',
	#tag : 'Client-Server'
}

{ #category : 'private' }
ZnUnixSocketClient >> newConnectionTo: url [
	self unixSocket
		ifNil: [ super newConnectionTo: url ]
		ifNotNil: [ :socketPath | self newConnectionToUnixSocketFile: socketPath asFileReference ]
]

{ #category : 'private' }
ZnUnixSocketClient >> newConnectionToUnixSocketFile: socketFile [
	| initialMilliseconds |
	self signalHTTPProgress: 'Connecting to ',  socketFile asString.
	initialMilliseconds := Time millisecondClockValue.
	(connection notNil and: [ connection isConnected ])
		ifTrue: [ connection close ].
	connection := ZnNetworkingUtils socketStreamToUnixSocketFile: socketFile.
	self logConnectionEstablishedTo: socketFile asZnUrl started: initialMilliseconds
]

{ #category : 'accessing' }
ZnUnixSocketClient >> unixSocket [
	^ self optionAt: #unixSocket ifAbsent: [ nil ]
]

{ #category : 'accessing' }
ZnUnixSocketClient >> unixSocket: socketPath [
	self optionAt: #unixSocket put: socketPath
]
