"
Abstract Seaside component with common functionality for the different OAuth1 based SSO providers.
"
Class {
	#name : 'ZnSSOSeasideOAuth1DemoPanel',
	#superclass : 'ZnSSOSeasideDemoPanel',
	#instVars : [
		'oauthService',
		'requestToken',
		'accessToken'
	],
	#category : 'Zinc-SSO-Seaside-Demo',
	#package : 'Zinc-SSO-Seaside-Demo'
}

{ #category : 'accessing' }
ZnSSOSeasideOAuth1DemoPanel >> accessToken [
	^ accessToken
]

{ #category : 'accessing' }
ZnSSOSeasideOAuth1DemoPanel >> accessToken: anObject [
	accessToken := anObject
]

{ #category : 'actions' }
ZnSSOSeasideOAuth1DemoPanel >> checkSetUp [

	self oauthService hasKeys
		ifFalse: [ self error: 'Consumer key and/or secret missing.' ].
]

{ #category : 'actions' }
ZnSSOSeasideOAuth1DemoPanel >> gotoSignOn: aCallbackUrl [
	"Redirect the client to the OAuth provider to handle the sign-in and authorization."

	self checkSetUp.

	requestToken := self oauthService getRequestTokenFor: aCallbackUrl with: self requestTokenExtraParameters.
	
	self requestContext
		redirectTo: (self oauthService loginUrlFor: requestToken) ; 
		respond
	
]

{ #category : 'actions' }
ZnSSOSeasideOAuth1DemoPanel >> handleCallback [
	"Hanlde the callback from the OAuth provider. If the client approved our request
	we can now get the access token." 

	| request token verifier |

	request := self requestContext request.

	token := request at: 'oauth_token'.
	verifier := request at: 'oauth_verifier'.
	
	(token isNil or: [ verifier isNil])
		ifTrue: [ ^self ].
		
	token = self requestToken value
		ifFalse: [ self error: 'Invalid token value' ].
	
	self accessToken: (self oauthService getAccessToken: self requestToken verifier: verifier)
]

{ #category : 'actions' }
ZnSSOSeasideOAuth1DemoPanel >> handleVerificationCode: aCode [
	"Try to get an access code using the user supplied verification code."

	aCode trimBoth isEmpty
		ifFalse: [
			self accessToken: (self oauthService getAccessToken: self requestToken verifier: aCode trimBoth) ]
]

{ #category : 'testing' }
ZnSSOSeasideOAuth1DemoPanel >> hasAccessToken [

	^self accessToken notNil
]

{ #category : 'accessing' }
ZnSSOSeasideOAuth1DemoPanel >> oauthService [
	^ oauthService
]

{ #category : 'accessing' }
ZnSSOSeasideOAuth1DemoPanel >> oauthService: anObject [
	oauthService := anObject
]

{ #category : 'accessing' }
ZnSSOSeasideOAuth1DemoPanel >> requestToken [
	^ requestToken
]

{ #category : 'resources' }
ZnSSOSeasideOAuth1DemoPanel >> requestTokenExtraParameters [

	^nil
]
