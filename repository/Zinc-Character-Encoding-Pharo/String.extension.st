Extension { #name : #String }

{ #category : #'*Zinc-Character-Encoding-Pharo' }
String >> asZnCharacterEncoder [
	"Return a ZnCharacterEncoder instance using the receiver as identifier"

	" 'UTF-8' asZnCharacterEncoder "

	^ ZnCharacterEncoder newForEncoding: self
]

{ #category : #'*Zinc-Character-Encoding-Pharo' }
String >> encodeWith: encoding [
	"Produce a ByteArray that encodes the receiver, using a specified encoding.
	Encoding is either a ZnCharacterEncoder instance or an identifier for one."

	" 'Les élèves français' encodeWith: #utf8 "

	^ encoding asZnCharacterEncoder encodeString: self
]
