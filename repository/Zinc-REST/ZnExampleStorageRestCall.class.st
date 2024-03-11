"
I am ZnExampleStorageRestCall, the root of a hierarchy of REST calls implementing a simple storage service with CRUD operations.

The calls implemented by my subclasses are used by ZnExampleStorageRestServerDelegate.
"
Class {
	#name : 'ZnExampleStorageRestCall',
	#superclass : 'ZnJSONRestCall',
	#category : 'Zinc-REST-Tests',
	#package : 'Zinc-REST',
	#tag : 'Tests'
}

{ #category : 'accessing' }
ZnExampleStorageRestCall class >> isAbstract [
	^ self = ZnExampleStorageRestCall 
]
