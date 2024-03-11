"
Seaside component that handles the Google SSO callback and displays profile information.
"
Class {
	#name : 'ZnSSOSeasideGoogleOAuth2DemoPanel',
	#superclass : 'ZnSSOSeasideOAuth2DemoPanel',
	#category : 'Zinc-SSO-Seaside-Demo',
	#package : 'Zinc-SSO-Seaside-Demo'
}

{ #category : 'actions' }
ZnSSOSeasideGoogleOAuth2DemoPanel >> gotoSignOn: aCallbackUrl [
	"Redirect to the Facebook sigon webpage."
	
	| state |
	
	oauthSession := (ZnOAuth2Session google: self oauthConsumerData)
		yourself.
		
	state := String streamContents: [ :stream |
		stream 
			nextPutAll: aCallbackUrl pathString ;
			nextPut: $? ;
			nextPutAll: aCallbackUrl queryString ].

	self requestContext
		redirectTo: (oauthSession authenticationUrlWithState: state) ;
		respond
]

{ #category : 'resources' }
ZnSSOSeasideGoogleOAuth2DemoPanel >> oauthConsumerData [

	^ ZnOAuth2ConsumerData 
		key: (self application preferenceAt: #oauth2GoogleClientId)
		secret: (self application preferenceAt: #oauth2GoogleClientSecret)
		redirectUrl: (self application preferenceAt: #oauth2GoogleRedirectUrl)
]

{ #category : 'rendering' }
ZnSSOSeasideGoogleOAuth2DemoPanel >> renderContentOn: html [

	html heading
		level3 ;
		with: 'Google user data'.
		
	userData isNil
		ifTrue: [ 
			html strong: 'No user data'.
			^ self ].

	self renderJSONDict: userData on: html.

	userData at: 'link' ifPresent: [ :link | self renderLink: link on: html ].
	userData at: 'picture' ifPresent: [ :link | self renderImage: (link, '?sz=200') on: html ]
]
