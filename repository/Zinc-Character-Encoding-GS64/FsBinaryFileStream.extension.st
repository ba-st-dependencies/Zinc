Extension { #name : #FsBinaryFileStream }

{ #category : #'*Zinc-Character-Encoding-GS64' }
FsBinaryFileStream >> next: count into: buffer [

	^self readInto: buffer startingAt: 1 count: count
]
