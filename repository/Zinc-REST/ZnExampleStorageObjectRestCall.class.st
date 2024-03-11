"
ZnExampleStorageObjectRestCall.

GET /storage/object/<id>

	return the map stored under id
	
DELETE /storage/object/<id>

	delete the map stored under id
	
PUT /storage/object/<id> <MAP>

	overwrite the map stored under id with MAP

	#'object-uri' is a reserved key in MAP
"
Class {
	#name : 'ZnExampleStorageObjectRestCall',
	#superclass : 'ZnExampleStorageRestCall',
	#category : 'Zinc-REST-Tests',
	#package : 'Zinc-REST',
	#tag : 'Tests'
}

{ #category : 'accessing' }
ZnExampleStorageObjectRestCall class >> pattern [
	^ #( 'storage' 'objects' '*' )
]

{ #category : 'public' }
ZnExampleStorageObjectRestCall >> delete [
	| objectUri |
	objectUri := '/storage/objects/{1}' format: { variables first }.
	self delegate storage removeKey: objectUri ifAbsent: [ ^ self notFound ].
	self emptyOkResponse
]

{ #category : 'public' }
ZnExampleStorageObjectRestCall >> get [
	| data objectUri |
	objectUri := '/storage/objects/{1}' format: { variables first }.
	data := self delegate storage at: objectUri ifAbsent: [ ^ self notFound ].
	self jsonResponse: data
]

{ #category : 'public' }
ZnExampleStorageObjectRestCall >> put [
	| data objectUri |
	objectUri := '/storage/objects/{1}' format: { variables first }.
	(self delegate storage includesKey: objectUri) ifFalse: [ ^ self notFound ].
	data := self jsonRequest.
	data at: #'object-uri' put: objectUri.
	self delegate storage at: objectUri put: data.
	self emptyOkResponse 
]
