"
I am ZnOAuth1DropboxUserAccess, an implementation of part of the DropBox API.
I am a ZnOAuth1UserAccess.

See https://www.dropbox.com/developers/reference
"
Class {
	#name : 'ZnOAuth1DropboxUserAccess',
	#superclass : 'ZnOAuth1UserAccess',
	#category : 'Zinc-SSO-OAuth1-Core',
	#package : 'Zinc-SSO-OAuth1-Core'
}

{ #category : 'api' }
ZnOAuth1DropboxUserAccess >> getAccountInfo [
	| url response |
	url := ZnUrl fromString: 'https://api.dropbox.com/1/account/info'.
	response := self oauth1Service httpGet: url using: self accessToken.
	^ NeoJSONReader fromString: response
]

{ #category : 'api' }
ZnOAuth1DropboxUserAccess >> getFile: pathSegments [
	| url response |
	url := ZnUrl fromString: 'https://api-content.dropbox.com/1/files/sandbox'.
	url addPathSegments: pathSegments.
	response := self oauth1Service httpGet: url using: self accessToken.
	^ response
]

{ #category : 'api' }
ZnOAuth1DropboxUserAccess >> getMetaData: pathSegments [
	| url response |
	url := ZnUrl fromString: 'https://api.dropbox.com/1/metadata/sandbox'.
	url addPathSegments: pathSegments.
	url queryAt: #list put: #true.
	response := self oauth1Service httpGet: url using: self accessToken.
	^ NeoJSONReader fromString: response
]

{ #category : 'api' }
ZnOAuth1DropboxUserAccess >> getRootInfo [
	^ self getMetaData: #( #/ )
]

{ #category : 'api' }
ZnOAuth1DropboxUserAccess >> putFile: pathSegments data: entity [
	| url response |
	url := ZnUrl fromString: 'https://api-content.dropbox.com/1/files_put/sandbox'.
	url addPathSegments: pathSegments.
	response := self oauth1Service httpPut: url with: entity using: self accessToken.
	^ NeoJSONReader fromString: response
]
