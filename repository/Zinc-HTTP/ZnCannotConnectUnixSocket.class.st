"
ZnCannotConnectUnixSocket is signalled when a Unix Domain Socket connection should be established but was not.

Part of Zinc HTTP Components. 
"
Class {
	#name : 'ZnCannotConnectUnixSocket',
	#superclass : 'Error',
	#instVars : [
		'file'
	],
	#category : 'Zinc-HTTP-UnixSocket-Exceptions',
	#package : 'Zinc-HTTP-UnixSocket',
	#tag : 'Exceptions'
}

{ #category : 'accessing' }
ZnCannotConnectUnixSocket >> file [
	^ file
]

{ #category : 'accessing' }
ZnCannotConnectUnixSocket >> file: anObject [
	file := anObject
]

{ #category : 'accessing' }
ZnCannotConnectUnixSocket >> messageText [
	^ super messageText
		ifEmpty: [ self file ifNotNil: [ self file fullName ] ifNil: [ '' ] ]
]
