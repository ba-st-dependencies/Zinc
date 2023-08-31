Extension { #name : #Collection }

{ #category : #'*Zinc-Resource-Meta-GS64' }
Collection >> addedToZnUrl: url [
	^ url withPathSegments: self
]
