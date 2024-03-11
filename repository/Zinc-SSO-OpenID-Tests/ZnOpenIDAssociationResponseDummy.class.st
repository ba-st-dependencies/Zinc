Class {
	#name : 'ZnOpenIDAssociationResponseDummy',
	#superclass : 'ZnOpenIDAssociationResponse',
	#instVars : [
		'signatureCheck'
	],
	#category : 'Zinc-SSO-OpenID-Tests',
	#package : 'Zinc-SSO-OpenID-Tests'
}

{ #category : 'actions' }
ZnOpenIDAssociationResponseDummy >> doNotCheckSignature [
	signatureCheck := false.
]

{ #category : 'initialize-release' }
ZnOpenIDAssociationResponseDummy >> initialize [
	super initialize.
	signatureCheck := true
]

{ #category : 'actions' }
ZnOpenIDAssociationResponseDummy >> shouldCheckSignature [
	^ signatureCheck
]

{ #category : 'actions' }
ZnOpenIDAssociationResponseDummy >> sign: aString andCheck: aSignature [
	^ self shouldCheckSignature
		ifTrue: [ super sign: aString andCheck: aSignature ]
		ifFalse: [ true ]
]
