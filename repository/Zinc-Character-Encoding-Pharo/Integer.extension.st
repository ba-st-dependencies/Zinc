Extension { #name : #Integer }

{ #category : #'*Zinc-Character-Encoding-Pharo' }
Integer class >> fromHexString: string [

	^ self readFrom: string readStream base: 16
]
