"
I am ZnAWSS3Client, a basic AWS S3 Client (http://en.wikipedia.org/wiki/Amazon_S3).

| client |
(client := ZnAWSS3Client new)
	accessKeyId: '2ZGSSBGBHQGJ9VV5N441';
	secretAccessKey: 'OtxrzxIsfpFjA7SwPzILwy8Bw21TLhquhboDYROV';
	checkIntegrity: true.
client buckets.
client keysIn: 'my-bucket'.
client keysIn: 'my-bucket' query: (Dictionary with: 'prefix'->'my-').
client at: 'my-bucket' -> 'my-key'.
client at: 'my-bucket' -> 'my-key' put: (ZnEntity with: '0123456789').
client at: 'my-bucket' -> 'my-key' put: (ZnEntity with: 'Smalltalk rules S3!') headers: (Dictionary with: 'x-amz-acl'->'public-read').
client remove: 'my-bucket' -> 'my-key'.
client removeBucket: 'my-bucket'.
client close.

I depend on Zinc HTTP Components and XML Support.
"
Class {
	#name : 'ZnAWSS3Client',
	#superclass : 'Object',
	#instVars : [
		'signatureTool',
		'checkIntegrity',
		'httpClient'
	],
	#category : 'Zinc-AWS',
	#package : 'Zinc-AWS'
}

{ #category : 'accessing' }
ZnAWSS3Client >> accessKeyId [
	"The AWS Security Credentials' Access Keys' Access Key ID used by me"
	
	^ signatureTool accessKeyId
]

{ #category : 'accessing' }
ZnAWSS3Client >> accessKeyId: string [
	"Set my AWS Security Credentials' Access Keys' Access Key ID"

	signatureTool accessKeyId: string
]

{ #category : 'operations' }
ZnAWSS3Client >> addBucket: bucket [
	"Create a new AWS S3 bucket"

	self endPoint: self standardEndPoint.
	self httpClient url: bucket.
	^ self executeRequest: #put

]

{ #category : 'private protocol' }
ZnAWSS3Client >> addContentHash [
	| md5 |
	self httpClient request hasEntity ifFalse: [ ^ self ].
	md5 := self md5: self httpClient request contents.
	self httpClient headerAt: 'Content-MD5' put: (ZnUtils encodeBase64: md5)



]

{ #category : 'operations' }
ZnAWSS3Client >> at: bucketKeyAssociation [
	"Access an AWS S3 object in a bucket,
	identified by a bucket->key association"
	
	self endPoint: (self endPointForBucket: bucketKeyAssociation key).
	self httpClient url: bucketKeyAssociation value.
	^ self executeRequest: #get
]

{ #category : 'operations' }
ZnAWSS3Client >> at: bucketKeyAssociation put: object [
	"Set an AWS S3 object in a bucket to object,
	assumed to be ZnEntity compatible,
	identified by a bucket->key association"

	^ self at: bucketKeyAssociation put: object headers: nil
]

{ #category : 'operations' }
ZnAWSS3Client >> at: bucketKeyAssociation put: object headers: headers [
	"Set an AWS S3 object in a bucket to object,
	assumed to be ZnEntity compatible,
	identified by a bucket->key association
	adding headers to the request"
	
	self endPoint: (self endPointForBucket: bucketKeyAssociation key).
	self httpClient url: bucketKeyAssociation value.
	self httpClient entity: object.
	headers notNil 
		ifTrue: [ self httpClient headerAddAll: headers ].
	^ self executeRequest: #put
]

{ #category : 'operations' }
ZnAWSS3Client >> buckets [
	"Return an array of all  AWS S3 bucket name strings for the account"
	
	| response |
	self endPoint: self standardEndPoint.
	self httpClient url: '/'.
	response := self executeRequest: #get.
	^ (response isSuccess and: [ response contentType = ZnMimeType applicationXml ])
		ifTrue: [
			self processBucketsXml: response contents ]
		ifFalse: [
			self error: 'Could not list buckets' ]
]

{ #category : 'accessing' }
ZnAWSS3Client >> checkIntegrity [
	"Do I check the integrety of get/put requests using content hashes ?"
	
	checkIntegrity isNil ifTrue: [ checkIntegrity := false ].
	^ checkIntegrity
]

{ #category : 'accessing' }
ZnAWSS3Client >> checkIntegrity: boolean [
	"Set whether I should check the integrety of get/put requests using content hashes"

	checkIntegrity := boolean
]

{ #category : 'initialize-release' }
ZnAWSS3Client >> close [
	"Close the network resources we are using"
	
	httpClient notNil 
		ifTrue: [ httpClient close ]
]

{ #category : 'operations extra' }
ZnAWSS3Client >> downloadFile: filename fromBucket: bucket [
	"Do a streaming download of the key filename from bucket,
	creating it as a file with that name in the current directory."
	
	| streaming response |
	streaming := self httpClient streaming.
	self httpClient streaming: true.
	response := self at: bucket -> filename.
	self httpClient streaming: streaming.
	response isSuccess ifFalse: [ ^ ZnHttpUnsuccessful signal ].
	self httpClient downloadEntityTo: filename.
	^ response

]

{ #category : 'accessing' }
ZnAWSS3Client >> eTag [
	^ (self httpClient response 
			headers at: 'ETag' ifAbsent: [ ^ nil ]) withoutQuoting
]

{ #category : 'initialize-release' }
ZnAWSS3Client >> endPoint: host [
	"Initialize me to talk to the endpoint named host.
	Create a new HTTP client if needed, else reuse the existing one.
	Install my signatureTool as a prepare request hook."

	httpClient
		ifNil: [ 
			httpClient := ZnClient new
				http;
				prepareRequest: signatureTool;
				yourself ].
	httpClient host: host
]

{ #category : 'private' }
ZnAWSS3Client >> endPointForBucket: bucketKey [
	^ String streamContents: [ :stream |
		stream 
			nextPutAll: bucketKey;
			nextPut: $.; 
			nextPutAll: self standardEndPoint ]
]

{ #category : 'private protocol' }
ZnAWSS3Client >> enforceContentHash [
	| etag md5 request  |
	request := self httpClient request.
	request hasEntity ifFalse: [ ^ self ].
	(etag := self eTag) ifNil: [ ^ self ].
	md5 := self md5: request contents.
	etag = md5 hex
		ifFalse: [ self error: 'Content MD5 hash and ETag do not match' ]
]

{ #category : 'private protocol' }
ZnAWSS3Client >> executeRequest: method [
	self httpClient method: method asUppercase.
	self prepareRequest.
	self httpClient perform: method.
	self postProcessResponse.
	^ self httpClient response


]

{ #category : 'private' }
ZnAWSS3Client >> httpClient [
	httpClient isNil
		ifTrue: [ self endPoint: self standardEndPoint ].
	^ httpClient
]

{ #category : 'initialize-release' }
ZnAWSS3Client >> initialize [ 
	super initialize.
	signatureTool := ZnAWSS3RequestSignatureTool new
]

{ #category : 'private' }
ZnAWSS3Client >> isListBucketResultTruncated: dom [
	^ (dom root contentStringAt: 'IsTruncated') = 'true'
]

{ #category : 'operations' }
ZnAWSS3Client >> keysIn: bucket [
	"Return a collection of ZnAWSS3Key objects describing the keys in bucket"
	
	^ self keysIn: bucket query: nil
]

{ #category : 'operations' }
ZnAWSS3Client >> keysIn: bucket query: query [
	"Return a collection of ZnAWSS3Key objects describing the keys in bucket
	using optional URI query fields"
	
	| response keys dom |
	self endPoint: (self endPointForBucket: bucket).
	self httpClient url: '/'.
	query notNil ifTrue: [ self httpClient queryAddAll: query ].
	keys := nil.
	^ Array streamContents: [ :out |
		[ 
			keys ifNotNil: [ self httpClient queryAt: 'marker' put: keys last key ].
			response := self executeRequest: #get.
			(response isSuccess and: [ response contentType = ZnMimeType applicationXml ])
				ifFalse: [ ^ self error: 'Could not list keys' ].
			dom := XMLDOMParser parse: response contents.
			keys:= self processKeysXml: dom for: bucket.
			out nextPutAll: keys.
			self isListBucketResultTruncated: dom ] whileTrue ]
]

{ #category : 'private' }
ZnAWSS3Client >> md5: object [
	^ MD5 new hashMessage: object
]

{ #category : 'operations' }
ZnAWSS3Client >> metaAt: bucketKeyAssociation [
	"Access the meta information of an AWS S3 object in a bucket,
	identified by a bucket->key association, by doing a HEAD."
	
	self endPoint: (self endPointForBucket: bucketKeyAssociation key).
	self httpClient url: bucketKeyAssociation value.
	^ self executeRequest: #head
]

{ #category : 'private protocol' }
ZnAWSS3Client >> postProcessResponse [
	self checkIntegrity 
		ifTrue: [ self enforceContentHash ]
]

{ #category : 'private protocol' }
ZnAWSS3Client >> prepareRequest [
	self checkIntegrity 
		ifTrue: [ self addContentHash ]

]

{ #category : 'private' }
ZnAWSS3Client >> processBucketsXml: string [
	| dom |
	dom := XMLDOMParser parse: string.
	^ ((dom allElementsNamed: 'Bucket') 
			collect: [ :each | 
				each contentStringAt: 'Name']) asArray
]

{ #category : 'private' }
ZnAWSS3Client >> processKeysXml: dom for: bucket [
	^ ((dom allElementsNamed: 'Contents') 
			collect: [ :each | 
				(ZnAWSS3Key fromXml: each) 
					bucket: bucket; 
					yourself ]) asArray
]

{ #category : 'operations' }
ZnAWSS3Client >> remove: bucketKeyAssociation [
	"Remove an  AWS S3 object in a bucket,
	identified by a bucket->key association"

	self endPoint: (self endPointForBucket: bucketKeyAssociation key).
	self httpClient url: bucketKeyAssociation value.
	^ self executeRequest: #delete
]

{ #category : 'operations' }
ZnAWSS3Client >> removeBucket: bucket [
	"Remove an AWS S3 bucket"
	
	self endPoint: self standardEndPoint.
	self httpClient url: bucket.
	^ self executeRequest: #delete

]

{ #category : 'accessing' }
ZnAWSS3Client >> secretAccessKey [
	"The AWS Security Credentials' Access Keys' Secret Access Key used by me"
	
	^ signatureTool secretAccessKey
]

{ #category : 'accessing' }
ZnAWSS3Client >> secretAccessKey: string [
	"Set my AWS Security Credentials' Access Keys' Secret Access Key"

	signatureTool secretAccessKey: string
]

{ #category : 'private' }
ZnAWSS3Client >> standardEndPoint [
	^ 's3.amazonaws.com'
]

{ #category : 'operations extra' }
ZnAWSS3Client >> uploadFile: filename inBucket: bucket [
	^ self uploadFile: filename withMd5: nil inBucket: bucket
]

{ #category : 'operations extra' }
ZnAWSS3Client >> uploadFile: filename withMd5: md5 inBucket: bucket [
	"Do a streaming upload of the file filename to bucket.
	When md5 is notNil, use it to validate the ETag of the response."
	
	| reference entry size mimeType fileStream entity response |
	reference := filename asFileReference.
	entry := reference entry.
	size := entry size.
	mimeType := ZnMimeType forFilenameExtension: reference extension.
	fileStream := reference readStream.
	mimeType isBinary ifTrue: [ fileStream binary ].
	(entity := ZnStreamingEntity type: mimeType length: size)
		stream: fileStream.
	self at: bucket -> reference basename put: entity.
	(md5 notNil and: [ (md5 sameAs: self eTag) not ])
		ifTrue: [ self error: 'Uploaded ETag does not equal supplied MD5' ].
	^ self httpClient response

]
