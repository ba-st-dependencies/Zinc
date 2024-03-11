"
ZnExampleSumRestCallTest contains unit tests for ZnExampleRestCall.
"
Class {
	#name : 'ZnExampleSumRestCallTest',
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
ZnExampleSumRestCallTest >> setUp [
	server := ZnServer startOn: 1700 + 10 atRandom.
	server delegate: 
		(ZnRestServerDelegate new 
			uriSpace: (ZnCallHierarchyRestUriSpace new 
							rootClass: ZnExampleSumRestCall;
							yourself); 
			yourself).
	client := ZnClient new
		url: server localUrl;
		addPathSegment: #sum;
		yourself
]

{ #category : 'running' }
ZnExampleSumRestCallTest >> tearDown [
	client close.
	server stop
]

{ #category : 'testing' }
ZnExampleSumRestCallTest >> testPostSum [
	"Here we test POSTing a text file with a number per line to /sum"
	
	| input output |
	input := #(1 2 3).
	client entity: (ZnEntity text: (String crlf join: input)).
	output := client post.
	self assert: client isSuccess.
	self assert: output equals: input sum asString
]

{ #category : 'testing' }
ZnExampleSumRestCallTest >> testQuerySum [
	"Here we test a GET /sum?numbers=1,2,3"

	| input output |
	input := #(1 2 3).
	client queryAt: #numbers put: ($, join: input).
	output := client get.
	self assert: client isSuccess.
	self assert: output equals: input sum asString
]

{ #category : 'testing' }
ZnExampleSumRestCallTest >> testUriSum [
	"Here we test doing a GET /sum/1/2/3"
	
	| input output |
	input := #(1 2 3).
	input do: [ :each | client addPathSegment: each asString ].
	output := client get.
	self assert: client isSuccess.
	self assert: output equals: input sum asString
]
