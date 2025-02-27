Extension { #name : #AbstractFileReference }

{ #category : #'*Zinc-Resource-Meta-GS64' }
AbstractFileReference >> asUrl [
	"Convert the receiver in a file:// ZnUrl.
	Only an absolute path can be represented as a file:// URL"

	^ self asZnUrl
]

{ #category : #'*Zinc-Resource-Meta-GS64' }
AbstractFileReference >> asZnUrl [
	"Convert the receiver in a file:// ZnUrl.
	Only an absolute path can be represented as a file:// URL"

	^ self asAbsolute path asZnUrl
]
