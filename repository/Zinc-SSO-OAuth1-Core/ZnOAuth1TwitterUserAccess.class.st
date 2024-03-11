Class {
	#name : 'ZnOAuth1TwitterUserAccess',
	#superclass : 'ZnOAuth1UserAccess',
	#category : 'Zinc-SSO-OAuth1-Core',
	#package : 'Zinc-SSO-OAuth1-Core'
}

{ #category : 'twitter-api' }
ZnOAuth1TwitterUserAccess >> accountVerifyCredentials [
	"https://dev.twitter.com/docs/api/1.1/get/account/verify_credentials "

	| url response json |

	url := ZnUrl fromString: 'https://api.twitter.com/1.1/account/verify_credentials.json'.
		
	response := (self oauth1Service httpGet: url using: self accessToken) asString.
	json := NeoJSONReader fromString: response.
	
	^json

]

{ #category : 'twitter-api' }
ZnOAuth1TwitterUserAccess >> getFriendsTimeline [

	| url response json |

	url := ZnUrl fromString: 'http://api.twitter.com/1/statuses/friends_timeline.json'.
		
	response := (self oauth1Service httpGet: url using: self accessToken) asString.
	json := NeoJSONReader fromString: response.
	
	^json

]

{ #category : 'twitter-api' }
ZnOAuth1TwitterUserAccess >> statusesUpdate: aString [
	"https://dev.twitter.com/docs/api/1.1/post/statuses/update"

	| request response json |

	request := ZnRequest post: 'https://api.twitter.com/1.1/statuses/update.json'.
	request entity: (ZnApplicationFormUrlEncodedEntity new
		at: 'status' put: aString ;
		yourself).
		
	response := self oauth1Service executeRequest: request token: self accessToken.
	response isSuccess 
		ifFalse: [ self error: 'Post failed: ', response contents printString ].

	json := NeoJSONReader fromString: response contents.
	
	^json

]
