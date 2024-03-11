"
I am ZnRestUriSpace.

I can #match: a request to a REST call.
"
Class {
	#name : 'ZnRestUriSpace',
	#superclass : 'Object',
	#category : 'Zinc-REST-Server',
	#package : 'Zinc-REST',
	#tag : 'Server'
}

{ #category : 'public' }
ZnRestUriSpace >> match: request [
	self subclassResponsibility 
]
