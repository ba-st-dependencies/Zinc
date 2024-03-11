Class {
	#name : 'ZnOpenIDAuthRequest',
	#superclass : 'ZnSSOMessage',
	#category : 'Zinc-SSO-OpenID-Core',
	#package : 'Zinc-SSO-OpenID-Core'
}

{ #category : 'constants' }
ZnOpenIDAuthRequest class >> modeImmediate [
	^'checkid_immediate'
]

{ #category : 'constants' }
ZnOpenIDAuthRequest class >> modeSetup [
	^'checkid_setup'
]

{ #category : 'constants' }
ZnOpenIDAuthRequest class >> selectId [
	^'http://specs.openid.net/auth/2.0/identifier_select'
]

{ #category : 'accessing' }
ZnOpenIDAuthRequest >> assocHandle [

	^self propertyAt: 'openid.assoc_handle'
]

{ #category : 'accessing' }
ZnOpenIDAuthRequest >> assocHandle: aString [

	self propertyAt: 'openid.assoc_handle' put: aString
]

{ #category : 'accessing attribute exchange' }
ZnOpenIDAuthRequest >> axMode: aString [

	self propertyAt: 'openid.ax.mode' put: aString
]

{ #category : 'accessing attribute exchange' }
ZnOpenIDAuthRequest >> axRequestCountry [

	self
		nsAx: self class nsAttributeExchangeExtension;
		axMode: 'fetch_request';
		axTypeCountry: 'http://axschema.org/contact/country/home';
		axRequired: (self axRequired isNil
			ifTrue: [ '' ]
			ifFalse: [ self axRequired, ',']), 'country'
]

{ #category : 'accessing attribute exchange' }
ZnOpenIDAuthRequest >> axRequestEmail [

	self
		nsAx: self class nsAttributeExchangeExtension;
		axMode: 'fetch_request';
		axTypeEmail: 'http://axschema.org/contact/email';
		axRequired: (self axRequired isNil
			ifTrue: [ '' ]
			ifFalse: [ self axRequired, ',']), 'email'
]

{ #category : 'accessing attribute exchange' }
ZnOpenIDAuthRequest >> axRequestLanguage [

	self
		nsAx: self class nsAttributeExchangeExtension;
		axMode: 'fetch_request';
		axTypeLanguage: 'http://axschema.org/pref/language';
		axRequired: (self axRequired isNil
			ifTrue: [ '' ]
			ifFalse: [ self axRequired, ',']), 'language'
]

{ #category : 'accessing attribute exchange' }
ZnOpenIDAuthRequest >> axRequestNames [

	self
		nsAx: self class nsAttributeExchangeExtension;
		axMode: 'fetch_request';
		axTypeFirstname: 'http://axschema.org/namePerson/first';
		axTypeLastname: 'http://axschema.org/namePerson/last';
		axRequired: (self axRequired isNil
			ifTrue: [ '' ]
			ifFalse: [ self axRequired, ',']), 'firstname,lastname'
]

{ #category : 'accessing attribute exchange' }
ZnOpenIDAuthRequest >> axRequestNamesAndEmail [

	self
		axRequestNames;
		axRequestEmail 
]

{ #category : 'accessing attribute exchange' }
ZnOpenIDAuthRequest >> axRequired [

	^self propertyAt: 'openid.ax.required' ifAbsent: [ nil ]
]

{ #category : 'accessing attribute exchange' }
ZnOpenIDAuthRequest >> axRequired: aString [

	self propertyAt: 'openid.ax.required' put: aString
]

{ #category : 'accessing attribute exchange' }
ZnOpenIDAuthRequest >> axTypeCountry: aString [

	self propertyAt: 'openid.ax.type.country' put: aString
]

{ #category : 'accessing attribute exchange' }
ZnOpenIDAuthRequest >> axTypeEmail: aString [

	self propertyAt: 'openid.ax.type.email' put: aString
]

{ #category : 'accessing attribute exchange' }
ZnOpenIDAuthRequest >> axTypeFirstname: aString [

	self propertyAt: 'openid.ax.type.firstname' put: aString
]

{ #category : 'accessing attribute exchange' }
ZnOpenIDAuthRequest >> axTypeLanguage: aString [

	self propertyAt: 'openid.ax.type.language' put: aString
]

{ #category : 'accessing attribute exchange' }
ZnOpenIDAuthRequest >> axTypeLastname: aString [

	self propertyAt: 'openid.ax.type.lastname' put: aString
]

{ #category : 'accessing' }
ZnOpenIDAuthRequest >> claimedId [

	^self propertyAt: 'openid.claimed_id'
]

{ #category : 'accessing' }
ZnOpenIDAuthRequest >> claimedId: aString [

	self propertyAt: 'openid.claimed_id' put: aString
]

{ #category : 'accessing' }
ZnOpenIDAuthRequest >> identity [

	^self propertyAt: 'openid.identity'
]

{ #category : 'accessing' }
ZnOpenIDAuthRequest >> identity: aString [

	self propertyAt: 'openid.identity' put: aString
]

{ #category : 'initialize-release' }
ZnOpenIDAuthRequest >> initialize [

	super initialize.
	
	self 
		ns: self class nsOpenId2;
		claimedId: self class selectId;
		identity: self class selectId
]

{ #category : 'accessing' }
ZnOpenIDAuthRequest >> mode [

	^self propertyAt: 'openid.mode'
]

{ #category : 'accessing' }
ZnOpenIDAuthRequest >> mode: aString [

	self propertyAt: 'openid.mode' put: aString
]

{ #category : 'accessing' }
ZnOpenIDAuthRequest >> modeCheckidSetup [
	self mode: self class modeSetup 
]

{ #category : 'accessing openid' }
ZnOpenIDAuthRequest >> ns [

	^self propertyAt: 'openid.ns'
]

{ #category : 'accessing openid' }
ZnOpenIDAuthRequest >> ns: aString [

	self propertyAt: 'openid.ns' put: aString
]

{ #category : 'accessing attribute exchange' }
ZnOpenIDAuthRequest >> nsAx: aString [

	self propertyAt: 'openid.ns.ax' put: aString
]

{ #category : 'accessing oauth' }
ZnOpenIDAuthRequest >> nsOAuth: aString [

	self propertyAt: 'openid.ns.oauth' put: aString
]

{ #category : 'accessing pape' }
ZnOpenIDAuthRequest >> nsPape [

	^self propertyAt: 'openid.ns.pape'
]

{ #category : 'accessing pape' }
ZnOpenIDAuthRequest >> nsPape: aString [

	self propertyAt: 'openid.ns.pape' put: aString
]

{ #category : 'accessing oauth' }
ZnOpenIDAuthRequest >> oAuthConsumer: aString [

	self nsOAuth: self class nsOAuth.
	self propertyAt: 'openid.oauth.consumer' put: aString
]

{ #category : 'accessing oauth' }
ZnOpenIDAuthRequest >> oAuthScope: aString [

	self nsOAuth: self class nsOAuth.
	self propertyAt: 'openid.oauth.scope' put: aString
]

{ #category : 'accessing pape' }
ZnOpenIDAuthRequest >> papeMaxAuthAge [
	^self propertyAt: 'openid.pape.max_auth_age'
]

{ #category : 'accessing pape' }
ZnOpenIDAuthRequest >> papeMaxAuthAge: anInteger [
	"Sets the maximum acceptable time (in seconds) since the user last authenticated. 
	If the session is older, the user will be prompted to log in again. Setting the value
	to zero will force a password reprompt regardless of session age."

	self nsPape: self class nsPape.
	self propertyAt: 'openid.pape.max_auth_age' put: anInteger
]

{ #category : 'accessing' }
ZnOpenIDAuthRequest >> realm [

	^self propertyAt: 'openid.realm'
]

{ #category : 'accessing' }
ZnOpenIDAuthRequest >> realm: aString [

	self propertyAt: 'openid.realm' put: aString
]

{ #category : 'accessing' }
ZnOpenIDAuthRequest >> returnTo [

	^self propertyAt: 'openid.return_to'
]

{ #category : 'accessing' }
ZnOpenIDAuthRequest >> returnTo: aString [

	self propertyAt: 'openid.return_to' put: aString
]
