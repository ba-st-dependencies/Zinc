Class {
	#name : 'ZnXRDOpenIDClaimedId',
	#superclass : 'ZnXRDService',
	#instVars : [
		'opEndpoint',
		'localId'
	],
	#category : 'Zinc-SSO-OpenID-Core',
	#package : 'Zinc-SSO-OpenID-Core'
}

{ #category : 'instance creation' }
ZnXRDOpenIDClaimedId class >> newFromXmlElement: aXmlElement [

	| opEndpoint localId |

	aXmlElement
		elementsAt: 'URI'
		do: [ :e | 
			opEndpoint
				ifNil: [ opEndpoint := e contentString ]
				ifNotNil: [ Error signal: 'Too many URI elements for OpenID Claimed Id' ] ].
	aXmlElement
		elementsAt: 'LocalID'
		do: [ :e | 
			localId
				ifNil: [ localId := e contentString ]
				ifNotNil: [ Error signal: 'Too many localIds elements for OpenID Claimed Id' ] ].
	^ self new
		localId: localId;
		opEndpoint: opEndpoint;
		yourself
]

{ #category : 'resources' }
ZnXRDOpenIDClaimedId class >> serviceType [

	^'http://specs.openid.net/auth/2.0/signon'
]

{ #category : 'comparing' }
ZnXRDOpenIDClaimedId >> = anObject [
	^ (anObject isKindOf: self class) and: [ self localId = anObject localId and: [ self opEndpoint = anObject opEndpoint ] ]
]

{ #category : 'comparing' }
ZnXRDOpenIDClaimedId >> hash [
	^ self localId hash + self opEndpoint hash.
]

{ #category : 'testing' }
ZnXRDOpenIDClaimedId >> isClaimedIdService [
	^true
]

{ #category : 'accessing' }
ZnXRDOpenIDClaimedId >> localId [
	^ localId
]

{ #category : 'accessing' }
ZnXRDOpenIDClaimedId >> localId: anObject [
	localId := anObject
]

{ #category : 'accessing' }
ZnXRDOpenIDClaimedId >> opEndpoint [
	^ opEndpoint
]

{ #category : 'accessing' }
ZnXRDOpenIDClaimedId >> opEndpoint: anObject [
	opEndpoint := anObject
]
