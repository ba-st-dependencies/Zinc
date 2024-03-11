Extension { #name : 'ZnResponse' }

{ #category : '*Zinc-HTTP-Inspector-Extensions' }
ZnResponse >> inspectionEntity: aBuilder [
	<inspectorPresentationOrder: 10 title: 'Entity'>
	 
	^ aBuilder newText
		text: self entity contents asString;
		yourself
]

{ #category : '*Zinc-HTTP-Inspector-Extensions' }
ZnResponse >> inspectionHeaders: aBuilder [
	<inspectorPresentationOrder: 10 title: 'Headers'>
	
	^ aBuilder newTable 
		addColumn: (SpStringTableColumn 
			title: 'Key'
			evaluated: [ :each | StObjectPrinter asTruncatedTextFrom: each key ])
			beSortable;
		addColumn: (SpStringTableColumn 
			title: 'Value' 
			evaluated: [ :each | StObjectPrinter asTruncatedTextFrom: each value ])
			beSortable;
		items: (self headers headers associations collect: [:e | StInspectorAssociationNode hostObject: e ]);
		yourself
]
