Extension { #name : #ZnClientTest }

{ #category : #'*Zinc-Tests-Pharo' }
ZnClientTest >> t3EasyGeoIPUrl [
	^ 'http://easy.t3-platform.net/rest/geo-ip' asZnUrl
]

{ #category : #'*Zinc-Tests-Pharo' }
ZnClientTest >> testGetGeoIP [
	| result client |
	result := (client := ZnClient new)
		systemPolicy;
		url: self t3EasyGeoIPUrl;
		queryAt: 'address' put: '81.83.7.35';
		accept: ZnMimeType applicationJson;
		contentReader: [ :entity |
					self class environment
						at: #NeoJSONReader
						ifPresent: [ :parserClass | parserClass fromString: entity contents ]
						ifAbsent: [ ^ self ] ];
		ifFail: [ ^ self fail ];
		get.
	self assert: result isDictionary.
	self assert: (result at: #country) equals: 'BE'.
	client close
]

{ #category : #'*Zinc-Tests-Pharo' }
ZnClientTest >> testJsonRESTGet [
	| client |
	self class environment at: #STONJSON ifAbsent: [ ^ self skip ].
	self withServerDo: [ :server |
		server onRequestRespond: [ :request |
			request method = #GET
				ifTrue: [ ZnResponse ok: (ZnEntity json: '{"name":"pi","symbol":"π","value":3.141592653589793}') ]
				ifFalse: [ ZnResponse badRequest: request ] ].
		(client := ZnClient new)
			forJsonREST;
			get: server localUrl.
		self assert: client isSuccess.
		self assert: (client contents at: #name) equals: 'pi'.
		client close ]
]

{ #category : #'*Zinc-Tests-Pharo' }
ZnClientTest >> testJsonRESTPost [
	| client |
	self class environment at: #STONJSON ifAbsent: [ ^ self skip ].
	self withServerDo: [ :server |
		server onRequestRespond: [ :request |
			request method = #POST
				ifTrue: [
					self assert: request contentType equals: ZnMimeType applicationJson.
					ZnResponse ok: request entity ]
				ifFalse: [ ZnResponse badRequest: request ] ].
		(client := ZnClient new)
			forJsonREST;
			post: server localUrl contents: { #foo->1. #bar->'Test' } asDictionary.
		self assert: client isSuccess.
		self assert: (client contents at: #foo) equals: 1.
		client close ]
]
