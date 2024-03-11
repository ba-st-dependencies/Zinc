"
ZnWebWorkspaceStorage stores a dictionary of keys with string contents in a directory.

To allow for a large number of key/values subdirectories are created based on the first two letters of a key.
"
Class {
	#name : 'ZnWebWorkspaceStorage',
	#superclass : 'Object',
	#instVars : [
		'directory'
	],
	#category : 'Zinc-WWS-Server',
	#package : 'Zinc-WWS-Server'
}

{ #category : 'instance creation' }
ZnWebWorkspaceStorage class >> on: directory [
	^ self new
		directory: directory;
		yourself
]

{ #category : 'accessing' }
ZnWebWorkspaceStorage >> at: key [
	^ self at: key ifAbsent: [ KeyNotFound signalFor: key ]
]

{ #category : 'accessing' }
ZnWebWorkspaceStorage >> at: key ifAbsent: block [
	| fullPath |
	fullPath := self directory / (key first: 2) / key.
	fullPath exists
		ifFalse: [ ^ block value ].
	^ fullPath readStreamDo: [ :stream | 
			stream upToEnd ]
]

{ #category : 'accessing' }
ZnWebWorkspaceStorage >> at: key put: string [
	| subDirectory |
	self directory ensureCreateDirectory.
	subDirectory := self directory / (key first: 2).
	subDirectory ensureCreateDirectory.
	(subDirectory / key) writeStreamDo: [ :out | 
		(ZnNewLineWriterStream on: out) in: [ :stream |
			stream forLf.
			string linesDo: [ :each | stream nextPutAll: each; newLine ] ] ]
]

{ #category : 'accessing' }
ZnWebWorkspaceStorage >> directory [
	^ directory
]

{ #category : 'initialize-release' }
ZnWebWorkspaceStorage >> directory: aDirectory [
	directory := aDirectory
]
