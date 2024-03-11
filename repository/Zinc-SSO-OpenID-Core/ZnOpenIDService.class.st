"
See http://code.google.com/apis/accounts/docs/OpenID.html
"
Class {
	#name : 'ZnOpenIDService',
	#superclass : 'Object',
	#instVars : [
		'provider',
		'endpoint',
		'associationResponse',
		'associationExpireTime',
		'realm'
	],
	#category : 'Zinc-SSO-OpenID-Core',
	#package : 'Zinc-SSO-OpenID-Core'
}

{ #category : 'instance creation' }
ZnOpenIDService class >> forProvider: anOpenIDProvider [

	^self new
		provider: anOpenIDProvider;
		setEndpoint: anOpenIDProvider discoverEndpoint ;
		yourself
]

{ #category : 'resources' }
ZnOpenIDService class >> httpClient [

	^ ZnClient new
		beOneShot ;
		yourself
]

{ #category : 'accessing' }
ZnOpenIDService >> assocHandle [
	^associationResponse assocHandle
]

{ #category : 'accessing' }
ZnOpenIDService >> associationResponse [
	^associationResponse
]

{ #category : 'private' }
ZnOpenIDService >> authenticationError: aString [

	self error: aString
]

{ #category : 'resources' }
ZnOpenIDService >> dateAndTimeNow [

	^ DateAndTime now
]

{ #category : 'actions' }
ZnOpenIDService >> getAuthenticationRequestUrl: aReturnToUrlString [
	"Answer a URL to the OpenID authentication page."
	
	^self getAuthenticationRequestUrl: aReturnToUrlString do: [ :request | 
		request axRequestNamesAndEmail ]
]

{ #category : 'actions' }
ZnOpenIDService >> getAuthenticationRequestUrl: aReturnToUrl do: aBlock [
	"Answer a URL to the OpenID authentication page."
	
	| request url |
	
	self isAssociationValid 
		ifFalse: [ self setupAssociation ].
		
	request := ZnOpenIDAuthRequest new
		modeCheckidSetup;
		assocHandle: self assocHandle;
		returnTo:  aReturnToUrl asString.
	self realm notNil
		ifTrue: [ request realm: self realm ].
	aBlock value: request.

	url := endpoint copy.
	request addToUrl: url.
	^url
]

{ #category : 'actions' }
ZnOpenIDService >> getAuthenticationRequestUrl: aReturnToUrlString maxAuthAge: maxAgeInSecs [
	"Answer a URL to the OpenID authentication page."
	
	^self getAuthenticationRequestUrl: aReturnToUrlString do: [ :request | 
		request papeMaxAuthAge: maxAgeInSecs ]
]

{ #category : 'actions' }
ZnOpenIDService >> getAuthenticationResponseFrom: aDictionary [

	^ZnOpenIDAuthResponse newFromDictionary: aDictionary

]

{ #category : 'actions' }
ZnOpenIDService >> getValidatedAuthenticationResponseFrom: aDictionary [

	| responseMessage |

	responseMessage := self getAuthenticationResponseFrom: aDictionary.
	responseMessage isSuccess 
		ifTrue: [ self validateAuthResponse: responseMessage ].
	^ responseMessage 

]

{ #category : 'resources' }
ZnOpenIDService >> httpClient [

	^ self class httpClient
]

{ #category : 'testing' }
ZnOpenIDService >> isAssociationValid [

	^associationResponse notNil and: [ associationExpireTime > self dateAndTimeNow ]
]

{ #category : 'accessing' }
ZnOpenIDService >> provider [
	^provider
]

{ #category : 'accessing' }
ZnOpenIDService >> provider: anOpenIDProvider [

	provider := anOpenIDProvider 
]

{ #category : 'accessing' }
ZnOpenIDService >> providerName [
	^provider name
]

{ #category : 'accessing' }
ZnOpenIDService >> realm [
	^realm
]

{ #category : 'accessing' }
ZnOpenIDService >> realm: aString [
	"Set the authenticated realm. Identifies the domain that the end user is being asked to trust. (optional)"
	realm := aString
]

{ #category : 'initialize-release' }
ZnOpenIDService >> setEndpoint: urlString [

	endpoint := urlString asZnUrl.
	self setupAssociation 

]

{ #category : 'initialize-release' }
ZnOpenIDService >> setupAssociation [

	"
		openid.ns:http://specs.openid.net/auth/2.0
		openid.mode:associate
		openid.session_type:no-encryption
		openid.assoc_type:HMAC-SHA1	"

	| url response |
	
	endpoint isNil
		ifTrue: [ self error: 'endpoint undefined' ].
	
	url := endpoint copy.
	ZnOpenIDAssociationRequest new addToUrl: url.
	response := self httpClient 
		url: url ;
		get ;
		response.
	
	response isSuccess
		ifFalse: [ self error: 'Failed to setup association' ].
	
	associationResponse := ZnOpenIDAssociationResponse newFromKeyValueForm: response contents.
	associationExpireTime := self dateAndTimeNow + (Integer readFrom: associationResponse expiresIn readStream) seconds.

]

{ #category : 'actions' }
ZnOpenIDService >> validateAuthResponse: anAuthResponse [
	"Validate the authentication response. Raise an error when something is wrong."

	| signedFields requiredFields |

	anAuthResponse opEndpoint isNil
		ifTrue: [ self authenticationError: 'openid.op_endpoint is required in OpenID auth responses' ].
	anAuthResponse claimedId isNil
		ifTrue: [ self authenticationError: 'openid.clamied_id must be present in OpenID2 auth responses' ].
	anAuthResponse responseNonce isNil
		ifTrue: [ self authenticationError: 'openid.response_nonce is required in OpenID2 auth responses' ].
	signedFields := anAuthResponse signed subStrings: ','.
	requiredFields := #( 'return_to' 'response_nonce' 'op_endpoint' 'assoc_handle' 'identity' 'claimed_id' ).
	requiredFields
		do: [ :each | 
			(signedFields includes: each)
				ifFalse: [ self authenticationError: each , ' must be signed' ] ].
	(self associationResponse sign: anAuthResponse signedText andCheck: anAuthResponse sig)
		ifFalse: [ self authenticationError: 'signature mismatch' ].

	self provider shouldValidateClaimedIdBelongsToEndpoint
		ifTrue: [ self validateClaimedId: anAuthResponse claimedId belongsToEndpoint: anAuthResponse opEndpoint ].
		
	self provider nonceLocker seeAndValidate: (ZnOpenIDNonce fromString: anAuthResponse responseNonce)
]

{ #category : 'private' }
ZnOpenIDService >> validateClaimedId: claimedId belongsToEndpoint: endpointUrl [

	| response xrdsDocument elements |

	response := self httpClient 
		url: claimedId ;
		get ;
		response.
	response isSuccess
		ifFalse: [ ZnOpenIDClaimedIDVerificationError signal ].

	xrdsDocument := response contents.
	elements := ZnXRDService parseServicesFromXrds: xrdsDocument.
	elements := elements select: [ :service | service isClaimedIdService ].
	(elements anySatisfy: [ :e | e opEndpoint = endpointUrl ])
		ifFalse: [ ZnOpenIDClaimedIDVerificationError signal ].

]
