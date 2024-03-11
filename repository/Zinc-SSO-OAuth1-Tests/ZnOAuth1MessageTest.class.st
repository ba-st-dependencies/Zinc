Class {
	#name : 'ZnOAuth1MessageTest',
	#superclass : 'TestCase',
	#category : 'Zinc-SSO-OAuth1-Tests',
	#package : 'Zinc-SSO-OAuth1-Tests'
}

{ #category : 'private' }
ZnOAuth1MessageTest >> signStringSHA1: aString usingSecret: aSecret [ 

	^ ZnOAuth1AuthorizationCalculator signStringSHA1: aString usingSecret: aSecret
]

{ #category : 'tests' }
ZnOAuth1MessageTest >> testGoogleSignature [

	| baseString key |
	
	baseString := 'GET&https%3A%2F%2Fwww.google.com%2Faccounts%2FOAuthGetRequestToken&oauth_callback%3Dhttp%253A%252F%252Fgooglecodesamples.com%252Foauth_playground%252Findex.php%26oauth_consumer_key%3Dtest2.doit.st%26oauth_nonce%3Daf4aa64aafe3b959d0b249225ee887a8%26oauth_signature_method%3DHMAC-SHA1%26oauth_timestamp%3D1297166598%26oauth_version%3D1.0%26scope%3Dhttps%253A%252F%252Fwww.google.com%252Fcalendar%252Ffeeds%252F'.
	
	key := 'jXGgXXXXXXn28YYYYYavPHq&'.
	
	self assert: (self signStringSHA1: baseString usingSecret: key) = 'r4ELOrYf9Oqd2YhOu85hXs81muY='
		

]

{ #category : 'tests' }
ZnOAuth1MessageTest >> testTwitterCalculator [
	"Example from: https://dev.twitter.com/docs/auth/creating-signature"

	| calculator request header |
	
	calculator := ZnOAuth1AuthorizationCalculator new
		consumerKey: 'xvz1evFS4wEEPTGEFPHBog' ;
		consumerSecret: 'kAcSOqF21Fu85e7zjz7ZN2U4ZRhfV3WpwPAoE3Z7kBw' ;
		token: '370773112-GmHxMAgYyLbNEtIKZeRNFsMKPR9EyMZeS9weJAEb' ;
		tokenSecret: 'LswwdoUaIvS8ltyTt5jkRh4J50vUPVVHtR2YPi5kE' ;
		nonce: 'kYjzVBB8Y0ZFabxSWbWovY3uYSQ2pTgmZeNu2VS4cg' ;
		timestamp: '1318622958' ;
		yourself.
	
	self assert: calculator getSignatureKey = 'kAcSOqF21Fu85e7zjz7ZN2U4ZRhfV3WpwPAoE3Z7kBw&LswwdoUaIvS8ltyTt5jkRh4J50vUPVVHtR2YPi5kE'.

	request := (ZnRequest post: 'https://api.twitter.com/1/statuses/update.json?include_entities=true')
		entity: (ZnApplicationFormUrlEncodedEntity new
			at: 'status' put: 'Hello Ladies + Gentlemen, a signed OAuth request!' ;
			yourself) ;
		yourself.
		
	self assert: (calculator getBaseString: request with: calculator getOAuthParameters) =
		'POST&https%3A%2F%2Fapi.twitter.com%2F1%2Fstatuses%2Fupdate.json&include_entities%3Dtrue%26oauth_consumer_key%3Dxvz1evFS4wEEPTGEFPHBog%26oauth_nonce%3DkYjzVBB8Y0ZFabxSWbWovY3uYSQ2pTgmZeNu2VS4cg%26oauth_signature_method%3DHMAC-SHA1%26oauth_timestamp%3D1318622958%26oauth_token%3D370773112-GmHxMAgYyLbNEtIKZeRNFsMKPR9EyMZeS9weJAEb%26oauth_version%3D1.0%26status%3DHello%2520Ladies%2520%252B%2520Gentlemen%252C%2520a%2520signed%2520OAuth%2520request%2521'.
	
	header := calculator getAuthorizationHeader: request.
	self assert: header = 'OAuth oauth_consumer_key="xvz1evFS4wEEPTGEFPHBog",oauth_nonce="kYjzVBB8Y0ZFabxSWbWovY3uYSQ2pTgmZeNu2VS4cg",oauth_signature_method="HMAC-SHA1",oauth_timestamp="1318622958",oauth_version="1.0",oauth_token="370773112-GmHxMAgYyLbNEtIKZeRNFsMKPR9EyMZeS9weJAEb",oauth_signature="tnnArxj06cWHq44gCs1OSKk%2FjLY%3D"'
]

{ #category : 'tests' }
ZnOAuth1MessageTest >> testTwitterSignature [
	"Source: http://dev.twitter.com/pages/auth"

	| baseString key |
	
	baseString := 'POST&https%3A%2F%2Fapi.twitter.com%2Foauth%2Frequest_token&oauth_callback%3Dhttp%253A%252F%252Flocalhost%253A3005%252Fthe_dance%252Fprocess_callback%253Fservice_provider_id%253D11%26oauth_consumer_key%3DGDdmIQH6jhtmLUypg82g%26oauth_nonce%3DQP70eNmVz8jvdPevU3oJD2AfF7R7odC2XJcn4XlZJqk%26oauth_signature_method%3DHMAC-SHA1%26oauth_timestamp%3D1272323042%26oauth_version%3D1.0'.
	
	key := 'MCD8BKwGdgPHvAuvgvz4EQpqDAtx89grbuNMRd7Eh98&'.
	
	self assert: (self signStringSHA1: baseString usingSecret: key) = '8wUi7m5HFQy76nowoCThusfgB+Q='
	
		

]
