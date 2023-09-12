Extension { #name : #ByteArray }

{ #category : #'*Zinc-Character-Encoding-GS64' }
ByteArray >> asString [

	^ ZnNullEncoder new decodeBytes: self
]

{ #category : #'*Zinc-Character-Encoding-GS64' }
ByteArray >> handleArgumentErrorDuring: aBlock [

	^ aBlock
		  on: ArgumentError
		  do: [ :error | ZnInvalidUTF8 signal: error messageText ]
]

{ #category : #'*Zinc-Character-Encoding-GS64' }
ByteArray >> swap: oneIndex with: anotherIndex [
	"Move the element at oneIndex to anotherIndex, and vice-versa."

	| element |
	element := self at: oneIndex.
	self at: oneIndex put: (self at: anotherIndex).
	self at: anotherIndex put: element
]
