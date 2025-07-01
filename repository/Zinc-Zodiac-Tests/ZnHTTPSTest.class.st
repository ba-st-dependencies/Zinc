"
"
Class {
	#name : #ZnHTTPSTest,
	#superclass : #TestCase,
	#instVars : [
	],
	#category : #'Zinc-Zodiac-Tests'
}

{ #category : #private }
ZnHTTPSTest >> ensureSocketStreamFactory [
	self 
		assert: ZnNetworkingUtils default secureSocketStreamClass isNotNil
		description: 'Please set a secure socket stream class in ZnNetworkingUtils default or switch to the ZnZodiacNetworkingUtils socket stream factory'
]

{ #category : #testing }
ZnHTTPSTest >> testAmazonAWS [
	| client |

	self ensureSocketStreamFactory.
	(client := ZnClient new) 
		get: 'https://aws.amazon.com/'.
	self assert: client isSuccess.
	self assert: (client contents includesSubstring: 'Amazon').
	client close
]

{ #category : #testing }
ZnHTTPSTest >> testGmailEncrypted [
	| client |

	self ensureSocketStreamFactory.
	(client := ZnClient new)
		maxNumberOfRedirects: 10;
		get: 'https://www.gmail.com'.
	self assert: client isSuccess.
	self assert: (client contents includesSubstring: 'Google').
	self assert: (client contents includesSubstring: 'mail').
	client close
]

{ #category : #testing }
ZnHTTPSTest >> testGoogleEncrypted [
	| client |

	self ensureSocketStreamFactory.
	(client := ZnClient new) 
		get: 'https://encrypted.google.com/search?q=Smalltalk'.
	self assert: client isSuccess.
	self assert: (client contents includesSubstring: 'Google').    
	self assert: (client contents includesSubstring: 'Smalltalk').
	client close
]

{ #category : #testing }
ZnHTTPSTest >> testWikimedia [
	| client |

	self ensureSocketStreamFactory.
	(client := ZnClient new) 
		get: 'https://secure.wikimedia.org/'.
	self assert: client isSuccess.
	self assert: (client contents includesSubstring: 'Wikimedia').
	client close

]
