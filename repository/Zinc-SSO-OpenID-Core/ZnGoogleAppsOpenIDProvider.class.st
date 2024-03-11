"
A ZnGoogleAppsOpenIDProvider is a specialized OpenIDProvider for use with Google Apps.

Instance Variables
	domain:		<String>

domain
	- Google Apps domain name

"
Class {
	#name : 'ZnGoogleAppsOpenIDProvider',
	#superclass : 'ZnOpenIDProvider',
	#instVars : [
		'domain'
	],
	#category : 'Zinc-SSO-OpenID-Core',
	#package : 'Zinc-SSO-OpenID-Core'
}

{ #category : 'instance creation' }
ZnGoogleAppsOpenIDProvider class >> forDomain: aString [

	^ self new setDomain: aString
]

{ #category : 'accessing' }
ZnGoogleAppsOpenIDProvider >> domain [
	^ domain
]

{ #category : 'testing' }
ZnGoogleAppsOpenIDProvider >> isGoogleAppsProvider [
	^true
]

{ #category : 'printing' }
ZnGoogleAppsOpenIDProvider >> printOn: stream [

	super printOn: stream.
	stream
		nextPutAll: '-' ;
		print: self domain
]

{ #category : 'initialize-release' }
ZnGoogleAppsOpenIDProvider >> setDomain: aString [

	| url response |
	
	domain := aString.
	
	"Getting the eindpoint for a Google Apps hosted domains works a little bit different. 
	See https://developers.google.com/google-apps/sso/openid_reference_implementation"

	url := 'https://www.google.com/accounts/o8/.well-known/host-meta?hd=', domain.
	response := self httpClient
		url: url ;
		get ;
		response.
	response isSuccess
		ifFalse: [ ZnOpenIDNoSuchDomain signal: domain ].
		
	discoveryUrl := response contents asString readStream 
		upTo: $< ;
		upTo: $>
]
