"
I am ZnAmazonOAuth2Session.
I am a ZnOAuth2Session.
"
Class {
	#name : 'ZnAmazonOAuth2Session',
	#superclass : 'ZnOAuth2Session',
	#category : 'Zinc-SSO-OAuth2-Core',
	#package : 'Zinc-SSO-OAuth2-Core'
}

{ #category : 'as yet unclassified' }
ZnAmazonOAuth2Session >> authenticationUrl [

	^ (ZnUrl fromString: 'https://www.amazon.com/ap/oa')
		queryAt: 'client_id' put: self consumerData key ;
		queryAt: 'response_type' put: 'code' ;
		queryAt: 'redirect_uri' put: self redirectUrl ;
		queryAt: 'scope' put: self scopeParameter ;
		yourself.

]

{ #category : 'as yet unclassified' }
ZnAmazonOAuth2Session >> handleAuthenticationCallback: aParameterDictionary [ 

	| code url oauthResponse |
	
	code := aParameterDictionary at: 'code' ifAbsent: [ ^nil ].

	url := (ZnUrl fromString: 'https://api.amazon.com/auth/o2/token')
		queryAt: 'grant_type' put: 'authorization_code' ;
		queryAt: 'client_id' put: self consumerData key ;
		queryAt: 'client_secret' put: self consumerData secret ;
		queryAt: 'code' put: code;
		yourself.
	
	oauthResponse := ZnClient new get: url.
	
	accessToken := (self fieldDictionaryFrom: oauthResponse) at: 'access_token'.
]
