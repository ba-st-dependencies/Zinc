"
I'm a ZnOpenIDConnectSession, representing server side state tracking an OpenID Connect session.

See: http://openid.net/connect/

Instance Variables
	discoveryDocument:		<ZnOpenIDConnectDiscoveryDocument>
	extraAuthenticationParameters:		<Dictionary>
	idToken:		<Object>

"
Class {
	#name : 'ZnOpenIDConnectSession',
	#superclass : 'ZnOAuth2Session',
	#instVars : [
		'discoveryDocument',
		'authenticationState',
		'extraAuthenticationParameters'
	],
	#category : 'Zinc-SSO-OAuth2-Core',
	#package : 'Zinc-SSO-OAuth2-Core'
}

{ #category : 'resources' }
ZnOpenIDConnectSession class >> ssoScopes [

	^#( 'openid' 'profile' 'email' )
]

{ #category : 'accessing' }
ZnOpenIDConnectSession >> authenticationState [

	^authenticationState
]

{ #category : 'public' }
ZnOpenIDConnectSession >> authenticationUrl [

	authenticationState := self secureRandomString.
	^self authenticationUrlWithState: authenticationState.
]

{ #category : 'public' }
ZnOpenIDConnectSession >> authenticationUrlWithState: aStateString [

	| authUrl |

	authUrl := (ZnUrl fromString: self authorizationEndpoint)
		queryAt: 'response_type' put: 'code' ;
		queryAt: 'client_id' put: self consumerData key ;
		queryAt: 'redirect_uri' put: self redirectUrl ;
		queryAt: 'scope' put: self scopeParameter ;
		queryAt: 'state' put: aStateString ;
		queryAddAll: self extraAuthenticationParameters ;
		yourself.

	^authUrl
]

{ #category : 'accessing' }
ZnOpenIDConnectSession >> authorizationEndpoint [

	^discoveryDocument authorizationEndpoint
]

{ #category : 'accessing' }
ZnOpenIDConnectSession >> extraAuthenticationParameterAt: aKey [

	^self extraAuthenticationParameters at: aKey ifAbsent: [ nil ]
]

{ #category : 'accessing' }
ZnOpenIDConnectSession >> extraAuthenticationParameterAt: aKey put: aStringOrNil [

	aStringOrNil isNil
		ifTrue: [ self extraAuthenticationParameters removeKey: aKey ifAbsent: [  ] ]
		ifFalse: [ self extraAuthenticationParameters at: aKey put: aStringOrNil ]
]

{ #category : 'accessing' }
ZnOpenIDConnectSession >> extraAuthenticationParameters [

	^extraAuthenticationParameters ifNil: [ extraAuthenticationParameters := Dictionary new ]
]

{ #category : 'public' }
ZnOpenIDConnectSession >> getUserData [

	| url response |
	
	url := (ZnUrl fromString: self userinfoEndpoint)
		queryAt: 'access_token' put: self accessToken;
		yourself.

	response := ZnClient new get: url.
	
	^ ZnUtils defaultJSONReader fromString: response
]

{ #category : 'public' }
ZnOpenIDConnectSession >> handleAuthenticationCallback: aParameterDictionary [ 

	| code tokenRequest tokenResponse tokenData |

	code := aParameterDictionary at: 'code' ifAbsent: [ ^nil ].
	self authenticationState notNil
		ifTrue: [ self validateAuthenticationState: (aParameterDictionary at: 'state') ].

	tokenRequest  := (ZnRequest post: (ZnUrl fromString: self tokenEndpoint))
		entity: (ZnApplicationFormUrlEncodedEntity new
			at: 'code' put: code ;
			at: 'client_id' put: self consumerData key ;
			at: 'client_secret' put: self consumerData secret ;
			at: 'redirect_uri' put: self redirectUrl ;
			at: 'grant_type' put: 'authorization_code' ;
			yourself) ;
		yourself.

	tokenResponse := ZnClient new 
		request: tokenRequest ;
		post.
	tokenData := ZnUtils defaultJSONReader fromString: tokenResponse.
		
	self validateIdToken: (tokenData at: 'id_token').

	accessToken := tokenData at: 'access_token'.
	tokenType := tokenData at: 'token_type'.
	refreshToken := tokenData at: 'refresh_token' ifAbsent: [ nil ].
]

{ #category : 'initialization-release' }
ZnOpenIDConnectSession >> initializeWith: aDiscoveryDocument consumerData: aConsumerData [

	discoveryDocument := aDiscoveryDocument.
	self setConsumerData: aConsumerData 
]

{ #category : 'accessing' }
ZnOpenIDConnectSession >> issuer [

	^discoveryDocument issuer
]

{ #category : 'resources' }
ZnOpenIDConnectSession >> secureRandomString [

	self error: 'Not Yet Implemented'
]

{ #category : 'accessing' }
ZnOpenIDConnectSession >> tokenEndpoint [

	^discoveryDocument tokenEndpoint
]

{ #category : 'accessing' }
ZnOpenIDConnectSession >> userinfoEndpoint [

	^discoveryDocument userinfoEndpoint
]

{ #category : 'private' }
ZnOpenIDConnectSession >> validateAuthenticationState: aString [

	self authenticationState = aString 
		ifFalse: [ self error: 'Invalid authentication state' ]
]

{ #category : 'private' }
ZnOpenIDConnectSession >> validateIdToken: aString [
	"TO DO!"
	
	self error: 'Not Yet Implemented'
]
