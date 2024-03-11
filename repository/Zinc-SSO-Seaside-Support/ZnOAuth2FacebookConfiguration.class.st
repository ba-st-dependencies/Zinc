"
This Seaside configuration class defines the attributes required to use Facebook OAuth2
"
Class {
	#name : 'ZnOAuth2FacebookConfiguration',
	#superclass : 'WASystemConfiguration',
	#category : 'Zinc-SSO-Seaside-Support',
	#package : 'Zinc-SSO-Seaside-Support'
}

{ #category : 'description' }
ZnOAuth2FacebookConfiguration >> describeOn: config [ 

	(config string: #oauthFacebookClientId)
		group: #oauth;
		label: 'Facebook client_id';
		comment: 'OAuth 2.0 client_id for Facebook.'.
		
	(config string: #oauthFacebookClientSecret)
		group: #oauth;
		label: 'Facebook client_secret';
		comment: 'OAuth 2.0 client_secret for Facebook.'
]
