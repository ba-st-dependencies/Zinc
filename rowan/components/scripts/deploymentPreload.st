| symbolDictionary |
symbolDictionary := Rowan image
	symbolDictNamed: 'Zinc'
	ifAbsent: [
			Rowan image symbolList createDictionaryNamed: 'Zinc' at: Rowan image symbolList size + 1.
			Rowan image symbolDictNamed: 'Zinc'
	].
symbolDictionary at: #PrimitiveFailed ifAbsentPut: [ArgumentError].
symbolDictionary at: #ByteString ifAbsentPut: [String].
symbolDictionary at: #WideString ifAbsentPut: [String].
"Just to make code compile, later is configured in a post-load script"
symbolDictionary at: #SocketAddress ifAbsentPut: [nil].
symbolDictionary at: #Socket ifAbsentPut: [nil].
symbolDictionary at: #SocketStream ifAbsentPut: [nil].
