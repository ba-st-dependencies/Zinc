Class {
	#name : 'ZnOpenIDServiceDummy',
	#superclass : 'ZnOpenIDService',
	#instVars : [
		'httpClient',
		'endpointValidation'
	],
	#category : 'Zinc-SSO-OpenID-Tests',
	#package : 'Zinc-SSO-OpenID-Tests'
}

{ #category : 'accessing' }
ZnOpenIDServiceDummy >> associationResponse: anAssociationResponse [
	associationResponse := anAssociationResponse.
	

]

{ #category : 'initialize-release' }
ZnOpenIDServiceDummy >> claimedId: claimedId xrds: aString [
	self httpClient: (ZnHttpClientDummy new
		responseForGet: claimedId content: aString).
]

{ #category : 'actions' }
ZnOpenIDServiceDummy >> doNotCheckSignature [
	associationResponse := ZnOpenIDAssociationResponseDummy new
		doNotCheckSignature;
		yourself
]

{ #category : 'actions' }
ZnOpenIDServiceDummy >> doNotValidateEndpoint [
	endpointValidation := false.
]

{ #category : 'resources' }
ZnOpenIDServiceDummy >> httpClient [

	^ httpClient ifNil: [ httpClient := ZnHttpClientDummy new ]
]

{ #category : 'initialize-release' }
ZnOpenIDServiceDummy >> httpClient: newHttpClient [
	httpClient := newHttpClient.
]

{ #category : 'initialize-release' }
ZnOpenIDServiceDummy >> initialize [ 
	super initialize.
	endpointValidation := true.
]

{ #category : 'actions' }
ZnOpenIDServiceDummy >> shouldValidateEndpoint [
	^ endpointValidation
]

{ #category : 'actions' }
ZnOpenIDServiceDummy >> validateClaimedId: claimedId belongsToEndpoint: opEndpoint [
	self shouldValidateEndpoint
		ifTrue: [ super validateClaimedId: claimedId belongsToEndpoint: opEndpoint ]
]
