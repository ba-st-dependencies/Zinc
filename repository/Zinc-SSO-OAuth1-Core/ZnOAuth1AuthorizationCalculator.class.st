"
Utility class to calculate the correct Authorization header for OAuth1 requests.
"
Class {
	#name : 'ZnOAuth1AuthorizationCalculator',
	#superclass : 'Object',
	#instVars : [
		'consumerKey',
		'consumerSecret',
		'signatureMethod',
		'version',
		'nonce',
		'timestamp',
		'token',
		'tokenSecret',
		'callback',
		'verifier'
	],
	#category : 'Zinc-SSO-OAuth1-Core',
	#package : 'Zinc-SSO-OAuth1-Core'
}

{ #category : 'utility' }
ZnOAuth1AuthorizationCalculator class >> signStringSHA1: aString usingSecret: aSecret [ 
	"Signs a string with <aSecret>, and encode the
	resulting byteArray into plain ASCII with base64."
	
	| hmac digest |

	hmac := SHA1 new hmac.
	hmac key: aSecret asByteArray.
	digest := hmac digestMessage: aString asByteArray.
	^ZnBase64Encoder new encode: digest
]

{ #category : 'accessing' }
ZnOAuth1AuthorizationCalculator >> callback [
	^ callback
]

{ #category : 'accessing' }
ZnOAuth1AuthorizationCalculator >> callback: anObject [
	callback := anObject
]

{ #category : 'accessing' }
ZnOAuth1AuthorizationCalculator >> consumerKey [
	^ consumerKey
]

{ #category : 'accessing' }
ZnOAuth1AuthorizationCalculator >> consumerKey: anObject [
	consumerKey := anObject
]

{ #category : 'accessing' }
ZnOAuth1AuthorizationCalculator >> consumerSecret [
	^ consumerSecret
]

{ #category : 'accessing' }
ZnOAuth1AuthorizationCalculator >> consumerSecret: anObject [
	consumerSecret := anObject
]

{ #category : 'api' }
ZnOAuth1AuthorizationCalculator >> getAuthorizationHeader: aRequest [
	"Create the OAuth1 Authorization header. See: http://code.google.com/apis/accounts/docs/OAuth_ref.html "

	| oauthParameters baseString signatureKey encoder |
	
	oauthParameters := self getOAuthParameters.
	baseString := self getBaseString: aRequest with: oauthParameters.
	signatureKey := self getSignatureKey.
	encoder := ZnPercentEncoder new.
	
	self signatureMethod = 'HMAC-SHA1'
		ifTrue: [
			oauthParameters add: 'oauth_signature' -> (self class signStringSHA1: baseString usingSecret: signatureKey) ]
		ifFalse: [
			self error: 'Unsupported signature method' ].
		
	^String streamContents: [ :stream |
		stream nextPutAll: 'OAuth '.
		oauthParameters 
			do: [ :assoc |
				stream
					nextPutAll: assoc key ;
					nextPutAll: '="'.
				encoder encode: assoc value readStream to: stream.
				stream nextPutAll: '"' ]
			separatedBy: [ stream nextPutAll: ',' ] ]
]

{ #category : 'actions' }
ZnOAuth1AuthorizationCalculator >> getBaseString: aRequest with: anOAuthParameters [
	"Create the OAuth1 baseString"

	| params paramsString percentEncoder |
	
	percentEncoder := ZnPercentEncoder new.
	
	params := OrderedCollection new
		addAll: anOAuthParameters ;
		yourself.
	aRequest mergedFields keysAndValuesDo:  [ :key :value | params add: key -> value ].
	
	params sort: [ :a1 :a2 |
		a1 key = a2 key
			ifTrue: [ a1 value < a2 value ]
			ifFalse: [ a1 key < a2 key ] ].
		
	paramsString := String streamContents: [ :stream |
		params 
			do: [ :assoc |
				stream
					nextPutAll: assoc key ;
					nextPut: $=.
				percentEncoder encode: assoc value readStream to: stream ]
			separatedBy: [ stream nextPutAll: '&' ] ].
		
	^String streamContents: [ :stream | | baseUrl |
		stream
			nextPutAll: aRequest method ;
			nextPut: $&.
		baseUrl := aRequest uri copy
			query: nil ;
			fragment: nil ;
			asString.
		percentEncoder encode: baseUrl readStream to: stream. 	
		stream nextPut: $&.
		percentEncoder encode: paramsString readStream to:  stream ]
]

{ #category : 'actions' }
ZnOAuth1AuthorizationCalculator >> getOAuthParameters [

	| list |
	
	list := OrderedCollection new
		add: 'oauth_consumer_key' -> self consumerKey ;
		add: 'oauth_nonce' -> self nonce ;
		add: 'oauth_signature_method' -> self signatureMethod ;
		add: 'oauth_timestamp' -> self timestamp ;
		add: 'oauth_version' -> self version ;
		yourself.
		
	self token notNil
		ifTrue: [ list add: 'oauth_token' -> self token ].
	self callback notNil
		ifTrue: [ list add: 'oauth_callback' -> self callback asString ].
	self verifier notNil
		ifTrue: [ list add: 'oauth_verifier' -> self verifier ].
	^ list
]

{ #category : 'actions' }
ZnOAuth1AuthorizationCalculator >> getSignatureKey [
	"Create the OAuth1 signature key. "

	| percentEncoder |

	percentEncoder := ZnPercentEncoder new.

	^String streamContents: [ :stream |
		percentEncoder encode: self consumerSecret readStream to: stream.
		stream nextPut: $&.
		percentEncoder encode: (self tokenSecret ifNil: [ '' ]) readStream to: stream ]
]

{ #category : 'initialize-release' }
ZnOAuth1AuthorizationCalculator >> initialize [

	super initialize.
	self setUp
]

{ #category : 'accessing' }
ZnOAuth1AuthorizationCalculator >> nonce [
	^ nonce
]

{ #category : 'accessing' }
ZnOAuth1AuthorizationCalculator >> nonce: anObject [
	nonce := anObject
]

{ #category : 'initialize-release' }
ZnOAuth1AuthorizationCalculator >> setUp [

	| begin secondsSinceEpoch |
	
	begin := DateAndTime year: 1970 day: 1 hour: 0 minute: 0 second: 0 offset: Duration zero. 
	secondsSinceEpoch := (DateAndTime now asUTC - begin) asSeconds.
	
	self version: '1.0'.
	self signatureMethod: 'HMAC-SHA1'.
	self timestamp: secondsSinceEpoch asString.
	self nonce: UUID new asString
]

{ #category : 'accessing' }
ZnOAuth1AuthorizationCalculator >> signatureMethod [
	^ signatureMethod
]

{ #category : 'accessing' }
ZnOAuth1AuthorizationCalculator >> signatureMethod: anObject [
	signatureMethod := anObject
]

{ #category : 'accessing' }
ZnOAuth1AuthorizationCalculator >> timestamp [
	^ timestamp
]

{ #category : 'accessing' }
ZnOAuth1AuthorizationCalculator >> timestamp: anObject [
	timestamp := anObject
]

{ #category : 'accessing' }
ZnOAuth1AuthorizationCalculator >> token [
	^ token
]

{ #category : 'accessing' }
ZnOAuth1AuthorizationCalculator >> token: anObject [
	token := anObject
]

{ #category : 'accessing' }
ZnOAuth1AuthorizationCalculator >> tokenSecret [
	^ tokenSecret
]

{ #category : 'accessing' }
ZnOAuth1AuthorizationCalculator >> tokenSecret: anObject [
	tokenSecret := anObject
]

{ #category : 'accessing' }
ZnOAuth1AuthorizationCalculator >> verifier [
	^ verifier
]

{ #category : 'accessing' }
ZnOAuth1AuthorizationCalculator >> verifier: anObject [
	verifier := anObject
]

{ #category : 'accessing' }
ZnOAuth1AuthorizationCalculator >> version [
	^ version
]

{ #category : 'accessing' }
ZnOAuth1AuthorizationCalculator >> version: anObject [
	version := anObject
]
