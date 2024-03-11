"
I am ZnJSONRestCall.
I am a ZnAutoMatchedRestCall and a ZnRestCall.

I offer extra support for the common case where most responses or requests use JSON as representation.

I work together with ZnJSONRestServerDelegate.
"
Class {
	#name : 'ZnJSONRestCall',
	#superclass : 'ZnAutoMatchedRestCall',
	#category : 'Zinc-REST-Server',
	#package : 'Zinc-REST',
	#tag : 'Server'
}

{ #category : 'accessing' }
ZnJSONRestCall class >> isAbstract [
	^ self = ZnJSONRestCall 
]

{ #category : 'public' }
ZnJSONRestCall >> created: uri [
	^ (super created: uri)
		entity: (ZnEntity with: (self toJson: uri), String crlf type: ZnMimeType applicationJson);
		yourself
]

{ #category : 'public' }
ZnJSONRestCall >> emptyOkResponse [
	| entity |
	entity := ZnEntity with: (self toJson: #OK) , String crlf type: ZnMimeType applicationJson.
	^ response := ZnResponse ok: entity
]

{ #category : 'utils' }
ZnJSONRestCall >> fromJson: string [
	^ self delegate fromJson: string
]

{ #category : 'accessing' }
ZnJSONRestCall >> jsonRequest [
	^ (self request contentType matches: ZnMimeType applicationJson)
		ifTrue: [
			self fromJson: self request contents ]
		ifFalse: [
			self error: 'JSON content expected' ]
]

{ #category : 'accessing' }
ZnJSONRestCall >> jsonResponse: data [
	| entity |
	entity := ZnEntity with: (self toJson: data) type: ZnMimeType applicationJson.
	self response: (ZnResponse ok: entity)
]

{ #category : 'utils' }
ZnJSONRestCall >> toJson: data [
	^ self delegate toJson: data
]
