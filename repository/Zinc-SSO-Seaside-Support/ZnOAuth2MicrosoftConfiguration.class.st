"
This Seaside configuration class defines the attributes required to use Microsoft OAuth2
"
Class {
	#name : 'ZnOAuth2MicrosoftConfiguration',
	#superclass : 'WASystemConfiguration',
	#category : 'Zinc-SSO-Seaside-Support',
	#package : 'Zinc-SSO-Seaside-Support'
}

{ #category : 'description' }
ZnOAuth2MicrosoftConfiguration >> describeOn: config [ 

	(config string: #oauth2MicrosoftClientId)
		group: #oauth;
		label: 'Microsoft client_id';
		comment: 'OAuth 2.0 client_id for Microsoft Live Connect.'.
		
	(config string: #oauth2MicrosoftClientSecret)
		group: #oauth;
		label: 'Microsoft client_secret';
		comment: 'OAuth 2.0 client_secret for Microsoft Live Connect.'
]
