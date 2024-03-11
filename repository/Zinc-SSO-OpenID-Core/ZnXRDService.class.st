Class {
	#name : 'ZnXRDService',
	#superclass : 'Object',
	#category : 'Zinc-SSO-OpenID-Core',
	#package : 'Zinc-SSO-OpenID-Core'
}

{ #category : 'instance creation' }
ZnXRDService class >> newFromXmlElement: aXmlElement [
	self subclassResponsibility.
]

{ #category : 'parsing' }
ZnXRDService class >> parseOPEndpointFromXrds: aString [

	| xmlNode |

	xmlNode := self xmlParser parse: aString.
	xmlNode := xmlNode root elementAt: 'XRD'.
	xmlNode := xmlNode elementAt: 'Service'.
	^xmlNode contentStringAt: 'URI'
]

{ #category : 'parsing' }
ZnXRDService class >> parseServiceElement: aXmlElement [
	"Parses xml element containing service definition. Method returns collection of services because
	every different type is parsed to different service."

	| types classes |
	types := OrderedCollection new.
	aXmlElement elementsAt: 'Type' do: [ :e | types add: e contentString ].
	classes := OrderedCollection new.
	types do: [ :type | classes addAll: (self allSubclasses select: [ :c | c serviceType = type ]) ].
	classes isEmpty
		ifTrue: [ ^ nil ].	"Unknonwn type"
	^ classes collect: [ :c | c newFromXmlElement: aXmlElement ]
]

{ #category : 'parsing' }
ZnXRDService class >> parseServicesFromXrds: aString [

	| xrdElement elements document |

	document := self xmlParser parse: aString.
	xrdElement := document root elementAt: 'XRD'.
	elements := OrderedCollection new.
	xrdElement
		elementsAt: 'Service'
		do: [ :e | (self parseServiceElement: e) ifNotNil: [ :nonNilService | elements addAll: nonNilService ] ].
	^ elements
]

{ #category : 'resources' }
ZnXRDService class >> xmlParser [

	^ XMLDOMParser 
]

{ #category : 'testing' }
ZnXRDService >> isClaimedIdService [
	^false
]
