Class {
	#name : 'ZnOpenIDSingleSignOn',
	#superclass : 'Object',
	#instVars : [
		'providers',
		'providerSessions'
	],
	#classVars : [
		'Default'
	],
	#category : 'Zinc-SSO-OpenID-Core',
	#package : 'Zinc-SSO-OpenID-Core'
}

{ #category : 'class initialization' }
ZnOpenIDSingleSignOn class >> clear [

	Default := nil
]

{ #category : 'accessing' }
ZnOpenIDSingleSignOn class >> default [

	^Default ifNil: [ 
		Default := self new
			addProviders: self defaultProviders ;
			yourself ]
]

{ #category : 'accessing' }
ZnOpenIDSingleSignOn class >> default: anInstance [

	Default := anInstance
]

{ #category : 'resources' }
ZnOpenIDSingleSignOn class >> defaultProviders [

	^ OrderedCollection new
		add: ZnOpenIDProvider newGoogleProvider ;
		add: ZnOpenIDProvider newMyOpenIDProvider ;
		add: ZnOpenIDProvider newYahooProvider ;
		add: ZnOpenIDProvider newHyvesProvider ;
		yourself
]

{ #category : 'resources' }
ZnOpenIDSingleSignOn class >> providerNameGoogle [
	^'Google'
]

{ #category : 'resources' }
ZnOpenIDSingleSignOn class >> providerNameHyves [
	^'Hyves'
]

{ #category : 'resources' }
ZnOpenIDSingleSignOn class >> providerNameMyOpenID [
	^'myOpenID'
]

{ #category : 'resources' }
ZnOpenIDSingleSignOn class >> providerNameYahoo [
	^'Yahoo'
]

{ #category : 'class initialization' }
ZnOpenIDSingleSignOn class >> unload [

	self clear
]

{ #category : 'adding' }
ZnOpenIDSingleSignOn >> addProvider: aProvider [

	^ self providers add: aProvider
]

{ #category : 'adding' }
ZnOpenIDSingleSignOn >> addProviders: aProviderCollection [

	^ self providers addAll: aProviderCollection
]

{ #category : 'convenience' }
ZnOpenIDSingleSignOn >> googleProvider [

	^self providers detect: [ :each | each name = self class providerNameGoogle ]
]

{ #category : 'convenience' }
ZnOpenIDSingleSignOn >> googleSession [

	^self sessionForProviderNamed: self class providerNameGoogle
]

{ #category : 'convenience' }
ZnOpenIDSingleSignOn >> hyvesSession [

	^self sessionForProviderNamed: self class providerNameHyves
]

{ #category : 'initialize-release' }
ZnOpenIDSingleSignOn >> initialize [

	super initialize.
	providers := OrderedCollection new.
	providerSessions := OrderedCollection new
]

{ #category : 'convenience' }
ZnOpenIDSingleSignOn >> myOpenIDProvider [

	^self providers detect: [ :each | each name = self class providerNameMyOpenID ]
]

{ #category : 'accessing' }
ZnOpenIDSingleSignOn >> providerSessions [
	^providerSessions
]

{ #category : 'accessing' }
ZnOpenIDSingleSignOn >> providers [
	^providers
]

{ #category : 'convenience' }
ZnOpenIDSingleSignOn >> sessionForGoogleAppsDomain: aString [
	"Answer a OpenIDService object for the Google Apps domain."

	| provider |
	
	provider := self providers
		detect: [ :each | each isGoogleAppsProvider and: [ each domain = aString ] ]
		ifNone: [
			self providers add: ((ZnGoogleAppsOpenIDProvider forDomain: aString)
				name: self class providerNameGoogle;
				imgUrl: 'http://openid.net/images/get-logos/google.png';
				altText: 'Login with your Google Apps account';
				yourself ) ].
	^self sessionForProvider: provider
]

{ #category : 'accessing' }
ZnOpenIDSingleSignOn >> sessionForProvider: aProvider [

	^self providerSessions
		detect: [ :each | each provider = aProvider ]
		ifNone: [ self providerSessions add: aProvider createSession ]
]

{ #category : 'accessing' }
ZnOpenIDSingleSignOn >> sessionForProviderNamed: aString [

	| provider |
	
	provider := self providers detect: [ :each | each name = aString ].
	^self sessionForProvider: provider
]

{ #category : 'convenience' }
ZnOpenIDSingleSignOn >> yahooSession [

	^self sessionForProviderNamed: self class providerNameYahoo
]
