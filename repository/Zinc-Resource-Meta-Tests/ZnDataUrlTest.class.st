Class {
	#name : 'ZnDataUrlTest',
	#superclass : 'TestCase',
	#category : 'Zinc-Resource-Meta-Tests',
	#package : 'Zinc-Resource-Meta-Tests'
}

{ #category : 'tests' }
ZnDataUrlTest >> testABriefNote [
	| dataUrl |
	dataUrl := ZnDataUrl fromString: 'data:,A%20brief%20note'.
	self assert: dataUrl data equals: 'A brief note'.
	self deny: dataUrl isBase64Encoded.
]

{ #category : 'tests' }
ZnDataUrlTest >> testBinary [
	self
		assert: (ZnDataUrl bytes: #[1 2 3] type: 'application/octet-stream')
		equals: (ZnDataUrl bytes: #[1 2 3] type: 'application/octet-stream').
	self
		assert: (ZnDataUrl bytes: #[1 2 3] type: 'application/octet-stream') hash
		equals: (ZnDataUrl bytes: #[1 2 3] type: 'application/octet-stream') hash.
	self
		assert: (ZnDataUrl bytes: #[1 2 3] type: 'application/octet-stream') printString
		equals: (ZnDataUrl bytes: #[1 2 3] type: 'application/octet-stream') printString
]

{ #category : 'tests' }
ZnDataUrlTest >> testBinaryAll [
	| dataUrl |
	dataUrl := ZnDataUrl new.
	dataUrl data: (0 to: 255) asByteArray.
	dataUrl mediaType: ZnMimeType applicationOctetStream.
	dataUrl base64Encoded: true.
	self assert: dataUrl data equals: (0 to: 255) asByteArray.
	self assert: dataUrl isBase64Encoded.
	self assert: dataUrl mediaType equals: ZnMimeType applicationOctetStream.
	self assert: (ZnDataUrl fromString: dataUrl printString) data equals: (0 to: 255) asByteArray
]

{ #category : 'tests' }
ZnDataUrlTest >> testEmpty [
	| dataUrl |
	dataUrl := ZnDataUrl new.
	self assert: dataUrl isEmpty.
	self assert: dataUrl scheme equals: #data.
	self assert: ('text/plain' asZnMimeType matches: dataUrl mediaType).
	self assert: dataUrl equals: ZnDataUrl new
]

{ #category : 'tests' }
ZnDataUrlTest >> testGreek [
	| dataUrl |
	dataUrl := ZnDataUrl fromString: 'data:text/plain;charset=iso-8859-7,%e1%f8%e2'.
	self assert: dataUrl data equals: 'αψβ'.
	self deny: dataUrl isBase64Encoded.
	self assert: (dataUrl printString sameAs: 'data:text/plain;charset=iso-8859-7,%e1%f8%e2')
]

{ #category : 'tests' }
ZnDataUrlTest >> testParseMinimal [
	| dataUrl |
	dataUrl := ZnDataUrl fromString: 'data:,'.
	self assert: dataUrl isEmpty.
	self assert: dataUrl scheme equals: #data.
	self assert: ('text/plain' asZnMimeType matches: dataUrl mediaType).
]

{ #category : 'tests' }
ZnDataUrlTest >> testPng [
	| logoPngBytes dataUrl representation |
	logoPngBytes := PolymorphSystemSettings pharoLogoContents base64Decoded.
	dataUrl := ZnDataUrl bytes: logoPngBytes type: ZnMimeType imagePng.
	representation := dataUrl printString.
	dataUrl := ZnDataUrl fromString: representation.
	self assert: dataUrl data equals: logoPngBytes 
]

{ #category : 'tests' }
ZnDataUrlTest >> testSimpleBinary [
	| dataUrl |
	dataUrl := ZnDataUrl new.
	dataUrl data: #[ 0 1 2 3 4 5 6 7 8 9 ].
	dataUrl mediaType: ZnMimeType applicationOctetStream.
	dataUrl base64Encoded: true.
	self assert: dataUrl data equals: #[ 0 1 2 3 4 5 6 7 8 9 ].
	self assert: dataUrl isBase64Encoded.
	self assert: dataUrl mediaType equals: ZnMimeType applicationOctetStream
]

{ #category : 'tests' }
ZnDataUrlTest >> testSimpleString [
	| dataUrl |
	dataUrl := ZnDataUrl new.
	dataUrl data: 'foo'.
	self assert: dataUrl data equals: 'foo'
]

{ #category : 'tests' }
ZnDataUrlTest >> testSmallGif [

	| dataUrl |
	dataUrl := ZnDataUrl fromString:
		           'data:image/gif;base64,R0lGODdhMAAwAPAAAAAAAP///ywAAAAAMAAwAAAC8IyPqcvt3wCcDkiLc7C0qwyGHhSWpjQu5yqmCYsapyuvUUlvONmOZtfzgFzByTB10QgxOR0TqBQejhRNzOfkVJ+5YiUqrXF5Y5lKh/DeuNcP5yLWGsEbtLiOSpa/TPg7JpJHxyendzWTBfX0cxOnKPjgBzi4diinWGdkF8kjdfnycQZXZeYGejmJlZeGl9i2icVqaNVailT6F5iJ90m6mvuTS4OK05M0vDk0Q4XUtwvKOzrcd3iq9uisF81M1OIcR7lEewwcLp7tuNNkM3uNna3F2JQFo97Vriy/Xl4/f1cf5VWzXyym7PHhhx4dbgYKAAA7'.
	self assert: dataUrl mediaType equals: ZnMimeType imageGif.
	self deny: dataUrl isEmpty.
	self assert: dataUrl isBase64Encoded.
	self
		assert: dataUrl data
		equals:
			#[ 71 73 70 56 55 97 48 0 48 0 240 0 0 0 0 0 255 255 255 44 0 0 0 0
			   48 0 48 0 0 2 240 140 143 169 203 237 223 0 156 14 72 139 115
			   176 180 171 12 134 30 20 150 166 52 46 231 42 166 9 139 26 167
			   43 175 81 73 111 56 217 142 102 215 243 128 92 193 201 48 117
			   209 8 49 57 29 19 168 20 30 142 20 77 204 231 228 84 159 185 98
			   37 42 173 113 121 99 153 74 135 240 222 184 215 15 231 34 214
			   26 193 27 180 184 142 74 150 191 76 248 59 38 146 71 199 39 167
			   119 53 147 5 245 244 115 19 167 40 248 224 7 56 184 118 40 167
			   88 103 100 23 201 35 117 249 242 113 6 87 101 230 6 122 57 137
			   149 151 134 151 216 182 137 197 106 104 213 90 138 84 250 23 152
			   137 247 73 186 154 251 147 75 131 138 211 147 52 188 57 52 67 133
			   212 183 11 202 59 58 220 119 120 170 246 232 172 23 205 76 212
			   226 28 71 185 68 123 12 28 46 158 237 184 211 100 51 123 141 157
			   173 197 216 148 5 163 222 213 174 44 191 94 94 63 127 87 31 229
			   85 179 95 44 166 236 241 225 135 30 29 110 6 10 0 0 59 ].
	self
		assert: dataUrl printString
		equals:
		'data:image/gif;base64,R0lGODdhMAAwAPAAAAAAAP///ywAAAAAMAAwAAAC8IyPqcvt3wCcDkiLc7C0qwyGHhSWpjQu5yqmCYsapyuvUUlvONmOZtfzgFzByTB10QgxOR0TqBQejhRNzOfkVJ+5YiUqrXF5Y5lKh/DeuNcP5yLWGsEbtLiOSpa/TPg7JpJHxyendzWTBfX0cxOnKPjgBzi4diinWGdkF8kjdfnycQZXZeYGejmJlZeGl9i2icVqaNVailT6F5iJ90m6mvuTS4OK05M0vDk0Q4XUtwvKOzrcd3iq9uisF81M1OIcR7lEewwcLp7tuNNkM3uNna3F2JQFo97Vriy/Xl4/f1cf5VWzXyym7PHhhx4dbgYKAAA7'
]

{ #category : 'tests' }
ZnDataUrlTest >> testText [
	self 
		assert: (ZnDataUrl text: 'Les élèves Français')
		equals: (ZnDataUrl text: 'Les élèves Français').
	self 
		assert: (ZnDataUrl text: 'Les élèves Français') hash
		equals: (ZnDataUrl text: 'Les élèves Français') hash.
	self 
		assert: (ZnDataUrl text: 'Les élèves Français') printString
		equals: (ZnDataUrl text: 'Les élèves Français') printString
]
