Class {
	#name : 'ZnOAuth1Service',
	#superclass : 'Object',
	#instVars : [
		'providerAccount'
	],
	#category : 'Zinc-SSO-OAuth1-Core',
	#package : 'Zinc-SSO-OAuth1-Core'
}

{ #category : 'actions' }
ZnOAuth1Service >> executeRequest: aRequest token: anAccessToken [
	" Execute the HTTP request <aRequest>. Use <anAccessToken> to set the OAuth Authorization header."

	^self executeRequest: aRequest token: anAccessToken followRedirects: true
]

{ #category : 'actions' }
ZnOAuth1Service >> executeRequest: aRequest token: anAccessToken followRedirects: aBoolean [
	"Execute the HTTP request <aRequest>. Use <anAccessToken> to set the OAuth Authorization header."

	| calculator response |

	calculator := self providerAccount newCalculator.
	anAccessToken notNil
		ifTrue: [
			calculator 
				token: anAccessToken value;
				tokenSecret: anAccessToken secret ].
	
	aRequest setAuthorization: (calculator getAuthorizationHeader: aRequest).
	response := self httpClient 
		request: aRequest ;
		execute ;
		response.
	
	(aBoolean and: [ response isRedirect ])
		ifTrue: [ 
			| newRequest |
			newRequest := aRequest copy
				url: (response headers at: 'Location') ;
				yourself.
			^self executeRequest: newRequest token: anAccessToken ].
	^response
]

{ #category : 'actions' }
ZnOAuth1Service >> getAccessToken: aToken [
	"The final step: Use the token <aToken> that was authorized by the user to get the access token."

	^self getAccessToken: aToken verifier: nil
]

{ #category : 'actions' }
ZnOAuth1Service >> getAccessToken: aToken verifier: aVerifier [
	"The final step: Use the token <aToken> that was authorized by the user to get the access token."

	| calculator request response responseProperties |
	
	calculator := self providerAccount newCalculator
		token: aToken value ;
		tokenSecret: aToken secret ;
		verifier: aVerifier ;
		yourself.

	request := ZnRequest get: self providerAccount getAccessTokenUrl.
	request
		setAccept: '*/*' ;
		setAuthorization: (calculator getAuthorizationHeader: request).

	response := self httpClient
		request: request ;
		execute ;
		response.
	
	response isSuccess 
		ifFalse: [ self error: 'Invalid response' ].

	responseProperties := response contents.
	responseProperties isString
		ifTrue: [ responseProperties := self resourceMetaUtils parseQueryFrom: responseProperties readStream ].

	^self providerAccount accessTokenClass newFromDictionary: responseProperties 
]

{ #category : 'actions' }
ZnOAuth1Service >> getRequestToken [
	"The first step is to get a token and token_secret. Use this mthod only with OAuth 1.0 providers.
	OAuth version 1.0a requires a callback url."

	^self getRequestTokenFor: nil with: nil
]

{ #category : 'actions' }
ZnOAuth1Service >> getRequestTokenFor: aCallbackUrl [
	"The first step is to get a token and token_secret for <aCallbackUrl>."

	^self getRequestTokenFor: aCallbackUrl with: nil
]

{ #category : 'actions' }
ZnOAuth1Service >> getRequestTokenFor: aCallbackUrl with: extraParameters [
	"The first step is to get a token and token_secret for <aCallbackUrl>.
	Version 1.0a of OAuth requires a callback url. "

	| calculator request response responseProperties |

	calculator := self providerAccount newCalculator
		callback: aCallbackUrl ;
		yourself.
	
	request := ZnRequest get: self providerAccount getRequestTokenUrl.
	extraParameters notNil
		ifTrue: [ extraParameters keysAndValuesDo: [ :key :value | request uri queryAt: key put: value ] ].
	request
		setAccept: '*/*' ;
		setAuthorization: (calculator getAuthorizationHeader: request).

	response := self httpClient
		request: request ;
		execute ;
		response.
		
	response isSuccess 
		ifFalse: [ self error: 'Invalid response' ].

	responseProperties := response contents.
	responseProperties isString
		ifTrue: [ responseProperties := self resourceMetaUtils parseQueryFrom: responseProperties readStream ].
	(aCallbackUrl notNil and: [ (responseProperties at: 'oauth_callback_confirmed') ~= 'true' ])
		ifTrue: [ self error: 'Callback not confirmed' ].
		
	^ZnOAuth1Token newFromDictionary: responseProperties
]

{ #category : 'testing' }
ZnOAuth1Service >> hasKeys [
	^self providerAccount hasKeys
]

{ #category : 'resources' }
ZnOAuth1Service >> httpClient [

	^ZnClient new
		dontFollowRedirects ;
		yourself
]

{ #category : 'actions' }
ZnOAuth1Service >> httpDelete: anUrl using: aToken [

	| response |
	
	response := self executeRequest: (ZnRequest delete: anUrl) token: aToken.
	response isSuccess
		ifFalse: [ self error: 'httpDelete failed' ].

	^response contents
]

{ #category : 'actions' }
ZnOAuth1Service >> httpGet: anUrl using: aToken [

	| response |
	
	response := self executeRequest: (ZnRequest get: anUrl) token: aToken.
	response isSuccess
		ifFalse: [ self error: 'httpGet failed' ].

	^response contents
]

{ #category : 'actions' }
ZnOAuth1Service >> httpPost: anUrl with: anEntity using: aToken [

	| response request |
	
	request := ZnRequest post: anUrl.
	request entity: anEntity.
	
	response := self executeRequest: request token: aToken.
	response isSuccess
		ifFalse: [ self error: 'httpPost failed' ].

	^ response contents
]

{ #category : 'actions' }
ZnOAuth1Service >> httpPut: anUrl with: anEntity using: aToken [

	| response request |
	
	request := ZnRequest put: anUrl.
	request entity: anEntity.
	
	response := self executeRequest: request token: aToken.
	response isSuccess
		ifFalse: [ self error: 'httpPut failed' ].

	^ response contents
]

{ #category : 'actions' }
ZnOAuth1Service >> loginUrlFor: aToken [
	"Answer the url to which we should redirect the user. If the user grants us access the provider will redirect
	the user to the callbackUrl. The redirect will contain a new token which we can use to get an access token."

	^self providerAccount authorizeTokenUrl asZnUrl
		queryAt: 'oauth_token' put: aToken value ;
		yourself
]

{ #category : 'actions' }
ZnOAuth1Service >> loginUrlFor: aToken callbackUrl: anUrl [
	"Answer the url to which we should redirect the user. If the user grants us access the provider will redirect
	the user to the callbackUrl. The redirect will contain a new token which we can use to get an access token.
	
	This method should be used with OAuth 1.0 providers. Use #loginUrlFor: with OAuth 1.0a providers."

	^(self loginUrlFor: aToken)
		queryAt: 'oauth_callback' put: anUrl ;
		yourself
	
]

{ #category : 'accessing' }
ZnOAuth1Service >> providerAccount [
	^ providerAccount
]

{ #category : 'accessing' }
ZnOAuth1Service >> providerAccount: anObject [
	providerAccount := anObject
]

{ #category : 'resources' }
ZnOAuth1Service >> resourceMetaUtils [

	^ZnResourceMetaUtils
]
