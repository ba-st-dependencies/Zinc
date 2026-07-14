Extension { #name : #CharacterCollection }

{ #category : #'*Zinc-Character-Encoding-GS64' }
CharacterCollection >> asZnCharacterEncoder [
	"Return a ZnCharacterEncoder instance using the receiver as identifier"

	^ ZnCharacterEncoder newForEncoding: self
]

{ #category : #'*Zinc-Character-Encoding-GS64' }
CharacterCollection >> isWideString [

	^ false
]
