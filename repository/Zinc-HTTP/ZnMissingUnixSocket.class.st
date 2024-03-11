"
ZnMissingUnixSocket is signalled when a Unix Domain Socket file does not exist but should exist.

Part of Zinc HTTP Components. 
"
Class {
	#name : 'ZnMissingUnixSocket',
	#superclass : 'Error',
	#instVars : [
		'file'
	],
	#category : 'Zinc-HTTP-UnixSocket-Exceptions',
	#package : 'Zinc-HTTP-UnixSocket',
	#tag : 'Exceptions'
}

{ #category : 'accessing' }
ZnMissingUnixSocket >> file [
	^ file
]

{ #category : 'accessing' }
ZnMissingUnixSocket >> file: anObject [
	file := anObject
]

{ #category : 'accessing' }
ZnMissingUnixSocket >> messageText [
	^ super messageText
		ifEmpty: [ self file ifNotNil: [ self file fullName ] ifNil: [ '' ] ]
]
