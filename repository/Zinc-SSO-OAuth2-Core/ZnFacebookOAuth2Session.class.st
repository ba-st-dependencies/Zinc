"
I am ZnFacebookOAuth2Session.
I am a ZnOAuth2Session.
"
Class {
	#name : 'ZnFacebookOAuth2Session',
	#superclass : 'ZnOAuth2Session',
	#category : 'Zinc-SSO-OAuth2-Core',
	#package : 'Zinc-SSO-OAuth2-Core'
}

{ #category : 'resources' }
ZnFacebookOAuth2Session class >> scopeEmail [
	"Provides access to the user's primary email address in the email property.
	See: https://developers.facebook.com/docs/reference/login/email-permissions/ "
	
	^ 'email'
]

{ #category : 'resources' }
ZnFacebookOAuth2Session class >> scopeUserLikes [
	"Provides access to the list of all of the pages the user has liked as the likes connection
	See: https://developers.facebook.com/docs/reference/login/extended-profile-properties/"
	
	^ 'user_likes'
]

{ #category : 'resources' }
ZnFacebookOAuth2Session class >> scopeUserPhotos [
	"Provides access to the photos the user has uploaded.
	See: https://developers.facebook.com/docs/reference/login/extended-profile-properties/"
	
	^ 'user_photos'
]

{ #category : 'resources' }
ZnFacebookOAuth2Session class >> ssoScopes [
	"Answer a collection of scopes that can be used for Authentication. "

	^ Array with: self scopeEmail
]

{ #category : 'public' }
ZnFacebookOAuth2Session >> authenticationUrl [

	^ (ZnUrl fromString: 'https://graph.facebook.com/oauth/authorize')
		queryAt: 'client_id' put: self consumerData key ;
		queryAt: 'redirect_uri' put: self redirectUrl ;
		queryAt: 'scope' put: self scopeParameter ;
		yourself.

]

{ #category : 'public' }
ZnFacebookOAuth2Session >> getUserData [

	| url response |
	
	url := (ZnUrl fromString: 'https://graph.facebook.com/me')
		queryAt: 'access_token' put: self accessToken;
		yourself.

	response := ZnClient new get: url.
	
	^ ZnUtils defaultJSONReader fromString: response
]

{ #category : 'public' }
ZnFacebookOAuth2Session >> handleAuthenticationCallback: aParameterDictionary [ 

	| code url oauthResponse |
	
	code := aParameterDictionary at: 'code' ifAbsent: [ ^nil ].

	url := (ZnUrl fromString: 'https://graph.facebook.com/oauth/access_token')
		queryAt: 'client_id' put: self consumerData key ;
		queryAt: 'redirect_uri' put: self redirectUrl ;
		queryAt: 'client_secret' put: self consumerData secret ;
		queryAt: 'code' put: code;
		yourself.
	
	oauthResponse := ZnClient new get: url.
	
	accessToken := (self fieldDictionaryFrom: oauthResponse) at: 'access_token'.
]
