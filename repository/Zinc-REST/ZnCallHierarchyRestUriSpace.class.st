"
I am ZnCallHierarchyRestUriSpace.
I am a ZnRestUriSpace.

I represent a class hierarchy of REST call subclasses, below my root class.
"
Class {
	#name : 'ZnCallHierarchyRestUriSpace',
	#superclass : 'ZnRestUriSpace',
	#instVars : [
		'rootClass'
	],
	#category : 'Zinc-REST-Server',
	#package : 'Zinc-REST',
	#tag : 'Server'
}

{ #category : 'public' }
ZnCallHierarchyRestUriSpace >> match: request [
	| subclasses |
	subclasses := rootClass withAllSubclasses sorted: [ :x :y | x order <= y order ].
	subclasses do: [ :each |
		(each match: request)
			ifNotNil: [ :variables |
				^ each new
					variables: variables;
					yourself ] ].
	^ nil  
]

{ #category : 'accessing' }
ZnCallHierarchyRestUriSpace >> rootClass [
	^ rootClass
]

{ #category : 'initialize-release' }
ZnCallHierarchyRestUriSpace >> rootClass: anObject [
	rootClass := anObject
]
