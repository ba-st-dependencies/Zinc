Extension { #name : #SocketAddress }

{ #category : #'*Zinc-Resource-Meta-Pharo' }
SocketAddress class >> ipAddressForHostName: aHostNameString timeout: aTimeout [

	| address |
	address := NetNameResolver
		           addressForName: aHostNameString
		           timeout: aTimeout.
	(address isNil or: [ address = SocketAddress zero ]) ifTrue: [
		^ NameLookupFailure signalFor: aHostNameString ].
	^ address
]

{ #category : #'*Zinc-Resource-Meta-Pharo' }
SocketAddress class >> loopBackAddress [ 

	^ NetNameResolver loopBackAddress 
]

{ #category : #'*Zinc-Resource-Meta-Pharo' }
SocketAddress class >> loopBackName [

	^ NetNameResolver loopBackName
]
