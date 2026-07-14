Extension { #name : #ByteArray }

{ #category : #'*Zinc-Character-Encoding-GS64' }
ByteArray >> asString [

	^ ZnNullEncoder new decodeBytes: self
]

{ #category : #'*Zinc-Character-Encoding-GS64' }
ByteArray >> decodeFromUTF8 [
	"Decode receiver from UTF8 format.
	 Returns either a Unicode7 , Unicode16 or Unicode32 ,
	 using the minimum character size needed to represent decoded result."

	^ self handleArgumentErrorDuring: [
		  self _decodeUtf8StartingAt: 1 unicodeResult: true maxSize: nil bytesConsumed: nil ]
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
