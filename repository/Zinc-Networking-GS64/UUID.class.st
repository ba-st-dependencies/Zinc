"
I am UUID.
I am a ByteArray.

An RFC4122 Universally Unique Identifier (UUID) is an opaque 128-bit number that can be used for identification purposes. Concretely, a UUID is a 16 element byte array.

The intent of UUIDs is to enable distributed systems to uniquely identify information without significant central coordination. In this context the word unique should be taken to mean ""practically unique"" rather than ""guaranteed unique"".

Usage:

	UUID new.
	
Whenever you create a new UUID, the shared, default UUIDGenerator will be used to generate a new, unique UUID.

See UUIDGenerator for extensive documentation on how UUIDs are actually generated.

UUIDs have a standard string representation, like this:

	3ccb64f1-aa04-0d00-bbbc-259a0f871399
	
The representation consists of 32 lowercase hexadecimal digits, displayed in five groups separated by hyphens, in the form 8-4-4-4-12 for a total of 36 characters (32 alphanumeric characters and four hyphens).

My #printOn: #printString and #asString methods produce this representation.  My class' #fromString: or instance #readFrom: parse it.

Alternatively, my base 36 number representation is  the shortest representation still being able to work as filenames etc since it does not depend on case nor characters that might cause problems, and it is reasonably short.

See #asString36 and my class' #fromString36:

UUIDs are basically opaque (contain no interesting content) and should be treated as indivisable values. Do not use parts of them, since these will most probably no longer be unique.

See also:

  http://en.wikipedia.org/wiki/UUID
  https://tools.ietf.org/html/rfc4122
"
Class {
	#name : 'UUID',
	#superclass : 'ByteArray',
	#classVars : [
		'GeneratorClass'
	],
	#category : 'Zinc-Networking-GS64',
	#package : 'Zinc-Networking-GS64'
}

{ #category : 'instance creation' }
UUID class >> fromString: aString [
	"Read a UUID from aString with my official representation, 32 lowercase hexadecimal (base 16) digits, displayed in five groups separated by hyphens, in the form 8-4-4-4-12 for a total of 36 characters (32 alphanumeric characters and four hyphens)"

	| uuid |
	aString size ~= 36 ifTrue: [ self error: 'a UUID should be 36 characters' ].
	uuid := self nilUUID.
	uuid readFrom: aString readStream.
	^ uuid
]

{ #category : 'configuring' }
UUID class >> generatorClass [

	^ GeneratorClass
]

{ #category : 'configuring' }
UUID class >> generatorClass: aClass [

	GeneratorClass := aClass
]

{ #category : 'instance creation' }
UUID class >> new [
	"Create and return a new UUID"

	^ (self new: 16)
]

{ #category : 'instance creation' }
UUID class >> new: aSize [

	(aSize == 16) ifFalse: [ self error: 'Wrong UUID size' ].

	^ (super new: aSize) initialize
]

{ #category : 'instance creation' }
UUID class >> nilUUID [
	"Return a empty un-initialized UUID, with all zero values, 00000000-0000-0000-0000-000000000000"
	"Must call basicNew: here because I have a non-trivial initialize method."

	^ self basicNew: 16
]

{ #category : 'comparing' }
UUID >> < aMagnitude [
	"Answer whether the receiver is less than the argument."

	(self size = aMagnitude size) ifFalse: [
		^ self size < aMagnitude size ].
	1 to: self size do: [:i |
		(self at: i) = (aMagnitude at: i) ifFalse: [
			^ (self at: i) < (aMagnitude at: i) ]].
	^false
]

{ #category : 'comparing' }
UUID >> <= uuid [

	^ self = uuid or: [ self < uuid ]
]

{ #category : 'comparing' }
UUID >> > uuid [

	^ uuid < self
]

{ #category : 'comparing' }
UUID >> >= uuid [

	^ self = uuid or: [ uuid < self ]
]

{ #category : 'converting' }
UUID >> asString [

	^ self printString
]

{ #category : 'converting' }
UUID >> asString36 [
	"Return a String encoding the receiver as a base 36 number using 0-9 and lowercase a-z.
	This is the shortest representation still being able to work as
	filenames etc since it does not depend on case nor characters
	that might cause problems, and it is reasonably short."

	| num |
	num := 0.
	1 to: self size do: [ :i | num := num + ((256 raisedTo: i - 1) * (self at: i)) ].
	^ (num printStringRadix: 36) asLowercase
]

{ #category : 'initialization' }
UUID >> initialize [
	super initialize.
	self class generatorClass default placeFields: self
]

{ #category : 'testing' }
UUID >> isNilUUID [
	"Return true when I am equal to the nilUUID, 00000000-0000-0000-0000-000000000000, false otherwise"

	^ self allSatisfy: [ :each | each isZero ]
]

{ #category : 'printing' }
UUID >> printHexAt: index to: aStream [

	| map v |
	map := '0123456789abcdef'.
	v := self at: index.
	aStream nextPut: (map at: (v bitShift: -4) + 1).
	aStream nextPut: (map at: (v bitAnd: 15) + 1)
]

{ #category : 'printing' }
UUID >> printOn: aStream [
	"Print my official representation, 32 lowercase hexadecimal digits, displayed in five groups separated by hyphens, in the form 8-4-4-4-12 for a total of 36 characters (32 alphanumeric characters and four hyphens) on aStream"

	1 to: 4 do: [ :i | self printHexAt: i to: aStream ].
	aStream nextPut: $-.
	5 to: 6 do: [ :i | self printHexAt: i to: aStream ].
	aStream nextPut: $-.
	7 to: 8 do: [ :i | self printHexAt: i to: aStream ].
	aStream nextPut: $-.
	9 to: 10 do: [ :i | self printHexAt: i to: aStream ].
	aStream nextPut: $-.
	11 to: 16 do: [ :i | self printHexAt: i to: aStream ]
]

{ #category : 'printing' }
UUID >> printString [
	"Return a String with my official representation, 32 lowercase hexadecimal digits, displayed in five groups separated by hyphens, in the form 8-4-4-4-12 for a total of 36 characters (32 alphanumeric characters and four hyphens)"

	^ String
		new: 36
		streamContents: [ :stringStream | self printOn: stringStream ]
]

{ #category : 'initialization' }
UUID >> readFrom: aStream [
	"Read my official representation, 32 lowercase hexadecimal digits, displayed in five groups separated by hyphens, in the form 8-4-4-4-12 for a total of 36 characters (32 alphanumeric characters and four hyphens) from aStream"

	1 to: 4 do: [ :i | self at: i put: (Integer fromHexString: (aStream next:2)) ].
	aStream next = $- ifFalse: [ self error: '- separator expected' ].
	5 to: 6 do: [ :i | self at: i put: (Integer fromHexString: (aStream next:2)) ].
	aStream next = $- ifFalse: [ self error: '- separator expected' ].
	7 to: 8 do: [ :i | self at: i put: (Integer fromHexString: (aStream next:2)) ].
	aStream next = $- ifFalse: [ self error: '- separator expected' ].
	9 to: 10 do: [ :i | self at: i put: (Integer fromHexString: (aStream next:2)) ].
	aStream next = $- ifFalse: [ self error: '- separator expected' ].
	11 to: 16 do: [ :i | self at: i put: (Integer fromHexString: (aStream next:2)) ]
]
