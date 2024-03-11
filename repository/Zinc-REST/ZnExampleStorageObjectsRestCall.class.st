"
ZnExampleStorageObjectsRestCall.

GET /storage/objects

	list all stored maps as a list of object-uris
	
GET /storage/objects?key1=value1&key2=value2

	as above with conjunctive condition specified 
	
POST /storage/objects <MAP>
	
	store a new map, returns the created object-uri

	#'object-uri' is a reserved key in MAP
"
Class {
	#name : 'ZnExampleStorageObjectsRestCall',
	#superclass : 'ZnExampleStorageRestCall',
	#category : 'Zinc-REST-Tests',
	#package : 'Zinc-REST',
	#tag : 'Tests'
}

{ #category : 'accessing' }
ZnExampleStorageObjectsRestCall class >> pattern [
	^ #( 'storage' 'objects' )
]

{ #category : 'public' }
ZnExampleStorageObjectsRestCall >> get [
	| predicateKeys |
	predicateKeys := request uri queryKeys.
	predicateKeys isEmpty
		ifTrue: [ self jsonResponse: self delegate storage keys ]
		ifFalse: [ 
			| objectKeys |
			objectKeys := OrderedCollection new.
			self delegate storage
				keysAndValuesDo: [ :key :value | 
					(predicateKeys allSatisfy: [ :each | (value at: each ifAbsent: [ nil ]) = (request uri queryAt: each) ])
						ifTrue: [ objectKeys add: key ] ].
			self jsonResponse: objectKeys ]
]

{ #category : 'public' }
ZnExampleStorageObjectsRestCall >> post [
	| data newUri |
	data := self jsonRequest.
	data isDictionary
		ifTrue: [ 
			newUri := '/storage/objects/{1}' format: { self delegate nextId printString }.
			data at: #'object-uri' put: newUri.
			self delegate storage at: newUri put: data.
			self created: newUri ]
		ifFalse: [ self badRequest: 'JSON map expected' ]
]
