Class {
	#name : 'ZnFileUrlTest',
	#superclass : 'TestCase',
	#category : 'Zinc-Resource-Meta-Tests',
	#package : 'Zinc-Resource-Meta-Tests'
}

{ #category : 'testing' }
ZnFileUrlTest >> testAsFileReference [
	| fileUrl fileReference |
	fileUrl := 'file:///foo/bar/test.txt' asZnUrl.
	fileReference := fileUrl asFileReference.
	self assert: fileReference basename equals: 'test.txt'.
	self assert: fileReference pathSegments asArray equals: #( 'foo' 'bar' 'test.txt' ).
	self assert: fileReference isAbsolute
]

{ #category : 'testing' }
ZnFileUrlTest >> testAsFileReferenceNoDoubleSlash [
	| fileUrl fileReference |
	fileUrl := 'file:/foo/bar/test.txt' asZnUrl.
	self assert: fileUrl asString equals: 'file:///foo/bar/test.txt'.
	fileReference := fileUrl asFileReference.
	self assert: fileReference basename equals: 'test.txt'.
	self assert: fileReference pathSegments asArray equals: #( 'foo' 'bar' 'test.txt' ).
	self assert: fileReference isAbsolute
]

{ #category : 'testing' }
ZnFileUrlTest >> testAsZnUrl [
	| fileReference fileUrl |
	fileReference := FileLocator root / 'foo' / 'bar' / 'test.txt'.
	fileUrl := fileReference asZnUrl.
	self assert: fileUrl isFile.
	self assert: fileUrl directory equals: 'foo/bar'.
	self assert: fileUrl file equals: 'test.txt'.
	self assert: fileUrl pathSegments asArray equals: #( 'foo' 'bar' 'test.txt').
	self assert: fileUrl pathPrintString equals: '/foo/bar/test.txt'.
	self assert: fileUrl printString equals: 'file:///foo/bar/test.txt'.
	self deny: fileUrl hasHost.
	self deny: fileUrl hasPort.
	self deny: fileUrl hasQuery.
	self deny: fileUrl hasFragment
]

{ #category : 'testing' }
ZnFileUrlTest >> testRelative [
	| fileReference fileUrl |
	fileReference := 'foo/bar/test.txt' asFileReference.
	self assert: fileReference isRelative.
	fileUrl := fileReference asZnUrl.
	self assert: fileUrl isFile.
	self assert: fileUrl pathSegments size >= fileReference pathSegments size.
	self assert: (fileUrl pathSegments asArray endsWith: fileReference pathSegments asArray)
]

{ #category : 'testing' }
ZnFileUrlTest >> testRetrieveContents [
	| fileReference contents url |
	fileReference := ('file-<1p>.txt' expandMacrosWith: 1000 atRandom) asFileReference.
	contents := 'Testing <1p> and counting.<r><l>' expandMacrosWith: 1000 atRandom.
	fileReference ensureDelete.
	fileReference writeStreamDo: [ :stream | stream nextPutAll: contents ].
	url := fileReference asZnUrl.
	self assert: url isFile.
	self assert: url retrieveContents equals: contents.
	fileReference ensureDelete
]

{ #category : 'testing' }
ZnFileUrlTest >> testRoot [
	| fileUrl fileReference |
	fileReference := FileLocator root.
	self assert: fileReference isRoot.
	fileUrl := fileReference asZnUrl.
	self assert: fileUrl isFile.
	self assert: fileUrl isSlash
]

{ #category : 'testing' }
ZnFileUrlTest >> testSlash [
	| fileUrl fileReference |
	fileUrl := 'file:///' asZnUrl.
	self assert: fileUrl isSlash.
	self assert: fileUrl isFile.
	fileReference := fileUrl asFileReference.
	self assert: fileReference isRoot
]

{ #category : 'testing' }
ZnFileUrlTest >> testSpaces [
	self
		assert: 'file:///foo%20bar/test.st' asZnUrl asFileReference
		equals: FileLocator root / 'foo bar' / 'test.st'.
	self
		assert: (FileLocator root / 'foo bar' / 'test.st') asZnUrl
		equals: 'file:///foo%20bar/test.st' asZnUrl
]

{ #category : 'testing' }
ZnFileUrlTest >> testTrailingSlash [
	| fileReference1 fileReference2 fileUrl1 fileUrl2 |
	fileReference1 := '/foo/bar' asFileReference.
	fileReference2 := '/foo/bar/' asFileReference.
	self assert: fileReference1 equals: fileReference2.
	self assert: fileReference1 asZnUrl equals: fileReference2 asZnUrl.

	fileUrl1 := 'file:///foo/bar' asZnUrl.
	fileUrl2 := 'file:///foo/bar/' asZnUrl.
	self deny: fileUrl1 equals: fileUrl2.
	self assert: fileUrl1 asFileReference equals: fileUrl2 asFileReference
]

{ #category : 'testing' }
ZnFileUrlTest >> testWrongScheme [
	self should: [ 'http://zn.stfx.eu/zn/small.html' asZnUrl asFileReference ] raise: AssertionFailure
]
