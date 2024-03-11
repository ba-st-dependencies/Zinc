"
Seaside component that handles the OpenID signin process
"
Class {
	#name : 'ZnSSOSeasideOpenIDDemoPanel',
	#superclass : 'ZnSSOSeasideDemoPanel',
	#instVars : [
		'providerSession',
		'authResponse'
	],
	#category : 'Zinc-SSO-Seaside-Demo',
	#package : 'Zinc-SSO-Seaside-Demo'
}

{ #category : 'accessing' }
ZnSSOSeasideOpenIDDemoPanel >> authResponse [
	^ authResponse
]

{ #category : 'actions' }
ZnSSOSeasideOpenIDDemoPanel >> gotoSignOn: aCallbackUrl [

	| authUrl |
	
	authUrl := self providerSession getAuthenticationRequestUrl: aCallbackUrl asString do: [ :request |
		request realm: (self application preferenceAt: #openidRealm).
		request axRequestNamesAndEmail
		"self openIDoptionsForm updateAuthenticationRequest: request "].

	self requestContext
		redirectTo: authUrl ;
		respond
]

{ #category : 'actions' }
ZnSSOSeasideOpenIDDemoPanel >> handleCallback [

	| request |
	
	request := self requestContext request.
	authResponse := providerSession getValidatedAuthenticationResponseFrom:  request fields.

]

{ #category : 'accessing' }
ZnSSOSeasideOpenIDDemoPanel >> providerSession [

	^ providerSession 
]

{ #category : 'rendering' }
ZnSSOSeasideOpenIDDemoPanel >> renderContentOn: html [

	html heading
		level: 2;
		with: 'OpenID2 Authentication Response'.
		
	self authResponse isNil
		ifTrue: [ 
			html text: 'No response received.'.
			^ self ].

	self 	renderField: 'openid.mode' value: self authResponse mode on: html.
	self authResponse isSuccess 
		ifFalse: [ ^ self  ].

	self
		renderField: 'openid.identity' value: self authResponse identity on: html;
		renderField: 'openid.claimed_id' value: self authResponse claimedId on: html;
		renderField: 'First Name' value: self authResponse axValueFirstname on: html;
		renderField: 'Last name' value: self authResponse axValueLastname on: html;
		renderField: 'Email' value: self authResponse axValueEmail on: html;
		renderField: 'Country' value: self authResponse axValueCountry on: html;
		renderField: 'Language' value: self authResponse axValueLanguage on: html

]

{ #category : 'rendering' }
ZnSSOSeasideOpenIDDemoPanel >> renderField: aString value: aValue on: html [

	html div: [
		html text: aString.
		html text: ' : '.
		html strong: aValue ]
	


]

{ #category : 'initialize-release' }
ZnSSOSeasideOpenIDDemoPanel >> setProviderSession: anObject [

	providerSession := anObject 
]
