"
I am ZnGoogleOAuth2Session.
I am a ZnOAuthSession.

Google OAuth2 docs: https://developers.google.com/identity/protocols/OAuth2WebServer.

accessType - hold the access type value described by the Google OAuth2 docs. The value can be: ""online"" (default) or ""offline"".

prompt - hold the approval_prompt value described by the Google OAuth2 docs. The value can be: ""none"", ""consent"" and/or ""select_account"". It is useful to use ""consent"" when in ""offline"" mode, because a refresh_token is sent only when user consent is obtained.

"
Class {
	#name : 'ZnGoogleOAuth2Session',
	#superclass : 'ZnOAuth2Session',
	#instVars : [
		'accessType',
		'prompt'
	],
	#category : 'Zinc-SSO-OAuth2-Core',
	#package : 'Zinc-SSO-OAuth2-Core'
}

{ #category : 'resources' }
ZnGoogleOAuth2Session class >> scopeUserinfoEmail [
	"Gain read-only access to the user's email address."

	^ 'https://www.googleapis.com/auth/userinfo.email'
]

{ #category : 'resources' }
ZnGoogleOAuth2Session class >> scopeUserinfoProfile [
	"Gain read-only access to basic profile information, including a user identifier, name, profile photo, 
	profile URL, country, language, timezone, and birthdate. "

	^ 'https://www.googleapis.com/auth/userinfo.profile'
]

{ #category : 'resources' }
ZnGoogleOAuth2Session class >> ssoScopes [
	"Answer a collection of scopes that can be used for Authentication. "

	^ Array with: self scopeUserinfoProfile with: self scopeUserinfoEmail
]

{ #category : 'accessing' }
ZnGoogleOAuth2Session >> accessType [
	^ accessType
]

{ #category : 'accessing' }
ZnGoogleOAuth2Session >> accessType: aString [
	accessType := aString
]

{ #category : 'public' }
ZnGoogleOAuth2Session >> authenticationUrlWithState: stateString [
	"Add access_type and prompt parameters for Google OAuth 2.0."

	^ (super authenticationUrlWithState: stateString)
		queryAt: 'access_type' put: self accessType;
		queryAt: 'prompt' put: self prompt;
		yourself
]

{ #category : 'accessing' }
ZnGoogleOAuth2Session >> beConsentPrompt [
	self prompt: 'consent'
]

{ #category : 'accessing' }
ZnGoogleOAuth2Session >> beNonePrompt [
	self prompt: 'none'
]

{ #category : 'accessing' }
ZnGoogleOAuth2Session >> beOfflineAccessType [
	self accessType: 'offline'
]

{ #category : 'accessing' }
ZnGoogleOAuth2Session >> beOnlineAccessType [
	self accessType: 'online'
]

{ #category : 'accessing' }
ZnGoogleOAuth2Session >> beSelectAccountPrompt [
	self prompt: 'select_account'
]

{ #category : 'public' }
ZnGoogleOAuth2Session >> getUserData [

	| url client response |
	
	url := (ZnUrl fromString: 'https://www.googleapis.com/oauth2/v3/userinfo')
		queryAt: 'access_token' put: self accessToken;
		yourself.

	client := ZnClient new.
	response := [ client get: url ] 
		ensure: [ client close ].
	
	^ ZnUtils defaultJSONReader fromString: response
]

{ #category : 'initialize-release' }
ZnGoogleOAuth2Session >> initialize [
	super initialize.
	self beOnlineAccessType.
	self beNonePrompt.
	self authorizationEndpoint: 'https://accounts.google.com/o/oauth2/v2/auth'.
	self tokenEndpoint: 'https://oauth2.googleapis.com/token'.
]

{ #category : 'accessing' }
ZnGoogleOAuth2Session >> prompt [
	^ prompt
]

{ #category : 'accessing' }
ZnGoogleOAuth2Session >> prompt: aString [
	prompt := aString
]
