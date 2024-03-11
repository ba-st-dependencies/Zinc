"
I am ZnAWSS3Key.

I hold each result from listing the keys in an AWS S3 bucket.

Use #value to convert me to what ZnAWSS3Client>>#at: 
and ZnAWSS3Client>>#at:put: expect (a bucket->key association).
"
Class {
	#name : 'ZnAWSS3Key',
	#superclass : 'Object',
	#instVars : [
		'key',
		'size',
		'etag',
		'bucket',
		'xml',
		'bucketKeyAssociation'
	],
	#category : 'Zinc-AWS',
	#package : 'Zinc-AWS'
}

{ #category : 'instance creation' }
ZnAWSS3Key class >> bucket: bucket key: key [
	^ (self new)
		bucket: bucket;
		key: key;
		yourself
]

{ #category : 'instance creation' }
ZnAWSS3Key class >> fromAssociation: association [
	^ self bucket: association key key: association value
]

{ #category : 'instance creation' }
ZnAWSS3Key class >> fromXml: dom [
	^ self new fromXml: dom; yourself
]

{ #category : 'accessing' }
ZnAWSS3Key >> asResource [
	^ String streamContents: [ :stream |
		stream 
			nextPut: $/; 
			nextPutAll: bucketKeyAssociation key; 
			nextPut: $/; 
			nextPutAll: bucketKeyAssociation value ]
]

{ #category : 'accessing' }
ZnAWSS3Key >> asUrl [
	^ (ZnUrl new)
		scheme: #http;
		host: 's3.amazonaws.com';
		parseFrom: self asResource;
		yourself
]

{ #category : 'accessing' }
ZnAWSS3Key >> bucket [
	^ bucket
]

{ #category : 'private' }
ZnAWSS3Key >> bucket: anObject [
	bucket := anObject
]

{ #category : 'accessing' }
ZnAWSS3Key >> bucketKeyAssociation [
	bucketKeyAssociation isNil ifTrue: [ 
		bucketKeyAssociation := bucket -> key ].
	^ bucketKeyAssociation
]

{ #category : 'accessing' }
ZnAWSS3Key >> etag [
	^ etag
]

{ #category : 'private' }
ZnAWSS3Key >> etag: anObject [
	etag := anObject
]

{ #category : 'initialize-release' }
ZnAWSS3Key >> fromXml: dom [
	self 
		key: (dom contentStringAt: 'Key');
		etag: (dom contentStringAt: 'ETag') withoutQuoting; 
		size: (Integer readFrom: (dom contentStringAt: 'Size') ifFail: [ -1 ]); 
		xml: dom

]

{ #category : 'accessing' }
ZnAWSS3Key >> key [
	^ key
]

{ #category : 'private' }
ZnAWSS3Key >> key: anObject [
	key := anObject
]

{ #category : 'printing' }
ZnAWSS3Key >> printOn: stream [
	super printOn: stream.
	stream nextPut: $(.
	stream print: self bucketKeyAssociation.
	stream nextPut: $)
]

{ #category : 'accessing' }
ZnAWSS3Key >> size [
	^ size
]

{ #category : 'private' }
ZnAWSS3Key >> size: anObject [
	size := anObject
]

{ #category : 'accessing' }
ZnAWSS3Key >> value [
	^ self bucketKeyAssociation
]

{ #category : 'accessing' }
ZnAWSS3Key >> xml [
	^ xml
]

{ #category : 'private' }
ZnAWSS3Key >> xml: anObject [
	xml := anObject
]
