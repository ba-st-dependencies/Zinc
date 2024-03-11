Extension { #name : 'HTTPSocket' }

{ #category : '*Zinc-Patch-HTTPSocket' }
HTTPSocket classSide >> httpGet: url [
	"Forward to Zinc HTTP Components"
	
	self deprecated: 'Use ZnClient' on: ' 2012-10-03T18:02:49Z' in: 'Pharo 2.0'.
	
	^ ZnHTTPSocketFacade httpGet: url
]

{ #category : '*Zinc-Patch-HTTPSocket' }
HTTPSocket classSide >> httpGet: url accept: mimeType [
	"Forward to Zinc HTTP Components"
	
	self deprecated: 'Use ZnClient' on: ' 2012-10-03T18:02:49Z' in: 'Pharo 2.0'.
	
	^ ZnHTTPSocketFacade httpGet: url accept: mimeType 
]

{ #category : '*Zinc-Patch-HTTPSocket' }
HTTPSocket classSide >> httpGet: url args: queryArguments accept: mimeType [
	"Forward to Zinc HTTP Components"
	
	self deprecated: 'Use ZnClient' on: ' 2012-10-03T18:02:49Z' in: 'Pharo 2.0'.
	
	^ ZnHTTPSocketFacade httpGet: url args: queryArguments accept: mimeType 
]

{ #category : '*Zinc-Patch-HTTPSocket' }
HTTPSocket classSide >> httpGet: url args: queryArguments accept: mimeType request: extraHeaders [
	"Forward to Zinc HTTP Components"
	
	self deprecated: 'Use ZnClient' on: ' 2012-10-03T18:02:49Z' in: 'Pharo 2.0'.
	
	^ ZnHTTPSocketFacade httpGet: url args: queryArguments accept: mimeType request: extraHeaders 
]

{ #category : '*Zinc-Patch-HTTPSocket' }
HTTPSocket classSide >> httpGet: url args: queryArguments user: username passwd: password [
	"Forward to Zinc HTTP Components"
	
	self deprecated: 'Use ZnClient' on: ' 2012-10-03T18:02:49Z' in: 'Pharo 2.0'.
	
	^ ZnHTTPSocketFacade httpGet: url args: queryArguments user: username passwd: password
]

{ #category : '*Zinc-Patch-HTTPSocket' }
HTTPSocket classSide >> httpGetDocument: url [
	"Forward to Zinc HTTP Components"
	
	self deprecated: 'Use ZnClient' on: ' 2012-10-03T18:02:49Z' in: 'Pharo 2.0'.
	
	^ ZnHTTPSocketFacade httpGetDocument: url
]

{ #category : '*Zinc-Patch-HTTPSocket' }
HTTPSocket classSide >> httpGetDocument: url accept: mimeType [
	"Forward to Zinc HTTP Components"
	
	self deprecated: 'Use ZnClient' on: ' 2012-10-03T18:02:49Z' in: 'Pharo 2.0'.
	
	^ ZnHTTPSocketFacade httpGetDocument: url accept: mimeType 
]

{ #category : '*Zinc-Patch-HTTPSocket' }
HTTPSocket classSide >> httpGetDocument: url args: queryArguments [
	"Forward to Zinc HTTP Components"
	
	self deprecated: 'Use ZnClient' on: ' 2012-10-03T18:02:49Z' in: 'Pharo 2.0'.
	
	^ ZnHTTPSocketFacade httpGetDocument: url args: queryArguments
]

{ #category : '*Zinc-Patch-HTTPSocket' }
HTTPSocket classSide >> httpGetDocument: url args: queryArguments accept: mimeType [
	"Forward to Zinc HTTP Components"
	
	self deprecated: 'Use ZnClient' on: ' 2012-10-03T18:02:49Z' in: 'Pharo 2.0'.
	
	^ ZnHTTPSocketFacade httpGetDocument: url args: queryArguments accept: mimeType
]

{ #category : '*Zinc-Patch-HTTPSocket' }
HTTPSocket classSide >> httpGetDocument: url args: queryArguments accept: mimeType request: extraHeaders [
	"Forward to Zinc HTTP Components"
	
	self deprecated: 'Use ZnClient' on: ' 2012-10-03T18:02:49Z' in: 'Pharo 2.0'.
	
	^ ZnHTTPSocketFacade httpGetDocument: url args: queryArguments accept: mimeType request: extraHeaders
]

{ #category : '*Zinc-Patch-HTTPSocket' }
HTTPSocket classSide >> httpGif: url [
	"Forward to Zinc HTTP Components"
	
	self deprecated: 'Use ZnClient' on: ' 2012-10-03T18:02:49Z' in: 'Pharo 2.0'.
	
	^ ZnHTTPSocketFacade httpGif: url
]

{ #category : '*Zinc-Patch-HTTPSocket' }
HTTPSocket classSide >> httpJpeg: url [
	"Forward to Zinc HTTP Components"
	
	self deprecated: 'Use ZnClient' on: ' 2012-10-03T18:02:49Z' in: 'Pharo 2.0'.
	
	^ ZnHTTPSocketFacade httpJpeg: url
]

{ #category : '*Zinc-Patch-HTTPSocket' }
HTTPSocket classSide >> httpPng: url [
	"Forward to Zinc HTTP Components"
	
	self deprecated: 'Use ZnClient' on: ' 2012-10-03T18:02:49Z' in: 'Pharo 2.0'.
	
	^ ZnHTTPSocketFacade httpPng: url
]

{ #category : '*Zinc-Patch-HTTPSocket' }
HTTPSocket classSide >> httpPost: url args: arguments accept: mimeType [
	"Forward to Zinc HTTP Components"
	
	self deprecated: 'Use ZnClient' on: ' 2012-10-03T18:02:49Z' in: 'Pharo 2.0'.
	
	^ ZnHTTPSocketFacade httpPost: url args: arguments accept: mimeType
]

{ #category : '*Zinc-Patch-HTTPSocket' }
HTTPSocket classSide >> httpPost: url args: arguments user: username passwd: password [
	"Forward to Zinc HTTP Components"
	
	self deprecated: 'Use ZnClient' on: ' 2012-10-03T18:02:49Z' in: 'Pharo 2.0'.
	
	^ ZnHTTPSocketFacade httpPost: url args: arguments user: username passwd: password
]

{ #category : '*Zinc-Patch-HTTPSocket' }
HTTPSocket classSide >> httpPostDocument: url args: arguments [
	"Forward to Zinc HTTP Components"
	
	self deprecated: 'Use ZnClient' on: ' 2012-10-03T18:02:49Z' in: 'Pharo 2.0'.
	
	^ ZnHTTPSocketFacade httpPostDocument: url args: arguments
]

{ #category : '*Zinc-Patch-HTTPSocket' }
HTTPSocket classSide >> httpPostDocument: url args: arguments accept: mimeType [
	"Forward to Zinc HTTP Components"
	
	self deprecated: 'Use ZnClient' on: ' 2012-10-03T18:02:49Z' in: 'Pharo 2.0'.
	
	^ ZnHTTPSocketFacade httpPostDocument: url args: arguments accept: mimeType
]

{ #category : '*Zinc-Patch-HTTPSocket' }
HTTPSocket classSide >> httpPostDocument: url args: arguments accept: mimeType request: extraHeaders [
	"Forward to Zinc HTTP Components"
	
	self deprecated: 'Use ZnClient' on: ' 2012-10-03T18:02:49Z' in: 'Pharo 2.0'.
	
	^ ZnHTTPSocketFacade httpPostDocument: url args: arguments accept: mimeType request: extraHeaders
]

{ #category : '*Zinc-Patch-HTTPSocket' }
HTTPSocket classSide >> httpPostMultipart: url args: arguments accept: mimeType request: extraHeaders [
	"Forward to Zinc HTTP Components"
	
	self deprecated: 'Use ZnClient' on: ' 2012-10-03T18:02:49Z' in: 'Pharo 2.0'.
	
	^ ZnHTTPSocketFacade httpPostMultipart: url args: arguments accept: mimeType request: extraHeaders
]

{ #category : '*Zinc-Patch-HTTPSocket' }
HTTPSocket classSide >> httpPut: stream to: url user: username passwd: password [
	"Forward to Zinc HTTP Components"
	
	self deprecated: 'Use ZnClient' on: ' 2012-10-03T18:02:49Z' in: 'Pharo 2.0'.
	
	^ ZnHTTPSocketFacade httpPut: stream to: url user: username passwd: password
]
