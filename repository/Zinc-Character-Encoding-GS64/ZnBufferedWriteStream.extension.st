Extension { #name : #ZnBufferedWriteStream }

{ #category : #'*Zinc-Character-Encoding-GS64' }
ZnBufferedWriteStream >> finish [
	self flushBuffer
]
