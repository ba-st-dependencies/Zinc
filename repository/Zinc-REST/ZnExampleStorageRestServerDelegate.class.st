"
I am ZnExampleStorageRestServerDelegate.

I offer a REST interface on /storage with CRUD operations on JSON maps. I automatically use the call hierarchy below ZnExampleStorageRestCall.

To install me you can do:

	ZnServer startDefaultOn: 1701.
	ZnServer default logToTranscript.

	ZnServer default delegate
		map: 'storage' 
		to: ZnExampleStorageRestServerDelegate new.
			
	ZnServer stopDefault.

See ZnExampleStorageRestServerDelegateTests for example client usage.

"
Class {
	#name : 'ZnExampleStorageRestServerDelegate',
	#superclass : 'ZnJSONRestServerDelegate',
	#instVars : [
		'storage',
		'idCounter'
	],
	#category : 'Zinc-REST-Tests',
	#package : 'Zinc-REST',
	#tag : 'Tests'
}

{ #category : 'initialize-release' }
ZnExampleStorageRestServerDelegate >> initialize [ 
	idCounter := 1000.
	self uriSpace: ZnCallHierarchyRestUriSpace new.
	self uriSpace rootClass: ZnExampleStorageRestCall
]

{ #category : 'accessing' }
ZnExampleStorageRestServerDelegate >> nextId [
	^ idCounter := idCounter + 1
]

{ #category : 'accessing' }
ZnExampleStorageRestServerDelegate >> storage [
	^ storage ifNil: [ storage := Dictionary new ]
]
