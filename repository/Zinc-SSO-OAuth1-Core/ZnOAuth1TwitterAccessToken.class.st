Class {
	#name : 'ZnOAuth1TwitterAccessToken',
	#superclass : 'ZnOAuth1Token',
	#instVars : [
		'userId',
		'screenName'
	],
	#category : 'Zinc-SSO-OAuth1-Core',
	#package : 'Zinc-SSO-OAuth1-Core'
}

{ #category : 'instance creation' }
ZnOAuth1TwitterAccessToken class >> newFromDictionary: aDictionary [

	^(super newFromDictionary:  aDictionary)
		userId: (aDictionary at: 'user_id') ;
		screenName: (aDictionary at: 'screen_name') ;
		yourself

]

{ #category : 'accessing' }
ZnOAuth1TwitterAccessToken >> screenName [
	^ screenName
]

{ #category : 'accessing' }
ZnOAuth1TwitterAccessToken >> screenName: anObject [
	screenName := anObject
]

{ #category : 'accessing' }
ZnOAuth1TwitterAccessToken >> userId [
	^ userId
]

{ #category : 'accessing' }
ZnOAuth1TwitterAccessToken >> userId: anObject [
	userId := anObject
]
