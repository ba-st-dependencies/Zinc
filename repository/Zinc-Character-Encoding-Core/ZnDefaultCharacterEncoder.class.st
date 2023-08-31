"
I am ZnDefaultCharacterEncoder.
I am a DynamicVariable and a ProcessSpecificVariable.

I can be used to modify the default ZnCharacteEncoder on a per process basis, for example:

ZnDefaultCharacterEncoder 
	value: ZnUTF8Encoder latin1
	during: [ ZnClient new get: 'http://zn.stfx.eu/zn/small.html' ]
"
Class {
	#name : #ZnDefaultCharacterEncoder,
	#superclass : #DynamicVariable,
	#category : #'Zinc-Character-Encoding-Core'
}

{ #category : #accessing }
ZnDefaultCharacterEncoder class >> default [

	^ ZnCharacterEncoder utf8
]

{ #category : #accessing }
ZnDefaultCharacterEncoder >> default [

	^ self class default
]
