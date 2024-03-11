"
ZnCannotCreateUnixSocket is signalled when a Unix Domain Socket should be instantiated but was not.

Part of Zinc HTTP Components. 
"
Class {
	#name : 'ZnCannotCreateUnixSocket',
	#superclass : 'Error',
	#instVars : [
		'file'
	],
	#category : 'Zinc-HTTP-UnixSocket-Exceptions',
	#package : 'Zinc-HTTP-UnixSocket',
	#tag : 'Exceptions'
}

{ #category : 'accessing' }
ZnCannotCreateUnixSocket >> file [
	^ file
]

{ #category : 'accessing' }
ZnCannotCreateUnixSocket >> file: anObject [
	file := anObject
]

{ #category : 'accessing' }
ZnCannotCreateUnixSocket >> messageText [
	^ super messageText
		ifEmpty: [ self file ifNotNil: [ self file fullName ] ifNil: [ '' ] ]
]
