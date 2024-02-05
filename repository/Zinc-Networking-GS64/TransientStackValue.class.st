Class {
	#name : 'TransientStackValue',
	#superclass : 'Object',
	#instVars : [
		'value'
	],
	#category : 'Zinc-Networking-GS64',
	#package : 'Zinc-Networking-GS64'
}

{ #category : 'accessing' }
TransientStackValue class >> value: anObject [

	^self new value: anObject
]

{ #category : 'initialization' }
TransientStackValue >> initialize [
	"ensure that I stay in memory"

	super initialize.
	self _setNoStubbing
]

{ #category : 'initialization' }
TransientStackValue >> value [

	^ value
]

{ #category : 'initialization' }
TransientStackValue >> value: anObject [

	value := anObject
]
