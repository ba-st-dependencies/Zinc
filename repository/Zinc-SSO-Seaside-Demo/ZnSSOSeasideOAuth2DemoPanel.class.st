"
Abstract Seaside component with common functionality for the different OAuth2 based SSO providers.
"
Class {
	#name : 'ZnSSOSeasideOAuth2DemoPanel',
	#superclass : 'ZnSSOSeasideDemoPanel',
	#instVars : [
		'oauthSession',
		'userData'
	],
	#category : 'Zinc-SSO-Seaside-Demo',
	#package : 'Zinc-SSO-Seaside-Demo'
}

{ #category : 'actions' }
ZnSSOSeasideOAuth2DemoPanel >> handleCallback [
	"This method is invoked when the SSO provider redirects back to this application." 

	oauthSession handleAuthenticationCallback: self requestContext request fields.
	userData := oauthSession getUserData
]

{ #category : 'accessing' }
ZnSSOSeasideOAuth2DemoPanel >> oauthSession [

	^ oauthSession 
]

{ #category : 'accessing' }
ZnSSOSeasideOAuth2DemoPanel >> userData [

	^userData 
]
