"
I am ZnJSONRestServerDelegate.
I am a ZnRestServerDelegate.

I offer extra support for the common case where most responses or requests use JSON as representation.

I work together with ZnJSONRestCall.
"
Class {
	#name : 'ZnJSONRestServerDelegate',
	#superclass : 'ZnRestServerDelegate',
	#category : 'Zinc-REST-Server',
	#package : 'Zinc-REST',
	#tag : 'Server'
}

{ #category : 'error handling' }
ZnJSONRestServerDelegate >> errorResponse: request code: code message: message [
	| statusLine data |
	statusLine := ZnStatusLine code: code.
	(data := Dictionary new)
		at: 'method' put: request method;
		at: 'uri' put: request uri printString;
		at: 'status-code' put: statusLine code;
		at: 'status-message' put: statusLine reason;
		at: 'message' put: message.
	^ ZnResponse new
		statusLine: statusLine;
		headers: ZnHeaders defaultResponseHeaders;
		entity: (ZnEntity with: (self toJson: data) type: ZnMimeType applicationJson);
		yourself
]

{ #category : 'utils' }
ZnJSONRestServerDelegate >> fromJson: string [
	^ NeoJSONReader fromString: string
]

{ #category : 'utils' }
ZnJSONRestServerDelegate >> toJson: data [
	^ String streamContents: [ :stream | 
			(NeoJSONWriter on: stream)
				prettyPrint: true;
				newLine: String crlf;
				asciiOnly: true;
				nextPut: data.
			stream crlf ]
]
