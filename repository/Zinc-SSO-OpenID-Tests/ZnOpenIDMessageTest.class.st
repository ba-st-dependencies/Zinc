Class {
	#name : 'ZnOpenIDMessageTest',
	#superclass : 'TestCase',
	#category : 'Zinc-SSO-OpenID-Tests',
	#package : 'Zinc-SSO-OpenID-Tests'
}

{ #category : 'resources' }
ZnOpenIDMessageTest >> associationResult [

	^'ns:http://specs.openid.net/auth/2.0
session_type:no-encryption
assoc_type:HMAC-SHA1
assoc_handle:AOQobUe4qad3I-VsAjGHVmxz_KeE0V1GHKW29cOaA2jNJphIjkYbjeYU
expires_in:46800
mac_key:aOVJIcgiyTGBT6SLPjnmMcbvNhY=
'

]

{ #category : 'resources' }
ZnOpenIDMessageTest >> authenticationResultSignedText [

	^'op_endpoint:https://www.google.com/accounts/o8/ud
claimed_id:https://www.google.com/accounts/o8/id?id=AItOawnFQzS9_B505VJ_fNmY14ZywzVOINjI22k
identity:https://www.google.com/accounts/o8/id?id=AItOawnFQzS9_B505VJ_fNmY14ZywzVOINjI22k
return_to:http://pier.doit.st
response_nonce:2010-03-05T10:40:06ZJ6jQJGQatr63qw
assoc_handle:AOQobUe4qad3I-VsAjGHVmxz_KeE0V1GHKW29cOaA2jNJphIjkYbjeYU
ns.ext1:http://openid.net/srv/ax/1.0
ext1.mode:fetch_response
ext1.type.firstname:http://axschema.org/namePerson/first
ext1.value.firstname:Jan
ext1.type.email:http://axschema.org/contact/email
ext1.value.email:jvdsandt@gmail.com
ext1.type.lastname:http://axschema.org/namePerson/last
ext1.value.lastname:van de Sandt
' collect: [ :ch | ch = Character cr ifTrue: [ Character lf ] ifFalse: [ ch ]]
]

{ #category : 'resources' }
ZnOpenIDMessageTest >> authenticationResultUrl [

	^'http://pier.doit.st/?openid.ns=http%3A%2F%2Fspecs.openid.net%2Fauth%2F2.0&openid.mode=id_res&openid.op_endpoint=https%3A%2F%2Fwww.google.com%2Faccounts%2Fo8%2Fud&openid.response_nonce=2010-03-05T10%3A40%3A06ZJ6jQJGQatr63qw&openid.return_to=http%3A%2F%2Fpier.doit.st&openid.assoc_handle=AOQobUe4qad3I-VsAjGHVmxz_KeE0V1GHKW29cOaA2jNJphIjkYbjeYU&openid.signed=op_endpoint%2Cclaimed_id%2Cidentity%2Creturn_to%2Cresponse_nonce%2Cassoc_handle%2Cns.ext1%2Cext1.mode%2Cext1.type.firstname%2Cext1.value.firstname%2Cext1.type.email%2Cext1.value.email%2Cext1.type.lastname%2Cext1.value.lastname&openid.sig=4WUEhV1Dqm%2Bf2LagiJ1d0QfoVJw%3D&openid.identity=https%3A%2F%2Fwww.google.com%2Faccounts%2Fo8%2Fid%3Fid%3DAItOawnFQzS9_B505VJ_fNmY14ZywzVOINjI22k&openid.claimed_id=https%3A%2F%2Fwww.google.com%2Faccounts%2Fo8%2Fid%3Fid%3DAItOawnFQzS9_B505VJ_fNmY14ZywzVOINjI22k&openid.ns.ext1=http%3A%2F%2Fopenid.net%2Fsrv%2Fax%2F1.0&openid.ext1.mode=fetch_response&openid.ext1.type.firstname=http%3A%2F%2Faxschema.org%2FnamePerson%2Ffirst&openid.ext1.value.firstname=Jan&openid.ext1.type.email=http%3A%2F%2Faxschema.org%2Fcontact%2Femail&openid.ext1.value.email=jvdsandt%40gmail.com&openid.ext1.type.lastname=http%3A%2F%2Faxschema.org%2FnamePerson%2Flast&openid.ext1.value.lastname=van+de+Sandt'

]

{ #category : 'testing' }
ZnOpenIDMessageTest >> testAssociationResponse [

	| input response |
	
	input := self associationResult .
	response := ZnOpenIDAssociationResponse newFromKeyValueForm: input.
	
	self assert: response isHmacSHA1.
	self assert: (response sign: 'my-data' andCheck: 'Crc335ANSwfLu+qcCYMkYRbXbew=').
	
	self deny: (response sign: 'my-data' andCheck: 'INVALID=')
	
	

]

{ #category : 'testing' }
ZnOpenIDMessageTest >> testAuthResponse [

	| url response assocResponse |
	
	url := self authenticationResultUrl asZnUrl.
	response := ZnOpenIDAuthResponse newFromUrl: url.
	
	self assert: (response axValueEmail = 'jvdsandt@gmail.com').
	self assert: (response signedText = self authenticationResultSignedText).

	assocResponse := ZnOpenIDAssociationResponse newFromKeyValueForm: self associationResult.
	self assert: (assocResponse sign: response signedText andCheck: response sig)

]
