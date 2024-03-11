"
ZnExampleStorageNotificationRestCall

GET /storage/exception/notification

	Causes a Notification and then generate a result

"
Class {
	#name : 'ZnExampleStorageNotificationRestCall',
	#superclass : 'ZnExampleStorageRestCall',
	#category : 'Zinc-REST-Tests',
	#package : 'Zinc-REST',
	#tag : 'Tests'
}

{ #category : 'accessing' }
ZnExampleStorageNotificationRestCall class >> pattern [
	^ #( 'storage' 'exception' 'notification' )
]

{ #category : 'public' }
ZnExampleStorageNotificationRestCall >> get [

	"Raise a Notification during the operation. E.g. when using
	NativeBoost a NBRecursionDetect will be notified that should
	not abort the execution"
	Notification signal: 'Something to note'.
	self jsonResponse: Dictionary new.
]
