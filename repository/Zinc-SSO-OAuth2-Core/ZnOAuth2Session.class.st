"
I am ZnOAuth2Session, representing server side state tracking an OAuth2 session.

consumerData  
	- needed to setup an authentication request with a provider
	
accessToken
	- the result of a successful authentication
	
scopes
	- collection of strings representing the permissions 	
	
redirectUrl
	- the URL needed by the provider to get back to us

tokenType
	- Indicates the type of token returned (not really used yet). 
	
refreshToken 
	- a token that may be used to obtain a new access token. This field is only present if access_type=offline is included in the authorization code request (currently only used by Google).
"
Class {
	#name : 'ZnOAuth2Session',
	#superclass : 'Object',
	#instVars : [
		'consumerData',
		'redirectUrl',
		'scopes',
		'accessToken',
		'tokenType',
		'refreshToken',
		'expiresOn',
		'authorizationEndpoint',
		'tokenEndpoint'
	],
	#category : 'Zinc-SSO-OAuth2-Core',
	#package : 'Zinc-SSO-OAuth2-Core'
}

{ #category : 'instance creation' }
ZnOAuth2Session class >> amazon: aConsumerData [

	^ ZnAmazonOAuth2Session new
		setConsumerData: aConsumerData ;
		yourself
]

{ #category : 'instance creation' }
ZnOAuth2Session class >> facebook: aConsumerData [

	^ ZnFacebookOAuth2Session new
		setConsumerData: aConsumerData ;
		yourself
]

{ #category : 'instance creation' }
ZnOAuth2Session class >> google: aConsumerData [

	^ ZnGoogleOAuth2Session new
		setConsumerData: aConsumerData ;
		yourself
]

{ #category : 'instance creation' }
ZnOAuth2Session class >> microsoft: aConsumerData [

	^ ZnMicrosoftOAuth2Session new
		setConsumerData: aConsumerData ;
		yourself
]

{ #category : 'resources' }
ZnOAuth2Session class >> ssoScopes [
	"Answer a collection of scopes that can be used for Authentication. "

	^ #()
]

{ #category : 'accessing' }
ZnOAuth2Session >> accessToken [
	^ accessToken
]

{ #category : 'accessing' }
ZnOAuth2Session >> accessToken: aString [
	accessToken := aString
]

{ #category : 'accessing' }
ZnOAuth2Session >> addScope: aScopeString [
	self scopes add: aScopeString
]

{ #category : 'public' }
ZnOAuth2Session >> authenticationUrl [
	^ self authenticationUrlWithState: 'no-op'
]

{ #category : 'public' }
ZnOAuth2Session >> authenticationUrlWithState: stateString [
	"Answer an url to be used in an Authorization Request for an Authorization Code Grant flow.
	Subclasses can override this method and add additional query parameters.

	See for details: https://tools.ietf.org/html/rfc6749#section-4.1"

	^ (ZnUrl fromString: self authorizationEndpoint)
		queryAt: 'response_type' put: 'code';
		queryAt: 'client_id' put: self consumerData key;
		queryAt: 'redirect_uri' put: self redirectUrl;
		queryAt: 'scope' put: self scopeParameter;
		queryAt: 'state' put: stateString;
		yourself
]

{ #category : 'accessing' }
ZnOAuth2Session >> authorizationEndpoint [
	^ authorizationEndpoint
]

{ #category : 'accessing' }
ZnOAuth2Session >> authorizationEndpoint: aString [
	authorizationEndpoint := aString
]

{ #category : 'accessing' }
ZnOAuth2Session >> consumerData [
	^ consumerData
]

{ #category : 'accessing' }
ZnOAuth2Session >> expirationMargin [
	"Answer my margin for determining expiration (in seconds)."
	^ 60.
]

{ #category : 'accessing' }
ZnOAuth2Session >> expiresOn [
	^ expiresOn
]

{ #category : 'private' }
ZnOAuth2Session >> fieldDictionaryFrom: aString [

	| dict stream |
	
	dict := Dictionary new.
	stream := aString readStream.
	[ stream atEnd ] whileFalse: [ dict at: (stream upTo: $=) put: (stream upTo: $&) ].

	^dict
]

{ #category : 'public' }
ZnOAuth2Session >> handleAuthenticationCallback: aParameterDictionary [ 
	"Handle an Authorization Response code by issuing an Access Token Request.
	
	See for details: https://tools.ietf.org/html/rfc6749#section-4.1.3"
	| code tokenRequest client tokenResponse |
	
	code := aParameterDictionary at: 'code' ifAbsent: [ ^ nil ].

	tokenRequest  := (ZnRequest post: (ZnUrl fromString: self tokenEndpoint))
		entity: (ZnApplicationFormUrlEncodedEntity new
			at: 'grant_type' put: 'authorization_code';
			at: 'code' put: code;
			at: 'redirect_uri' put: self redirectUrl;
			at: 'client_id' put: self consumerData key;
			at: 'client_secret' put: self consumerData secret;
			yourself);
		yourself.

	client := ZnClient new.
	tokenResponse := [ 
		client request: tokenRequest;
			post ] ensure: [ client close ].

	self updateTokens: (ZnUtils defaultJSONReader fromString: tokenResponse).

]

{ #category : 'public' }
ZnOAuth2Session >> handleTokenRefresh [
	"Refresh my access token.
	
	See for details: https://tools.ietf.org/html/rfc6749#section-6"
	| tokenRequest client tokenResponse |
	
	tokenRequest  := (ZnRequest post: (ZnUrl fromString: self tokenEndpoint))
		entity: (ZnApplicationFormUrlEncodedEntity new
			at: 'grant_type' put: 'refresh_token';
			at: 'refresh_token' put: self refreshToken;
			at: 'client_id' put: self consumerData key;
			at: 'client_secret' put: self consumerData secret;
			yourself);
		yourself.

	client := ZnClient new.
	tokenResponse := [ 
		client request: tokenRequest;
			post ] ensure: [ client close ].

	self updateTokens: (ZnUtils defaultJSONReader fromString: tokenResponse).

]

{ #category : 'initialize-release' }
ZnOAuth2Session >> initialize [

	super initialize.
	
	scopes := OrderedCollection withAll: self class ssoScopes 
]

{ #category : 'testing' }
ZnOAuth2Session >> isExpired [
	"Answer if I consider myself expired, based on my expiresOn variable and expirationMargin.
	Convert current date and time to UTC to prevent daylight saving issues."

	expiresOn ifNil: [ ^ true ].

	^ expiresOn <= (DateAndTime now asUTC + self expirationMargin).
]

{ #category : 'testing' }
ZnOAuth2Session >> isLive [
	"Answer if I have a access token that is not expired, or else, a valid refresh token to refresh my access token."
	^ self accessToken isNotNil and: [
		self isExpired not or: [
			self refreshToken isNotNil ] ]
]

{ #category : 'public' }
ZnOAuth2Session >> liveAccessToken [
	self isExpired
		ifTrue: [
			self refreshToken ifNil: [ ZnAuthError signal: 'OAuth 2.0 access token has expired (and missing refresh token)' ].
			self handleTokenRefresh ].
	^ self accessToken
]

{ #category : 'accessing' }
ZnOAuth2Session >> redirectUrl [
	^ redirectUrl
]

{ #category : 'accessing' }
ZnOAuth2Session >> redirectUrl: aString [
	redirectUrl := aString
]

{ #category : 'accessing' }
ZnOAuth2Session >> refreshToken [
	^ refreshToken
]

{ #category : 'accessing' }
ZnOAuth2Session >> refreshToken: aString [
	refreshToken := aString
]

{ #category : 'private' }
ZnOAuth2Session >> scopeParameter [

	^ String streamContents: [ :stream |
		self scopes
			do: [ :each | stream nextPutAll: each ]
			separatedBy: [ stream nextPut: Character space ] ]
]

{ #category : 'accessing' }
ZnOAuth2Session >> scopes [

	^ scopes ifNil: [ scopes := OrderedCollection new ]
]

{ #category : 'accessing' }
ZnOAuth2Session >> scopes: aCollection [

	scopes := aCollection
]

{ #category : 'initialize-release' }
ZnOAuth2Session >> setConsumerData: aConsumerData [

	consumerData := aConsumerData.
	redirectUrl := aConsumerData ifNotNil: [ aConsumerData redirectUrl ]

]

{ #category : 'accessing' }
ZnOAuth2Session >> tokenEndpoint [
	^ tokenEndpoint
]

{ #category : 'accessing' }
ZnOAuth2Session >> tokenEndpoint: aString [
	tokenEndpoint := aString
]

{ #category : 'accessing' }
ZnOAuth2Session >> tokenType [
	^ tokenType
]

{ #category : 'public' }
ZnOAuth2Session >> updateExpiration: timeoutInteger [
	"Update my expiration date and time.
	Convert current date and time to UTC to prevent daylight saving issues."

	expiresOn := DateAndTime now asUTC + timeoutInteger.
]

{ #category : 'parsing' }
ZnOAuth2Session >> updateTokens: tokenData [
	"Update tokens from dictionary, signalling authentication error when present."

	(tokenData includesKey: 'error')
		ifTrue: [ ZnAuthError signal: (tokenData at: 'error') asString ].

	accessToken := tokenData at: 'access_token'.
	tokenType := tokenData at: 'token_type' ifAbsent:[ 'Bearer' ]. "Bearer is the default type on most implementation, sometimes the auth server not always respond with the type"
	(tokenData includesKey: 'expires_in')
		ifTrue: [ self updateExpiration: (tokenData at: 'expires_in') ].
	(tokenData includesKey: 'refresh_token')
		ifTrue: [ refreshToken := tokenData at: 'refresh_token' ]

]
