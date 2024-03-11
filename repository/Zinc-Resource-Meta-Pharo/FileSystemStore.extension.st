Extension { #name : #FileSystemStore }

{ #category : #'*Zinc-Resource-Meta-Pharo' }
FileSystemStore >> mimeTypesAt: aPath [
	| mimeType |
	mimeType := ZnMimeType
						forFilenameExtension: aPath extension
						ifAbsent: [  ^ nil ].
	^ Array with: mimeType
]
