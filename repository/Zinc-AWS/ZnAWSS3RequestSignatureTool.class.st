"
I am a tool to sign AWS S3 requests.

See also http://docs.aws.amazon.com/AmazonS3/latest/dev/RESTAuthentication.html
"
Class {
	#name : 'ZnAWSS3RequestSignatureTool',
	#superclass : 'Object',
	#instVars : [
		'accessKeyId',
		'secretAccessKey'
	],
	#category : 'Zinc-AWS',
	#package : 'Zinc-AWS'
}

{ #category : 'accessing' }
ZnAWSS3RequestSignatureTool >> accessKeyId [
	"The AWS Security Credentials' Access Keys' Access Key ID used by me"
	
	^ accessKeyId
]

{ #category : 'accessing' }
ZnAWSS3RequestSignatureTool >> accessKeyId: string [
	"Set my AWS Security Credentials' Access Keys' Access Key ID"

	accessKeyId := string
]

{ #category : 'private' }
ZnAWSS3RequestSignatureTool >> authorizationFor: request [
	| canonicalString hmac |
	request headers at: 'Date' put: ZnUtils httpDate.
	canonicalString := self canonicalStringFor: request.
	hmac := self hmacSha1: canonicalString.
	^ ZnUtils encodeBase64: hmac 
]

{ #category : 'private' }
ZnAWSS3RequestSignatureTool >> bucketFromEndPoint: host [
	"For foo.s3.amazonaws.com return /foo
	For s3.amazonaws.com return the empty string"
	
	| position |
	position := host indexOfSubCollection: self standardEndPoint.
	^ position < 3
		ifTrue: [ '' ]
		ifFalse: [ '/', (host copyFrom: 1 to: position - 2) ]
]

{ #category : 'private' }
ZnAWSS3RequestSignatureTool >> canonicalStringFor: request [
	^ String streamContents: [ :stream |
		stream nextPutAll: request method; lf.
		(request headers includesKey: 'Content-MD5')
			ifTrue: [ stream nextPutAll: (request headers at: 'Content-MD5') ].
		stream lf.
		request headers hasContentType ifTrue: [
			stream print: request headers contentType ].
		stream lf.
		(request headers includesKey: 'Date')
			ifTrue: [ stream nextPutAll: (request headers at: 'Date') ].
		stream lf.
		self printAmzHeaders: request headers to: stream.
		stream 
			nextPutAll: (self bucketFromEndPoint: request uri host); 
			nextPutAll: request uri pathPrintString ]
]

{ #category : 'private' }
ZnAWSS3RequestSignatureTool >> hmacSha1: string [
	^ (HMAC on: SHA1 new)
		key: self secretAccessKey asByteArray;
		digestMessage: string asByteArray
]

{ #category : 'private' }
ZnAWSS3RequestSignatureTool >> printAmzHeaders: headers to: stream [
	| amzHeaders |
	amzHeaders := OrderedCollection new.
	headers headersDo: [ :key :value |
		(key beginsWith: 'X-Amz')
			ifTrue: [ 
				amzHeaders add: key asLowercase -> value ] ].
	amzHeaders sorted do: [ :each |
		stream 
			nextPutAll: each key; 
			nextPut: $:; 
			nextPutAll: each value; 
			lf ]
]

{ #category : 'accessing' }
ZnAWSS3RequestSignatureTool >> secretAccessKey [
	"The AWS Security Credentials' Access Keys' Secret Access Key used by me"
	
	^ secretAccessKey
]

{ #category : 'accessing' }
ZnAWSS3RequestSignatureTool >> secretAccessKey: string [
	"Set my AWS Security Credentials' Access Keys' Secret Access Key"

	secretAccessKey := string
]

{ #category : 'public' }
ZnAWSS3RequestSignatureTool >> signRequest: request [
	| authorization |
	authorization := self authorizationFor: request.
	request
		setAuthorization:
			(String
				streamContents: [ :stream | 
					stream
						nextPutAll: 'AWS ';
						nextPutAll: self accessKeyId;
						nextPut: $:;
						nextPutAll: authorization ])
]

{ #category : 'private' }
ZnAWSS3RequestSignatureTool >> standardEndPoint [
	^ 's3.amazonaws.com'
]

{ #category : 'public' }
ZnAWSS3RequestSignatureTool >> value: request [
	self signRequest: request
]
