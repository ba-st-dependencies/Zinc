"
ZnWebWorkspaceDelegate implements the http://ws.stfx.eu shared workspaces web service.

(ZnServer defaultOn: 1701)
	delegate: (ZnWebWorkspaceDelegate new endpoint: 'http://localhost:1701'; yourself);
	logToTranscript;
	start.
	
ZnEasy get: 'http://localhost:1701/1WS4U'
ZnEasy get: 'http://localhost:1701/1WS4U?format=text'
ZnEasy get: 'http://localhost:1701/1WS4U?format=html'

ZnEasy 
	post: 'http://localhost:1701' 
	data: (ZnEntity text: '123 factorial.\3 timesRepeat: [ Smalltalk garbageCollect ]\' withCRs).

"
Class {
	#name : 'ZnWebWorkspaceDelegate',
	#superclass : 'Object',
	#instVars : [
		'workspaces',
		'endpoint'
	],
	#category : 'Zinc-WWS-Server',
	#package : 'Zinc-WWS-Server'
}

{ #category : 'private' }
ZnWebWorkspaceDelegate >> demoKey [
	^ '1WS4U'
]

{ #category : 'accessing' }
ZnWebWorkspaceDelegate >> endpoint [
	^ endpoint ifNil: [ endpoint := 'http://ws.stfx.eu' asZnUrl ]
]

{ #category : 'initialize-release' }
ZnWebWorkspaceDelegate >> endpoint: aUrlObject [
	endpoint := aUrlObject asZnUrl 
]

{ #category : 'private html generation' }
ZnWebWorkspaceDelegate >> generateCaptcha: request [
	| first second |
	first := request session attributeAt: #firstNumber put: 10 atRandom.
	second := request session attributeAt: #secondNumber put: 10 atRandom.
	^ String streamContents: [ :stream |
		stream << ' Captcha: '; << first asWords; << ' plus '; << second asWords.
		stream << ' equals <input name="sum" placeholder="0" title="Enter the sum in digits" size="3"> ' ]
]

{ #category : 'private html generation' }
ZnWebWorkspaceDelegate >> generateHomepage [
	^ String streamContents: [ :stream |
		stream << '<!DOCTYPE html>'.
		stream << '<html>'.
		stream << self homepageData.
		stream << self standardPageFooter.
		stream << '</body></html>' ]

]

{ #category : 'private' }
ZnWebWorkspaceDelegate >> generateNewKey [
	^ ((10 raisedTo: 9) atRandom * Time totalSeconds) printStringBase: 36

]

{ #category : 'private html generation' }
ZnWebWorkspaceDelegate >> generateNewPage [
	^ String streamContents: [ :stream |
		stream << '<!DOCTYPE html>'.
		stream << '<html>'.
		stream << self newPageData.
		stream << self standardPageFooter.
		stream << '</body></html>' ]

]

{ #category : 'private html generation' }
ZnWebWorkspaceDelegate >> generatePageFor: workspace withKey: key [
	^ String streamContents: [ :stream |
		stream << '<!DOCTYPE html>'; crlf.
		stream << '<html>' << (self standardPageHeader format: { key }).
		stream << '<body>'.
		stream << (self standardPageProlog format: { self endpoint. key }).
		stream << '<pre><code class="smalltalk">' << workspace << '</code></pre>'.
		stream << self standardPageFooter.
		stream << '</body></html>' ]

]

{ #category : 'private request handling' }
ZnWebWorkspaceDelegate >> handleGet: request [
	| key workspace format entity |
	key := request uri firstPathSegment.
	workspace := workspaces at: key ifAbsent: [ ^ ZnResponse notFound: request uri ].
	format := request uri queryAt: 'format' ifAbsent: [ nil ].
	entity := (format = 'html' or: [ (self isBrowserRequest: request) and: [ format ~= 'text' ] ])
		ifTrue: [ ZnEntity html: (self generatePageFor: workspace withKey: key) ]
		ifFalse: [ ZnEntity text: workspace ].
	^ ZnResponse ok: entity
]

{ #category : 'private request handling' }
ZnWebWorkspaceDelegate >> handleIndex: request [
	^ ZnResponse ok: (ZnEntity html: self generateHomepage)
]

{ #category : 'private request handling' }
ZnWebWorkspaceDelegate >> handleNewIndex: request [
	| html captcha |
	captcha := self generateCaptcha: request.
	html := self generateNewPage format: { #captcha -> captcha } asDictionary.
	^ ZnResponse ok: (ZnEntity html: html)
]

{ #category : 'private request handling' }
ZnWebWorkspaceDelegate >> handleNewPost: request [
	| key contents first second sum |
	(request hasEntity and: [ request entity contentType = ZnMimeType applicationFormUrlEncoded ])
		ifFalse: [ ^ ZnResponse badRequest: request ].
	contents := request entity at: #contents.
	first := request session attributeAt: #firstNumber ifAbsent: [ 0 ]. 
	second := request session attributeAt: #secondNumber ifAbsent: [ 0 ]. 
	sum := Integer readFrom: (request entity at: #sum ifAbsent: [ ]) ifFail: [ 0 ].
	contents isEmpty | first isZero | second isZero | sum isZero | (first + second ~= sum) 
		ifTrue: [  ^ ZnResponse badRequest: request ].
	key := self generateNewKey.
	workspaces at: key put: contents.
	^ ZnResponse redirect: key
]

{ #category : 'private request handling' }
ZnWebWorkspaceDelegate >> handlePost: request [
	| key |
	(request hasEntity and: [ request entity contentType isBinary not ])
		ifFalse: [ ^ ZnResponse badRequest: request ].
	key := self generateNewKey.
	workspaces at: key put: request contents.
	^ ZnResponse created: key
]

{ #category : 'public' }
ZnWebWorkspaceDelegate >> handleRequest: request [
	request uri isSlash
		ifTrue: [ 
			request method = #GET ifTrue: [ ^ self handleIndex: request ].
			request method = #POST ifTrue: [ ^ self handlePost: request ] ]
		ifFalse: [ 
			request uri pathSegments size = 1
				ifTrue: [ 
					request uri firstPathSegment = #new
						ifTrue: [ 
							request method = #GET ifTrue: [ ^ self handleNewIndex: request ].
							request method = #POST ifTrue: [ ^ self handleNewPost: request ] ]
						ifFalse: [ 
							request method = #GET
								ifTrue: [ ^ self handleGet: request ] ] ] ].
	^ ZnResponse badRequest: request uri
]

{ #category : 'private html' }
ZnWebWorkspaceDelegate >> homepageData [
	^ '
<head>
<title>Shared Smalltalk Workspaces</title>
<link href="http://stfx.eu/wws/style.css" rel="stylesheet" type="text/css"/>
</head>

<body>

<h1>Shared Smalltalk Workspaces</h1>
<h3>Hello and welcome to http://ws.stfx.eu,</h3>
<h3>a free web service to share Smalltalk workspaces.</h3>

<div class="intro">
<p>
This website offers a web service to easily <b>share Smalltalk workspaces</b>.
</p>
<p>
It is a <a href="http://en.wikipedia.org/wiki/Pastebin">pastebin</a> for Smalltalk.
</p>
<p>
Using the standard Workspace <b>GTPlayground</b>,
you can easily <b>publish the contents of any workspace to this website/webservice</b>.
</p>
<p>
Each time you publish a workspace, you will create a new shared web workspace.
Each shared web workspace is identified by a unique key.
Keys look like 6DKGPHMWVMI8. The <b>unique, official URL</b> to the shared workspace
for that key then becomes http://ws.stfx.eu/6DKGPHMWVMI8.
</p>
<p>
To actually <b>share the workspace</b> you can <b>pass the URL around</b> in any message.
Recepients will then be able to <b>open the shared workspace using a web browser</b>.
The HTML page generated will apply Smalltalk aware syntax highlighting to the contents.
</p>
<p>
Alternatively, recipients of a shared workspace URL or key can <b>use Spotter or GTPlayground
to open the contents right in an image</b>, ready to be used.
</p>
<p>
For instructions on how to begin, see the <a href="1WS4U">Getting Started Workspace</a>.
</p>
<p>
You can also create a shared workspace using <b>a simple web interface</b> where you can directly type or paste text, see <a href="new">New</a>.
</p>
<p>
All information published via this service is public.
The keys in the URLs are random and hard to guess, 
so unless someone knows the URL/key they won''t be able to access the workspace.
We promise not to further share workspaces by publishing indexes or making their contents searcheable.
This service is currently in beta.
Workspaces are not guaranteed to be persistent,
although every effort is made to offer a good service.
</p>
<p>
When serving a workspace''s contents, the Accept HTTP header will normally determine the resulting response''s content.
Browser HTTP agents that normally indicate that they prefer HTML content will receive a full, decorated HTML page.
Non-browser HTTP agents will receive plain, undecorated text content. 
A custom Accept header can be used to control the response.
Additionally, adding a query parameter format=html or format=text to the URL will override this behavior. 
</p>
<p>
Once created, shared workspaces are read-only. They can neither be modified, nor deleted.
Little used workspaces will eventually be removed after some period of time.
The maximum size for workspaces is limited to 2Kb. 
Any line end convention as well as ASCII, Latin1 and UTF-8 encoding are supported for incoming data.
Workspaces are always served using the Unix line end convention and UTF-8 encoding.
</p>
</div>
'
]

{ #category : 'initialize-release' }
ZnWebWorkspaceDelegate >> initialize [ 
	super initialize.
	workspaces := ZnWebWorkspaceStorage on: 'wws/data' asFileReference
]

{ #category : 'private' }
ZnWebWorkspaceDelegate >> isBrowserRequest: request [
	| accept primaryMimeType |
	accept := request headers at: 'Accept' ifAbsent: [ ^ false ].
	primaryMimeType := (((accept findTokens: ',') 
		collect: [ :each | each asZnMimeType])
			sorted: [ :x :y | | q1 q2 |
				q1 := (x parameterAt: 'q' ifAbsent: [ 1.0 ]) asNumber.
				q2 := (y parameterAt: 'q' ifAbsent: [ 1.0 ]) asNumber.
				q1 >= q2 ]) first.
	^ primaryMimeType matches: ZnMimeType textHtml 
]

{ #category : 'private html' }
ZnWebWorkspaceDelegate >> newPageData [
	^ '
<head>
<title>Create A New Shared Smalltalk Workspace</title>
<link href="http://stfx.eu/wws/style.css" rel="stylesheet" type="text/css"/>
</head>

<body>

<h1>Create A New Shared Smalltalk Workspace</h1>

<form method="POST" action="new">
<textarea 
  name="contents" class="smalltalk"
  rows="20" cols="60" 
  placeholder="
Go ahead and type or paste Smalltalk code. 
Answer the Captcha and press Create when you are done. 
Once created, a workspace is readonly and can no longer be edited. 
If anything goes wrong, use your Browser''s Back button.
">
</textarea>
<div class="toolbar">
  <a href="/">Home</a>
  | <a href="1WS4U">Getting Started Workspace</a>
  | {captcha}
  | <input type="submit" value="Create"</a>
</div>
</form>
'
]

{ #category : 'private html' }
ZnWebWorkspaceDelegate >> standardPageFooter [
	^ '<div class="footer">
<a href="http://ws.stfx.eu">Shared Smalltalk Workspaces</a>
 is a free web service offered by
<a href="http://stfx.eu">http://stfx.eu</a>. 
Copyright &copy; 2012-2019 Sven Van Caekenberghe.
Built and served using <a href="http://www.pharo.org">Pharo Smalltalk</a> 7.0.
</div>
<div class="disclaimer">
THIS SOFTWARE SERVICE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHOR OR SERVICE PROVIDER BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE SERVICE OR THE USE OR OTHER DEALINGS 
IN THE SOFTWARE SERVICE.
</div>'
]

{ #category : 'private html' }
ZnWebWorkspaceDelegate >> standardPageHeader [
	^ '<head>
<title>Shared Smalltalk Workspace {1} - http://ws.stfx.eu/{1}</title>
<link href="http://stfx.eu/wws/style.css" rel="stylesheet" type="text/css"/>
<script src="http://stfx.eu/wws/highlight/highlight.pack.js" type="text/javascript"></script>
<script type="text/javascript">
  hljs.initHighlightingOnLoad();
</script>
<link href="http://stfx.eu/wws/highlight/styles/default.css" rel="stylesheet"" type="text/css"/>
</head>
'
]

{ #category : 'private html' }
ZnWebWorkspaceDelegate >> standardPageProlog [
	^ '<h1>Shared Smalltalk Workspace {1}<h1>
<h3><a href="{1}">http://ws.stfx.eu/{1}</a></h3>
<div class="toolbar">
Doit <input class="doit" type="text" value="GTPlayground openUrl: ''{1}{2}''." size="60" readonly="true"/>
| <a href="{1}?format=text">Raw</a>
| <a href="1WS4U">Getting Started Workspace</a>
| <a href="/">Home</a>
| <a href="new">New</a>
</div>
'
]
