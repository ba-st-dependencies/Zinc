Class {
	#name : 'ZnHttpClientDummy',
	#superclass : 'Object',
	#instVars : [
		'url',
		'responses',
		'response'
	],
	#category : 'Zinc-SSO-OpenID-Tests',
	#package : 'Zinc-SSO-OpenID-Tests'
}

{ #category : 'instance creation' }
ZnHttpClientDummy class >> new [
	^super new initialize
]

{ #category : 'api' }
ZnHttpClientDummy >> get [

	response := responses at: url.
	^ response contents
]

{ #category : 'initialize-release' }
ZnHttpClientDummy >> initialize [ 
	super initialize.
	responses := Dictionary new.
]

{ #category : 'api' }
ZnHttpClientDummy >> response [

	^ response
]

{ #category : 'initialize-release' }
ZnHttpClientDummy >> responseForGet: endpointUrl content: aString [

	responses
		at: endpointUrl
		put: 	(ZnResponse ok: (ZnStringEntity xml: aString))
]

{ #category : 'api' }
ZnHttpClientDummy >> url: anObject [

	url := anObject.
	response := nil
]
