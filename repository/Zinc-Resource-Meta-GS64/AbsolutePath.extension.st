Extension { #name : #AbsolutePath }

{ #category : #'*Zinc-Resource-Meta-GS64' }
AbsolutePath >> asUrl [
	"Convert the receiver in a file:// ZnUrl"

	^ self asZnUrl
]

{ #category : #'*Zinc-Resource-Meta-GS64' }
AbsolutePath >> asZnUrl [
	"Convert the receiver in a file:// ZnUrl"

	| fileUrl |
	fileUrl := ZnUrl new.
	fileUrl scheme: #file.
	self do: [ :each | fileUrl addPathSegment: each ].
	^ fileUrl
]
