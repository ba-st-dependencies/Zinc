Class {
	#name : 'ZnOpenIDServiceTest',
	#superclass : 'TestCase',
	#category : 'Zinc-SSO-OpenID-Tests',
	#package : 'Zinc-SSO-OpenID-Tests'
}

{ #category : 'private' }
ZnOpenIDServiceTest >> currentTime [
	^ DateAndTime now
]

{ #category : 'private' }
ZnOpenIDServiceTest >> defaultAuthResponse [
	^ ZnOpenIDAuthResponse new
		propertyAt: 'openid.op_endpoint' put: 'endpoint';
		propertyAt: 'openid.claimed_id' put: 'claimedid';
		propertyAt: 'openid.response_nonce' put: self generateValidNonce;
		propertyAt: 'openid.return_to' put: '123123123';
		propertyAt: 'openid.assoc_handle' put: '123123123';
		propertyAt: 'openid.sig' put: '123123123';
		propertyAt: 'openid.identity' put: '123123123';
		propertyAt: 'openid.signed' put: 'return_to,response_nonce,op_endpoint,assoc_handle,identity,claimed_id';
		yourself	"OpenID 2.0 / 10.1: identity is optional -> test that it doesn not have to be there.  "
]

{ #category : 'private' }
ZnOpenIDServiceTest >> dummyProvider [

	^ ZnOpenIDProvider new
		name: 'dummy' ;
		yourself
]

{ #category : 'private' }
ZnOpenIDServiceTest >> encodeNonceFromTime: dateTime andDiscriminator: aString [
	^ (ZnOpenIDNonce encodeRFC3339Date: dateTime) , aString.
]

{ #category : 'private' }
ZnOpenIDServiceTest >> generateSimpleXrdsForEndpoint: endpoint andLocalId: localId [
	^ '<xrds:XRDS xmlns="xri://$xrd*($v*2.0)" xmlns:xrds="xri://$xrds"><XRD><Service priority="0"><Type>http://specs.openid.net/auth/2.0/signon</Type><URI>'
		, endpoint , '</URI><LocalID>' , localId , '</LocalID></Service></XRD></xrds:XRDS>'
]

{ #category : 'private' }
ZnOpenIDServiceTest >> generateValidNonce [
	^ self encodeNonceFromTime: self currentTime andDiscriminator: ''
]

{ #category : 'running' }
ZnOpenIDServiceTest >> setUp [
	ZnOpenIDNonceLocker reset.
]

{ #category : 'running' }
ZnOpenIDServiceTest >> tearDown [
	ZnOpenIDNonceLocker reset.
]

{ #category : 'tests' }
ZnOpenIDServiceTest >> testClaimedIdIsValidatedCorrectEndpoint [
	| response service |
	response := self defaultAuthResponse.
	service := ZnOpenIDServiceDummy new.
	service
		doNotValidateEndpoint ;
		doNotCheckSignature;
		provider: self dummyProvider ;		
		claimedId: response claimedId
			xrds:
				'<xrds:XRDS xmlns="xri://$xrd*($v*2.0)" xmlns:xrds="xri://$xrds"><XRD><Service priority="0"><Type>http://specs.openid.net/auth/2.0/signon</Type><URI>endpoint</URI><LocalID>123123123</LocalID></Service></XRD></xrds:XRDS>'.

	self shouldnt: [ service validateAuthResponse: response ] raise: ZnOpenIDClaimedIDVerificationError
]

{ #category : 'tests' }
ZnOpenIDServiceTest >> testClaimedIdIsValidatedWorksWithsMultipleDefinitions [
	| response service xrdsDocument |
	xrdsDocument := '<xrds:XRDS xmlns:xrds="xri://$xrds" xmlns="xri://$xrd*($v*2.0)">
<XRD>
<Service priority="0">
<Type>http://specs.openid.net/auth/2.0/signon</Type>
<Type>http://openid.net/srv/ax/1.0</Type>
<Type>http://specs.openid.net/extensions/ui/1.0/mode/popup</Type>
<Type>http://specs.openid.net/extensions/ui/1.0/icon</Type>
<Type>http://specs.openid.net/extensions/pape/1.0</Type>
<URI>https://www.google.com/accounts/o8/ud</URI>
</Service>
<Service priority="10">
<Type>http://specs.openid.net/auth/2.0/signon</Type>
<Type>http://openid.net/srv/ax/1.0</Type>
<Type>http://specs.openid.net/extensions/ui/1.0/mode/popup</Type>
<Type>http://specs.openid.net/extensions/ui/1.0/icon</Type>
<Type>http://specs.openid.net/extensions/pape/1.0</Type>
<URI>https://www.google.com/accounts/o8/ud?source=mail</URI>
</Service>
<Service priority="10">
<Type>http://specs.openid.net/auth/2.0/signon</Type>
<Type>http://openid.net/srv/ax/1.0</Type>
<Type>http://specs.openid.net/extensions/ui/1.0/mode/popup</Type>
<Type>http://specs.openid.net/extensions/ui/1.0/icon</Type>
<Type>http://specs.openid.net/extensions/pape/1.0</Type>
<URI>https://www.google.com/accounts/o8/ud?source=gmail.com</URI>
</Service>
<Service priority="10">
<Type>http://specs.openid.net/auth/2.0/signon</Type>
<Type>http://openid.net/srv/ax/1.0</Type>
<Type>http://specs.openid.net/extensions/ui/1.0/mode/popup</Type>
<Type>http://specs.openid.net/extensions/ui/1.0/icon</Type>
<Type>http://specs.openid.net/extensions/pape/1.0</Type>
<URI>https://www.google.com/accounts/o8/ud?source=googlemail.com</URI>
</Service>
<Service priority="10">
<Type>http://specs.openid.net/auth/2.0/signon</Type>
<Type>http://openid.net/srv/ax/1.0</Type>
<Type>http://specs.openid.net/extensions/ui/1.0/mode/popup</Type>
<Type>http://specs.openid.net/extensions/ui/1.0/icon</Type>
<Type>http://specs.openid.net/extensions/pape/1.0</Type>
<URI>https://www.google.com/accounts/o8/ud?source=profiles</URI>
</Service>
</XRD>
</xrds:XRDS>'.
	response := self defaultAuthResponse
		propertyAt: 'openid.op_endpoint' put: 'https://www.google.com/accounts/o8/ud?source=profiles';
		yourself.
	service := ZnOpenIDServiceDummy new
		doNotCheckSignature ;
		claimedId: response claimedId xrds: xrdsDocument ;
		provider: self dummyProvider ;
		yourself.
	"self shouldnt: [ "service validateAuthResponse: response." ] raise: CFOpenIDClaimedIDVerificationError"
]

{ #category : 'tests' }
ZnOpenIDServiceTest >> testClaimedIdIsValidatedWrongEndpoint [
	| response service |
	response := self defaultAuthResponse.
	service := ZnOpenIDServiceDummy new
		doNotCheckSignature ;
		provider: self dummyProvider ;
		claimedId: response claimedId
			xrds: (self generateSimpleXrdsForEndpoint: 'endoint123' andLocalId: '123123').

	self should: [ service validateAuthResponse: response ] raise: ZnOpenIDClaimedIDVerificationError
]

{ #category : 'tests' }
ZnOpenIDServiceTest >> testValidateResponseAcceptsNonceInOnlyInCertainTimeFrame [
	| response service nonce |
	nonce := self encodeNonceFromTime: self currentTime - 2 minutes andDiscriminator: '123'.
	ZnOpenIDNonceLocker 
		reset;
		acceptedTimeFrame: 1 minute.
	response := self defaultAuthResponse
		propertyAt: 'openid.response_nonce' put: nonce;
		yourself.
	service := ZnOpenIDServiceDummy new
		doNotValidateEndpoint ;
		doNotCheckSignature ;
		provider: self dummyProvider ;
		yourself.

	self should: [ service validateAuthResponse: response ] raise: ZnOpenIDNonceTooOldError
]

{ #category : 'tests' }
ZnOpenIDServiceTest >> testValidateResponseAcceptsOnlyValidNonces [
	| response service |
	response := self defaultAuthResponse
		propertyAt: 'openid.response_nonce' put: '123123123';
		yourself.
	service := ZnOpenIDServiceDummy new
		doNotValidateEndpoint ;
		doNotCheckSignature ;
		provider: self dummyProvider ;
		yourself.

	self should: [ service validateAuthResponse: response ] raise: ZnOpenIDNonceInvalidError
]

{ #category : 'tests' }
ZnOpenIDServiceTest >> testValidateResponseAcceptsSameNonceOnlyOnceForSameProvider [
	| response service |
	response := self defaultAuthResponse.
	service := ZnOpenIDServiceDummy new
		doNotValidateEndpoint ;
		doNotCheckSignature ;
		provider: self dummyProvider ;
		yourself.

	self shouldnt: [ service validateAuthResponse: response ] raise: ZnOpenIDNonceSeenError.
	self should: [ service validateAuthResponse: response ] raise: ZnOpenIDNonceSeenError
]
