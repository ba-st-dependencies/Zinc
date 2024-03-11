Class {
	#name : 'ZnSSOMessage',
	#superclass : 'Object',
	#instVars : [
		'properties'
	],
	#category : 'Zinc-SSO-OpenID-Core',
	#package : 'Zinc-SSO-OpenID-Core'
}

{ #category : 'constants' }
ZnSSOMessage class >> assocTypeHmacSHA1 [
	"OpenID2 association type"
	
	^'HMAC-SHA1'
]

{ #category : 'instance creation' }
ZnSSOMessage class >> newFromDictionary: aDictionary [

	| instance |
	
	instance := self new.
	aDictionary keysAndValuesDo: [ :key :value | 
		(self propertyPrefix = '' or: [ key beginsWith: self propertyPrefix ])
			ifTrue: [ instance propertyAt: key put: value ] ].
	^ instance
]

{ #category : 'instance creation' }
ZnSSOMessage class >> newFromKeyValueForm: aString [

	| eolChar msg stream |
	
	eolChar := (aString includes: Character lf)
		ifTrue: [ Character lf ]
		ifFalse: [ Character cr ].
	
	msg := self new.
	stream := ReadStream on: aString.
	[ stream atEnd ] whileFalse: [
		msg propertyAt: (stream upTo: $:) put: (stream upTo: eolChar)].
	^msg
]

{ #category : 'instance creation' }
ZnSSOMessage class >> newFromUrl: anUrl [

	| instance |
	
	instance := self new.
	anUrl asZnUrl queryDo: [ :key :value | instance propertyAt: key put: value ].
	^ instance
]

{ #category : 'constants' }
ZnSSOMessage class >> nsAttributeExchangeExtension [
	"Answer the namespace"

	^'http://openid.net/srv/ax/1.0'
]

{ #category : 'constants' }
ZnSSOMessage class >> nsOAuth [
	"Answer the namespace"

	^'http://specs.openid.net/extensions/oauth/1.0'
]

{ #category : 'constants' }
ZnSSOMessage class >> nsOpenId2 [
	"Answer the namespace"

	^'http://specs.openid.net/auth/2.0'
]

{ #category : 'constants' }
ZnSSOMessage class >> nsPape [
	"Answer the namespace"

	^'http://specs.openid.net/extensions/pape/1.0'
]

{ #category : 'constants' }
ZnSSOMessage class >> propertyPrefix [

	^ ''
]

{ #category : 'utility' }
ZnSSOMessage class >> signStringSHA1: aString usingSecret: aSecret [ 
	"Signs a string with <aSecret>, and encode the
	resulting byteArray into plain ASCII with base64."
	
	| hmac digest |

	hmac := SHA1 new hmac.
	hmac key: aSecret asByteArray.
	digest := hmac digestMessage: aString asByteArray.
	^ZnBase64Encoder new encode: digest
]

{ #category : 'actions' }
ZnSSOMessage >> addToUrl: anUrl [
	"Add the receivers properties as parameters to ==anUrl==."
	
	self properties keysAndValuesDo: [ :key :value | anUrl queryAt: key put: value ]
]

{ #category : 'private' }
ZnSSOMessage >> errorPropertyNotFound: aSelector [ 
	self error: 'Property ' , aSelector , ' not found.'
]

{ #category : 'initialize-release' }
ZnSSOMessage >> initialize [

	super initialize.
	properties := Dictionary new
]

{ #category : 'accessing' }
ZnSSOMessage >> prefixForNamespace: aNamespace ifAbsent: aBlock [

	| begin |
	
	begin := 'openid.ns.'.
	self properties keysAndValuesDo: [ :key :value |
		(aNamespace = value and: [ (key copyFrom: 1 to: begin size) = begin ])
			ifTrue: [ ^key copyFrom: begin size + 1 to: key size ]].
	^aBlock value
]

{ #category : 'accessing' }
ZnSSOMessage >> properties [
	"Answer the property dictionary of the receiver."

	^properties
]

{ #category : 'accessing' }
ZnSSOMessage >> propertyAt: aKey [
	"Answer the value of the property ==aKey==, raises an error if the property doesn't exist."

	^ self propertyAt: aKey ifAbsent: [ self errorPropertyNotFound: aKey ]
]

{ #category : 'accessing' }
ZnSSOMessage >> propertyAt: aKey ifAbsent: aBlock [
	"Answer the value of the property ==aKey==, or the result of ==aBlock== if the property doesn't exist."

	^ self properties at: aKey ifAbsent: aBlock
]

{ #category : 'accessing' }
ZnSSOMessage >> propertyAt: aKey ifAbsentPut: aBlock [
	"Answer the value of the property ==aKey==, or if the property doesn't exist adds and answers the result of evaluating ==aBlock==."

	^ self properties at: aKey ifAbsentPut: aBlock
]

{ #category : 'accessing' }
ZnSSOMessage >> propertyAt: aKey ifPresent: aBlock [
	"Lookup the property ==aKey==, if it is present, answer the value of evaluating ==aBlock== block with the value. Otherwise, answer ==nil==."

	^ self properties at: aKey ifPresent: aBlock
]

{ #category : 'accessing' }
ZnSSOMessage >> propertyAt: aKey put: aValue [
	"Adds or replaces the property ==aKey== with ==aValue==."

	^ self properties at: aKey put: aValue
]

{ #category : 'accessing' }
ZnSSOMessage >> removePropertyAt: aKey [

	^ self properties removeKey: aKey ifAbsent: [ ]
]
