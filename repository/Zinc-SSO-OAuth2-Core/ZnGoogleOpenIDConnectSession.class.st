"
A ZnGoogleOpenIDConnectSession is used to support Google specific extensions of the OpenID Connect standard.

See https://developers.google.com/accounts/docs/OAuth2Login

"
Class {
	#name : 'ZnGoogleOpenIDConnectSession',
	#superclass : 'ZnOpenIDConnectSession',
	#category : 'Zinc-SSO-OAuth2-Core',
	#package : 'Zinc-SSO-OAuth2-Core'
}

{ #category : 'instance creation' }
ZnGoogleOpenIDConnectSession class >> withConsumerData: aConsumerData [

	^self new
		initializeWith: ZnOpenIDConnectDiscoveryDocument google consumerData: aConsumerData 
]

{ #category : 'accessing authentication parameters' }
ZnGoogleOpenIDConnectSession >> accessType [

	^self extraAuthenticationParameterAt: 'access_type'
]

{ #category : 'accessing authentication parameters' }
ZnGoogleOpenIDConnectSession >> accessType: aString [

	self extraAuthenticationParameterAt: 'access_type' put: aString
]

{ #category : 'accessing authentication parameters' }
ZnGoogleOpenIDConnectSession >> beOfflineAccessType [

	self accessType: 'offline'
]

{ #category : 'accessing authentication parameters' }
ZnGoogleOpenIDConnectSession >> beOnlineAccessType [

	self accessType: 'online'
]

{ #category : 'accessing authentication parameters' }
ZnGoogleOpenIDConnectSession >> hostedDomain [

	^self extraAuthenticationParameterAt: 'hd'
]

{ #category : 'accessing authentication parameters' }
ZnGoogleOpenIDConnectSession >> hostedDomain: aString [

	self extraAuthenticationParameterAt: 'hd' put: aString.
]

{ #category : 'accessing authentication parameters' }
ZnGoogleOpenIDConnectSession >> loginHint [

	^self extraAuthenticationParameterAt: 'login_hint'
]

{ #category : 'accessing authentication parameters' }
ZnGoogleOpenIDConnectSession >> loginHint: aString [

	self extraAuthenticationParameterAt: 'login_hint' put: aString.
]

{ #category : 'private' }
ZnGoogleOpenIDConnectSession >> validateIdToken: aString [
	"TO DO!"
	
"From Google: https://developers.google.com/accounts/docs/OAuth2Login#obtainuserinfo

An ID token is a cryptographically signed JSON object encoded in base 64. Normally, it is critical that you validate an ID token before you use it, but since you are communicating directly with Google over an intermediary-free HTTPS channel and using your client secret to authenticate yourself to Google, you can be confident that the token you receive really comes from Google and is valid. If your server passes the ID token to other components of your app, it is extremely important that the other components validate the token before using it."
]
