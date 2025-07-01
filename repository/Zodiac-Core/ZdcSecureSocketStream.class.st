"
I am ZdcSecureSocketStream, a binary read/write stream for SSL communication.

I am a ZdcOptimizedSocketStream.

When I am used as a client, call #connect on me before using me as a normal stream.

When I am used as a server, call #accept on me before using me as a normal stream.

Currently, certificate management is ignored.
"
Class {
	#name : #ZdcSecureSocketStream,
	#superclass : #ZdcOptimizedSocketStream,
	#instVars : [
		'sslSession',
		'in',
		'out',
		'connecting'
	],
	#category : #'Zodiac-Core'
}

{ #category : #'private' }
ZdcSecureSocketStream class >> socketClass [
  ^ GsSecureSocket
]

{ #category : #'testing' }
ZdcSecureSocketStream >> atEnd [
  "I am atEnd when there is no more data to be read and there never will be.
	This means that readBuffer must be empty, there must be no more unread data 
	available at the socket, and the socket must be closed"
  readBuffer isEmpty
    ifFalse: [ ^ false ].
  socket notNil
    ifTrue: [ 
      | readCount |
      readCount := self fillReadBufferNoWait.
      readCount = 0
        ifTrue: [ ^ true ].
      readBuffer isEmpty
        ifFalse: [ ^ false ] ].
  ^ self isConnected not
]

{ #category : #'initialize-release' }
ZdcSecureSocketStream >> close [
	"Close the stream, flush if necessary. 
	Destory the SSLSession object."
	[ super close ] ensure: [ 
		sslSession ifNotNil: [
			sslSession destroy.
			sslSession := nil ] ]
]

{ #category : #'ssl' }
ZdcSecureSocketStream >> connect [
  "Do the SSL client handshake."
  | count |
  count := 0.
  connecting := true.
  self sslSession
    connect: in
    from: 1
    to: count
    into: out.
  connecting := false
]

{ #category : #'private in' }
ZdcSecureSocketStream >> fillReadBuffer [
	"Ask the socket to fill the read buffer with data. Wait for a data."
	
	self fillReadBufferNoWait.
	(readBuffer isEmpty and: [ self isConnected ])
		ifTrue: [ 
			self socketWaitForData. "when successful, recurse, else signal exception"
			self fillReadBuffer ]
]

{ #category : #'initialize-release' }
ZdcSecureSocketStream >> initialize  [
	super initialize.
	connecting := false
]

{ #category : #'testing' }
ZdcSecureSocketStream >> isConnected [
	"Are we connected at the socket level ?
	Has the SSL handshake been done successfully ?"
	^ super isConnected 
		and: [ sslSession notNil and: [ connecting or: [ sslSession isConnected ] ] ]
]

{ #category : #'accessing' }
ZdcSecureSocketStream >> serverNameIndication: aDomainNameString [
  "Set the Server Name Indication for the TLS connection.
  Note, this should be set before sending #connect.
  Note, some supported version of GemStone do not support
  SNI. As a result, it is only set in supported version."
  | sock |
  sock := self socket.
  (sock respondsTo: #setServerNameIndication:)
    ifTrue: [ sock setServerNameIndication: aDomainNameString ]
]

{ #category : #'accessing' }
ZdcSecureSocketStream >> socket [
  "Return the underlying socket object that I delegate I/O to"
  ^ self sslSession secureSocket
]

{ #category : #'accessing' }
ZdcSecureSocketStream >> sslSession [
  "Return the underlying ZdcAbstractSSLSession object 
	that we use for encryption and decryption, 
	as well as connection setup handshaking, connect and accept"
  sslSession isNil
    ifTrue: [ 
      sslSession := self sslSessionClass new
        secureSocket: socket;
        yourself ].
  ^ sslSession
]

{ #category : #'accessing' }
ZdcSecureSocketStream >> sslSessionClass [
  ^ ZdcGemStoneSSLSession
]

