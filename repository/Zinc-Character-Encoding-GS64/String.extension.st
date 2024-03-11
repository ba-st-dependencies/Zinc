Extension { #name : #String }

{ #category : #'*Zinc-Character-Encoding-GS64' }
String >> urlDecoded [
	"URL Decode the receiver and return the resulting String.
	This is an encoding where characters that are illegal in a URL are escaped."

    ^ ZnPercentEncoder new decode: self
]

{ #category : #'*Zinc-Character-Encoding-GS64' }
String >> urlEncoded [
	"URL Encode the receiver and return the resulting String.
	This is an encoding where characters that are illegal in a URL are escaped."

    ^ ZnPercentEncoder new encode: self
]

{ #category : #'*Zinc-Character-Encoding-GS64' }
String >> utf8Encoded [
	"Produce a ByteArray encoding the receiver using UTF-8,
	the recommended encoding for Strings, unless you know what you are doing."

	" 'Les élèves français' utf8Encoded "

	^ self encodeWith: ZnCharacterEncoder utf8
]
