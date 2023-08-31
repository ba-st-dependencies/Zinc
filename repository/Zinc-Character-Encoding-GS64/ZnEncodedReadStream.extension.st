Extension { #name : #ZnEncodedReadStream }

{ #category : #'*Zinc-Character-Encoding-GS64' }
ZnEncodedReadStream >> back [
	self encoder backOnStream: stream.
	peeked ifNotNil: [
		self encoder backOnStream: stream.
		peeked := nil ].
	^ nil
]
