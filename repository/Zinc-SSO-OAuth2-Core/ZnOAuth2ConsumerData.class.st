"
I am ZnOAuth2ConsumerData holding the data necessary to ask an OAuth2 provider to do authentication on our behalf.

key
	- the application key

redirectUrl
	- The url to which to provider will redirect to

secret
	- the application secret
"
Class {
	#name : 'ZnOAuth2ConsumerData',
	#superclass : 'Object',
	#instVars : [
		'key',
		'secret',
		'redirectUrl'
	],
	#category : 'Zinc-SSO-OAuth2-Core',
	#package : 'Zinc-SSO-OAuth2-Core'
}

{ #category : 'instance creation' }
ZnOAuth2ConsumerData class >> key: aKey secret: aSecret [

	^ self new setKey: aKey andSecret: aSecret
]

{ #category : 'instance creation' }
ZnOAuth2ConsumerData class >> key: aKey secret: aSecret redirectUrl: anUrl [

	^ self new setKey: aKey andSecret: aSecret andRedirectUrl: anUrl
]

{ #category : 'accessing' }
ZnOAuth2ConsumerData >> key [
	^ key
]

{ #category : 'accessing' }
ZnOAuth2ConsumerData >> redirectUrl [

	^ redirectUrl 
]

{ #category : 'accessing' }
ZnOAuth2ConsumerData >> secret [
	^ secret
]

{ #category : 'initialize-release' }
ZnOAuth2ConsumerData >> setKey: aKey andSecret: aSecret [

	key := aKey.
	secret := aSecret 
]

{ #category : 'initialize-release' }
ZnOAuth2ConsumerData >> setKey: aKey andSecret: aSecret andRedirectUrl: anUrl [

	self setKey: aKey andSecret: aSecret.
	redirectUrl := anUrl
]
