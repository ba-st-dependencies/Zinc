"
I am ZnNetworkingUtils holding various utilities related to HTTP networking.

My class side is a general API.

My instance side is a factory.

ZnNetworkingUtils default socketStreamClass: SocketStream.
ZnNetworkingUtils default socketStreamClass: ZdcSocketStream.

Part of Zinc HTTP Components.
"
Class {
	#name : #ZnNetworkingUtils,
	#superclass : #Object,
	#instVars : [
		'socketStreamClass',
		'secureSocketStreamClass',
		'sslSessionClass',
		'socketClass',
		'socketAddressClass'
	],
	#classVars : [
		'Default',
		'DefaultSocketStreamTimeout'
	],
	#category : #'Zinc-HTTP-Support'
}

{ #category : #accessing }
ZnNetworkingUtils class >> default [
	^ Default ifNil: [ Default := self new ]
]

{ #category : #accessing }
ZnNetworkingUtils class >> default: instance [
	Default := instance
]

{ #category : #constants }
ZnNetworkingUtils class >> defaultSocketStreamTimeout [
	"Global default timeout in seconds for SocketStream IO"

	^ DefaultSocketStreamTimeout
]

{ #category : #constants }
ZnNetworkingUtils class >> defaultSocketStreamTimeout: seconds [
	"Global default timeout in seconds for SocketStream IO"

	^ DefaultSocketStreamTimeout := seconds
]

{ #category : #'class initialization' }
ZnNetworkingUtils class >> initialize [
	"The default will try to use ZdcSocketStream and ZdcSecureSocketStream"

	Default := self new.
	DefaultSocketStreamTimeout := 30
]

{ #category : #converting }
ZnNetworkingUtils class >> ipAddressToString: byteArray [
	^ String streamContents: [ :stream |
			byteArray
				do: [ :each | stream print: each ]
				separatedBy: [ stream nextPut: $. ] ]
]

{ #category : #constants }
ZnNetworkingUtils class >> listenBacklogSize [
	"Server socket backlog size (number of pending connection waiting to be accepted)"

	^ 32
]

{ #category : #proxy }
ZnNetworkingUtils class >> proxyAuthorizationHeaderValueToUrl: url [
	"Answer the Proxy-Authorization header value for HTTP access to url, or nil if none"

	^ self default proxyAuthorizationHeaderValueToUrl: url
]

{ #category : #networking }
ZnNetworkingUtils class >> secureSocketStreamOn: socket [
	^ self default
		secureSocketStreamOn: socket
]

{ #category : #networking }
ZnNetworkingUtils class >> serverSocketOn: port [
	^ self default
		serverSocketOn: port
]

{ #category : #networking }
ZnNetworkingUtils class >> serverSocketOn: port interface: address [
	^ self default
		serverSocketOn: port interface: address
]

{ #category : #proxy }
ZnNetworkingUtils class >> shouldProxyUrl: url [
	"Answer if we should proxy HTTP access to url."

	^ self default shouldProxyUrl: url
]

{ #category : #constants }
ZnNetworkingUtils class >> socketBufferSize [
	"Size in bytes for Sockets and SocketStream IO buffers"

	^ 4096
]

{ #category : #networking }
ZnNetworkingUtils class >> socketStreamOn: socket [
	^ self default
		socketStreamOn: socket
]

{ #category : #constants }
ZnNetworkingUtils class >> socketStreamTimeout [
	"Access the current timeout in seconds for SocketStream IO"

	^ ZnConnectionTimeout value
		ifNil: [ self defaultSocketStreamTimeout ]
]

{ #category : #networking }
ZnNetworkingUtils class >> socketStreamToUrl: url [
	^ self default
		socketStreamToUrl: url
]

{ #category : #accessing }
ZnNetworkingUtils >> bufferSize [
	^ self class socketBufferSize
]

{ #category : #initialization }
ZnNetworkingUtils >> initialize [

	super initialize.
	self socketStreamClass: (LanguagePlatform current
			 globalNamed: #ZdcSocketStream
			 ifAbsent: [ SocketStream ]).
	self secureSocketStreamClass: (LanguagePlatform current
			 globalNamed: #ZdcSecureSocketStream
			 ifAbsent: [ nil ]).
	self sslSessionClass: (LanguagePlatform current
			 globalNamed: #ZdcPluginSSLSession
			 ifAbsent: [ nil ])
]

{ #category : #proxy }
ZnNetworkingUtils >> isProxyAuthorizationRequired [
	"Does the proxy require authorization ?"

	^ false
]

{ #category : #proxy }
ZnNetworkingUtils >> isProxySet [
	"Should a proxy be used ?"

	^ false
]

{ #category : #proxy }
ZnNetworkingUtils >> proxyAuthorizationHeaderValueToUrl: url [
	"Answer the Proxy-Authorization header value for HTTP access to url, or nil if none"

	^ nil
]

{ #category : #accessing }
ZnNetworkingUtils >> secureSocketStreamClass [

	^ secureSocketStreamClass ifNil: [
		  secureSocketStreamClass := LanguagePlatform current
			                             globalNamed: #ZdcSecureSocketStream
			                             ifAbsent: [ nil ] ]
]

{ #category : #'initialize-release' }
ZnNetworkingUtils >> secureSocketStreamClass: anObject [
	secureSocketStreamClass := anObject
]

{ #category : #public }
ZnNetworkingUtils >> secureSocketStreamOn: socket [
	| stream |
	stream := self secureSocketStreamClass on: socket.
	self setSocketStreamParameters: stream.
	^ stream
]

{ #category : #public }
ZnNetworkingUtils >> serverSocketOn: port [
	| socket |
	socket := self socketClass newTCP.
	self setServerSocketOptions: socket.
	socket listenOn: port backlogSize: self class listenBacklogSize.
	socket isValid
		ifFalse: [ self error: 'Cannot create socket on port ', port printString ].
	^ socket
]

{ #category : #public }
ZnNetworkingUtils >> serverSocketOn: port interface: address [
	| socket |
	socket := self socketClass newTCP.
	self setServerSocketOptions: socket.
	socket
		listenOn: port
		backlogSize: self class listenBacklogSize
		interface: address.
	socket isValid
		ifFalse: [ self error: 'Cannot create socket on port ', port printString ].
	^ socket
]

{ #category : #private }
ZnNetworkingUtils >> setServerSocketOptions: socket [
	socket
		setOption: 'TCP_NODELAY' value: 1;
		setOption: 'SO_SNDBUF' value: self class socketBufferSize;
		setOption: 'SO_RCVBUF' value: self class socketBufferSize
]

{ #category : #private }
ZnNetworkingUtils >> setSocketStreamParameters: stream [
	stream
		binary;
		shouldSignal: true;
		autoFlush: false;
		bufferSize: self bufferSize;
		timeout: self timeout
]

{ #category : #proxy }
ZnNetworkingUtils >> shouldProxyUrl: url [
	"Even when a proxy is set, some URLs should not be proxied.
	There is no setting for this in the image.
	We exclude localhost and explicit exceptions from being proxied."

	^ false
]

{ #category : #accessing }
ZnNetworkingUtils >> socketAddressClass [

	^ socketAddressClass ifNil: [ SocketAddress ]
]

{ #category : #accessing }
ZnNetworkingUtils >> socketAddressClass: aClass [

	socketAddressClass := aClass
]

{ #category : #accessing }
ZnNetworkingUtils >> socketClass [

	^ socketClass ifNil: [ Socket ]
]

{ #category : #accessing }
ZnNetworkingUtils >> socketClass: aClass [

	socketClass := aClass
]

{ #category : #accessing }
ZnNetworkingUtils >> socketStreamClass [
	^ socketStreamClass ifNil: [ socketStreamClass := SocketStream ]
]

{ #category : #'initialize-release' }
ZnNetworkingUtils >> socketStreamClass: anObject [
	socketStreamClass := anObject
]

{ #category : #public }
ZnNetworkingUtils >> socketStreamOn: socket [
	| stream |
	stream := self socketStreamClass on: socket.
	self setSocketStreamParameters: stream.
	^ stream
]

{ #category : #public }
ZnNetworkingUtils >> socketStreamToUrl: url [

	url hasHost ifFalse: [ ZnMissingHost signal ].
	^ self socketStreamToUrlDirectly: url
]

{ #category : #public }
ZnNetworkingUtils >> socketStreamToUrlDirectly: url [
	| stream address |
	address := self socketAddressClass ipAddressForHostName: url host timeout: self timeout. 
	stream := (self streamClassForScheme: url scheme) 
		openConnectionToHost: address
		port: url portOrDefault
		timeout: self timeout.  
	self setSocketStreamParameters: stream.  
	(#(https wss) includes: url scheme) ifTrue: [ stream connect ].  
	^ stream
]

{ #category : #public }
ZnNetworkingUtils >> sslSessionClass [

	^ sslSessionClass ifNil: [
		  sslSessionClass := LanguagePlatform current
			                     globalNamed: #ZdcPluginSSLSession
			                     ifAbsent: [ nil ] ]
]

{ #category : #'initialize-release' }
ZnNetworkingUtils >> sslSessionClass: anObject [
	sslSessionClass := anObject
]

{ #category : #accessing }
ZnNetworkingUtils >> streamClassForScheme: scheme [
	(#(http ws) includes: scheme) ifTrue: [
		^ self socketStreamClass ].
	(#(https wss) includes: scheme) ifTrue: [
		^ self secureSocketStreamClass ifNil: [
			self error: 'No secure socket stream class set or available' ] ].
	(ZnUnknownScheme scheme: scheme) signal
]

{ #category : #accessing }
ZnNetworkingUtils >> timeout [
	^ self class socketStreamTimeout
]
