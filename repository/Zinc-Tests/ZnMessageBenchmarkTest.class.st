Class {
	#name : 'ZnMessageBenchmarkTest',
	#superclass : 'TestCase',
	#category : 'Zinc-Tests',
	#package : 'Zinc-Tests'
}

{ #category : 'asserting' }
ZnMessageBenchmarkTest >> assert: actual equals: expected [
	"Patched to only check equality, not hashes: some basic GS64 classes
	define the hash of certain strange Unicode32 strings incorrectly, which
	makes the superclass implementation fail."

	self assert: actual = expected
]

{ #category : 'testing' }
ZnMessageBenchmarkTest >> testRequests [
	ZnMessageBenchmark requests do: [ :each |
		| bench |
		bench := ZnMessageBenchmark new.
		bench perform: each.
		self assert: (bench message isKindOf: ZnRequest).
		bench writeRepresentation.
		self assert: (bench read isKindOf: ZnRequest).
		self assert: bench read equals: bench message ]
]

{ #category : 'testing' }
ZnMessageBenchmarkTest >> testResponses [
	ZnMessageBenchmark responses do: [ :each |
		| bench |
		bench := ZnMessageBenchmark new.
		bench perform: each.
		self assert: (bench message isKindOf: ZnResponse).
		bench writeRepresentation.
		self assert: (bench read isKindOf: ZnResponse).
		self assert: bench read equals: bench message ]
]
