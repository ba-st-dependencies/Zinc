"
"
Class {
	#name : #ZdcGemStoneSSLSession,
	#superclass : #ZdcAbstractSSLSession,
	#instVars : [
    'secureSocket'
	],
	#category : #'Zodiac-GemStone-Core'
}

{ #category : #'operations' }
ZdcGemStoneSSLSession >> connect: srcBuf from: start to: stop into: dstBuf [
  "Start or continue the client handshake using the given input token"
  "Starts or continues a client handshake using the provided data.
	Will eventually produce output to be sent to the server"
  GsSecureSocket setCaCertLocation.
  self secureSocket secureConnect
    ifFalse: [ 
      | certError errorString |
      certError := GsSecureSocket fetchLastCertificateVerificationErrorForClient.
      errorString := self secureSocket lastErrorString asString.
      [ 
      certError
        ifNil: [ self error: errorString ]
        ifNotNil: [ self error: 'Cert error: =>' , certError , ' : ' , errorString ] ]
        ensure: [ self destroy ] ].
  ^ 0
]

{ #category : #'initialize' }
ZdcGemStoneSSLSession >> destroy [
  "Do any necessary cleanup when I am no longer needed"
  secureSocket ifNil: [ ^ self ].
  secureSocket close.
  secureSocket := nil
]

{ #category : #'testing' }
ZdcGemStoneSSLSession >> isConnected [
  "Returns true if the SSL handshake has been completed"
  ^ self secureSocket isActive
]

{ #category : #'accessing' }
ZdcGemStoneSSLSession >> secureSocket: aGsSecureSocket [
  secureSocket := aGsSecureSocket
]

{ #category : #'accessing' }
ZdcGemStoneSSLSession >> secureSocket [
  ^ secureSocket
]

{ #category : #'accessing' }
ZdcGemStoneSSLSession >> certificateName [
	^ ''
]

{ #category : #'accessing' }
ZdcGemStoneSSLSession >> certificateName: aString [
	"We are not doing anything for now"
]

{ #category : #'accessing' }
ZdcGemStoneSSLSession >> serverName [
		^ secureSocket getServerNameIndication
]

{ #category : #'accessing' }
ZdcGemStoneSSLSession >> serverName: aString [
	secureSocket setServerNameIndication: aString.
	secureSocket setExpectedHost: aString
]