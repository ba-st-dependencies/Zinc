"
I am ZnSSOServerDelegate, an example/test using SSO.

(ZnServer startOn: 8100)
	delegate: (ZnSSOServerDelegate new
		facebookData: (ZnOAuth2ConsumerData 
			key: '538399976180189'
			secret: '***************'
			redirectUrl: 'http://localhost:8100/sso-facebook-callback');
		googleData: (ZnOAuth2ConsumerData 
			key: '81499955779.apps.googleusercontent.com'
			secret: '***************'
			redirectUrl: 'http://localhost:8100/sso-google-callback');
		twitterData: (ZnOAuth1ConsumerData newForTwitterAuthentication 
			consumer: '5PAXu9CygKPD0aKwjnGdOA' ;
			consumerSecret: '*********');
		yourself);
	yourself.

"
Class {
	#name : 'ZnSSOServerDelegate',
	#superclass : 'ZnDefaultServerDelegate',
	#instVars : [
		'facebookData',
		'googleData',
		'microsoftData',
		'twitterData',
		'dropboxData',
		'googleOpenIDService',
		'yahooOpenIDService'
	],
	#category : 'Zinc-SSO-Demo',
	#package : 'Zinc-SSO-Demo'
}

{ #category : 'accessing' }
ZnSSOServerDelegate >> dropboxData [
	^ dropboxData
]

{ #category : 'accessing' }
ZnSSOServerDelegate >> dropboxData: anObject [
	dropboxData := anObject
]

{ #category : 'accessing' }
ZnSSOServerDelegate >> dropboxOAuth1Service [

	^ ZnOAuth1Service new
		providerAccount: self dropboxData ;
		yourself
]

{ #category : 'accessing-session' }
ZnSSOServerDelegate >> dropboxSessionFor: aRequest ifAbsent: aBlock [

	^ aRequest session attributeAt: 'dropbox-session' ifAbsent: aBlock
]

{ #category : 'accessing-session' }
ZnSSOServerDelegate >> dropboxSessionFor: aRequest put: anObject [

	^ aRequest session attributeAt: 'dropbox-session' put: anObject
]

{ #category : 'accessing' }
ZnSSOServerDelegate >> facebookData [
	^ facebookData
]

{ #category : 'accessing' }
ZnSSOServerDelegate >> facebookData: anObject [
	facebookData := anObject
]

{ #category : 'accessing-session' }
ZnSSOServerDelegate >> facebookSessionFor: aRequest [
	^ aRequest session 
		attributeAt: 'facebook-session' 
		ifAbsentPut: [ ZnOAuth2Session facebook: self facebookData ]
]

{ #category : 'private' }
ZnSSOServerDelegate >> generateInvalidCallbackRequest [

	| html entity |

	html := String streamContents: [ :stream |
		stream
			nextPutAll: '<h3>Not a valid callback request</h3>' ].

	entity := ZnEntity html: html. 
	^ ZnResponse ok: entity
]

{ #category : 'accessing' }
ZnSSOServerDelegate >> googleData [
	^ googleData
]

{ #category : 'accessing' }
ZnSSOServerDelegate >> googleData: anObject [
	googleData := anObject
]

{ #category : 'accessing' }
ZnSSOServerDelegate >> googleOpenIDService [

	^ googleOpenIDService ifNil: [ googleOpenIDService := ZnOpenIDProvider newGoogleProvider createSession ]
]

{ #category : 'accessing-session' }
ZnSSOServerDelegate >> googleSessionFor: aRequest [
	^ aRequest session 
		attributeAt: 'google-session' 
		ifAbsentPut: [ ZnOAuth2Session google: self googleData ]
]

{ #category : 'private' }
ZnSSOServerDelegate >> htmlPageTitled: title do: block [
	^ String streamContents: [ :stream |
		stream 
			<< '<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html>
<head>
<title>';
			<< title;
			<< '</title>
<style type="text/css">
body {
  color: black;
  background: white;
  width: 900px;
  font-family: Verdana, Arial, Helvetica, sans-serif;
  font-size: 13px;
}
p {
  width: 600px;
  padding: 0 5px 10px 0px;
} 
ul,ol {
  width: 600px;
  padding: 0 5px 5px 30px;
} 
#logo {
  color: orange;
  font-family: Helvetica, sans-serif;
  font-weight: bold;
  font-size: 100px;
}
</style>
</head>
<body>
<div id="logo">Zn</div>
<h1>'; 
			<< title; 
			<<'</h1>'. 
		block value: stream. 
		stream << '</body></html>' ]
]

{ #category : 'initialize-release' }
ZnSSOServerDelegate >> initialize [

	super initialize.
	
	self prefixMap
		at: 'sso-demo' put: #ssoDemo: ;
		at: 'sso-reset' put: #ssoReset: ;
		at: 'sso-google' put: #ssoGoogle: ;
		at: 'sso-google-callback' put: #ssoGoogleCallback: ;
		at: 'sso-google-data' put: #ssoGoogleData: ;
		at: 'sso-facebook' put: #ssoFacebook: ;
		at: 'sso-facebook-callback' put: #ssoFacebookCallback: ;
		at: 'sso-facebook-data' put: #ssoFacebookData: ;
		at: 'sso-microsoft' put: #ssoMicrosoft: ;
		at: 'sso-microsoft-callback' put: #ssoMicrosoftCallback: ;
		at: 'sso-microsoft-data' put: #ssoMicrosoftData: ;
		at: 'sso-twitter' put: #ssoTwitter: ;
		at: 'sso-twitter-callback' put: #ssoTwitterCallback: ;
		at: 'sso-twitter-data' put: #ssoTwitterData: ;
		at: 'sso-dropbox' put: #ssoDropbox: ;
		at: 'sso-dropbox-callback' put: #ssoDropboxCallback: ;
		at: 'sso-dropbox-data' put: #ssoDropboxData: ;
		at: 'sso-openid' put: #ssoOpenID: ;
		at: 'sso-openid-callback' put: #ssoOpenIDCallback: 


]

{ #category : 'testing' }
ZnSSOServerDelegate >> isOAuth2Callback: aRequest [

	^aRequest uri queryKeys includes: 'code'
]

{ #category : 'private' }
ZnSSOServerDelegate >> manipulateDemoFile: dropboxUserAccess [
	"A little DropBox file manipulation demo."
	
	| demoFilePath contents id |
	demoFilePath := #( 'demo.txt' ).
	contents := [ dropboxUserAccess getFile: demoFilePath ] on: Error do: [ nil ].
	id := 0.
	contents ifNotNil: [ 
		contents linesDo: [ :line | | tokens |
			tokens := $: split: line.
			(tokens size >= 2 and: [ tokens first trimBoth = 'id' ])
				ifTrue: [ id := Integer readFrom: tokens second trimBoth ifFail: [ 0 ] ] ] ].
	id := id + 1.
	contents := String streamContents: [ :out |
		out << 'file:demo.txt'; crlf.
		out << 'description:created & updated automatically by ZnSSOServerDelegate>>#manipulateDemoFile:'; crlf.
		out << 'timestamp:'; print: DateAndTime now; crlf.
		out << 'id:'; print: id; crlf ].
	dropboxUserAccess putFile: demoFilePath data: (ZnEntity text: contents).
	^ id 
	
]

{ #category : 'accessing' }
ZnSSOServerDelegate >> microsoftData [
	^ microsoftData
]

{ #category : 'accessing' }
ZnSSOServerDelegate >> microsoftData: anObject [
	microsoftData := anObject
]

{ #category : 'accessing-session' }
ZnSSOServerDelegate >> microsoftSessionFor: aRequest [
	^ aRequest session 
		attributeAt: 'microsoft-session' 
		ifAbsentPut: [ ZnOAuth2Session microsoft: self microsoftData ]
]

{ #category : 'private' }
ZnSSOServerDelegate >> openIdServiceFor: aProviderName [

	aProviderName = 'Google'
		ifTrue: [ ^ self googleOpenIDService ].
		
	aProviderName = 'Yahoo'
		ifTrue: [ ^ self yahooOpenIDService ].
		
	self error: 'Unknown OpenID Provider'
]

{ #category : 'private' }
ZnSSOServerDelegate >> printDictionary: aDictionary asHtmlOn: aStream [

	aStream
		nextPutAll: '<ul>'.
	aDictionary keysAndValuesDo: [ :key :value |
		aStream
			nextPutAll: '<li>' ;
			nextPutAll: key.
		value isDictionary
			ifTrue: [ self printDictionary: value asHtmlOn: aStream ]
			ifFalse: [
				aStream
					nextPutAll: ' --> ' ;
					nextPutAll: value asString ].
		aStream nextPutAll: '</li>' ].
	aStream nextPutAll: '</ul>'
]

{ #category : 'accessing-session' }
ZnSSOServerDelegate >> resetSessions: request [
	#(#google #microsoft #facebook #twitter) do: [ :each | 
			request session removeAttribute: each , '-session' ]
]

{ #category : 'responses' }
ZnSSOServerDelegate >> ssoDemo: request [
	| html session service token |
	html := self
		htmlPageTitled: 'Zinc SSO Demo'
		do: [ :stream | 
			stream << '<h2>OAuth2 Providers</h2>'.
			#(#Google #Facebook )
				do: [ :each |
					session := self perform: (each asLowercase, 'SessionFor:') asSymbol with: request.
					stream
						<< '<a href="';
						<< session authenticationUrl asString;
						<< '" title="Login with ';
						<< each;
						<< '">';
						<< each;
						<< '</a>' ]
				separatedBy: [ stream << ' | ' ].
			stream << '<h2>OAuth1 Providers</h2>'.
			service := self twitterOAuth1Service.
			token := service getRequestTokenFor: request server url / 'sso-twitter-callback'.
			self twitterSessionFor: request put: token.
			stream
				<< '<a href="';
				<< (service loginUrlFor: token) asString;
				<< '" title="Login with ';
				<< #Twitter;
				<< '">';
				<< #Twitter;
				<< '</a>'.
			stream << '<h2>OpenID Providers</h2>'.
			#( Google Yahoo ) 
				do: [ :each |
					stream
						<< '<a href=''sso-openid?provider=' ;
						<< each ;
						<< ''' title=''Login with ' ;
						<< each ;
						<< '''>' ;
						<< each ;
						<< '</a>' ]
				separatedBy: [ stream << ' | ' ].
			stream << '<h4>May the Source be with you!</h4>' ].
	^ ZnResponse ok: (ZnEntity html: html)
]

{ #category : 'responses' }
ZnSSOServerDelegate >> ssoDropbox: request [

	| oauthService requestToken html entity |

	oauthService := self dropboxOAuth1Service.
	
	requestToken := oauthService getRequestToken.
	self dropboxSessionFor: request put: requestToken.
	
	html := self htmlPageTitled: 'Zinc SSO Dropbox Login' do: [ :stream |
		stream
			<< '<h3>Dropbox SSO</h3>' ;
			<< '<a href="' ;
			<< (oauthService loginUrlFor: requestToken callbackUrl: request server url / 'sso-dropbox-callback') asString ;
			<< '">Login with Dropbox</a>' ].

	entity := ZnEntity html: html. 
	^ ZnResponse ok: entity
]

{ #category : 'responses' }
ZnSSOServerDelegate >> ssoDropboxCallback: request [

	| requestToken oauthToken accessToken |

	requestToken := self dropboxSessionFor: request 
		ifAbsent:  [ ^ self generateInvalidCallbackRequest ].

	oauthToken := request uri queryAt: 'oauth_token' ifAbsent: [ nil ].
	
	(oauthToken notNil and: [ oauthToken ~= requestToken value ])
		ifTrue: [ ^ self generateInvalidCallbackRequest ].
	
	accessToken := self dropboxOAuth1Service getAccessToken: requestToken.
	self dropboxSessionFor: request put: accessToken. 

	^ ZnResponse redirect: 'sso-dropbox-data'
]

{ #category : 'responses' }
ZnSSOServerDelegate >> ssoDropboxData: request [

	|  accessToken userAccess accountInfo rootInfo id html entity |
	
	accessToken := self dropboxSessionFor: request
		ifAbsent: [ ^ self generateInvalidCallbackRequest ].
		
	userAccess := ZnOAuth1DropboxUserAccess new
		oauth1Service: self dropboxOAuth1Service ;
		accessToken: accessToken.
		
	accountInfo := userAccess getAccountInfo.
	id := self manipulateDemoFile: userAccess.
	rootInfo := userAccess getRootInfo.
	
	html := self htmlPageTitled: 'Zinc SSO Dropbox Account Info' do: [ :stream | 
		stream << '<h3>Dropbox Account Info</h3>'.
		self printDictionary: accountInfo asHtmlOn: stream.
		stream << '<h3>Dropbox Root Info</h3>'.
		self printDictionary: rootInfo asHtmlOn: stream.
		stream << ('<h5>demo.txt manipulation id {1}</h5>' format: { id }).
		stream << '<p><a href="sso-reset?target=sso-dropbox">Reset</a></p>' ].

	entity := ZnEntity html: html. 
	^ ZnResponse ok: entity
]

{ #category : 'responses' }
ZnSSOServerDelegate >> ssoFacebook: request [

	| facebookSession html entity |

	facebookSession := self facebookSessionFor: request.
		
	html := self htmlPageTitled: 'Zinc SSO Facebook Login' do:  [ :stream |
		stream
			<< '<h3>Facebook SSO</h3>' ;
			<< '<a href="' ;
			<< facebookSession authenticationUrl asString ;
			<< '">Login with Facebook</a>' ].

	entity := ZnEntity html: html. 
	^ ZnResponse ok: entity
]

{ #category : 'responses' }
ZnSSOServerDelegate >> ssoFacebookCallback: request [

	| facebookSession |
	
	(self isOAuth2Callback: request)
		ifFalse: [ ^ self generateInvalidCallbackRequest ].
	
	facebookSession := self facebookSessionFor: request.
	facebookSession handleAuthenticationCallback: request uri query.
	
	^ ZnResponse redirect: 'sso-facebook-data'
]

{ #category : 'responses' }
ZnSSOServerDelegate >> ssoFacebookData: request [

	| facebookSession userData html entity |
	
	facebookSession := self facebookSessionFor: request.
	userData := facebookSession getUserData.

	html := self htmlPageTitled: 'Zinc SSO Facebook UserData' do: [ :stream | 
		stream << '<h3>Facebook UserData</h3>'.
		self printDictionary: userData asHtmlOn: stream.
		stream << '<a href="sso-reset">Reset</a>' ].

	entity := ZnEntity html: html. 
	^ ZnResponse ok: entity
]

{ #category : 'responses' }
ZnSSOServerDelegate >> ssoGoogle: request [

	| googleSession html entity |
	
	googleSession := self googleSessionFor: request.
		
	html := self htmlPageTitled: 'Zinc SSO Google Login' do: [ :stream |
		stream
			<< '<h3>Google SSO</h3>' ;
			<< '<a href="' ;
			<< googleSession authenticationUrl asString ;
			<< '">Login with Google</a>' ].

	entity := ZnEntity html: html. 
	^ ZnResponse ok: entity
]

{ #category : 'responses' }
ZnSSOServerDelegate >> ssoGoogleCallback: request [

	| googleSession |
	
	(self isOAuth2Callback: request)
		ifFalse: [ ^ self generateInvalidCallbackRequest ].

	googleSession := self googleSessionFor: request.
	googleSession handleAuthenticationCallback: request uri query.

	^ ZnResponse redirect: 'sso-google-data'
]

{ #category : 'responses' }
ZnSSOServerDelegate >> ssoGoogleData: request [

	| googleSession userData html entity |
	
	googleSession := self googleSessionFor: request.
	userData := googleSession getUserData.

	html := self htmlPageTitled: 'Zinc SSO Google UserData' do: [ :stream | 
		stream << '<h3>Google UserData</h3>'.
		self printDictionary: userData asHtmlOn: stream.
		stream << '<a href="sso-reset">Reset</a>'  ].

	entity := ZnEntity html: html. 
	^ ZnResponse ok: entity
]

{ #category : 'responses' }
ZnSSOServerDelegate >> ssoMicrosoft: request [

	| microsoftSession html entity |

	microsoftSession := self microsoftSessionFor: request.
		
	html := self htmlPageTitled: 'Zinc SSO Microsoft Login' do: [ :stream |
		stream
			<< '<h3>Microsoft SSO</h3>' ;
			<< '<a href="' ;
			<< microsoftSession authenticationUrl asString ;
			<< '">Login with Microsoft</a>' ].

	entity := ZnEntity html: html. 
	^ ZnResponse ok: entity
]

{ #category : 'responses' }
ZnSSOServerDelegate >> ssoMicrosoftCallback: request [

	| microsoftSession |
	
	(self isOAuth2Callback: request)
		ifFalse: [ ^ self generateInvalidCallbackRequest ].

	microsoftSession := self microsoftSessionFor: request.
	microsoftSession handleAuthenticationCallback: request uri query.

	^ ZnResponse redirect: 'sso-microsoft-data'
]

{ #category : 'responses' }
ZnSSOServerDelegate >> ssoMicrosoftData: request [

	| microsoftSession userData html entity |
	
	microsoftSession := self microsoftSessionFor: request.
	userData := microsoftSession getUserData.

	html := self htmlPageTitled: 'Zinc SSO Microsoft UserData' do: [ :stream | 
		stream << '<h3>Microsoft UserData</h3>'.
		self printDictionary: userData asHtmlOn: stream .
		stream << '<a href="sso-reset">Reset</a>' ].

	entity := ZnEntity html: html. 
	^ ZnResponse ok: entity
]

{ #category : 'responses' }
ZnSSOServerDelegate >> ssoOpenID: request [

	| service serverUrl callbackUrl authUrl |
	
	service := self openIdServiceFor: (request url queryAt: 'provider' ifAbsent: [ nil ]).

	serverUrl  := request server url.
	callbackUrl := (serverUrl / 'sso-openid-callback')
		queryAt: 'provider' put: (request url queryAt: 'provider') ;
		yourself.
	
	authUrl := service getAuthenticationRequestUrl: callbackUrl do: [ :authRequest |
		authRequest realm: serverUrl asString.
		authRequest axRequestNamesAndEmail
		"self openIDoptionsForm updateAuthenticationRequest: authRequest "].
	
	^ ZnResponse redirect: authUrl
]

{ #category : 'responses' }
ZnSSOServerDelegate >> ssoOpenIDCallback: request [

	| service authResponse html |

	service := self openIdServiceFor: (request url queryAt: 'provider' ifAbsent: [ nil ]).
	
	authResponse := service getValidatedAuthenticationResponseFrom:	request url query.
		
	html := self htmlPageTitled: 'Zinc SSO OpenID result for ', service providerName do: [ :stream | 
		stream << '<h3>' ; << service providerName ; << ' result</h3>'.
		self printDictionary: authResponse properties asHtmlOn: stream .
		stream << '<a href="sso-reset">Reset</a>' ].

	^ ZnResponse ok: (ZnEntity html: html)
]

{ #category : 'responses' }
ZnSSOServerDelegate >> ssoReset: request [
	| target |
	self resetSessions: request.
	target := request uri queryAt: #target ifAbsent: [ 'sso-demo' ].
	^ ZnResponse redirect: target
]

{ #category : 'responses' }
ZnSSOServerDelegate >> ssoTwitter: request [

	| oauthService requestToken html entity |

	oauthService := self twitterOAuth1Service.
	
	requestToken := oauthService getRequestTokenFor: request server url / 'sso-twitter-callback'.
	self twitterSessionFor: request put: requestToken.
	
	html := self htmlPageTitled: 'Zinc SSO Twitter Login' do: [ :stream |
		stream
			<< '<h3>Twitter SSO</h3>' ;
			<< '<a href="' ;
			<< (oauthService loginUrlFor: requestToken) asString ;
			<< '">Login with Twitter</a>' ].

	entity := ZnEntity html: html. 
	^ ZnResponse ok: entity
]

{ #category : 'responses' }
ZnSSOServerDelegate >> ssoTwitterCallback: request [

	| requestToken oauthToken oauthVerifier accessToken |

	requestToken := self twitterSessionFor: request 
		ifAbsent:  [ ^ self generateInvalidCallbackRequest ].

	oauthToken := request uri queryAt: 'oauth_token'.
	oauthVerifier := request uri queryAt: 'oauth_verifier'.
	
	(oauthToken isNil or: [ oauthVerifier isNil])
		ifTrue: [ ^ self generateInvalidCallbackRequest ].
		
	oauthToken = requestToken value
		ifFalse: [ ^ self generateInvalidCallbackRequest ].
	
	accessToken := self twitterOAuth1Service getAccessToken: requestToken verifier: oauthVerifier.
	self twitterSessionFor: request put: accessToken. 

	^ ZnResponse redirect: 'sso-twitter-data'
]

{ #category : 'responses' }
ZnSSOServerDelegate >> ssoTwitterData: request [

	|  accessToken userData html entity |
	
	accessToken := self twitterSessionFor: request
		ifAbsent: [ ^ self generateInvalidCallbackRequest ].
		
	userData := ZnOAuth1TwitterUserAccess new
		oauth1Service: self twitterOAuth1Service ;
		accessToken: accessToken ;
		accountVerifyCredentials.
	
	html := self htmlPageTitled: 'Zinc SSO Twitter UserData' do: [ :stream | 
		stream << '<h3>Twitter UserData</h3>'.
		self printDictionary: userData asHtmlOn: stream .
		stream << '<a href="sso-reset">Reset</a>' ].

	entity := ZnEntity html: html. 
	^ ZnResponse ok: entity
]

{ #category : 'accessing' }
ZnSSOServerDelegate >> twitterData [

	^ twitterData
]

{ #category : 'accessing' }
ZnSSOServerDelegate >> twitterData: aConsumerData [

	twitterData := aConsumerData
]

{ #category : 'accessing' }
ZnSSOServerDelegate >> twitterOAuth1Service [

	^ ZnOAuth1Service new
		providerAccount: self twitterData ;
		yourself
]

{ #category : 'accessing-session' }
ZnSSOServerDelegate >> twitterSessionFor: aRequest ifAbsent: aBlock [

	^ aRequest session attributeAt: 'twitter-session' ifAbsent: aBlock
]

{ #category : 'accessing-session' }
ZnSSOServerDelegate >> twitterSessionFor: aRequest put: anObject [

	^ aRequest session attributeAt: 'twitter-session' put: anObject
]

{ #category : 'accessing' }
ZnSSOServerDelegate >> yahooOpenIDService [

	^ yahooOpenIDService ifNil: [ yahooOpenIDService := ZnOpenIDProvider newYahooProvider createSession ]
]
