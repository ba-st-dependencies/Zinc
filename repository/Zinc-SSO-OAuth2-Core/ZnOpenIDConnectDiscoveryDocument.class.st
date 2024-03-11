"
A ZnOpenIDConnectDiscoveryDocument is an object that contains discovered information about an OpenID Connect Provider.
"
Class {
	#name : 'ZnOpenIDConnectDiscoveryDocument',
	#superclass : 'Object',
	#instVars : [
		'json'
	],
	#category : 'Zinc-SSO-OAuth2-Core',
	#package : 'Zinc-SSO-OAuth2-Core'
}

{ #category : 'instance creation' }
ZnOpenIDConnectDiscoveryDocument class >> fromUrl: anUrl [

	^self new initializeWith: (
		ZnUtils defaultJSONReader fromString: (
			ZnClient new
				accept: ZnMimeType applicationJson ;
				get: anUrl))
]

{ #category : 'resources' }
ZnOpenIDConnectDiscoveryDocument class >> google [

	^self fromUrl: self googleUrl 
]

{ #category : 'resources' }
ZnOpenIDConnectDiscoveryDocument class >> googleUrl [

	^'https://accounts.google.com/.well-known/openid-configuration'
]

{ #category : 'accessing' }
ZnOpenIDConnectDiscoveryDocument >> authorizationEndpoint [

	^json at: 'authorization_endpoint'
]

{ #category : 'initialize-release' }
ZnOpenIDConnectDiscoveryDocument >> initializeWith: aJsonDictionary [

	json := aJsonDictionary
]

{ #category : 'accessing' }
ZnOpenIDConnectDiscoveryDocument >> issuer [

	^json at: 'issuer'
]

{ #category : 'accessing' }
ZnOpenIDConnectDiscoveryDocument >> tokenEndpoint [

	^json at: 'token_endpoint'
]

{ #category : 'accessing' }
ZnOpenIDConnectDiscoveryDocument >> userinfoEndpoint [

	^json at: 'userinfo_endpoint'
]
