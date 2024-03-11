"
Seaside component that handles the Microsoft SSO callback and displays profile information.
"
Class {
	#name : 'ZnSSOSeasideMicrosoftDemoPanel',
	#superclass : 'ZnSSOSeasideOAuth2DemoPanel',
	#category : 'Zinc-SSO-Seaside-Demo',
	#package : 'Zinc-SSO-Seaside-Demo'
}

{ #category : 'as yet unclassified' }
ZnSSOSeasideMicrosoftDemoPanel >> gotoSignOn: aCallbackUrl [
	"Redirect to the Facebook sigon webpage."
	
	oauthSession := (ZnOAuth2Session microsoft: self oauthConsumerData)
		redirectUrl: aCallbackUrl greaseString ;
		yourself.

	self requestContext
		redirectTo: oauthSession authenticationUrl ;
		respond
]

{ #category : 'as yet unclassified' }
ZnSSOSeasideMicrosoftDemoPanel >> oauthConsumerData [

	^ ZnOAuth2ConsumerData 
		key: (self application preferenceAt: #oauth2MicrosoftClientId)
		secret: (self application preferenceAt: #oauth2MicrosoftClientSecret)
]

{ #category : 'as yet unclassified' }
ZnSSOSeasideMicrosoftDemoPanel >> renderContentOn: html [

	html heading
		level3 ;
		with: 'Microsoft user data'.
		
	userData isNil
		ifTrue: [ 
			html strong: 'No user data'.
			^ self ].

	self renderJSONDict: userData on: html.
	
	userData at: 'link' ifPresent: [ :link | self renderLink: link on: html ].

]
