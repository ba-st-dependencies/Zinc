"
gzip is an integral part of the VM. 
"
Class {
	#name : #GZipReadStream,
	#superclass : #Object,
	#category : #'Zinc-HTTP-GS64'
}

{ #category : #'instance creation' }
GZipReadStream class >> on: stream [

	ZnParseError signal: 'Decoding of gzip is unsupported in GS/64'
]
