Extension { #name : #FileSystem }

{ #category : #'*Zinc-Resource-Meta-Pharo' }
FileSystem >> mimeTypesAt: aResolvable [
	"Return the possible mime types for the given path."
	^ store mimeTypesAt: (self resolve: aResolvable)
]
