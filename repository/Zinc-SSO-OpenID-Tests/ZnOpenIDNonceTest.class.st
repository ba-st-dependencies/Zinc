Class {
	#name : 'ZnOpenIDNonceTest',
	#superclass : 'TestCase',
	#category : 'Zinc-SSO-OpenID-Tests',
	#package : 'Zinc-SSO-OpenID-Tests'
}

{ #category : 'private' }
ZnOpenIDNonceTest >> newNonce [
	^ZnOpenIDNonce new.
]

{ #category : 'private' }
ZnOpenIDNonceTest >> nonceFromString: aString [
	^ ZnOpenIDNonce fromString: aString
]

{ #category : 'tests' }
ZnOpenIDNonceTest >> testHash [
	| ts nonce1 nonce2 nonce3 nonce4 |

	ts := DateAndTime now.
	nonce1 := self newNonce
		timestamp: ts;
		distinctor: 'ABCD123' yourself.
	nonce2 := self newNonce
		timestamp: ts;
		distinctor: 'ABCD123' yourself.
	nonce3 := self newNonce
		timestamp: ts + 1 days;
		distinctor: 'ABCD124' yourself.
	nonce4 := self newNonce
		timestamp: ts + 1 days;
		yourself.
	self assert: nonce1 hash = nonce2 hash.
	self deny: nonce1 hash = nonce3 hash.
	self deny: nonce1 hash = nonce4 hash.
	self deny: nonce3 hash = nonce4 hash
]

{ #category : 'tests' }
ZnOpenIDNonceTest >> testOrderingNoDistinctor [
	| ts nonce1 nonce2 nonce3 |

	ts := DateAndTime now.
	nonce1 := self newNonce
		timestamp: ts;
		yourself.
	nonce2 := self newNonce
		timestamp: ts;
		yourself.
	nonce3 := self newNonce
		timestamp: ts + 1 days;
		yourself.
	self assert: nonce1 = nonce2.
	self assert: nonce1 < nonce3.
	self assert: nonce3 > nonce1
]

{ #category : 'tests' }
ZnOpenIDNonceTest >> testOrderingSingleDistinctor [
	| ts nonce1 nonce2 |

	ts := DateAndTime now.
	nonce1 := self newNonce
		timestamp: ts;
		yourself.
	nonce2 := self newNonce
		timestamp: ts;
		distinctor: '1';
		yourself.
	self assert: nonce1 < nonce2
]

{ #category : 'tests' }
ZnOpenIDNonceTest >> testOrderingWithDistinctors [
	| ts nonce1 nonce2 |
	
	ts := DateAndTime now.
	nonce1 := self newNonce
		timestamp: ts;
		distinctor: 'asd' yourself.
	nonce2 := self newNonce
		timestamp: ts;
		distinctor: '1';
		yourself.
	self assert: nonce1 > nonce2
]

{ #category : 'tests' }
ZnOpenIDNonceTest >> testPrintingNoDistinctor [
	| ts nonce |

	ts := ZnOpenIDNonce decodeRFC3339Date: '2010-11-30T13:42:59Z'.
	" ts := TimeStamp date: (Date year: 2010 month: 11 day: 30) time: (Time hour: 13 minute: 42 second: 59). "
	nonce :=  self newNonce
		timestamp: ts;
		yourself.
	self assert: '2010-11-30T13:42:59Z' = nonce asString
]

{ #category : 'tests' }
ZnOpenIDNonceTest >> testPrintingWithDistinctor [
	| ts nonce |

	ts := ZnOpenIDNonce decodeRFC3339Date: '2011-12-25T17:15:41Z'.	
	"ts := TimeStamp date: (Date year: 2011 month: 12 day: 25) time: (Time hour: 17 minute: 15 second: 41)."
	nonce :=  self newNonce
		timestamp: ts;
		distinctor: 'ABCD1234';
		yourself.
	self assert: '2011-12-25T17:15:41ZABCD1234' = nonce printString
]

{ #category : 'tests' }
ZnOpenIDNonceTest >> testReadingWithDisctinctor [
	| ts nonce |
	ts := ZnOpenIDNonce decodeRFC3339Date: '2011-12-25T17:15:41Z'.
	nonce := self nonceFromString: '2011-12-25T17:15:41ZCBD123'.
	self assert: nonce timestamp = ts.
	self assert: nonce distinctor = 'CBD123'
]

{ #category : 'tests' }
ZnOpenIDNonceTest >> testReadingWithWrongFormat [

	self should: [ self nonceFromString: '2011-1225T17:15:41Z' ] raise: ZnOpenIDNonceInvalidError.
	self should: [ self nonceFromString: 'asdasd' ] raise: ZnOpenIDNonceInvalidError.
	self should: [ self nonceFromString: '2011-11-23T11:48:19' ] raise: ZnOpenIDNonceInvalidError
]

{ #category : 'tests' }
ZnOpenIDNonceTest >> testReadingWithoutDisctinctor [
	| ts nonce |
	ts := ZnOpenIDNonce decodeRFC3339Date: '2011-12-25T17:15:41Z'.
	nonce := self nonceFromString: '2011-12-25T17:15:41Z'.
	self assert: nonce timestamp = ts
]
