Class {
	#name : 'ZnOpenIDNonceLockerTest',
	#superclass : 'TestCase',
	#instVars : [
		'locker'
	],
	#category : 'Zinc-SSO-OpenID-Tests',
	#package : 'Zinc-SSO-OpenID-Tests'
}

{ #category : 'running' }
ZnOpenIDNonceLockerTest >> setUp [

	ZnOpenIDNonceLocker reset.
	locker := ZnOpenIDNonceLocker new.
]

{ #category : 'tests' }
ZnOpenIDNonceLockerTest >> testLockerHasSize [
	| nonce |

	nonce := ZnOpenIDNonce new.
	locker seeAndValidate: nonce.
	self should: locker nonceCount = 1
]

{ #category : 'tests' }
ZnOpenIDNonceLockerTest >> testSameNonceIsNotAcceptedTwice [

	| nonce |
	
	nonce := ZnOpenIDNonce new.
	self shouldnt: [ locker seeAndValidate: nonce ] raise: ZnOpenIDNonceSeenError.
	self should: [ locker seeAndValidate: nonce ] raise: ZnOpenIDNonceSeenError
]

{ #category : 'tests' }
ZnOpenIDNonceLockerTest >> testTooOldNodesAreNotPolledAllTheTime [
	| nonce1 nonce2 |

	nonce1 := ZnOpenIDNonceDummy new.
	nonce2 := nonce1 copy.
	self shouldnt: [ locker seeAndValidate: nonce1  ] raise: ZnOpenIDNonceSeenError.
	locker resetRemovalTime.
	nonce1 makeOld.
	self shouldnt: [ locker seeAndValidate: nonce2 ] raise: ZnOpenIDNonceSeenError.
	self
		shouldnt: [ 
			locker
				seeAndValidate:
					(ZnOpenIDNonce new
						distinctor: 1;
						yourself) ]
		raise: ZnOpenIDNonceSeenError.
	self assert: nonce2 callCountOfIsOld = 1
]

{ #category : 'tests' }
ZnOpenIDNonceLockerTest >> testTooOldNodesAreRemoved [
	| nonce1 nonce2 |

	nonce1 := ZnOpenIDNonceDummy new.
	nonce2 := nonce1 copy.
	self shouldnt: [ locker seeAndValidate: nonce1 ] raise: ZnOpenIDNonceSeenError.
	locker resetRemovalTime.
	nonce1 makeOld.
	self shouldnt: [ locker seeAndValidate: nonce2 ] raise: ZnOpenIDNonceSeenError
]

{ #category : 'tests' }
ZnOpenIDNonceLockerTest >> testVaultHasSize [
	| nonce |

	nonce := ZnOpenIDNonce new.
	locker seeAndValidate: nonce.
	self should: locker nonceCount = 1
]
