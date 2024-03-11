Class {
	#name : 'ZnOpenIDNonceDummy',
	#superclass : 'ZnOpenIDNonce',
	#instVars : [
		'isOld',
		'callCountOfIsOld'
	],
	#category : 'Zinc-SSO-OpenID-Tests',
	#package : 'Zinc-SSO-OpenID-Tests'
}

{ #category : 'accessing' }
ZnOpenIDNonceDummy >> callCountOfIsOld [
	^ callCountOfIsOld
]

{ #category : 'initialize-release' }
ZnOpenIDNonceDummy >> initialize [
	super initialize.
	callCountOfIsOld := 0.
	isOld := false.
]

{ #category : 'testing' }
ZnOpenIDNonceDummy >> isOld [
	callCountOfIsOld := callCountOfIsOld + 1.
	^ isOld.
]

{ #category : 'accessing' }
ZnOpenIDNonceDummy >> makeOld [
	isOld := true.
]
