Extension { #name : #GsSecureSocket }

{ #category : #'*zodiac-gemstone-core' }
GsSecureSocket class >> newTCP [
  ^ super new initializeAsClient
]

{ #category : #'*zodiac-gemstone-core' }
GsSecureSocket >> writeFrom: aByteArray startingAt: startIndex for: length [
  | result |
  result := self write: length from: aByteArray startingAt: startIndex.
  result isNil
    ifTrue: [ self error: self fetchLastIoErrorString ].
  ^ result
]

{ #category : #'*zodiac-gemstone-core' }
GsSecureSocket >> acceptTimeoutMs: timeoutMs [
  "patch for bug 45873"
  | newServer |
  newServer := super acceptTimeoutMs: timeoutMs.
  newServer ifNil: [ ^ nil ].	"Normal accept failed"
  newServer initializeAsServer.	"SSL init as a server socket"
  ^ newServer
]

