Extension { #name : #ZnCharacterReadStream }

{ #category : #'*Zinc-Character-Encoding-GS64' }
ZnCharacterReadStream >> nextLine [
	"Read a CR, LF or CRLF terminated line, returning the contents of the line without the EOL. Return nil when the receiver is #atEnd."

	self atEnd ifTrue: [ ^ nil ].
	^ self collectionSpecies streamContents: [ :out | | eol char |
		eol := false.
		[ eol ] whileFalse: [
			char := self next.
			(char isNil or: [ char = Character lf ])
				ifTrue: [ eol := true ]
				ifFalse: [
					char = Character cr
						ifTrue: [ eol := true. self peekFor: Character lf ]
						ifFalse: [ out nextPut: char ] ] ] ]
]

{ #category : #'*Zinc-Character-Encoding-GS64' }
ZnCharacterReadStream >> upToAll: aCollection [
	"Answer a subcollection from the current access position to the occurrence (if any, but not inclusive) of aCollection. If aCollection is not in the stream, answer the entire rest of the stream."

	^ self collectionSpecies streamContents: [ :out | | pattern |
		pattern := aCollection readStream.
		([ self atEnd or: [ pattern atEnd ] ]) whileFalse: [
			self peek = pattern peek
				ifTrue: [
					self next. pattern next ]
				ifFalse: [
					pattern position = 0
						ifTrue: [ out nextPut: self next ]
						ifFalse: [ out next: pattern position putAll: aCollection ].
					pattern reset ] ].
		pattern atEnd
			ifFalse: [ out next: pattern position putAll: aCollection ] ]
]
