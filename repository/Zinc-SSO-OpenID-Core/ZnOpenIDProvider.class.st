"
A ZnOpenIDProvider instance holds information about an OpenID Provider (OP)
"
Class {
	#name : 'ZnOpenIDProvider',
	#superclass : 'Object',
	#instVars : [
		'name',
		'discoveryUrl',
		'shouldValidateClaimedIdBelongsToEndpoint',
		'nonceLocker',
		'imgUrl',
		'altText'
	],
	#category : 'Zinc-SSO-OpenID-Core',
	#package : 'Zinc-SSO-OpenID-Core'
}

{ #category : 'instance creation' }
ZnOpenIDProvider class >> newGoogleProvider [
	
	^self new
		name: 'Google';
		imgUrl: 'http://openid.net/images/get-logos/google.png' ;
		altText: 'Login with your Gmail account' ;
		discoveryUrl: 'https://www.google.com/accounts/o8/id' ;
		shouldValidateClaimedIdBelongsToEndpoint: true ;
		yourself
]

{ #category : 'instance creation' }
ZnOpenIDProvider class >> newHyvesProvider [
	
	^ self new
		name: 'Hyves' ;
		imgUrl: 'http://openid.net/images/get-logos/hyves.png';
		altText: 'Login with your Hyves account';
		discoveryUrl: 'http://www.hyves.nl/api/openid/xrds/';
		shouldValidateClaimedIdBelongsToEndpoint: false ;
		yourself

]

{ #category : 'instance creation' }
ZnOpenIDProvider class >> newMyOpenIDProvider [

	^ self new
		name: 'myOpenID' ;
		imgUrl: 'http://openid.net/images/get-logos/myopenid.png';
		altText: 'Login with your myOpenID account' ;
		discoveryUrl: 'http://www.myopenid.com/xrds';
		shouldValidateClaimedIdBelongsToEndpoint: false ;
		yourself

]

{ #category : 'instance creation' }
ZnOpenIDProvider class >> newYahooProvider [
	
	^ self new
		name: 'Yahoo' ;
		imgUrl: 'http://openid.net/images/get-logos/yahoo.png';
		altText: 'Login with your Yahoo account';
		discoveryUrl: 'http://open.login.yahooapis.com/openid20/www.yahoo.com/xrds';
		shouldValidateClaimedIdBelongsToEndpoint: false ;
		yourself

]

{ #category : 'accessing' }
ZnOpenIDProvider >> altText [
	^ altText
]

{ #category : 'accessing' }
ZnOpenIDProvider >> altText: anObject [
	altText := anObject
]

{ #category : 'actions' }
ZnOpenIDProvider >> createSession [

	^ZnOpenIDService forProvider: self
]

{ #category : 'actions' }
ZnOpenIDProvider >> discoverEndpoint [
	"XRDS (eXtensible Resource Descriptor Sequence) "

	| response |
	
	response := self httpClient
		url: self discoveryUrl ;
		accept: 'application/xrds+xml' ;
		get ;
		response.
	
	response isSuccess
		ifFalse: [ self error: 'Failed to retrieve endpoint for ', self printString ].
		
	^ ZnXRDService parseOPEndpointFromXrds: response contents
]

{ #category : 'accessing' }
ZnOpenIDProvider >> discoveryUrl [
	^discoveryUrl
]

{ #category : 'accessing' }
ZnOpenIDProvider >> discoveryUrl: aString [
	discoveryUrl := aString
]

{ #category : 'resources' }
ZnOpenIDProvider >> httpClient [

	^ ZnClient new beOneShot 
]

{ #category : 'accessing' }
ZnOpenIDProvider >> imgUrl [
	^ imgUrl
]

{ #category : 'accessing' }
ZnOpenIDProvider >> imgUrl: anObject [
	imgUrl := anObject
]

{ #category : 'testing' }
ZnOpenIDProvider >> isGoogleAppsProvider [
	^false
]

{ #category : 'accessing' }
ZnOpenIDProvider >> name [
	^name
]

{ #category : 'accessing' }
ZnOpenIDProvider >> name: aString [
	name := aString
]

{ #category : 'accessing' }
ZnOpenIDProvider >> nonceLocker [

	^ nonceLocker ifNil: [ nonceLocker := ZnOpenIDNonceLocker new ]
]

{ #category : 'printing' }
ZnOpenIDProvider >> printOn: stream [

	super printOn: stream.
	stream
		nextPutAll: '-' ;
		print: self name
]

{ #category : 'accessing' }
ZnOpenIDProvider >> shouldValidateClaimedIdBelongsToEndpoint [

	^ shouldValidateClaimedIdBelongsToEndpoint ifNil: [ shouldValidateClaimedIdBelongsToEndpoint := true ]
]

{ #category : 'accessing' }
ZnOpenIDProvider >> shouldValidateClaimedIdBelongsToEndpoint: aBoolean [

	shouldValidateClaimedIdBelongsToEndpoint := aBoolean
]
