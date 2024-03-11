"
A ZnOpenIDAssociationResponse represents a Association Session Response message. This message is the respone to a association session request message.
"
Class {
	#name : 'ZnOpenIDAssociationResponse',
	#superclass : 'ZnSSOMessage',
	#category : 'Zinc-SSO-OpenID-Core',
	#package : 'Zinc-SSO-OpenID-Core'
}

{ #category : 'accessing-openid' }
ZnOpenIDAssociationResponse >> assocHandle [
	^self propertyAt: 'assoc_handle'
]

{ #category : 'accessing-openid' }
ZnOpenIDAssociationResponse >> assocType [
	^self propertyAt: 'assoc_type'
]

{ #category : 'accessing-openid' }
ZnOpenIDAssociationResponse >> expiresIn [
	^self propertyAt: 'expires_in'
]

{ #category : 'testing' }
ZnOpenIDAssociationResponse >> isHmacSHA1 [

	^self assocType = self class assocTypeHmacSHA1
]

{ #category : 'accessing-openid' }
ZnOpenIDAssociationResponse >> macKey [
	^self propertyAt: 'mac_key'
]

{ #category : 'accessing-openid' }
ZnOpenIDAssociationResponse >> sessionType [
	^self propertyAt: 'session_type'
]

{ #category : 'actions' }
ZnOpenIDAssociationResponse >> sign: aString andCheck: aSignature [
	"Answer whether the calculated signature for ==aString== is equal to ==aSignature==."

	| calculatedSig checkSignature key |

	self isHmacSHA1 
		ifFalse: [ self error: 'Cannot sign, unknown assoc_type' ].

	key := ZnBase64Encoder new decode: self macKey.
	calculatedSig := self class signStringSHA1: aString usingSecret: key.
	checkSignature := aSignature collect: [ :ch | ch = Character space ifTrue: [ $+ ] ifFalse: [ ch ]].
	^calculatedSig = checkSignature 
	

]
