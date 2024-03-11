"
Instance Variables
	ssoSession:		<ZnOpenIDConnectSession>
	userData:		<Dictionary>



"
Class {
	#name : 'ZnSSOSeasideOpenIdConnectDemoPanel',
	#superclass : 'ZnSSOSeasideDemoPanel',
	#instVars : [
		'ssoSession',
		'userData'
	],
	#category : 'Zinc-SSO-Seaside-Demo',
	#package : 'Zinc-SSO-Seaside-Demo'
}

{ #category : 'actions' }
ZnSSOSeasideOpenIdConnectDemoPanel >> gotoSignOn: aCallbackUrl [
	"Redirect to the sigon webpage."
	
	| state |
	
	state := String streamContents: [ :stream |
		stream 
			nextPutAll: aCallbackUrl pathString ;
			nextPut: $? ;
			nextPutAll: aCallbackUrl queryString ].

	self requestContext
		redirectTo: (ssoSession authenticationUrlWithState: state) ;
		respond
]

{ #category : 'actions' }
ZnSSOSeasideOpenIdConnectDemoPanel >> handleCallback [
	"This method is invoked when the SSO provider redirects back to this application." 

	ssoSession handleAuthenticationCallback: self requestContext request fields.
	userData := ssoSession getUserData	
]

{ #category : 'rendering' }
ZnSSOSeasideOpenIdConnectDemoPanel >> renderContentOn: html [

	html heading
		level2 ;
		with: 'OpenID Connect'.
		
	html paragraph: [ 
		html text: 'Issuer: '.
		html strong: self ssoSession issuer ].
		
	userData isNil
		ifTrue: [ 
			html strong: 'No user data'.
			^ self ].

	html heading
		level3;
		with: 'getOpenIdConnect response'.
		
	self renderJSONDict: userData on: html.
]

{ #category : 'accessing' }
ZnSSOSeasideOpenIdConnectDemoPanel >> ssoSession [
	^ ssoSession
]

{ #category : 'accessing' }
ZnSSOSeasideOpenIdConnectDemoPanel >> ssoSession: anObject [
	ssoSession := anObject
]
