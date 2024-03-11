Extension { #name : #String }

{ #category : #'*Zinc-Resource-Meta-GS64' }
String >> addedToZnUrl: url [
	| segments |
	segments := self findTokens: '/'.
	^ url withPathSegments: segments
]

{ #category : #'*Zinc-Resource-Meta-GS64' }
String >> asUrl [
	^ self asZnUrl
]

{ #category : #'*Zinc-Resource-Meta-GS64' }
String >> asZnMimeType [
	^ ZnMimeType fromString: self
]

{ #category : #'*Zinc-Resource-Meta-GS64' }
String >> asZnUrl [
	^ ZnUrl fromString: self
]
