Class {
	#name : 'ZnOAuth1GoogleUserAccess',
	#superclass : 'ZnOAuth1UserAccess',
	#category : 'Zinc-SSO-OAuth1-Core',
	#package : 'Zinc-SSO-OAuth1-Core'
}

{ #category : 'api' }
ZnOAuth1GoogleUserAccess >> getContacts [

	| url result |
	
	url := ZnUrl fromString: 'https://www.google.com/m8/feeds/contacts/default/full'.
	result := self oauth1Service httpGet: url using: self accessToken.
	
	^result asString
]
