"
ZnServerSentEventStatusHandler is an example of a Server Sent Events application.

This handler will send status updates every 2 seconds.

The status update contains the full precision current date and time and the memory usage.

See ZnServerSentEventDelegate's class comment for installation/usage instructions.

Part of Zinc HTTP Components.
"
Class {
	#name : 'ZnServerSentEventStatusHandler',
	#superclass : 'Object',
	#category : 'Zinc-Server-Sent-Events',
	#package : 'Zinc-Server-Sent-Events'
}

{ #category : 'running' }
ZnServerSentEventStatusHandler >> run: connection [
	"Using Server-Sent Events is simple: keep a reference to the connection, 
	instanciate ZnServerSentEvent objects and use #writeOn: to push them out."
	
	| event status |
	[ 
	  status := self statusString.
	  event := ZnServerSentEvent type: 'status-update' data: status.
	  event writeOn: connection.
	  2 seconds asDelay wait ] repeat
]

{ #category : 'acccessing' }
ZnServerSentEventStatusHandler >> statusString [
	| vm |
	vm := SmalltalkImage current vm.
	^ String streamContents: [ :out | 
		out 
			print: DateAndTime now;
			space;
			<< 'memory '; print: vm memoryEnd; << ' bytes ' ;
			print: (vm memoryEnd - vm youngSpaceEnd / vm memoryEnd * 100.0); << '% free' ]
]
