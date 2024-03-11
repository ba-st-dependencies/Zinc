"
Seaside component that handles the Twitter SSO callback and displays profile information.
"
Class {
	#name : 'ZnSSOSeasideTwitterOAuth1DemoPanel',
	#superclass : 'ZnSSOSeasideOAuth1DemoPanel',
	#instVars : [
		'twitterAccess'
	],
	#category : 'Zinc-SSO-Seaside-Demo',
	#package : 'Zinc-SSO-Seaside-Demo'
}

{ #category : 'accessing' }
ZnSSOSeasideTwitterOAuth1DemoPanel >> accessToken: aToken [

	super accessToken: aToken.
	
	twitterAccess := ZnOAuth1TwitterUserAccess new
		oauth1Service: self oauthService ;
		accessToken: self accessToken ;
		yourself.
]

{ #category : 'actions' }
ZnSSOSeasideTwitterOAuth1DemoPanel >> actionUpdateStatus: aString [

	self twitterAccess statusesUpdate: aString
]

{ #category : 'resources' }
ZnSSOSeasideTwitterOAuth1DemoPanel >> defaulStatusText [

	^ 'This is my first tweet using Zinc-SSO! See https://github.com/svenvc/docs/blob/master/zinc/zinc-sso-paper.md for more information. #zinc-sso '
]

{ #category : 'initialization' }
ZnSSOSeasideTwitterOAuth1DemoPanel >> initialize [

	super initialize.

	self oauthService: (ZnOAuth1Service new
		providerAccount: (ZnOAuth1ConsumerData newForTwitterAuthentication
			consumer: (self application preferenceAt: #oauth1TwitterConsumerKey) ;
			consumerSecret: (self application preferenceAt: #oauth1TwitterConsumerSecret) ;
			yourself ))
]

{ #category : 'rendering' }
ZnSSOSeasideTwitterOAuth1DemoPanel >> renderContentOn: html [

	| json |
	
	self hasAccessToken
		ifFalse: [ ^self renderVerificationCodeFormOn: html ].
		
	self renderStatusFormOn: html. 
	
	html heading
		level: 3 ;
		with: 'Account properties'.

	json := self twitterAccess accountVerifyCredentials.
	self renderJSONDict: json on: html.
	
	json at: 'profile_image_url' ifPresent: [ :url | self renderImage: url on: html ]

]

{ #category : 'rendering' }
ZnSSOSeasideTwitterOAuth1DemoPanel >> renderMessage: msgDict on: html [

	html text: (msgDict at: 'text' ifAbsent: [ '?' ])
]

{ #category : 'rendering' }
ZnSSOSeasideTwitterOAuth1DemoPanel >> renderStatusFormOn: html [

	html form: [
		html label
			for: html nextId ;
			with: 'New Tweet:'.
		html break.
		html textInput
			id: html lastId ;
			size: 160 ;
			value: self defaulStatusText ;
			callback: [ :value | self actionUpdateStatus: value ].
		html submitButton 
			with: 'Post!' ]
]

{ #category : 'accessing' }
ZnSSOSeasideTwitterOAuth1DemoPanel >> twitterAccess [
	^twitterAccess
]
