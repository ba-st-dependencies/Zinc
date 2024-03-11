"
I am ZnMonticelloServerDelegate.
I am a proof of concept implementation of a basic Monticello server.
I function as a delegate for ZnServer.

ZnServer startDefaultOn: 1701.
ZnServer default delegate: ((ZnMonticelloServerDelegate new) 
									directory: (FileDirectory on: '/Users/sven/Tmp/monticello'); 
									yourself).

Part of Zinc HTTP Components.
"
Class {
	#name : 'ZnMonticelloServerDelegate',
	#superclass : 'Object',
	#instVars : [
		'directory'
	],
	#category : 'Zinc-FileSystem-Legacy',
	#package : 'Zinc-FileSystem-Legacy'
}

{ #category : 'accessing' }
ZnMonticelloServerDelegate >> directory [
	^ directory 
]

{ #category : 'accessing' }
ZnMonticelloServerDelegate >> directory: fileDirectory [
	directory := fileDirectory
]

{ #category : 'private' }
ZnMonticelloServerDelegate >> handleGetMczEntry: request [
	| name |
	name := request uri firstPathSegment.
	^ ((self isValidMczName: name) and: [ self directory fileExists: name ]) 
		ifTrue: [ | file entity |
			(file := self directory readOnlyFileNamed: name)
				binary.
			(entity := ZnStreamingEntity type: ZnMimeType applicationOctetStream length: file size)
				stream: file.
			ZnResponse ok: entity ]
		ifFalse: [ ZnResponse notFound: request uri ]
]

{ #category : 'private' }
ZnMonticelloServerDelegate >> handleListMczEntries: request [
	^ ZnResponse ok: (ZnEntity html: self repositoryListing)
]

{ #category : 'private' }
ZnMonticelloServerDelegate >> handlePutMczEntry: request [
	| name |
	name := request uri firstPathSegment.
	^ ((self isValidMczName: name) and: [ (self directory fileExists: name) not ]) 
		ifTrue: [
			self directory newFileNamed: name do: [ :file |
				file binary.
				request entity writeOn: file ].
			ZnResponse created: request uri ]
		ifFalse: [ ZnResponse badRequest: request ]
]

{ #category : 'public' }
ZnMonticelloServerDelegate >> handleRequest: request [
	(request method = #GET)
		ifTrue: [
			^ request uri isSlash
				ifTrue: [ self handleListMczEntries: request ]
				ifFalse: [ self handleGetMczEntry: request ] ].
	^ (request method = #PUT) 
		ifTrue: [ self handlePutMczEntry: request ]
		ifFalse: [ ZnResponse badRequest: request ]
]

{ #category : 'private' }
ZnMonticelloServerDelegate >> isValidMczName: string [
	^ string isString 
		and: [ string isEmpty not
			and: [ (string endsWith: '.mcz')
				and: [ (string includes: $/) not ] ] ]
]

{ #category : 'accessing' }
ZnMonticelloServerDelegate >> mczEntries [
	^ (self directory fileNames select: [ :each | each endsWith: '.mcz' ])
		asSortedCollection
]

{ #category : 'private' }
ZnMonticelloServerDelegate >> repositoryListing [
	^ String streamContents: [ :str |
		str nextPutAll: '<html><head><title>Monticello Repository</title></head>'.
		str nextPutAll: '<body><h1>Monticello Repository</h1>'.
		str nextPutAll: '<ul>'.
		self mczEntries do: [ :each | 
			str nextPutAll: '<li><a href="'; nextPutAll: each; nextPutAll: '">'; nextPutAll: each; nextPutAll: '</a></li>' ].
		str nextPutAll: '</ul></body></html>' ]
]

{ #category : 'public' }
ZnMonticelloServerDelegate >> value: request [
	"I implement the generic #value: message as equivalent to #handleRequest:"
	
	^ self handleRequest: request
]
