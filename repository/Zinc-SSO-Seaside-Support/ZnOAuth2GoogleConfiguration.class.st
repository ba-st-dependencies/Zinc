"
This Seaside configuration class defines the attributes required to use Google OAuth2
"
Class {
	#name : 'ZnOAuth2GoogleConfiguration',
	#superclass : 'WASystemConfiguration',
	#category : 'Zinc-SSO-Seaside-Support',
	#package : 'Zinc-SSO-Seaside-Support'
}

{ #category : 'description' }
ZnOAuth2GoogleConfiguration >> describeOn: config [ 

	(config string: #oauth2GoogleClientId)
		group: #oauth;
		label: 'Google oauth2 client_id';
		comment: 'OAuth 2.0 client_id for Google.'.
		
	(config string: #oauth2GoogleClientSecret)
		group: #oauth;
		label: 'Google oauth2 client_secret';
		comment: 'OAuth 2.0 client_secret for Google.'.	
		
	(config string: #oauth2GoogleRedirectUrl)
		group: #oauth;
		label: 'Google oauth2 redirect_url';
		comment: 'OAuth 2.0 redirect_url for Google.'.	
]
