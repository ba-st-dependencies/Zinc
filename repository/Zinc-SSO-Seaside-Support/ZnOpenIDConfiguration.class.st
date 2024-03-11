"
This Seaside configuration class defines the attributes required to use OpenID
"
Class {
	#name : 'ZnOpenIDConfiguration',
	#superclass : 'WASystemConfiguration',
	#category : 'Zinc-SSO-Seaside-Support',
	#package : 'Zinc-SSO-Seaside-Support'
}

{ #category : 'description' }
ZnOpenIDConfiguration >> describeOn: config [ 

	(config string: #openidRealm)
		group: #openid;
		label: 'OpenID Realm';
		comment: 'Authenticated realm. Identifies the domain that the end user is being asked to trust.'.
]
