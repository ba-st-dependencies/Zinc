Class {
	#name : 'ZnOAuth1UserAccess',
	#superclass : 'Object',
	#instVars : [
		'oauth1Service',
		'accessToken'
	],
	#category : 'Zinc-SSO-OAuth1-Core',
	#package : 'Zinc-SSO-OAuth1-Core'
}

{ #category : 'accessing' }
ZnOAuth1UserAccess >> accessToken [
	^ accessToken
]

{ #category : 'accessing' }
ZnOAuth1UserAccess >> accessToken: anObject [
	accessToken := anObject
]

{ #category : 'accessing' }
ZnOAuth1UserAccess >> oauth1Service [
	^ oauth1Service
]

{ #category : 'accessing' }
ZnOAuth1UserAccess >> oauth1Service: anObject [
	oauth1Service := anObject
]
