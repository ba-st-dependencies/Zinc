"
I am ZnMaximumNumberOfDictionaryEntries.
I am a DynamicVariable and a ProcessSpecificVariable.

I am used to control the maximum number of entries being added to a limited ZnMultiValueDictionary.

Used by ZnMultiValueDictionary and thus for reading headers,  url query and application form url encoded entity fields. This helps to protect us from malicious content.

"
Class {
	#name : 'ZnMaximumNumberOfDictionaryEntries',
	#superclass : 'DynamicVariable',
	#category : 'Zinc-Resource-Meta-Core',
	#package : 'Zinc-Resource-Meta-Core'
}

{ #category : 'accessing' }
ZnMaximumNumberOfDictionaryEntries class >> default [
	"The default maximum number dictionary entries to accept."

	^ 256
]

{ #category : #accessing }
ZnMaximumNumberOfDictionaryEntries >> default [

	^ self class default 
]
