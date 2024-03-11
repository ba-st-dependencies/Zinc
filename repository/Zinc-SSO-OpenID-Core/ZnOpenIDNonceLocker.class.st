"
I can validate a Nonce for a particular provider. To check the uniqueness of a Nonce I hold a collection of recent Nonces.
"
Class {
	#name : 'ZnOpenIDNonceLocker',
	#superclass : 'Object',
	#instVars : [
		'nonces',
		'lastRemovalRun'
	],
	#classVars : [
		'AcceptedTimeFrame'
	],
	#category : 'Zinc-SSO-OpenID-Core',
	#package : 'Zinc-SSO-OpenID-Core'
}

{ #category : 'accessing' }
ZnOpenIDNonceLocker class >> acceptedTimeFrame [
	^ AcceptedTimeFrame ifNil: [ AcceptedTimeFrame := 10 minutes ]
]

{ #category : 'accessing' }
ZnOpenIDNonceLocker class >> acceptedTimeFrame: aDuration [
	AcceptedTimeFrame := aDuration.
]

{ #category : 'class initialization' }
ZnOpenIDNonceLocker class >> reset [

	AcceptedTimeFrame := nil
]

{ #category : 'resources' }
ZnOpenIDNonceLocker >> dateAndTimeNow [

	^ DateAndTime now
]

{ #category : 'initialize-release' }
ZnOpenIDNonceLocker >> initialize [ 
	super initialize.
	nonces := Set new.
]

{ #category : 'resources' }
ZnOpenIDNonceLocker >> minimumRemovalInterval [ 
	^ 2 minutes.
]

{ #category : 'accessing' }
ZnOpenIDNonceLocker >> nonceCount [
	self removeOldNonces.
	^nonces size.
]

{ #category : 'removing' }
ZnOpenIDNonceLocker >> removeOldNonces [
	"Removes old nonces from internal colletion if enough (#minumumRemovalInterval) time has been since
	last removal."
	(lastRemovalRun isNil or: [ lastRemovalRun - self dateAndTimeNow > self minimumRemovalInterval ])
		ifTrue: [ 
			lastRemovalRun := self dateAndTimeNow.
			nonces := nonces reject: [ :nonce | nonce isOld ] ]
]

{ #category : 'actions' }
ZnOpenIDNonceLocker >> resetRemovalTime [
	lastRemovalRun := nil.
]

{ #category : 'actions' }
ZnOpenIDNonceLocker >> seeAndValidate: aCFOpenIDNonce [
	self removeOldNonces.
	aCFOpenIDNonce isOld
		ifTrue: [ ZnOpenIDNonceTooOldError signal ]
		ifFalse: [ 
			(nonces includes: aCFOpenIDNonce)
				ifTrue: [ ZnOpenIDNonceSeenError signal ]
				ifFalse: [ nonces add: aCFOpenIDNonce ] ]
]
