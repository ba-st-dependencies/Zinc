Class {
	#name : #GsSocketAddress,
	#superclass : #Object,
	#instVars : [
		'hostAddress',
		'portNumber'
	],
	#category : #'Zinc-Networking-GS64'
}

{ #category : #'instance creation' }
GsSocketAddress class >> host: aHostAddress port: aPortNumber [

	^ self new host: aHostAddress port: aPortNumber
]

{ #category : #'instance creation' }
GsSocketAddress class >> hostName: aHostNameString port: aPortNumber [ 
	"^an SpSocketAddress
	I translate aHostNameString to an IP address and then create
	a new instance of myself with >>host:port:"

	^aHostNameString == nil
		ifTrue: [ 
			self host: nil
				port: aPortNumber]
		ifFalse: [ 
			self host: (self ipAddressForHostName: aHostNameString timeout: 60)
				port: aPortNumber]
]

{ #category : #private }
GsSocketAddress class >> ipAddressForHostName: aHostNameString timeout: aTimeout [

	^ [ GsSocket getHostAddressByName: aHostNameString ]
		  on: ArgumentError
		  do: [ :error | NetworkError signal: error messageText ]
]

{ #category : #lookups }
GsSocketAddress class >> loopBackAddress [

	^ self ipAddressForHostName: self loopBackName timeout: 60
]

{ #category : #lookups }
GsSocketAddress class >> loopBackName [

	^ 'localhost'
]

{ #category : #initialization }
GsSocketAddress >> host: aHostAddress port: aPortNumber [

	hostAddress := aHostAddress.
	portNumber := aPortNumber.
	^ self
]

{ #category : #accessing }
GsSocketAddress >> hostAddress [

	^ hostAddress
]

{ #category : #accessing }
GsSocketAddress >> portNumber [

	^ portNumber
]
