Class {
	#name : 'ZnEasyTest',
	#superclass : 'TestCase',
	#category : 'Zinc-Tests',
	#package : 'Zinc-Tests'
}

{ #category : 'accessing' }
ZnEasyTest >> smallHtmlUrl [
	^ 'http://zn.stfx.eu/zn/small.html' asZnUrl
]

{ #category : 'testing' }
ZnEasyTest >> testDelete [
	self
		withServerDo: [ :server |
			| response |
			response := ZnEasy
				delete:
					(server localUrl
						addPathSegments: #('echo' 'foo');
						yourself).
			self assert: response headers contentType equals: ZnMimeType textPlain.
			self assert: response statusLine code equals: 200.
			self assert: (response entity string includesSubstring: 'DELETE').
			self assert: (response entity string includesSubstring: 'foo') ]
]

{ #category : 'testing' }
ZnEasyTest >> testGetSmallHTMLDocument [
	| url response |
	url := self smallHtmlUrl.
	response := ZnEasy get: url.
	self assert: response headers contentType equals: ZnMimeType textHtml.
	self assert: response statusLine code equals: 200.
	self assert: (response entity string includesSubstring: 'small')
]

{ #category : 'testing' }
ZnEasyTest >> testHeadSmallHTMLDocument [
	| url response |
	url := self smallHtmlUrl.
	response := ZnEasy head: url.
	self assert: response headers contentType equals: ZnMimeType textHtml.
	self assert: response statusLine code equals: 200.
	self assert: response hasEntity not
]

{ #category : 'testing' }
ZnEasyTest >> testPost [
	self
		withServerDo: [ :server |
			| response data |
			data := String streamContents: [ :stream | 1 to: 32 do: [ :each | stream nextPut: 'abc' atRandom ] ].
			response := ZnEasy
				post:
					(server localUrl
						addPathSegment: 'echo';
						yourself)
				data: (ZnEntity text: data).
			self assert: response headers contentType equals: ZnMimeType textPlain.
			self assert: response statusLine code equals: 200.
			self assert: (response entity string includesSubstring: 'POST').
			self assert: (response entity string includesSubstring: data) ]
]

{ #category : 'testing' }
ZnEasyTest >> testPostUnicodeUtf8 [
	self
		withServerDo: [ :server |
			| response data |
			data := String streamContents: [ :stream | 0 to: 16r024F do: [ :each | stream nextPut: each asCharacter ] ].
			response := ZnEasy
				post:
					(server localUrl
						addPathSegment: 'echo';
						yourself)
				data: (ZnEntity text: data).
			self assert: response headers contentType equals: ZnMimeType textPlain.
			self assert: response statusLine code equals: 200.
			self assert: (response entity string includesSubstring: 'POST').
			self assert: (response entity string includesSubstring: data) ]
]

{ #category : 'testing' }
ZnEasyTest >> testPut [
	self
		withServerDo: [ :server |
			| response data |
			data := String streamContents: [ :stream | 1 to: 32 do: [ :each | stream nextPut: 'abc' atRandom ] ].
			response := ZnEasy
				put:
					(server localUrl
						addPathSegment: 'echo';
						yourself)
				data: (ZnEntity text: data).
			self assert: response headers contentType equals: ZnMimeType textPlain.
			self assert: response statusLine code equals: 200.
			self assert: (response entity string includesSubstring: 'PUT').
			self assert: (response entity string includesSubstring: data) ]
]

{ #category : 'testing' }
ZnEasyTest >> testTimeout [
	self withServerDo: [ : server |
		self
			should: [
				ZnConnectionTimeout
					value: 1
					during: [ ZnEasy get: (server localUrl addPathSegment: 'echo'; queryAt: 'delay' put: '2'; yourself) ] ]
			raise: ConnectionTimedOut ]
]

{ #category : 'private' }
ZnEasyTest >> withServerDo: block [
	ZnServer withOSAssignedPortDo: block
]
