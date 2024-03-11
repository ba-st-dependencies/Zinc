Extension { #name : #WriteStreamPortable }

{ #category : #'*Zinc-Character-Encoding-GS64' }
WriteStreamPortable >> next: anInteger putAll: aCollection [
	"Store the next anInteger elements from the given collection."

	^ self next: anInteger putAll: aCollection startingAt: 1
]

{ #category : #'*Zinc-Character-Encoding-GS64' }
WriteStreamPortable >> setFrom: newStart to: newStop [

	position := newStart - 1.
	readLimit := newStop
]
