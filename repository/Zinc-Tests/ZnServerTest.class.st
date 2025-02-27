Class {
	#name : 'ZnServerTest',
	#superclass : 'TestCase',
	#category : 'Zinc-Tests',
	#package : 'Zinc-Tests'
}

{ #category : 'testing' }
ZnServerTest >> assertEntityTooLarge: serverUrl [
	| response client |
	client := ZnClient new
		url: serverUrl;
		addPathSegment: #echo;
		entity: (ZnEntity with: (ByteArray new: self entitySizeLimit + 1));
		yourself.
	response := client
		post;
		response.
	client close.
	self deny: response isSuccess.
	self assert: response code equals: 400.
	self assert: response contentType equals: ZnMimeType textPlain.
	self assert: (response entity contents includesSubstring: 'ZnEntityTooLarge')
]

{ #category : 'testing' }
ZnServerTest >> assertHeaderLineTooLong: serverUrl [
	| response client |
	client := ZnClient new
		url: serverUrl;
		addPathSegment: #echo;
		headerAt: 'X-Test' put: (String new: ZnConstants maximumLineLength withAll: $X);
		yourself.
	response := client
		get;
		response.
	client close.
	self deny: response isSuccess.
	self assert: response code equals: 400.
	self assert: response contentType equals: ZnMimeType textPlain.
	self assert: (response entity contents includesSubstring: 'ZnLineTooLong')
]

{ #category : 'testing' }
ZnServerTest >> assertRequestLineTooLong: serverUrl [
	| url response |
	url := serverUrl
		addPathSegment: #echo;
		addPathSegment: (String new: ZnConstants maximumLineLength withAll: $X);
		yourself.
	response := ZnEasy get: url.
	self deny: response isSuccess.
	self assert: response code equals: 400.
	self assert: response contentType equals: ZnMimeType textPlain.
	self assert: (response entity contents includesSubstring: 'ZnLineTooLong')
]

{ #category : 'testing' }
ZnServerTest >> assertTooManyHeaders: serverUrl [
	| response client |
	client := ZnClient new
		url: serverUrl;
		addPathSegment: #echo;
		yourself.
	client request headers unlimited.
	1 to: 256 do: [ :each | client headerAt: 'X-Test-' , each printString put: each printString ].
	response := client
		get;
		response.
	client close.
	self deny: response isSuccess.
	self assert: response code equals: 400.
	self assert: response contentType equals: ZnMimeType textPlain.
	self assert: (response entity contents includesSubstring: 'ZnTooManyDictionaryEntries')
]

{ #category : 'accessing' }
ZnServerTest >> entitySizeLimit [
	^ 1024
]

{ #category : 'private' }
ZnServerTest >> port [
	^ 1700 + 32 atRandom
]

{ #category : 'testing' }
ZnServerTest >> testAuthorizationFailed [
	self
		withServerDo: [ :server |
			| response |
			server authenticator: (ZnBasicAuthenticator username: 'foo' password: 'secret').
			response := ZnEasy
				get:
					(server localUrl
						addPathSegment: 'echo';
						yourself).
			self assert: response headers contentType equals: ZnMimeType textPlain.
			self assert: response statusLine code equals: 401.
			self assert: ((response headers at: 'WWW-Authenticate') includesSubstring: 'Basic').
			self assert: ((response headers at: 'WWW-Authenticate') includesSubstring: 'Zinc') ]
]

{ #category : 'testing' }
ZnServerTest >> testAuthorizationSuccessful [
	self
		withServerDo: [ :server |
			| response |
			server authenticator: (ZnBasicAuthenticator username: 'foo' password: 'secret').
			response := ZnEasy
				get:
					(server localUrl
						addPathSegments: #('echo' 'foo');
						yourself)
				username: 'foo'
				password: 'secret'.
			self assert: response headers contentType equals: ZnMimeType textPlain.
			self assert: response statusLine code equals: 200.
			self assert: (response entity string includesSubstring: 'Zinc').
			self assert: (response entity string includesSubstring: 'foo') ]
]

{ #category : 'testing' }
ZnServerTest >> testCustomDefaultDelegate [
	self withServerDo: [ :server | | customDelegate client |
		customDelegate := ZnDefaultServerDelegate empty.
		customDelegate
			map: 'ok' to: [ :request | ZnResponse ok: (ZnEntity text: 'OK') ];
			map: '/' to: 'ok';
			map: 'OK' to: [ :request | ZnResponse redirect: '/ok' ].
		server delegate: customDelegate.
		client := ZnClient new url: server localUrl.
		self assert: client get equals: 'OK'.
		client addPath: 'OK'.
		self assert: client get equals: 'OK'.
		client close	 ]
]

{ #category : 'testing' }
ZnServerTest >> testCustomServerString [
	self withServerDo: [ :server | | client |
		server localOptions at: #serverString put: 'foobar server'.
		(client := ZnClient new)
			get: server localUrl;
			close.
		self assert: (client response headers at: 'Server') equals: 'foobar server' ]
]

{ #category : 'testing' }
ZnServerTest >> testDefault [
	| port server initialDefaultServer wasRunning |
	wasRunning := ZnServer default ifNil: [ false ] ifNotNil: [ ZnServer default isRunning ].
	initialDefaultServer := ZnServer stopDefault.
	self assert: ZnServer default isNil.
	port := self port.
	server := ZnServer startDefaultOn: port.
	self assert: ZnServer default isNotNil.
	self assert: ZnServer default identicalTo: server.
	self assert: ZnServer default port equals: port.
	self assert: ZnServer default isRunning.
	self assert: (ZnServer managedServers includes: server).
	ZnServer stopDefault.
	self assert: ZnServer default isNil.
	self deny: server isRunning.
	self deny: (ZnServer managedServers includes: server).
	server := ZnServer startDefaultOn: port.
	"Starting the default again is actually a restart"
	ZnServer startDefaultOn: port.
	self assert: ZnServer default identicalTo: server.
	ZnServer stopDefault.
	ZnServer adoptAsDefault: initialDefaultServer.
	self assert: initialDefaultServer identicalTo: ZnServer default.
	wasRunning ifTrue: [ ZnServer default start ]
]

{ #category : 'testing' }
ZnServerTest >> testEcho [
	self
		withServerDo: [ :server |
			| response |
			response := ZnEasy
				get:
					(server localUrl
						addPathSegments: #('echo' 'foo');
						yourself).
			self assert: response contentType equals: ZnMimeType textPlain.
			self assert: response statusLine code equals: 200.
			self assert: (response entity contents includesSubstring: 'Zinc').
			self assert: (response entity contents includesSubstring: 'foo').
			self assert: (response entity contents includesSubstring: server printString) ]
]

{ #category : 'testing' }
ZnServerTest >> testEchoBinary [
	self
		withServerDo: [ :server |
			| response entityIn entityOut |
			server reader: [ :stream | ZnRequest readBinaryFrom: stream ].
			entityIn := ZnEntity with: 'ABC' type: 'text/plain'.
			response := ZnEasy
				put:
					(server localUrl
						addPathSegment: 'echo';
						yourself)
				data: entityIn.
			self assert: response contentType equals: ZnMimeType textPlain.
			self assert: response statusLine code equals: 200.
			entityOut := ZnEntity with: entityIn string asByteArray type: entityIn contentType.
			self assert: (response entity contents includesSubstring: entityOut printString) ]
]

{ #category : 'testing' }
ZnServerTest >> testEchoLocalInterface [
	| server response |
	(server := ZnServer on: self port) bindingAddress: ZnNetworkingUtils default socketAddressClass loopBackAddress.
	[ server start.
	self assert: server isRunning & server isListening description: ('Failed to start server on port <1p>. Is there one already?' expandMacrosWith: server port).
	response := ZnEasy
		get:
			(server localUrl
				addPathSegments: #('echo' 'foo');
				yourself).
	self assert: response contentType equals: ZnMimeType textPlain.
	self assert: response statusLine code equals: 200.
	self assert: (response entity contents includesSubstring: 'Zinc').
	self assert: (response entity contents includesSubstring: 'foo') ]
		ensure: [ server stop ]
]

{ #category : 'testing' }
ZnServerTest >> testEntityTooLarge [

	self withServerDo: [ :server |
		server maximumEntitySize: self entitySizeLimit.
		self deny: server debugMode.
		self assertEntityTooLarge: server localUrl ]
]

{ #category : 'testing' }
ZnServerTest >> testError [
	self withServerDo: [ :server | | url response |
		self deny: server debugMode.
		url := server localUrl
					addPathSegment: #error;
					queryAt: #message put: 'Test Error';
					yourself.
		response := ZnEasy get: url.
		self deny: response isSuccess.
		self assert: response code equals: 500.
		self assert: response contentType equals: ZnMimeType textPlain.
		self assert: (response entity contents includesSubstring: 'Test Error') ]
]

{ #category : 'testing' }
ZnServerTest >> testFormTest1 [
	| inputs client |
	inputs := #( '1+2=3 & 2+1=3' 'single ''' 'double " - cool ?' 'élèves français' 'Ελλάδα' ).
	self withServerDo: [ :server |
		(client := ZnClient new)
			url: server localUrl;
			addPathSegment: 'form-test-1'.
		inputs do: [ :each  |
			client
				queryAt: #input put: each;
				get.
			self assert: client isSuccess.
			self assert: (client contents includesSubstring: each) ] ]
]

{ #category : 'testing' }
ZnServerTest >> testFormTest2 [
	| inputs client |
	inputs := #( '1+2=3 & 2+1=3' 'single ''' 'double " - cool ?' 'élèves français' 'Ελλάδα' ).
	self withServerDo: [ :server |
		(client := ZnClient new)
			url: server localUrl;
			addPathSegment: 'form-test-2'.
		inputs do: [ :each  |
			client
				formAt: #input put: each;
				post.
			self assert: client isSuccess.
			self assert: (client contents includesSubstring: each) ] ]
]

{ #category : 'testing' }
ZnServerTest >> testFormTest3 [
	| inputs client part |
	inputs := #( ('foo.txt' 'this is foo!') ('français.txt' 'Je te dis: élèves français') ('Ελλάδα.txt' 'Ελλάδα is it!') ).
	self withServerDo: [ :server |
		server debugMode: true.
		(client := ZnClient new)
			url: server localUrl;
			addPathSegment: 'form-test-3'.
		inputs do: [ :each  |
			part := ZnMimePart
				fieldName: 'file'
				fileName: each first
				entity: (ZnEntity with: each second).
			client
				resetEntity;
				addPart: part;
				post.
			self assert: client isSuccess.
			self assert: (client contents includesSubstring: each first).
			self assert: (client contents includesSubstring: each second) ] ]
]

{ #category : 'testing' }
ZnServerTest >> testFormTest3Unspecified [
	"Simulate what most browsers seem to do: upload text files utf-8 encoded
	without specifying the charset in the mime type of the mime part"

	| inputs client part entity |
	inputs := #( ('foo.txt' 'this is foo!') ('français.txt' 'Je te dis: élèves français') ('Ελλάδα.txt' 'Ελλάδα is it!') ).
	self withServerDo: [ :server |
		server debugMode: true.
		(client := ZnClient new)
			url: server localUrl;
			addPathSegment: 'form-test-3'.
		inputs do: [ :each  |
			entity := ZnEntity
				with: each second utf8Encoded
				type: ZnMimeType textPlain clearCharSet.
			part := ZnMimePart fieldName: 'file' fileName: each first entity: entity.
			client
				resetEntity;
				addPart: part;
				post.
			self assert: client isSuccess.
			self assert: (client contents includesSubstring: each first).
			self assert: (client contents includesSubstring: each second) ] ]
]

{ #category : 'testing' }
ZnServerTest >> testGetConflictingConnectionHeader [
	self withServerDo: [ :server | | client |
		client := ZnClient new.
		client url: server localUrl; addPathSegment: #echo.
		"There are not supposed to be 2 Connection headers, the last one should win"
		client headerAt: 'Connection' add: 'keep-alive'.
		client headerAt: 'Connection' add: 'close'.
		client get.
		self assert: client isSuccess.
		self assert: (client contents includesSubstring: 'echo').
		self assert: client response isConnectionClose.
		client close ]
]

{ #category : 'testing' }
ZnServerTest >> testGetConnectionClose [
	self withServerDo: [ :server | | client |
		client := ZnClient new.
		client url: server localUrl; addPathSegment: #echo.
		client request setConnectionClose.
		client get.
		self assert: client isSuccess.
		self assert: (client contents includesSubstring: 'echo').
		self assert: client response isConnectionClose.
		client close ]
]

{ #category : 'testing' }
ZnServerTest >> testGetUnicodeUtf8 [
	self
		withServerDo: [ :server |
			| response html |
			response := ZnEasy
				get:
					(server localUrl
						addPathSegment: 'unicode';
						yourself).
			self assert: response contentType equals: ZnMimeType textHtml.
			self assert: response statusLine code equals: 200.
			self assert: response contentType isCharSetUTF8.
			html := response entity contents.
			self assert: (html includesSubstring: 'Unicode').
			0 to: 16r024F do: [ :each | self assert: (html includes: each asCharacter) ] ]
]

{ #category : 'testing' }
ZnServerTest >> testHeaderLineTooLong [

	self withServerDo: [ :server |
		self deny: server debugMode.
		self assertHeaderLineTooLong: server localUrl ]
]

{ #category : 'testing' }
ZnServerTest >> testLocalUrl [
	self withServerDo: [ :server |
		self assert: server localUrl scheme equals: #http.
		self assert: server localUrl host equals: ZnNetworkingUtils default socketAddressClass loopBackName.
		self assert: server localUrl port equals: server port ]
]

{ #category : 'tests' }
ZnServerTest >> testLogging [
	| client logEventCollection count renderedLogEvents |
	logEventCollection := OrderedCollection new.
	ZnLogEvent announcer
		when: ZnLogEvent do: [ :event | logEventCollection add: event ] for: self.
	[ 1 to: 3 do: [ :logLevel |
			self withServerDo: [ :server |
				server serverId: ('S' , logLevel asString) ; logLevel: logLevel.
				client := ZnClient new.
				client clientId: ('C' , logLevel asString); logLevel: logLevel.
				client get: (server localUrl addPathSegment: #small).
				self assert: client isSuccess.
				client get: (server localUrl addPathSegment: #error).
				self deny: client isSuccess.
				client close ] ].
		count := ZnLogEvent announcer numberOfSubscriptions ]
	ensure: [
		ZnLogEvent announcer
			unsubscribe: self ].
	self assert: ZnLogEvent announcer numberOfSubscriptions equals: count -1.
	self deny: logEventCollection isEmpty.
]

{ #category : 'testing' }
ZnServerTest >> testOSAssignedPort [
	| server |
	server := ZnServer on: 0.
	self assert: server port equals: 0.
	[ | response |
	server start.
	self assert: server port > 0.
	response := ZnEasy get: server localUrl / #echo / #foo.
	self assert: response contentType equals: ZnMimeType textPlain.
	self assert: response statusLine code equals: 200.
	self assert: (response entity contents includesSubstring: 'Zinc').
	self assert: (response entity contents includesSubstring: 'foo').
	self assert: (response entity contents includesSubstring: server printString) ]
		ensure: [ server stop ]
]

{ #category : 'testing' }
ZnServerTest >> testRequestLineTooLong [

	self withServerDo: [ :server |
		self deny: server debugMode.
		self assertRequestLineTooLong: server localUrl ]
]

{ #category : 'testing' }
ZnServerTest >> testRespond [
	self withServerDo: [ :server | | client |
		server onRequestRespond: [ :request |
			ZnRespond signalWith: (ZnResponse ok: (ZnEntity text: 'RESPONDED')).
			ZnResponse notFound: request uri ].
		client := ZnClient new.
		client get: server localUrl.
		self assert: client isSuccess.
		self assert: client response contentType equals: ZnMimeType textPlain.
		self assert: client contents equals: 'RESPONDED'.
		client close ]
]

{ #category : 'testing' }
ZnServerTest >> testSession [
	self
		withServerDo: [ :server |
			| client sessionId |
			client := ZnClient new
				url: (server localUrl addPathSegment: #session);
				yourself.
			self assert: client session cookieJar cookies isEmpty.
			client get.
			self assert: client isSuccess.
			self assert: client session cookieJar cookies size equals: 1.
			sessionId := client session cookieJar cookies anyOne value.
			self assert: (client contents includesSubstring: sessionId).
			client get.
			self assert: client isSuccess.
			self assert: client session cookieJar cookies size equals: 1.
			self assert: client session cookieJar cookies anyOne value equals: sessionId.
			self assert: (client contents includesSubstring: sessionId) ]
]

{ #category : 'testing' }
ZnServerTest >> testSessionExpired [
	self
		withServerDo: [ :server |
			| client sessionId |
			client := ZnClient new
				url: (server localUrl addPathSegment: #session);
				yourself.
			self assert: client session cookieJar cookies isEmpty.
			client get.
			self assert: client isSuccess.
			self assert: client session cookieJar cookies size equals: 1.
			sessionId := client session cookieJar cookies anyOne value.
			self assert: (client contents includesSubstring: sessionId).
			"Kill the server session as if it was expired"
			server sessionManager removeSessionWithId: sessionId.
			"The client still presents the old session id but should get a new one"
			client get.
			self assert: client isSuccess.
			self assert: client session cookieJar cookies size equals: 1.
			self deny: client session cookieJar cookies anyOne value equals: sessionId ]
]

{ #category : 'testing' }
ZnServerTest >> testSessionRoute [
	self
		withServerDo: [ :server |
			| client sessionId |
			server route: 'r1'.
			self assert: server route equals: 'r1'.
			client := ZnClient new
				url: (server localUrl addPathSegment: #session);
				yourself.
			self assert: client session cookieJar cookies isEmpty.
			client get.
			self assert: client isSuccess.
			self assert: client session cookieJar cookies size equals: 1.
			sessionId := client session cookieJar cookies anyOne value.
			self assert: (client contents includesSubstring: sessionId).
			self assert: (sessionId endsWith: '.r1').
			client get.
			self assert: client isSuccess.
			self assert: client session cookieJar cookies size equals: 1.
			self assert: client session cookieJar cookies anyOne value equals: sessionId.
			self assert: (client contents includesSubstring: sessionId) ]
]

{ #category : 'testing' }
ZnServerTest >> testSmall [
	self withServerDo: [ :server |
		| client |
		client := ZnClient new
			url: (server localUrl addPathSegment: #small);
			yourself.
		client get.
		self assert: client isSuccess.
		self assert: client response contentType equals: ZnMimeType textHtml.
		self assert: (client contents includesSubstring: 'Small').
		self assert: (client contents includesSubstring: 'This is a small HTML document').
		client close ]
]

{ #category : 'testing' }
ZnServerTest >> testTooManyConcurrentConnections [

	self withServerDo: [ :server |
		| client clients |
		self deny: server debugMode.
		server maximumNumberOfConcurrentConnections: 4.
		clients := (1 to: 4) collect: [ :each |
			           ZnClient new
				           url: server localUrl;
				           addPathSegment: #random;
				           clientId: ('client-<1p>}' expandMacrosWith: each );
				           enforceHttpSuccess;
				           get;
				           yourself ].
		client := ZnClient new
			          url: server localUrl;
			          addPathSegment: #random;
			          clientId: 'client-5';
			          get;
			          yourself.
		self assert: client response code equals: 503.
		clients do: [ :each |
			each
				get;
				close ].
		client get.
		self assert: client isSuccess.
		client close ]
]

{ #category : 'testing' }
ZnServerTest >> testTooManyHeaders [

	self withServerDo: [ :server |
		self deny: server debugMode.
		self assertTooManyHeaders: server localUrl ]
]

{ #category : #testing }
ZnServerTest >> testUrl [
	self withServerDo: [ :server |
		self assert: server url equals: server localUrl.
		server serverUrl:
					(ZnUrl new
						host: 'zn.stfx.eu';
						yourself).
		self assert: server url scheme equals: #http.
		self assert: server url host equals: 'zn.stfx.eu'.
		self assert: server url port equals: server port.
		server serverUrl: 'http://zn.stfx.eu:8080/zn'.
		self assert: server url scheme equals: #http.
		self assert: server url host equals: 'zn.stfx.eu'.
		self assert: server url port equals: 8080.
		self assert: server url path equals: 'zn' ]
]

{ #category : 'testing' }
ZnServerTest >> testZeroContentLength [
	self withServerDo: [ :server |
		| client |
		client := ZnClient new
			url: server localUrl / #echo;
			yourself.
		"Force a bogus zero content-length header"
		client headerAt: 'Content-Length' put: '0'.
		client get.
		self assert: client isSuccess.
		client close ]
]

{ #category : 'private' }
ZnServerTest >> withServerDo: block [
	ZnServer withOSAssignedPortDo: block
]
