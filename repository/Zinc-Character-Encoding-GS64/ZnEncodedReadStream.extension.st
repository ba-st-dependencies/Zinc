Extension { #name : #ZnEncodedReadStream }

{ #category : #'*Zinc-Character-Encoding-GS64' }
ZnEncodedReadStream >> back [
	self encoder backOnStream: stream.
	peeked ifNotNil: [
		self encoder backOnStream: stream.
		peeked := nil ].
	^ nil
]

{ #category : #'*Zinc-Character-Encoding-GS64' }
ZnEncodedReadStream >> position: aPosition [
	"Set the byte position in the underlying/wrapped binary stream to aPosition.
	This is not a character based position! Positions are zero based.
	I will move further backward if aPosition is not at the beginning of a code point."

	super position: aPosition.
	self encoder ensureAtBeginOfCodePointOnStream: stream.
	peeked := nil
]
