"
I am ZnFileSystemUtils.
I help is abstracting over API differences pre and post the introduction of FileSystem in Pharo 2.0

Part of Zinc HTTP Components.
"
Class {
	#name : 'ZnFileSystemUtils',
	#superclass : 'Object',
	#category : 'Zinc-FileSystem-Legacy',
	#package : 'Zinc-FileSystem-Legacy'
}

{ #category : 'paths' }
ZnFileSystemUtils class >> baseNameFor: fileName [
	^ (FileDirectory root directoryEntryFor: fileName) name
]

{ #category : 'defaults' }
ZnFileSystemUtils class >> defaultDirectory [
	^ FileDirectory default
]

{ #category : 'defaults' }
ZnFileSystemUtils class >> defaultDirectoryPath [
	^ FileDirectory default fullName
]

{ #category : 'paths' }
ZnFileSystemUtils class >> delete: path [
	^ FileDirectory default deleteFileNamed: path
]

{ #category : 'paths' }
ZnFileSystemUtils class >> deleteIfExists: path [
	^ (self exists: path)
		ifTrue: [ self delete: path. true ]
		ifFalse: [ false ]
]

{ #category : 'paths' }
ZnFileSystemUtils class >> directory: path [
	^ FileDirectory on: path
]

{ #category : 'paths' }
ZnFileSystemUtils class >> downloadPathTo: directoryOrFileName for: baseName [
	| downloadPath |
	downloadPath := FileDirectory on: directoryOrFileName.
	^ (downloadPath exists and: [ downloadPath directoryEntry isDirectory ])
		ifTrue: [
			baseName ifNil: [ 
				self error: 'Not enough information to construct a download path' ]. 
			(downloadPath / baseName) pathName ]
		ifFalse: [ 
			directoryOrFileName ]
]

{ #category : 'paths' }
ZnFileSystemUtils class >> exists: path [
	^ FileDirectory default fileExists: path
]

{ #category : 'paths' }
ZnFileSystemUtils class >> extensionFor: fileName [
	^ FileDirectory extensionFor: fileName
]

{ #category : 'streams' }
ZnFileSystemUtils class >> fileNamed: fileName do: block [
	^ FileStream 
		fileNamed: fileName 
		do: block
]

{ #category : 'queries' }
ZnFileSystemUtils class >> fileSizeFor: fileName [
	^ (FileDirectory root directoryEntryFor: fileName) fileSize
]

{ #category : 'streams' }
ZnFileSystemUtils class >> fileStreamFor: fileName [
	^ FileStream fileNamed: fileName
]

{ #category : 'paths' }
ZnFileSystemUtils class >> fullNameFor: fileName [
	^ (FileDirectory default / fileName) fullName
]

{ #category : 'queries' }
ZnFileSystemUtils class >> modificationTimeFor: path [
	^ (FileDirectory default directoryEntryFor: path) modificationDateAndTime
]

{ #category : 'streams' }
ZnFileSystemUtils class >> newFileNamed: fileName do: block [
	^ FileStream 
		newFileNamed: fileName 
		do: block
]

{ #category : 'streams' }
ZnFileSystemUtils class >> oldFileNamed: fileName do: block [
	^ FileStream 
		oldFileNamed: fileName 
		do: block
]

{ #category : 'streams' }
ZnFileSystemUtils class >> oldFileStreamFor: fileName [
	^ FileStream oldFileNamed: fileName
]
