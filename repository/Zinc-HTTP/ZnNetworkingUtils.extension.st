Extension { #name : 'ZnNetworkingUtils' }

{ #category : '*Zinc-HTTP-UnixSocket' }
ZnNetworkingUtils class >> socketStreamToUnixSocketFile: socketFile [
	^ self default
		socketStreamToUnixSocketFile: socketFile
]

{ #category : '*Zinc-HTTP-UnixSocket' }
ZnNetworkingUtils >> socketStreamToUnixSocketFile: socketFile [
	| ipcSocket |
	ipcSocket := self unixSocketOnFile: socketFile.
	^ self socketStreamOn: ipcSocket
]

{ #category : '*Zinc-HTTP-UnixSocket' }
ZnNetworkingUtils >> unixSocketOnFile: socketFile [
	| socketAddress ipcSocket |
	socketFile exists ifFalse: [ 
		ZnMissingUnixSocket new file: socketFile; signal ].
	socketAddress := NetNameResolver addressForSocketPath: socketFile fullName.
	ipcSocket := Socket newIPC.
	ipcSocket ifNil: [ 
		ZnCannotCreateUnixSocket new file: socketFile; signal ].
	ipcSocket connectTo: socketAddress.
	ipcSocket isConnected ifFalse: [ 
		ZnCannotConnectUnixSocket new file: socketFile; signal ].
	^ ipcSocket
]
