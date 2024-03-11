"
Abstract Seaside component with common functionality for the different SSO providers.
"
Class {
	#name : 'ZnSSOSeasideDemoPanel',
	#superclass : 'WAComponent',
	#category : 'Zinc-SSO-Seaside-Demo',
	#package : 'Zinc-SSO-Seaside-Demo'
}

{ #category : 'rendering' }
ZnSSOSeasideDemoPanel >> renderImage: aString on: html [

	html image
		style: 'position: absolute; right: 20px; top: 60px; ' ;
		url: aString 
]

{ #category : 'rendering' }
ZnSSOSeasideDemoPanel >> renderJSONDict: jsonDict on: html [

	html unorderedList: [
		jsonDict keysAndValuesDo: [ :key :value |
			html listItem: [
				html text: key.
				value isDictionary 
					ifTrue: [ 
						html text: ':'.
						self renderJSONDict: value on: html ]
					ifFalse: [ 
						html text: ' --> '; text: value ] ] ] ]
]

{ #category : 'rendering' }
ZnSSOSeasideDemoPanel >> renderLink: aString on: html [

	html anchor
		url: aString ;
		target: '_blank' ;
		with: 'Profile'
		
]
