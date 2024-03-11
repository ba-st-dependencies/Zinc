Extension { #name : #MultiByteString }

{ #category : #'*Zinc-Character-Encoding-GS64' }
MultiByteString >> isWideString [

	^ true
]

{ #category : #'*Zinc-Character-Encoding-GS64' }
MultiByteString >> utf8Encoded [
	"Produce a ByteArray encoding the receiver using UTF-8,
	the recommended encoding for Strings, unless you know what you are doing."

	^ self encodeWith: ZnCharacterEncoder utf8
]
