"
Seaside component that handles the Facebook SSO callback and displays profile information.
"
Class {
	#name : 'ZnSSOSeasideFacebookDemoPanel',
	#superclass : 'ZnSSOSeasideOAuth2DemoPanel',
	#category : 'Zinc-SSO-Seaside-Demo',
	#package : 'Zinc-SSO-Seaside-Demo'
}

{ #category : 'actions' }
ZnSSOSeasideFacebookDemoPanel >> gotoSignOn: aCallbackUrl [
	"Redirect to the Facebook sigon webpage."
	
	oauthSession := (ZnOAuth2Session facebook: self oauthConsumerData)
		redirectUrl: aCallbackUrl greaseString ;
		yourself.

	self requestContext
		redirectTo: oauthSession authenticationUrl ;
		respond
]

{ #category : 'resources' }
ZnSSOSeasideFacebookDemoPanel >> oauthConsumerData [

	^ ZnOAuth2ConsumerData 
		key: (self application preferenceAt: #oauthFacebookClientId)
		secret: (self application preferenceAt: #oauthFacebookClientSecret)
]

{ #category : 'rendering' }
ZnSSOSeasideFacebookDemoPanel >> renderContentOn: html [

	html heading
		level3 ;
		with: 'Facebook user data'.
		
	userData isNil
		ifTrue: [ 
			html strong: 'No user data'.
			^ self ].

	self renderJSONDict: userData on: html.
	
	userData at: 'link' ifPresent: [ :link | self renderLink: link on: html ].
	userData at: 'username' ifPresent: [ :name |
		self renderImage: ('http://graph.facebook.com/', name, '/picture?type=large') on: html ]
]
