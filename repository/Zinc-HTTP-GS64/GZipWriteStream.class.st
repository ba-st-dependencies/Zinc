"
gzip is an integral part of the VM. 
"
Class {
	#name : #GZipWriteStream,
	#superclass : #Object,
	#category : #'Zinc-HTTP-GS64'
}

{ #category : #'instance creation' }
GZipWriteStream class >> on: stream [

	ZnParseError signal: 'Encoding to gzip is unsupported in GS/64'
]
