"
ZnExampleStorageRestServerDelegateTest contains unit tests for the ZnExampleStorageRestServerDelegate in combination with the calls under ZnExampleStorageRestCall.

"
Class {
	#name : 'ZnExampleStorageRestServerDelegateTest',
	#superclass : 'TestCase',
	#instVars : [
		'server',
		'client'
	],
	#category : 'Zinc-REST-Tests',
	#package : 'Zinc-REST',
	#tag : 'Tests'
}

{ #category : 'running' }
ZnExampleStorageRestServerDelegateTest >> setUp [
	server := ZnServer startOn: 1700 + 10 atRandom.
	server delegate: ZnExampleStorageRestServerDelegate new.
	client := ZnClient new
		url: server localUrl;
		addPathSegment: #storage;
		accept: ZnMimeType applicationJson;
		contentReader: [ :entity | entity ifNotNil: [ NeoJSONReader fromString: entity contents ] ];
		contentWriter: [ :object | ZnEntity with: (NeoJSONWriter toString: object) type: ZnMimeType applicationJson ];
		yourself
]

{ #category : 'running' }
ZnExampleStorageRestServerDelegateTest >> tearDown [
	client close.
	server stop
]

{ #category : 'testing' }
ZnExampleStorageRestServerDelegateTest >> testCreate [
	"You create a new entry by posting a JSON map representation to /storage/objects
	The result is a 201 Created response with the URI of the new object both
	returned as a JSON string and as the Location header"
	
	| data objectUri |
	data := Dictionary with: #x -> 'foo' with: #y -> 'bar'.
	client
		addPathSegment: 'objects';
		contents: data;
		post.
	self assert: client isSuccess.
	self assert: client isCreated.
	objectUri := client response location.
	self assert: objectUri isString & objectUri isEmpty not.
	self assert: client contents equals: objectUri.
	client resetEntity.
	client get.
	self assert: client isSuccess.
	self assert: (client contents includes: objectUri).
	client 
		url: objectUri; 
		get.
	self assert: client isSuccess.
	data keysAndValuesDo: [ :key :value |
		(client contents at: key) = value ].
	self assert: (client contents at: #'object-uri') equals: objectUri 
]

{ #category : 'testing' }
ZnExampleStorageRestServerDelegateTest >> testCreateWithInvalidJson [
	"Send invalid input and get a generic 500 error"
	
	| response |

	client
		addPathSegment: 'objects';
		contentWriter: nil;
		contents: #[1 2 3] asString, '{';
		post.
	self deny: client isSuccess.
	response := client response.
	self assert: response isError.
	self assert: response status equals: 500.


]

{ #category : 'testing' }
ZnExampleStorageRestServerDelegateTest >> testDelete [
	"You delete an existing entry by doing a DELETE on its uri"
	
	| data objectUri |
	data := Dictionary with: #x -> 'foo' with: #y -> 'bar'.
	client
		addPathSegment: 'objects';
		contents: data;
		post.
	self assert: client isCreated.
	objectUri := client response location.
	client resetEntity.
	client 
		url: objectUri; 
		get.
	self assert: client isSuccess.
	client delete.
	self assert: client isSuccess.
	client get.
	self deny: client isSuccess.
	self assert: client isNotFound
]

{ #category : 'testing' }
ZnExampleStorageRestServerDelegateTest >> testEmpty [
	"An empty database returns a empty array for GET /storage/objects"
	
	client
		addPathSegment: 'objects';
		get.
	self assert: client isSuccess.
	self assert: client contents equals: #()
]

{ #category : 'testing' }
ZnExampleStorageRestServerDelegateTest >> testExceptionError [
	"Cause an AssertionFailure and get a 500 error"
	
	| response |

	client
		addPathSegment: 'exception';
		addPathSegment: 'assertion';
		get.
	self deny: client isSuccess.
	response := client response.
	self assert: response isError.
	self assert: response status equals: 500.


]

{ #category : 'testing' }
ZnExampleStorageRestServerDelegateTest >> testExceptionNotification [
	"Cause a Notification and get a 200 response"
	
	| response |

	client
		addPathSegment: 'exception';
		addPathSegment: 'notification';
		get.
	self assert: client isSuccess.
	response := client response.
	self deny: response isError.
	self assert: response status equals: 200.


]

{ #category : 'testing' }
ZnExampleStorageRestServerDelegateTest >> testQuery [
	"Any query parameters are seen as a conjunctive filter.
	Here we execute a GET /storage/object?string=five to find a entry where
	the key 'string' equals 'five'. Note that the uri is returned."

	| data objectUri |
	client addPathSegment: 'objects'.
	1 to: 10 do: [ :each |
		data := Dictionary with: #int -> each with: #string -> each asWords.
		client
			contents: data;
			post.
		self assert: client isCreated ].
	client resetEntity.
	client
		queryAt: #string put: 'five';
		get.
	self assert: client isSuccess.
	objectUri := client contents first.	
	client
		url: objectUri; 
		get.
	self assert: client isSuccess.
	self assert: (client contents at: #int) equals: 5
]

{ #category : 'testing' }
ZnExampleStorageRestServerDelegateTest >> testUpdate [
	"To update an existing object you PUT a new JSON map representation to an existing uri"
	
	| data objectUri |
	data := Dictionary with: #x -> 'foo' with: #y -> 'bar'.
	client
		addPathSegment: 'objects';
		contents: data;
		post.
	self assert: client isCreated.
	objectUri := client response location.
	client resetEntity.
	data at: #z put: 100.
	client
		url: objectUri; 
		contents: data;
		put.
	self assert: client isSuccess.
	client resetEntity.
	client get.
	self assert: client isSuccess.
	data keysAndValuesDo: [ :key :value |
		(client contents at: key) = value ].
	self assert: (client contents at: #'object-uri') equals: objectUri.
	self assert: (client contents at: #z) equals: 100
]
