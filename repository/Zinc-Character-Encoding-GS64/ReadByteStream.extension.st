Extension { #name : #ReadByteStream }

{ #category : #'*Zinc-Character-Encoding-GS64' }
ReadByteStream >> readInto: aCollection startingAt: startIndex count: n [
	"Read n objects into the given collection.
	Return number of elements that have been read."

	| max |
	max := (collection size - position) min: n.
	aCollection
		replaceFrom: startIndex
		to: startIndex + max - 1
		with: collection
		startingAt: position + 1.
	position := position + max.
	^ max
]
