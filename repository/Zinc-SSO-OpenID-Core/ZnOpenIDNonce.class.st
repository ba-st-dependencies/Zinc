"
I hold a parsed OpenID Nonce:

A string 255 characters or less in length, that MUST be unique to a successful authentication response. The nonce MUST start with the current time on the server, and MAY contain additional ASCII characters in the range 33-126 inclusive (printable non-whitespace characters), as necessary to make each response unique. The date and time MUST be formatted as specified in section 5.6 of [RFC3339], with the following restrictions:

All times must be in the UTC timezone, indicated with a ""Z"".
No fractional seconds are allowed
For example: 2005-05-15T17:11:51ZUNIQUE

"
Class {
	#name : 'ZnOpenIDNonce',
	#superclass : 'Magnitude',
	#instVars : [
		'timestamp',
		'distinctor'
	],
	#category : 'Zinc-SSO-OpenID-Core',
	#package : 'Zinc-SSO-OpenID-Core'
}

{ #category : 'utility' }
ZnOpenIDNonce class >> decodeRFC3339Date: aString [

	| stream date time |
	
	stream := aString readStream.
	date := Date readFrom: stream.
	(stream next asUppercase = $T and: [ aString last asUppercase = $Z ])
		ifFalse: [ self error: 'Invalid dateTime format' ].
	time := Time readFrom: stream.

	^ DateAndTime year: date year day: date dayOfYear hour: time hour minute: time minute second: time second offset: Duration zero
]

{ #category : 'utility' }
ZnOpenIDNonce class >> encodeRFC3339Date: aDateAndTime [

	| dt |
	
	dt := aDateAndTime asUTC.

	^ String streamContents: [ :stream |
		dt printYMDOn: stream.
		stream nextPut: $T.
		dt printHMSOn: stream.
		stream nextPut: $Z ]
]

{ #category : 'instance creation' }
ZnOpenIDNonce class >> fromString: aByteString [

	^ self new
		parseString: aByteString;
		yourself
]

{ #category : 'comparing' }
ZnOpenIDNonce >> < aOpenIDNonce [
	self timestamp < aOpenIDNonce timestamp
		ifTrue: [ ^ true ].
	self timestamp > aOpenIDNonce timestamp
		ifTrue: [ ^ false ].
	self distinctor = aOpenIDNonce distinctor
		ifTrue: [ ^ false ].
	self distinctor ifNil: [ ^ true ].
	aOpenIDNonce timestamp ifNil: [ ^ false ].
	^ self distinctor < aOpenIDNonce distinctor
]

{ #category : 'comparing' }
ZnOpenIDNonce >> = aOpenIDNonce [
	^self timestamp = aOpenIDNonce timestamp and: [ self distinctor = aOpenIDNonce distinctor ]
]

{ #category : 'resources' }
ZnOpenIDNonce >> dateAndTimeNow [

	^ DateAndTime now
]

{ #category : 'accessing' }
ZnOpenIDNonce >> distinctor [
	^ distinctor
]

{ #category : 'accessing' }
ZnOpenIDNonce >> distinctor: anObject [
	distinctor := anObject
]

{ #category : 'comparing' }
ZnOpenIDNonce >> hash [
	^ self timestamp hash << 32 + self distinctor hash
]

{ #category : 'initialize-release' }
ZnOpenIDNonce >> initialize [

	super initialize.
	timestamp := self dateAndTimeNow 
]

{ #category : 'testing' }
ZnOpenIDNonce >> isOld [
	^ self dateAndTimeNow - self timestamp > ZnOpenIDNonceLocker acceptedTimeFrame
]

{ #category : 'accessing' }
ZnOpenIDNonce >> parseString: aByteString [
	"Parses nonce that is format YYYY-MM-DD'T'HH:mm:SS'Z'Distinctor for example
	2011-11-23T11:48:19Z
	2011-11-23T11:48:19Zasdas123123
	
	"

	| timestampPart |
	
	[ 
	timestampPart := aByteString copyFrom: 1 to: 20.
	aByteString size > 22
		ifTrue: [ self distinctor: (aByteString allButFirst: 20). ].
	self timestamp: (self class decodeRFC3339Date: timestampPart) ]
		on: Error
		do: [ ZnOpenIDNonceInvalidError signal: aByteString ]
]

{ #category : 'printing' }
ZnOpenIDNonce >> printOn: aStream [

	aStream nextPutAll: (self class encodeRFC3339Date: self timestamp).
	self distinctor isNil ifFalse: [ aStream nextPutAll: self distinctor ]
]

{ #category : 'accessing' }
ZnOpenIDNonce >> timestamp [
	^ timestamp
]

{ #category : 'accessing' }
ZnOpenIDNonce >> timestamp: anObject [
	timestamp := anObject
]
