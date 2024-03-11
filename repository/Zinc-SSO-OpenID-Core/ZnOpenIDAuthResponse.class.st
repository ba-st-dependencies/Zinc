Class {
	#name : 'ZnOpenIDAuthResponse',
	#superclass : 'ZnSSOMessage',
	#category : 'Zinc-SSO-OpenID-Core',
	#package : 'Zinc-SSO-OpenID-Core'
}

{ #category : 'constants' }
ZnOpenIDAuthResponse class >> propertyPrefix [

	^ 'openid'
]

{ #category : 'accessing attribute exchange' }
ZnOpenIDAuthResponse >> axPropertyAt: aString ifAbsent: aBlock [

	| prefix |
	
	prefix := self prefixForNamespace: self class nsAttributeExchangeExtension ifAbsent: [ ^aBlock value ].
	^self propertyAt: ('openid.', prefix, '.', aString) ifAbsent: aBlock
	
]

{ #category : 'accessing attribute exchange' }
ZnOpenIDAuthResponse >> axValueCountry [
	^self axPropertyAt: 'value.country' ifAbsent: [ nil ]
	
]

{ #category : 'accessing attribute exchange' }
ZnOpenIDAuthResponse >> axValueEmail [
	^self axPropertyAt: 'value.email' ifAbsent: [ nil ]
	
]

{ #category : 'accessing attribute exchange' }
ZnOpenIDAuthResponse >> axValueFirstname [
	^self axPropertyAt: 'value.firstname' ifAbsent: [ nil ]
	
]

{ #category : 'accessing attribute exchange' }
ZnOpenIDAuthResponse >> axValueLanguage [
	^self axPropertyAt: 'value.language' ifAbsent: [ nil ]
	
]

{ #category : 'accessing attribute exchange' }
ZnOpenIDAuthResponse >> axValueLastname [
	^self axPropertyAt: 'value.lastname' ifAbsent: [ nil ]
	
]

{ #category : 'accessing openid' }
ZnOpenIDAuthResponse >> claimedId [
	^self propertyAt: 'openid.claimed_id'
]

{ #category : 'accessing openid' }
ZnOpenIDAuthResponse >> identity [
	^self propertyAt: 'openid.identity'
]

{ #category : 'testing' }
ZnOpenIDAuthResponse >> isSuccess [

	^self mode = 'id_res'
]

{ #category : 'accessing openid' }
ZnOpenIDAuthResponse >> mode [
	^self propertyAt: 'openid.mode'
]

{ #category : 'accessing oauth' }
ZnOpenIDAuthResponse >> oAuthPropertyAt: aString ifAbsent: aBlock [

	| prefix |
	
	prefix := self prefixForNamespace: self class nsOAuth ifAbsent: [ ^aBlock value ].
	^self propertyAt: ('openid.', prefix, '.', aString) ifAbsent: aBlock
	
]

{ #category : 'accessing oauth' }
ZnOpenIDAuthResponse >> oAuthRequestToken [
	^self oAuthPropertyAt: 'request_token' ifAbsent: [ nil ]
]

{ #category : 'accessing oauth' }
ZnOpenIDAuthResponse >> oAuthScope [
	^self oAuthPropertyAt: 'scope' ifAbsent: [ nil ]
]

{ #category : 'accessing openid' }
ZnOpenIDAuthResponse >> opEndpoint [
	^self propertyAt: 'openid.op_endpoint'
]

{ #category : 'accessing openid' }
ZnOpenIDAuthResponse >> responseNonce [
	^self propertyAt: 'openid.response_nonce'
]

{ #category : 'accessing openid' }
ZnOpenIDAuthResponse >> sig [
	^self propertyAt: 'openid.sig'
]

{ #category : 'accessing openid' }
ZnOpenIDAuthResponse >> signed [
	^self propertyAt: 'openid.signed'
]

{ #category : 'accessing openid' }
ZnOpenIDAuthResponse >> signedText [
	"Return the text on which the signature is applied."

	| signedParams text param |
	
	signedParams := self signed readStream.
	text := WriteStream on: String new.
	[ signedParams atEnd ] whileFalse: [
		param := signedParams upTo: $,.
		text 
			nextPutAll: param; 
			nextPut: $:; 
			nextPutAll: (self propertyAt: 'openid.', param);
			nextPut: Character lf].
	^text contents

]
