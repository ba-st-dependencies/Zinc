"
I am ZnRestServerUtils.
"
Class {
	#name : 'ZnRestServerUtils',
	#superclass : 'Object',
	#category : 'Zinc-REST-Server',
	#package : 'Zinc-REST',
	#tag : 'Server'
}

{ #category : 'utils' }
ZnRestServerUtils class >> extractBasicAuthorization: request [
	| authorization decodedCredentials indexOfColon |
	authorization := (request headers at: 'Authorization' ifAbsent: [ ^ nil ]) findTokens: ' '.
	(authorization size = 2 and: [ authorization first = 'Basic' ]) ifFalse: [ ^ nil ].
	decodedCredentials := ZnUtils decodeBase64: authorization second.
	indexOfColon := decodedCredentials indexOf: $: ifAbsent: [ ^ nil ].
	^ (decodedCredentials first: indexOfColon - 1) -> (decodedCredentials allButFirst: indexOfColon)

]

{ #category : 'utils' }
ZnRestServerUtils class >> matchPath: path pattern: pattern [
	"self matchPath: #('foo' '1' 'bar' '2') pattern: #('foo' '*' 'bar' '*')"
	
	| result |
	path isNil ifTrue: [ ^ pattern isNil ifTrue: [ #() ] ifFalse: [ nil ] ].
	(pattern isNil or: [ path size ~= pattern size ]) ifTrue: [ ^ nil ].
	(pattern includes: '*') 
		ifTrue: [ result := OrderedCollection new ]
		ifFalse: [ result := true ].
	pattern with: path do: [ :target :source |
		target = '*'
			ifTrue: [ 
				result add: source ]
			ifFalse: [ 
				source = target ifFalse: [ ^ nil ] ] ].
	^ result
]
