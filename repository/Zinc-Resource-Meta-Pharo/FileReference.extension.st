Extension { #name : #FileReference }

{ #category : #'*Zinc-Resource-Meta-Pharo' }
FileReference >> mimeTypes [
	"Return the possible mime types for the given path."
	^ filesystem mimeTypesAt: path
]
