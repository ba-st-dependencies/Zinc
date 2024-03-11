"
ZnExampleStorageAssertionFailureRestCall


GET /storage/exception/assertion

	Causes an AssertionFailure
"
Class {
	#name : 'ZnExampleStorageAssertionFailureRestCall',
	#superclass : 'ZnExampleStorageRestCall',
	#category : 'Zinc-REST-Tests',
	#package : 'Zinc-REST',
	#tag : 'Tests'
}

{ #category : 'accessing' }
ZnExampleStorageAssertionFailureRestCall class >> pattern [
	^ #( 'storage' 'exception' 'assertion' )
]

{ #category : 'public' }
ZnExampleStorageAssertionFailureRestCall >> get [
	"Let it fail"
	AssertionFailure signal: 'We can not handle this request'
]
