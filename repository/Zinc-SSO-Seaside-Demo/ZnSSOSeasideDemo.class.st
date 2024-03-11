"
A ZnSSOSeasideDemo is Seaside component that demonstrates how Zinc-SSO and Seaside can be used together.
"
Class {
	#name : 'ZnSSOSeasideDemo',
	#superclass : 'WAComponent',
	#instVars : [
		'hostedDomain',
		'responsePanel'
	],
	#category : 'Zinc-SSO-Seaside-Demo',
	#package : 'Zinc-SSO-Seaside-Demo'
}

{ #category : 'testing' }
ZnSSOSeasideDemo class >> canBeRoot [
	^true
]

{ #category : 'class initialization' }
ZnSSOSeasideDemo class >> initialize [

	self register
]

{ #category : 'class initialization' }
ZnSSOSeasideDemo class >> register [

	| application |
	
	application := WAAdmin register: self asApplicationAt: 'zinc-sso-demo'.
	
	application configuration
		addParent: ZnOpenIDConfiguration instance ;
		addParent: ZnOAuth1TwitterConfiguration instance ;
		addParent: ZnOAuth2FacebookConfiguration instance ;
		addParent: ZnOAuth2GoogleConfiguration instance ;
		addParent: ZnOAuth2MicrosoftConfiguration instance.

	application
		addLibrary: ZnSSOSeasideDemoFileLibrary.
		
	application
		preferenceAt: #oauth2GoogleRedirectUrl put: 'http://localhost:8080/oauth2callback'.
	self registerCallbackHandlerAt: 'oauth2callback'.
	
	^ application
]

{ #category : 'class initialization' }
ZnSSOSeasideDemo class >> registerCallbackHandlerAt: aKey [
	"setup an oauth2 callback handler"

	WAAdmin register: ZnOAuth2CallbackHandler at: aKey
]

{ #category : 'actions' }
ZnSSOSeasideDemo >> actionAbout [

	self responsePanel: ZnSSOAboutPanel new
]

{ #category : 'actions' }
ZnSSOSeasideDemo >> clearResponsePanel [

	responsePanel := nil
]

{ #category : 'resources' }
ZnSSOSeasideDemo >> googleOAuth2ConsumerData [

	^ZnOAuth2ConsumerData 
		key: (self application preferenceAt: #oauth2GoogleClientId)
		secret: (self application preferenceAt: #oauth2GoogleClientSecret)
		redirectUrl: (self application preferenceAt: #oauth2GoogleRedirectUrl)
]

{ #category : 'actions' }
ZnSSOSeasideDemo >> handleCallback [

	self responsePanel handleCallback
]

{ #category : 'accessing' }
ZnSSOSeasideDemo >> hostedDomain [
	^ hostedDomain
]

{ #category : 'accessing' }
ZnSSOSeasideDemo >> hostedDomain: anObject [
	hostedDomain := anObject
]

{ #category : 'resources' }
ZnSSOSeasideDemo >> openIDSingleSignOn [

	^ZnOpenIDSingleSignOn default
]

{ #category : 'rendering' }
ZnSSOSeasideDemo >> renderAnchor: aBlock title: aTitle imageUrl: anUrl on: html [

	self renderAnchor: aBlock title: aTitle imageUrl: anUrl target: nil on: html
]

{ #category : 'rendering' }
ZnSSOSeasideDemo >> renderAnchor: aBlock title: aTitle imageUrl: anUrl target: aTarget on: html [

	html div
		class: 'provider-link' ;
		with: [
			html anchor
				target: aTarget ;
				callback: aBlock ;
				with: [
					html image
						altText: aTitle ;
						title: aTitle ;
						url: anUrl ] ]
]

{ #category : 'rendering' }
ZnSSOSeasideDemo >> renderContentOn: html [

	self renderHeaderOn: html.
	
	html div
		style: 'clear: both; ' ;
		with: [
			self responsePanel notNil
				ifTrue: [
					html render: self responsePanel.
					html horizontalRule ]
				ifFalse: [
					self renderSignInOptionsOn: html ].
			self renderMenuOn: html ]
]

{ #category : 'rendering' }
ZnSSOSeasideDemo >> renderHeaderOn: html [

	html anchor
		id: 'logo' ;
		callback: [ self actionAbout ] ;
		with: 'Zn'.

	html heading
		level1 ;
		with: 'Zinc-SSO Seaside demo application'
]

{ #category : 'rendering' }
ZnSSOSeasideDemo >> renderMenuOn: html [

	html anchor
		callback: [ self clearResponsePanel ] ;
		with: 'Reset'.
		
	html text: ' | '.
	
	html anchor
		callback: [ self actionAbout ] ;
		with: 'About'
	

]

{ #category : 'rendering' }
ZnSSOSeasideDemo >> renderOAuth1Providers: aCallbackUrl on: html [

	html heading
		level2 ;
		with: 'OAuth1 providers'.

	html anchor
		callback: [ self signOnUsingOAuth1Twitter: aCallbackUrl ] ;
		with: [
			html image
				url: (ZnSSOSeasideDemoFileLibrary urlOf: #ssoTwitterGrayPng ) ;
				title: ' Sign in with Twitter' ]
]

{ #category : 'rendering' }
ZnSSOSeasideDemo >> renderOAuth2Providers: aCallbackUrl on: html [

	html heading
		level2 ;
		with: 'OAuth2 providers'.

	html anchor
		callback: [ self signOnUsingOAuth2Facebook: aCallbackUrl ] ;
		with: 'Facebook'.
	html text: ' | '.
	html anchor
		callback: [ self signOnUsingOAuth2Google: aCallbackUrl ] ;
		with: 'Google'.
	html text: ' | '.
	html anchor
		callback: [ self signOnUsingOAuth2Microsoft: aCallbackUrl ] ;
		with: 'Microsoft'
]

{ #category : 'rendering' }
ZnSSOSeasideDemo >> renderOpenID2SignInOptions: aCallbackUrl on: html [

	html heading
		level2;
		with: 'OpenID2 providers:'.

	html div: [
		self openIDSingleSignOn providers do: [ :each |
			self renderAnchor:  [ self signOnUsingOpenID2: each name callbackUrl: aCallbackUrl ]
				title: each altText
				imageUrl: each imgUrl
				on: html ] ]
]

{ #category : 'rendering' }
ZnSSOSeasideDemo >> renderOpenIDConnectProviders: aCallbackUrl on: html [

	html heading
		level2 ;
		with: 'OpenID Connect providers'.

	html div 
		style: 'float: left;' ;
		with: [ 
			html anchor
				callback: [ self signOnUsingOpenIDConnectGoogle: aCallbackUrl ] ;
				with: 'Google'.
			html text: ' | ' ].

	html form
		style: 'float: left; padding-left: 8px; padding-bottom: 8px;' ;
		with: [ 
			html label
				for: html nextId ;
				with: 'Google Apps domain: '.
			html textInput 
				id: html lastId ;
				on: #hostedDomain of: self.
			html submitButton 
				callback: [ self signOnUsingOpenIDConnectGoogle: aCallbackUrl domain: self hostedDomain ] ;
				with: 'Go' ]
]

{ #category : 'rendering' }
ZnSSOSeasideDemo >> renderSignInOptionsOn: html [

	| callback url |

	callback := WAActionCallback on: [ self handleCallback ] .
	url := html actionUrl copy addField: (html callbacks store: callback).
	url takeServerParametersFromRequest: self requestContext request.

	self renderOpenIDConnectProviders: url on: html.
	html horizontalRule
		style: 'clear: both;'.
	
	self renderOAuth2Providers: url on: html.
	html horizontalRule.
	
	self renderOAuth1Providers: url on: html.
	html horizontalRule.
	
	self renderOpenID2SignInOptions: url on: html.
	html horizontalRule
		style: 'clear: both;' 

	
]

{ #category : 'accessing' }
ZnSSOSeasideDemo >> responsePanel [

	^responsePanel 
]

{ #category : 'accessing' }
ZnSSOSeasideDemo >> responsePanel: aComponent [

	responsePanel := aComponent
]

{ #category : 'actions' }
ZnSSOSeasideDemo >> signOnUsingOAuth1Twitter: aCallbackUrl [
	
	self responsePanel: ZnSSOSeasideTwitterOAuth1DemoPanel new.
	self responsePanel gotoSignOn: aCallbackUrl
]

{ #category : 'actions' }
ZnSSOSeasideDemo >> signOnUsingOAuth2Facebook: aCallbackUrl [
	
	self responsePanel: ZnSSOSeasideFacebookDemoPanel new.
	self responsePanel gotoSignOn: aCallbackUrl
]

{ #category : 'actions' }
ZnSSOSeasideDemo >> signOnUsingOAuth2Google: aCallbackUrl [
	
	self responsePanel: ZnSSOSeasideGoogleOAuth2DemoPanel new.
	self responsePanel gotoSignOn: aCallbackUrl
]

{ #category : 'actions' }
ZnSSOSeasideDemo >> signOnUsingOAuth2Microsoft: aCallbackUrl [
	
	self responsePanel: ZnSSOSeasideMicrosoftDemoPanel new.
	self responsePanel gotoSignOn: aCallbackUrl
]

{ #category : 'actions' }
ZnSSOSeasideDemo >> signOnUsingOpenID2: aProviderName callbackUrl: aUrl [
	"Redirect to the sign in page of the OpenID provider."
	
	| providerSession |
	
	providerSession := self openIDSingleSignOn sessionForProviderNamed: aProviderName.
	
	self responsePanel: (ZnSSOSeasideOpenIDDemoPanel new
		setProviderSession: providerSession ;
		"openIDoptionsForm: self openIDoptionsForm ;"
		yourself ).
		
	self responsePanel gotoSignOn: aUrl
]

{ #category : 'actions' }
ZnSSOSeasideDemo >> signOnUsingOpenIDConnectGoogle: aCallbackUrl [
	
	self signOnUsingOpenIDConnectGoogle: aCallbackUrl domain: nil
]

{ #category : 'actions' }
ZnSSOSeasideDemo >> signOnUsingOpenIDConnectGoogle: aCallbackUrl domain: aDomain [
	
	self responsePanel: (ZnSSOSeasideOpenIdConnectDemoPanel new
		ssoSession: (
			(ZnGoogleOpenIDConnectSession withConsumerData: self googleOAuth2ConsumerData)
				hostedDomain: aDomain ;
				yourself )).

	self responsePanel gotoSignOn: aCallbackUrl
]

{ #category : 'updating' }
ZnSSOSeasideDemo >> updateRoot: aHtmlRoot [

	super updateRoot: aHtmlRoot.
	
	aHtmlRoot title: 'Zinc-SSO Seaside demo application'
]
