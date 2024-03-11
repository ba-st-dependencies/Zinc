Class {
	#name : 'ZnOAuth1Token',
	#superclass : 'Object',
	#instVars : [
		'value',
		'secret',
		'sessionid'
	],
	#category : 'Zinc-SSO-OAuth1-Core',
	#package : 'Zinc-SSO-OAuth1-Core'
}

{ #category : 'instance creation' }
ZnOAuth1Token class >> newFrom: aString [

	^self newFromDictionary: (ZnResourceMetaUtils parseQueryFrom: aString readStream)
]

{ #category : 'instance creation' }
ZnOAuth1Token class >> newFromDictionary: aDictionary [

	^self new
		value: (aDictionary at: 'oauth_token');
		secret: (aDictionary at: 'oauth_token_secret');
		yourself

]

{ #category : 'accessing' }
ZnOAuth1Token >> secret [
	^ secret
]

{ #category : 'accessing' }
ZnOAuth1Token >> secret: anObject [
	secret := anObject
]

{ #category : 'accessing' }
ZnOAuth1Token >> sessionid [
	^ sessionid
]

{ #category : 'accessing' }
ZnOAuth1Token >> sessionid: anObject [
	sessionid := anObject
]

{ #category : 'accessing' }
ZnOAuth1Token >> value [
	^ value
]

{ #category : 'accessing' }
ZnOAuth1Token >> value: anObject [
	value := anObject
]
