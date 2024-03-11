"
A ZnOpenIDAssociationRequest represents a Association Session Request message. This message is sent by the Relying Party to an OP Endpoint
"
Class {
	#name : 'ZnOpenIDAssociationRequest',
	#superclass : 'ZnSSOMessage',
	#category : 'Zinc-SSO-OpenID-Core',
	#package : 'Zinc-SSO-OpenID-Core'
}

{ #category : 'constants' }
ZnOpenIDAssociationRequest class >> modeAssociate [
	^'associate'
]

{ #category : 'instance creation' }
ZnOpenIDAssociationRequest class >> new [
	"Answer a new and initialized instance of the receiver."

	^super new
		sessionType: 'no-encryption';
		assocType: self assocTypeHmacSHA1;
		yourself

]

{ #category : 'accessing-openid' }
ZnOpenIDAssociationRequest >> assocType [
	^self propertyAt: 'openid.assoc_type'
]

{ #category : 'accessing-openid' }
ZnOpenIDAssociationRequest >> assocType: aString [
	self propertyAt: 'openid.assoc_type' put: aString
]

{ #category : 'initialize-release' }
ZnOpenIDAssociationRequest >> initialize [

	super initialize.
	self 
		ns: self class nsOpenId2;
		mode: self class modeAssociate
]

{ #category : 'accessing-openid' }
ZnOpenIDAssociationRequest >> mode [
	^self propertyAt: 'openid.mode'
]

{ #category : 'accessing-openid' }
ZnOpenIDAssociationRequest >> mode: aString [
	self propertyAt: 'openid.mode' put: aString
]

{ #category : 'accessing-openid' }
ZnOpenIDAssociationRequest >> ns [
	^self propertyAt: 'openid.ns'
]

{ #category : 'accessing-openid' }
ZnOpenIDAssociationRequest >> ns: aString [
	self propertyAt: 'openid.ns' put: aString
]

{ #category : 'accessing-openid' }
ZnOpenIDAssociationRequest >> sessionType [
	^self propertyAt: 'openid.session_type'
]

{ #category : 'accessing-openid' }
ZnOpenIDAssociationRequest >> sessionType: aString [
	self propertyAt: 'openid.session_type' put: aString
]
