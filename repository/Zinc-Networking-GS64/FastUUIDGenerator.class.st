Class {
	#name : #FastUUIDGenerator,
	#superclass : #Object,
	#instVars : [
		'bits1',
		'bits2',
		'bits3',
		'bits4',
		'random',
		'semaphore'
	],
	#category : #'Zinc-Networking-GS64'
}

{ #category : #accessing }
FastUUIDGenerator class >> _defaultKey [

	^ #'UUID_DEFAULT'
]

{ #category : #accessing }
FastUUIDGenerator class >> default [

	^ (SessionTemps current at: self _defaultKey ifAbsent: [  ]) ifNil: [
		  | default |
		  default := self new initialize.
		  SessionTemps current at: self _defaultKey put: default ]
]

{ #category : #accessing }
FastUUIDGenerator class >> initialize [

	SessionTemps current removeKey: self _defaultKey ifAbsent: [].
	UUID generatorClass: self
]

{ #category : #accessing }
FastUUIDGenerator class >> next [
	"Return a UUID using the shared generator"
	
	^ self default next
]

{ #category : #initialization }
FastUUIDGenerator >> generateFieldsVersion4 [

	semaphore critical: [
		bits1 := random integer.
		bits2 := random integer.
		bits3 := random integer.
		bits4 := random integer ].
	bits2 := (bits2 bitAnd: 16rFFFF0FFF) bitOr: 16r4000.
	bits3 := (bits3 bitAnd: 16r3FFFFFFF) bitOr: 16r80000000
]

{ #category : #initialization }
FastUUIDGenerator >> initialize [

	random := Random new.
	semaphore := Semaphore forMutualExclusion
]

{ #category : #accessing }
FastUUIDGenerator >> next [
	"Return the next UUID"

	| uuid |
	uuid := UUID nilUUID.
	self placeFields: uuid.
	^ uuid
]

{ #category : #initialization }
FastUUIDGenerator >> placeFields: aPlaceHolder [

	self generateFieldsVersion4.
	aPlaceHolder
		unsigned32At: 1 put: bits1;
		unsigned32At: 5 put: bits2;
		unsigned32At: 9 put: bits3;
		unsigned32At: 13 put: bits4
]
