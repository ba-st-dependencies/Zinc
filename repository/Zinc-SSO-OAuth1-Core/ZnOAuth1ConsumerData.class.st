Class {
	#name : 'ZnOAuth1ConsumerData',
	#superclass : 'Object',
	#instVars : [
		'getRequestTokenUrl',
		'authorizeTokenUrl',
		'getAccessTokenUrl',
		'consumer',
		'consumerSecret',
		'accessTokenClass'
	],
	#category : 'Zinc-SSO-OAuth1-Core',
	#package : 'Zinc-SSO-OAuth1-Core'
}

{ #category : 'instance creation' }
ZnOAuth1ConsumerData class >> newForDropbox [

	^self new
		getRequestTokenUrl: 'https://api.dropbox.com/1/oauth/request_token' ;
		authorizeTokenUrl: 'https://www.dropbox.com/1/oauth/authorize' ;
		getAccessTokenUrl: 'https://api.dropbox.com/1/oauth/access_token' ;
		yourself
]

{ #category : 'instance creation' }
ZnOAuth1ConsumerData class >> newForGoogle [

	^self new
		getRequestTokenUrl: 'https://www.google.com/accounts/OAuthGetRequestToken' ;
		authorizeTokenUrl: 'https://www.google.com/accounts/OAuthAuthorizeToken' ;
		getAccessTokenUrl: 'https://www.google.com/accounts/OAuthGetAccessToken' ;
		yourself
]

{ #category : 'instance creation' }
ZnOAuth1ConsumerData class >> newForTwitter [

	^self new
		getRequestTokenUrl: 'https://api.twitter.com/oauth/request_token' ;
		authorizeTokenUrl: 'https://api.twitter.com/oauth/authorize' ;
		getAccessTokenUrl: 'https://api.twitter.com/oauth/access_token' ;
		accessTokenClass:  ZnOAuth1TwitterAccessToken ;
		yourself
]

{ #category : 'instance creation' }
ZnOAuth1ConsumerData class >> newForTwitterAuthentication [
	"Twitter variant for authentication instead of authorization."

	^self newForTwitter 
		authorizeTokenUrl: 'https://api.twitter.com/oauth/authenticate' ;
		yourself
]

{ #category : 'accessing' }
ZnOAuth1ConsumerData >> accessTokenClass [
	^ accessTokenClass ifNil: [ accessTokenClass := ZnOAuth1Token ]
]

{ #category : 'accessing' }
ZnOAuth1ConsumerData >> accessTokenClass: anObject [
	accessTokenClass := anObject
]

{ #category : 'accessing' }
ZnOAuth1ConsumerData >> authorizeTokenUrl [
	^ authorizeTokenUrl
]

{ #category : 'accessing' }
ZnOAuth1ConsumerData >> authorizeTokenUrl: anObject [
	authorizeTokenUrl := anObject
]

{ #category : 'accessing' }
ZnOAuth1ConsumerData >> consumer [
	^ consumer
]

{ #category : 'accessing' }
ZnOAuth1ConsumerData >> consumer: anObject [
	consumer := anObject
]

{ #category : 'accessing' }
ZnOAuth1ConsumerData >> consumerSecret [
	^ consumerSecret
]

{ #category : 'accessing' }
ZnOAuth1ConsumerData >> consumerSecret: anObject [
	consumerSecret := anObject
]

{ #category : 'accessing' }
ZnOAuth1ConsumerData >> getAccessTokenUrl [
	^ getAccessTokenUrl
]

{ #category : 'accessing' }
ZnOAuth1ConsumerData >> getAccessTokenUrl: anObject [
	getAccessTokenUrl := anObject
]

{ #category : 'accessing' }
ZnOAuth1ConsumerData >> getRequestTokenUrl [
	^ getRequestTokenUrl
]

{ #category : 'accessing' }
ZnOAuth1ConsumerData >> getRequestTokenUrl: anObject [
	getRequestTokenUrl := anObject
]

{ #category : 'testing' }
ZnOAuth1ConsumerData >> hasKeys [

	^ self consumer notNil and: [ self consumerSecret notNil ]
]

{ #category : 'resources' }
ZnOAuth1ConsumerData >> newCalculator [

	^ ZnOAuth1AuthorizationCalculator new
		consumerKey: self consumer ;
		consumerSecret: self consumerSecret ;
		yourself
]
