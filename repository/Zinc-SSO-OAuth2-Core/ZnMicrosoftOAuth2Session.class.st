"
I am ZnMicrosoftOAuth2Session.
I am a ZnOAuth2Session.

Also see: http://msdn.microsoft.com/en-us/library/live/hh243647.aspx
"
Class {
	#name : 'ZnMicrosoftOAuth2Session',
	#superclass : 'ZnOAuth2Session',
	#category : 'Zinc-SSO-OAuth2-Core',
	#package : 'Zinc-SSO-OAuth2-Core'
}

{ #category : 'resources' }
ZnMicrosoftOAuth2Session class >> scopeBasic [
	"Read access to a user's basic profile info. Also enables read access to a user's list of contacts.
	See: http://msdn.microsoft.com/en-us/library/live/hh243646.aspx "

	^ 'wl.basic'
]

{ #category : 'resources' }
ZnMicrosoftOAuth2Session class >> scopeEmails [
	"Read access to a user's personal, preferred, and business email addresses.
	See: http://msdn.microsoft.com/en-us/library/live/hh243646.aspx "

	^ 'wl.emails'
]

{ #category : 'resources' }
ZnMicrosoftOAuth2Session class >> scopeSignin [
	"Single sign-in behavior. With single sign-in, users who are already signed in to Live Connect
	are also signed in to your website.
	See: http://msdn.microsoft.com/en-us/library/live/hh243646.aspx "

	^ 'wl.signin'
]

{ #category : 'resources' }
ZnMicrosoftOAuth2Session class >> ssoScopes [
	"Answer a collection of scopes that can be used for Authentication. "

	^ Array with: self scopeSignin with: self scopeBasic with: self scopeEmails
]

{ #category : 'public' }
ZnMicrosoftOAuth2Session >> authenticationUrl [

	^ (ZnUrl fromString: 'https://login.live.com/oauth20_authorize.srf')
		queryAt: 'response_type' put: 'code' ;
		queryAt: 'client_id' put: self consumerData key ;
		queryAt: 'redirect_uri' put: self redirectUrl ;
		queryAt: 'scope' put: self scopeParameter ;
		yourself.

]

{ #category : 'public' }
ZnMicrosoftOAuth2Session >> getUserData [

	| url response |
	
	url := (ZnUrl fromString: 'https://apis.live.net/v5.0/me')
		queryAt: 'access_token' put: self accessToken;
		yourself.

	response := ZnClient new get: url.
	
	^ ZnUtils defaultJSONReader fromString: response
]

{ #category : 'public' }
ZnMicrosoftOAuth2Session >> handleAuthenticationCallback: aParameterDictionary [ 

	| code tokenRequest tokenResponse tokenData |
	
	code := aParameterDictionary at: 'code' ifAbsent: [ ^nil ].

	tokenRequest  := (ZnRequest post: (ZnUrl fromString: 'https://login.live.com/oauth20_token.srf'))
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
		
	accessToken := tokenData at: 'access_token'
]
