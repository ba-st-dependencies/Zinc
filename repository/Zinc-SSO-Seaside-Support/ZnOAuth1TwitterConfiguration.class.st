"
This Seaside configuration class defines the attributes required to use Twitter OAuth1
"
Class {
	#name : 'ZnOAuth1TwitterConfiguration',
	#superclass : 'WASystemConfiguration',
	#category : 'Zinc-SSO-Seaside-Support',
	#package : 'Zinc-SSO-Seaside-Support'
}

{ #category : 'description' }
ZnOAuth1TwitterConfiguration >> describeOn: config [ 

	(config string: #oauth1TwitterConsumerKey)
		group: #oauth;
		label: 'Twitter Consumer Key';
		comment: 'OAuth 1.0 consumer key'.
		
	(config string: #oauth1TwitterConsumerSecret)
		group: #oauth;
		label: 'Twitter Consumer Secret';
		comment: 'OAuth 1.0 consumer secret.'.	
]
