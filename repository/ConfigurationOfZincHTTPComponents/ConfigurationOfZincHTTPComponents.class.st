"
I am ConfigurationOfZincHTTPComponents, the Metacello configuration of Zinc HTTP Components, an open-source Smalltalk framework to deal with the HTTP networking protocol.

For more information, see http://zn.stfx.eu

Here are some ways to load this project:

	ConfigurationOfZincHTTPComponents load.
	ConfigurationOfZincHTTPComponents project latestVersion load.
	ConfigurationOfZincHTTPComponents project latestVersion load: 'Tests'.
	(ConfigurationOfZincHTTPComponents project version: '2.9.1') load.
	ConfigurationOfZincHTTPComponents project bleedingEdge load.

Here is a list of available groups:

	default - Core
	Tests
	Character-Encoding
	Resource-Meta
	Zodiac
	
	AWS
	REST
	Seaside
	WebSocket
	SSO - SSO-OAuth1 - SSO-OAuth2 - SSO-OpenID - SSO-Demo
	
	WebDAV
	WWS
	Patch-HTTPSocket
	
This is open-source software licensed under the MIT License.
"
Class {
	#name : 'ConfigurationOfZincHTTPComponents',
	#superclass : 'Object',
	#instVars : [
		'project'
	],
	#classVars : [
		'LastVersionLoad'
	],
	#category : 'ConfigurationOfZincHTTPComponents',
	#package : 'ConfigurationOfZincHTTPComponents'
}

{ #category : 'private' }
ConfigurationOfZincHTTPComponents class >> bootstrapPackage: aString from: aPath [ 
	| repository version |
	repository := MCHttpRepository
				location: aPath
				user: ''
				password: ''.
	repository
		versionReaderForFileNamed: aString , '.mcz'
		do: [:reader | 
			version := reader version.
			version load.
			version workingCopy repositoryGroup addRepository: repository]
]

{ #category : 'catalog' }
ConfigurationOfZincHTTPComponents class >> catalogChangeLog [
	"Returns a paragraph describing the most important changes in the configuration class."
	^ 'Started and in production use since 2010, Zinc HTTP Components is a standard part of Pharo 1.4, 2.0, 3.0 and 4.0'
]

{ #category : 'catalog' }
ConfigurationOfZincHTTPComponents class >> catalogContactInfo [
	"Returns a paragraph describing contact information such as email, mailing lists and website."
	^ 'Written and maintained by Sven Van Caekenberghe (http://stfx.eu) and the community. Discussions on the Pharo mailing lists. Documentation can be found at http://zn.stfx.eu'
]

{ #category : 'catalog' }
ConfigurationOfZincHTTPComponents class >> catalogDescription [
	"Returns a paragraph describing the project"
	^ 'Zinc HTTP Components is an open source Smalltalk framework to deal with HTTP. It models most concepts of HTTP and its related standards and offers both client and server functionality. One of its key goals is to offer understandability (Smalltalk’s design principle number one). Anyone with a basic understanding of Smalltalk and the HTTP principles should be able to understand what is going on and learn, by looking at the implementation. '
]

{ #category : 'catalog' }
ConfigurationOfZincHTTPComponents class >> catalogKeyClassesAndExample [
	"Returns a paragraph or more describing the key classes of your project. You can use Pillar/Pier syntax to layout out the text i.e., ==Code== and - for bullet."
	^ 'The core classes are ZnClient and ZnServer. At a lower level, there are ZnRequest and ZnResponse, ZnEntity, ZnRequestLine, ZnStatusLine and ZnHeaders. This project also maintains ZnUrl, ZnMimeType and ZnCharacterEncoding.'
]

{ #category : 'catalog' }
ConfigurationOfZincHTTPComponents class >> catalogKeywords [
	"Returns an array of symbols"
	^ #(#networking #internet #http #client #server #request #response #url #'mime-type' #'character-encoding')
]

{ #category : 'private' }
ConfigurationOfZincHTTPComponents class >> ensureMetacello [
	"Bootstrap Gofer (if necessary), load latest mcz file for ConfigurationOfMetacello (using old 
	 Gofer API), then load the latest version of Metacello itself."

	Smalltalk at: #MetacelloProject ifAbsent: [ | error |
		"list of repositories to try, in case primary repository is not accessible"
		(Array 
			with: 'http://www.squeaksource.com/MetacelloRepository' 
			with: 'http://seaside.gemstone.com/ss/metacello') do: [:repositoryUrl |
				([
					Smalltalk at: #Gofer ifAbsent: [
					"Current version of Gofer from which to bootstrap - as of 1.0-beta.21"
						self bootstrapPackage: 'Gofer-Core-lr.115' from: repositoryUrl ].
					Smalltalk at: #Gofer ifPresent: [:goferClass | | gofer |
						gofer := goferClass new
							url: repositoryUrl;
							yourself.
						[ gofer addPackage: 'ConfigurationOfMetacello' ] on: Warning do: [:ex | ex resume ].
						gofer load ]]
							on: Error
							do: [ :ex |
								error := ex.
								Transcript 
									cr; 
									show: 'failed ensureMetacello: ';
									show: ex description printString;
									show: '...retrying'.
								"try again"
								ex return: nil ]) ~~ nil
					ifTrue: [
						"load 'default' group of Metacello"
						(Smalltalk at: #ConfigurationOfMetacello) perform: #load.
						^self ]].
		"shouldn't get here unless the load failed ... throw an error"
		self error: 'retry with alternate repository failed: ', error description printString ]
]

{ #category : 'accessing' }
ConfigurationOfZincHTTPComponents class >> getZnAndZdcMCVersions [
	^ (MCWorkingCopy allManagers collect: #description) 
			select: [ :each | ('*Zinc*' match: each) or: [ '*Zodiac*' match: each ]] 
			thenCollect: #asString
]

{ #category : 'accessing' }
ConfigurationOfZincHTTPComponents class >> getZnAndZdcMCVersionsReport [
	^ String crlf join: (self getZnAndZdcMCVersions) sorted
]

{ #category : 'metacello tool support' }
ConfigurationOfZincHTTPComponents class >> isMetacelloConfig [
	"Answer true and the Metacello tools will operate on you"
	
	^true
]

{ #category : 'metacello tool support' }
ConfigurationOfZincHTTPComponents class >> lastMetacelloVersionLoad [
	"Answer the last version loaded and the list of packages loaded for that version."

	LastVersionLoad == nil ifTrue: [ LastVersionLoad := nil -> 'default' ].
	^LastVersionLoad
]

{ #category : 'loading' }
ConfigurationOfZincHTTPComponents class >> load [
	"self load"

	^self project stableVersion load
]

{ #category : 'metacello tool support' }
ConfigurationOfZincHTTPComponents class >> metacelloVersion: versionString loads: anArrayOrString [
	"Stash the last version loaded and the list of packages loaded for that version. The list
	 of packages will be used by the tools when doing 'Load Package Version'"

	LastVersionLoad := versionString -> anArrayOrString
]

{ #category : 'accessing' }
ConfigurationOfZincHTTPComponents class >> project [

	^self new project
]

{ #category : 'unloading Metacello' }
ConfigurationOfZincHTTPComponents class >> unloadMetacello [

	Smalltalk at: #ConfigurationOfMetacello ifPresent: [:cls | cls unloadMetacello ]
]

{ #category : 'baselines' }
ConfigurationOfZincHTTPComponents >> baseline10: spec [ 
	<version: '1.0-baseline'>
	
	spec for: #common do: [
		spec 
			blessing: #baseline;
			description: 'Baseline for Zinc HTTP Components, a framework to deal with the HTTP networking';
			author: 'SvenVanCaekenberghe';
			repository: 'http://www.squeaksource.com/ZincHTTPComponents'.	
		spec project: 'Seaside30' with: [
				spec
					className: 'ConfigurationOfSeaside30';
					repository: 'http://www.squeaksource.com/MetacelloRepository' ].
		spec 
			package: 'Zinc-HTTP';
			package: 'Zinc-Patch-HTTPSocket' with: [ spec requires: 'Zinc-HTTP' ];
			package: 'Zinc-AWS' with: [ spec requires: 'Zinc-HTTP' ];
			package: 'Zinc-Tests' with: [ spec requires: 'Zinc-HTTP' ];
			package: 'Zinc-Seaside' with: [ spec requires: #('Zinc-HTTP' 'Seaside30') ].
		spec
			group: 'default' with: #('Core');
			group: 'Core' with: #('Zinc-HTTP');
			group: 'Tests' with: #('Zinc-Tests');
			group: 'Seaside' with: #('Zinc-Seaside');
			group: 'Patch-HTTPSocket' with: #('Zinc-Patch-HTTPSocket') ].
		
	spec for: #gemstone do:[
		spec repository: 'http://seaside.gemstone.com/ss/ZincHTTPComponents'.  
		spec
			package:'SocketStream' with:[spec repository: 'http://seaside.gemstone.com/ss/PharoCompat' ];
			package:'Seaside-GemStone-Adaptors-Zinc' with:[spec requires: #('Zinc-Gemstone' 'Zinc-Seaside')] ;
			package:'Zinc-GemstonePreliminary' with:[spec requires: #('SocketStream')  ];
			package:'Zinc-HTTP' with:[spec requires: #('Zinc-GemstonePreliminary')  ];
			package:'Zinc-Gemstone' with:[spec requires: #('Zinc-HTTP')  ];
			package: 'Zinc-Tests' with: [ spec requires: 'Zinc-Gemstone' ].
		spec
			group: 'default' with: #('Core');
			group: 'Core' with: #('Zinc-Gemstone');
			group: 'Tests' with: #('Zinc-Tests');
			group: 'Seaside' with: #('Seaside-GemStone-Adaptors-Zinc').
		
		]
]

{ #category : 'baselines' }
ConfigurationOfZincHTTPComponents >> baseline11: spec [ 
	<version: '1.1-baseline'>
	
	spec for: #common do: [
		spec 
			blessing: #baseline;
			description: 'Baseline for Zinc HTTP Components, a framework to deal with the HTTP networking';
			author: 'SvenVanCaekenberghe';
			repository: 'http://www.squeaksource.com/ZincHTTPComponents'.	
		spec project: 'Seaside30' with: [
				spec
					className: 'ConfigurationOfSeaside30';
					repository: 'http://www.squeaksource.com/MetacelloRepository' ].
		spec package: 'Zodiac' with: [spec repository: 'http://www.squeaksource.com/Zodiac'].
		spec 
			package: 'Zinc-HTTP';
			package: 'Zinc-Patch-HTTPSocket' with: [ spec requires: 'Zinc-HTTP' ];
			package: 'Zinc-AWS' with: [ spec requires: 'Zinc-HTTP' ];
			package: 'Zinc-Zodiac' with: [ spec requires:#( 'Zinc-HTTP' 'Zodiac') ];
			package: 'Zinc-Tests' with: [ spec requires: 'Zinc-HTTP' ];
			package: 'Zinc-Seaside' with: [ spec requires: #('Zinc-HTTP' 'Seaside30') ].
		spec
			group: 'default' with: #('Core');
			group: 'Core' with: #('Zinc-HTTP');
			group: 'Tests' with: #('Zinc-Tests');
			group: 'Seaside' with: #('Zinc-Seaside');
			group: 'Patch-HTTPSocket' with: #('Zinc-Patch-HTTPSocket') ].
		
	spec for: #gemstone do:[
		spec repository: 'http://seaside.gemstone.com/ss/ZincHTTPComponents'.  
		spec
			package:'SocketStream' with:[spec repository: 'http://seaside.gemstone.com/ss/PharoCompat' ];
			package:'Seaside-GemStone-Adaptors-Zinc' with:[spec requires: #('Zinc-Gemstone' 'Zinc-Seaside')] ;
			package:'Zinc-GemstonePreliminary' with:[spec requires: #('SocketStream')  ];
			package:'Zinc-HTTP' with:[spec requires: #('Zinc-GemstonePreliminary')  ];
			package:'Zinc-Gemstone' with:[spec requires: #('Zinc-HTTP')  ];
			package: 'Zinc-Tests' with: [ spec requires: 'Zinc-Gemstone' ].
		spec
			group: 'default' with: #('Core');
			group: 'Core' with: #('Zinc-Gemstone');
			group: 'Tests' with: #('Zinc-Tests');
			group: 'Seaside' with: #('Seaside-GemStone-Adaptors-Zinc').
		
		]
]

{ #category : 'baselines' }
ConfigurationOfZincHTTPComponents >> baseline12: spec [ 
	<version: '1.2-baseline'>
	
	spec for: #common do: [
		spec 
			blessing: #baseline;
			description: 'Baseline for Zinc HTTP Components, a framework to deal with the HTTP networking:
  move Seaside support to ConfigurationOfSeaside30.';
			author: 'SvenVanCaekenberghe';
			repository: 'http://www.squeaksource.com/ZincHTTPComponents'.	
		spec package: 'Zodiac' with: [spec repository: 'http://www.squeaksource.com/Zodiac'].
		spec 
			package: 'Zinc-HTTP';
			package: 'Zinc-Patch-HTTPSocket' with: [ spec requires: 'Zinc-HTTP' ];
			package: 'Zinc-AWS' with: [ spec requires: 'Zinc-HTTP' ];
			package: 'Zinc-Zodiac' with: [ spec requires:#( 'Zinc-HTTP' 'Zodiac') ];
			package: 'Zinc-Tests' with: [ spec requires: 'Zinc-HTTP' ].
		spec
			group: 'default' with: #('Core');
			group: 'Core' with: #('Zinc-HTTP');
			group: 'Tests' with: #('Zinc-Tests');
			group: 'Patch-HTTPSocket' with: #('Zinc-Patch-HTTPSocket') ].
		
	spec for: #gemstone do:[
		spec repository: 'http://seaside.gemstone.com/ss/ZincHTTPComponents'.  
		spec
			package:'Zinc-HTTP' with:[spec includes: #('Zinc-Gemstone')  ];
			package:'SocketStream' with:[spec repository: 'http://seaside.gemstone.com/ss/PharoCompat' ];
			package:'Zinc-GemstonePreliminary' with:[spec requires: #('SocketStream')  ];
			package:'Zinc-HTTP' with:[spec requires: #('Zinc-GemstonePreliminary')  ];
			package:'Zinc-Gemstone' with:[spec requires: #('Zinc-HTTP')  ];
			package: 'Zinc-Tests' with: [ spec requires: 'Zinc-Gemstone' ].
		]
]

{ #category : 'baselines' }
ConfigurationOfZincHTTPComponents >> baseline13: spec [ 
	<version: '1.3-baseline'>
	
	spec for: #common do: [
		spec 
			blessing: #baseline;
			description: 'Baseline for Zinc HTTP Components, a framework to deal with the HTTP networking:
  move Seaside support to ConfigurationOfSeaside30.';
			author: 'SvenVanCaekenberghe';
			repository: 'http://www.squeaksource.com/ZincHTTPComponents'.	
		spec package: 'Zodiac' with: [spec repository: 'http://www.squeaksource.com/Zodiac'].
		spec 
			package: 'Zinc-HTTP';
			package: 'Zinc-Patch-HTTPSocket' with: [ spec requires: 'Zinc-HTTP' ];
			package: 'Zinc-AWS' with: [ spec requires: 'Zinc-HTTP' ];
			package: 'Zinc-REST' with: [ spec requires: 'Zinc-HTTP' ];
			package: 'Zinc-Zodiac' with: [ spec requires:#( 'Zinc-HTTP' 'Zodiac') ];
			package: 'Zinc-Tests' with: [ spec requires: 'Zinc-HTTP' ].
		spec
			group: 'default' with: #('Core');
			group: 'Core' with: #('Zinc-HTTP');
			group: 'Tests' with: #('Zinc-Tests');
			group: 'Patch-HTTPSocket' with: #('Zinc-Patch-HTTPSocket') ].
		
	spec for: #gemstone do:[
		spec repository: 'http://seaside.gemstone.com/ss/ZincHTTPComponents'.  
		spec
			package:'Zinc-HTTP' with:[spec includes: #('Zinc-Gemstone')  ];
			package:'SocketStream' with:[spec repository: 'http://seaside.gemstone.com/ss/PharoCompat' ];
			package:'Zinc-GemstonePreliminary' with:[spec requires: #('SocketStream')  ];
			package:'Zinc-HTTP' with:[spec requires: #('Zinc-GemstonePreliminary')  ];
			package:'Zinc-Gemstone' with:[spec requires: #('Zinc-HTTP')  ];
			package: 'Zinc-Tests' with: [ spec requires: 'Zinc-Gemstone' ].
		]
]

{ #category : 'baselines' }
ConfigurationOfZincHTTPComponents >> baseline14: spec [ 
	<version: '1.4-baseline'>
	
	spec for: #common do: [
		spec 
			blessing: #baseline;
			description: 'Baseline for Zinc HTTP Components, a framework to deal with the HTTP networking';
			author: 'SvenVanCaekenberghe';
			repository: 'http://www.squeaksource.com/ZincHTTPComponents'.	
		spec package: 'Zodiac' with: [spec repository: 'http://www.squeaksource.com/Zodiac'].
		spec 
			package: 'Zinc-HTTP';
			package: 'Zinc-Patch-HTTPSocket' with: [
				spec
					repository: 'http://ss3.gemstone.com/ss/pharo';
					requires: 'Zinc-HTTP' ];
			package: 'Zinc-AWS' with: [ spec requires: 'Zinc-HTTP' ];
			package: 'Zinc-REST' with: [ spec requires: 'Zinc-HTTP' ];
			package: 'Zinc-Zodiac' with: [ spec requires:#( 'Zinc-HTTP' 'Zodiac') ];
			package: 'Zinc-Tests' with: [ spec requires: 'Zinc-HTTP' ].
		spec
			group: 'default' with: #('Core');
			group: 'Core' with: #('Zinc-HTTP');
			group: 'Tests' with: #('Zinc-Tests');
			group: 'Patch-HTTPSocket' with: #('Zinc-Patch-HTTPSocket') ].
		
	spec for: #gemstone do:[
		spec repository: 'http://seaside.gemstone.com/ss/ZincHTTPComponents'.  
		spec
			package:'Zinc-HTTP' with:[spec includes: #('Zinc-Gemstone')  ];
			package:'SocketStream' with:[spec repository: 'http://seaside.gemstone.com/ss/PharoCompat' ];
			package:'Zinc-GemstonePreliminary' with:[spec requires: #('SocketStream')  ];
			package:'Zinc-HTTP' with:[spec requires: #('Zinc-GemstonePreliminary')  ];
			package:'Zinc-Gemstone' with:[spec requires: #('Zinc-HTTP')  ];
			package: 'Zinc-Tests' with: [ spec requires: 'Zinc-Gemstone' ].
		]
]

{ #category : 'baselines' }
ConfigurationOfZincHTTPComponents >> baseline15: spec [
	<version: '1.5-baseline'>
	spec
		for: #common
		do: [ 
			spec
				blessing: #baseline;
				description: 'Baseline for Zinc HTTP Components, a framework to deal with the HTTP networking';
				author: 'PaulDeBruicker';
				timestamp: '4/4/2012 09:12';
				repository: 'http://www.squeaksource.com/ZincHTTPComponents'.
			spec package: 'Zodiac-Core' with: [ spec repository: 'http://www.squeaksource.com/Zodiac' ].
			spec
				package: 'Zinc-HTTP';
				package: 'Zinc-Patch-HTTPSocket'
					with: [ 
							spec
								repository: 'http://ss3.gemstone.com/ss/pharo';
								requires: 'Zinc-HTTP' ];
				package: 'Zinc-AWS' with: [ spec requires: 'Zinc-HTTP' ];
				package: 'Zinc-REST' with: [ spec requires: 'Zinc-HTTP' ];
				package: 'Zinc-Zodiac' with: [ spec requires: #('Zinc-HTTP' 'Zodiac-Core') ];
				package: 'Zinc-WebDAV' with: [ spec requires: 'Zinc-HTTP' ];
				package: 'Zinc-WWS-Server' with: [ spec requires: 'Zinc-HTTP' ];
				package: 'Zinc-WWS-Client' with: [ spec requires: 'Zinc-HTTP' ];
				package: 'Zinc-Tests' with: [ spec requires: 'Zinc-HTTP' ].
			spec
				group: 'default' with: #('Core');
				group: 'Core' with: #('Zinc-HTTP');
				group: 'Tests' with: #('Zinc-Tests');
				group: 'AWS' with: #('Zinc-AWS');
				group: 'WebDAV' with: #('Zinc-WebDAV');
				group: 'WWS' with: #('Zinc-WWS-Server' 'Zinc-WWS-Client');
				group: 'REST' with: #('Zinc-REST');
				group: 'Patch-HTTPSocket' with: #('Zinc-Patch-HTTPSocket') ].
	spec
		for: #gemstone
		do: [ 
			spec repository: 'http://seaside.gemstone.com/ss/ZincHTTPComponents'.
			spec
				package: 'Zinc-HTTP' with: [ spec includes: #('Zinc-Gemstone') ];
				package: 'SocketStream' with: [ spec repository: 'http://seaside.gemstone.com/ss/PharoCompat' ];
				package: 'Zinc-GemstonePreliminary' with: [ spec requires: #('SocketStream') ];
				package: 'Zinc-HTTP' with: [ spec requires: #('Zinc-GemstonePreliminary') ];
				package: 'Zinc-Gemstone' with: [ spec requires: #('Zinc-HTTP') ];
				package: 'Zinc-Tests' with: [ spec requires: 'Zinc-Gemstone' ] ]
]

{ #category : 'baselines' }
ConfigurationOfZincHTTPComponents >> baseline17: spec [
	<version: '1.7-baseline'>
	spec
		for: #common
		do: [ 
			spec
				blessing: #baseline;
				description: '
- add XMLSupport project
- update Zinc-AWS to require above
- add  FileSystem-Legacy to Pharo 1.x and FileSystem to Pharo 2.x';
				author: 'SeanDeNigris';
				timestamp: '7/4/2012 12:12-04:00';
				repository: 'http://www.squeaksource.com/ZincHTTPComponents'.
			spec project: 'XML Support' with: [
				spec
					className: 'ConfigurationOfXMLSupport';
					versionString: #'stable';
					repository: 'http://www.squeaksource.com/MetacelloRepository' ].
			spec package: 'Zodiac-Core' with: [ spec repository: 'http://www.squeaksource.com/Zodiac' ].
			spec
				package: 'Zinc-HTTP';
				package: 'Zinc-Patch-HTTPSocket'
					with: [ 
							spec
								repository: 'http://ss3.gemstone.com/ss/pharo';
								requires: 'Zinc-HTTP' ];
				package: 'Zinc-AWS' with: [ spec requires: #('Zinc-HTTP' 'XML Support') ];
				package: 'Zinc-REST' with: [ spec requires: 'Zinc-HTTP' ];
				package: 'Zinc-Zodiac' with: [ spec requires: #('Zinc-HTTP' 'Zodiac-Core') ];
				package: 'Zinc-WebDAV' with: [ spec requires: 'Zinc-HTTP' ];
				package: 'Zinc-WWS-Server' with: [ spec requires: 'Zinc-HTTP' ];
				package: 'Zinc-WWS-Client' with: [ spec requires: 'Zinc-HTTP' ];
				package: 'Zinc-Tests' with: [ spec requires: 'Zinc-HTTP' ].
			spec
				group: 'default' with: #('Core');
				group: 'Core' with: #('Zinc-HTTP');
				group: 'Tests' with: #('Zinc-Tests');
				group: 'AWS' with: #('Zinc-AWS');
				group: 'WebDAV' with: #('Zinc-WebDAV');
				group: 'WWS' with: #('Zinc-WWS-Server' 'Zinc-WWS-Client');
				group: 'REST' with: #('Zinc-REST');
				group: 'Patch-HTTPSocket' with: #('Zinc-Patch-HTTPSocket') ].
	spec for: #'pharo1.x' do: [ 
		spec
			package: 'Zinc-FileSystem-Legacy';
			package: 'Zinc-HTTP' with: [ spec requires: 'Zinc-FileSystem-Legacy' ] ].
	spec for: #'pharo2.x' do: [
		spec
			package: 'Zinc-FileSystem';
			package: 'Zinc-HTTP' with: [ spec requires: 'Zinc-FileSystem' ] ].
	spec
		for: #gemstone
		do: [ 
			spec repository: 'http://seaside.gemstone.com/ss/ZincHTTPComponents'.
			spec
				package: 'Zinc-HTTP' with: [ spec includes: #('Zinc-Gemstone') ];
				package: 'SocketStream' with: [ spec repository: 'http://seaside.gemstone.com/ss/PharoCompat' ];
				package: 'Zinc-GemstonePreliminary' with: [ spec requires: #('SocketStream') ];
				package: 'Zinc-HTTP' with: [ spec requires: #('Zinc-GemstonePreliminary') ];
				package: 'Zinc-Gemstone' with: [ spec requires: #('Zinc-HTTP') ];
				package: 'Zinc-Tests' with: [ spec requires: 'Zinc-Gemstone' ] ]
]

{ #category : 'baselines' }
ConfigurationOfZincHTTPComponents >> baseline18: spec [
	<version: '1.8-baseline'>
	spec for: #common do: [ 
		spec
			blessing: #baseline;
			description: 'Baseline for Zinc HTTP Components, a framework to deal with the HTTP networking';
			author: 'SvenVanCaekenberghe';
			repository: 'http://www.squeaksource.com/ZincHTTPComponents'.
		spec project: 'XML Support' with: [
			spec
				className: 'ConfigurationOfXMLSupport';
				versionString: #'stable';
				repository: 'http://www.squeaksource.com/MetacelloRepository' ].
		spec package: 'Zodiac-Core' with: [ 
			spec repository: 'http://www.squeaksource.com/Zodiac' ].
		spec
			package: 'Zinc-HTTP';
			package: 'Zinc-Patch-HTTPSocket' with: [ spec requires: 'Zinc-HTTP' ];
			package: 'Zinc-AWS' with: [ spec requires: #('Zinc-HTTP' 'XML Support') ];
			package: 'Zinc-REST' with: [ spec requires: 'Zinc-HTTP' ];
			package: 'Zinc-Zodiac' with: [ spec requires: #('Zinc-HTTP' 'Zodiac-Core') ];
			package: 'Zinc-WebSocket-Core' with: [ spec requires: 'Zinc-HTTP' ];
			package: 'Zinc-WebSocket-Tests' with: [ spec requires: 'Zinc-WebSocket-Core' ];
			package: 'Zinc-WebDAV' with: [ spec requires: 'Zinc-HTTP' ];
			package: 'Zinc-WWS-Server' with: [ spec requires: 'Zinc-HTTP' ];
			package: 'Zinc-WWS-Client' with: [ spec requires: 'Zinc-HTTP' ];
			package: 'Zinc-Tests' with: [ spec requires: 'Zinc-HTTP' ].
		spec
			group: 'default' with: #('Core');
			group: 'Core' with: #('Zinc-HTTP');
			group: 'Tests' with: #('Zinc-Tests');
			group: 'AWS' with: #('Zinc-AWS');
			group: 'WebDAV' with: #('Zinc-WebDAV');
			group: 'WebSocket' with: #('Zinc-WebSocket-Core' 'Zinc-WebSocket-Tests');
			group: 'WWS' with: #('Zinc-WWS-Server' 'Zinc-WWS-Client');
			group: 'REST' with: #('Zinc-REST');
			group: 'Patch-HTTPSocket' with: #('Zinc-Patch-HTTPSocket') ].
	spec for: #'pharo1.x' do: [ 
		spec
			package: 'Zinc-FileSystem-Legacy';
			package: 'Zinc-Pharo-Forward-Compatibility';
			package: 'Zinc-HTTP' with: [ spec requires: #('Zinc-FileSystem-Legacy' 'Zinc-Pharo-Forward-Compatibility') ] ].
	spec for: #'pharo2.x' do: [
		spec
			package: 'Zinc-FileSystem';
			package: 'Zinc-HTTP' with: [ spec requires: 'Zinc-FileSystem' ] ].
	spec for: #gemstone do: [ 
		spec
			repository: 'http://seaside.gemstone.com/ss/ZincHTTPComponents';
			package: 'Zinc-HTTP' with: [ spec includes: #('Zinc-Gemstone') ];
			package: 'SocketStream' with: [ spec repository: 'http://seaside.gemstone.com/ss/PharoCompat' ];
			package: 'Zinc-GemstonePreliminary' with: [ spec requires: #('SocketStream') ];
			package: 'Zinc-HTTP' with: [ spec requires: #('Zinc-GemstonePreliminary') ];
			package: 'Zinc-Gemstone' with: [ spec requires: #('Zinc-HTTP') ];
			package: 'Zinc-Tests' with: [ spec requires: 'Zinc-Gemstone' ] ]

]

{ #category : 'baselines' }
ConfigurationOfZincHTTPComponents >> baseline19: spec [
	<version: '1.9-baseline'>
	spec for: #common do: [ 
		spec
			blessing: #baseline;
			description: 'Baseline for Zinc HTTP Components, a framework to deal with the HTTP networking';
			author: 'SvenVanCaekenberghe';
			repository: 'http://mc.stfx.eu/ZincHTTPComponents'.
		spec project: 'XML Support' with: [
			spec
				className: 'ConfigurationOfXMLSupport';
				versionString: #'stable';
				repository: 'http://www.squeaksource.com/MetacelloRepository' ].
		spec package: 'Zodiac-Core' with: [ 
			spec repository: 'http://mc.stfx.eu/Zodiac' ].
		spec
			package: 'Zinc-HTTP';
			package: 'Zinc-Patch-HTTPSocket' with: [ spec requires: 'Zinc-HTTP' ];
			package: 'Zinc-AWS' with: [ spec requires: #('Zinc-HTTP' 'XML Support') ];
			package: 'Zinc-REST' with: [ spec requires: 'Zinc-HTTP' ];
			package: 'Zinc-Zodiac' with: [ spec requires: #('Zinc-HTTP' 'Zodiac-Core') ];
			package: 'Zinc-WebSocket-Core' with: [ spec requires: 'Zinc-HTTP' ];
			package: 'Zinc-WebSocket-Tests' with: [ spec requires: 'Zinc-WebSocket-Core' ];
			package: 'Zinc-WebDAV' with: [ spec requires: 'Zinc-HTTP' ];
			package: 'Zinc-WWS-Server' with: [ spec requires: 'Zinc-HTTP' ];
			package: 'Zinc-WWS-Client' with: [ spec requires: 'Zinc-HTTP' ];
			package: 'Zinc-Tests' with: [ spec requires: 'Zinc-HTTP' ].
		spec
			group: 'default' with: #('Core');
			group: 'Core' with: #('Zinc-HTTP');
			group: 'Tests' with: #('Zinc-Tests');
			group: 'AWS' with: #('Zinc-AWS');
			group: 'WebDAV' with: #('Zinc-WebDAV');
			group: 'WebSocket' with: #('Zinc-WebSocket-Core' 'Zinc-WebSocket-Tests');
			group: 'WWS' with: #('Zinc-WWS-Server' 'Zinc-WWS-Client');
			group: 'REST' with: #('Zinc-REST');
			group: 'Patch-HTTPSocket' with: #('Zinc-Patch-HTTPSocket') ].
	spec for: #'pharo1.x' do: [ 
		spec
			package: 'Zinc-FileSystem-Legacy';
			package: 'Zinc-Pharo-Forward-Compatibility';
			package: 'Zinc-HTTP' with: [ spec requires: #('Zinc-FileSystem-Legacy' 'Zinc-Pharo-Forward-Compatibility') ] ].
	spec for: #'pharo2.x' do: [
		spec
			package: 'Zinc-FileSystem';
			package: 'Zinc-HTTP' with: [ spec requires: 'Zinc-FileSystem' ] ].
	spec for: #gemstone do: [ 
		spec
			repository: 'http://seaside.gemstone.com/ss/ZincHTTPComponents';
			package: 'Zinc-HTTP' with: [ spec includes: #('Zinc-Gemstone') ];
			package: 'SocketStream' with: [ spec repository: 'http://seaside.gemstone.com/ss/PharoCompat' ];
			package: 'Zinc-GemstonePreliminary' with: [ spec requires: #('SocketStream') ];
			package: 'Zinc-HTTP' with: [ spec requires: #('Zinc-GemstonePreliminary') ];
			package: 'Zinc-Gemstone' with: [ spec requires: #('Zinc-HTTP') ];
			package: 'Zinc-Tests' with: [ spec requires: 'Zinc-Gemstone' ] ]
]

{ #category : 'baselines' }
ConfigurationOfZincHTTPComponents >> baseline20: spec [
	<version: '2.0-baseline'>
	spec for: #common do: [ 
		spec
			blessing: #baseline;
			description: 'Baseline for Zinc HTTP Components, a framework to deal with HTTP networking';
			author: 'SvenVanCaekenberghe';
			repository: 'http://mc.stfx.eu/ZincHTTPComponents'.
		spec project: 'XML Support' with: [
			spec
				className: 'ConfigurationOfXMLSupport';
				versionString: #'stable';
				repository: 'http://www.squeaksource.com/MetacelloRepository' ].
		spec project: 'Neo JSON' with: [
			spec
				className: 'ConfigurationOfNeoJSON';
				versionString: #'stable';
				repository: 'http://mc.stfx.eu/Neo' ].
		spec package: 'Zodiac-Core' with: [ 
			spec repository: 'http://mc.stfx.eu/Zodiac' ].
		spec
			package: 'Zinc-Resource-Meta-Core';
			package: 'Zinc-Resource-Meta-Tests' with: [ spec requires: 'Zinc-Resource-Meta-Core' ];
			package: 'Zinc-HTTP' with: [ spec requires: 'Zinc-Resource-Meta-Core' ];
			package: 'Zinc-Patch-HTTPSocket' with: [ spec requires: 'Zinc-HTTP' ];
			package: 'Zinc-AWS' with: [ spec requires: #('Zinc-HTTP' 'XML Support') ];
			package: 'Zinc-REST' with: [ spec requires: #('Zinc-HTTP' 'Neo JSON') ];
			package: 'Zinc-Zodiac' with: [ spec requires: #('Zinc-HTTP' 'Zodiac-Core' 'Zodiac-Tests') ];
			package: 'Zinc-WebSocket-Core' with: [ spec requires: 'Zinc-HTTP' ];
			package: 'Zinc-WebSocket-Tests' with: [ spec requires: 'Zinc-WebSocket-Core' ];
			package: 'Zinc-WebDAV' with: [ spec requires: 'Zinc-HTTP' ];
			package: 'Zinc-WWS-Server' with: [ spec requires: 'Zinc-HTTP' ];
			package: 'Zinc-WWS-Client' with: [ spec requires: 'Zinc-HTTP' ];
			package: 'Zinc-Tests' with: [ spec requires: 'Zinc-HTTP' ].
		spec
			group: 'default' with: #('Core');
			group: 'Core' with: #('Zinc-HTTP');
			group: 'Tests' with: #('Zinc-Tests');
			group: 'Zodiac' with: #('Zinc-Zodiac');
			group: 'AWS' with: #('Zinc-AWS');
			group: 'WebDAV' with: #('Zinc-WebDAV');
			group: 'WebSocket' with: #('Zinc-WebSocket-Core' 'Zinc-WebSocket-Tests');
			group: 'WWS' with: #('Zinc-WWS-Server' 'Zinc-WWS-Client');
			group: 'REST' with: #('Zinc-REST');
			group: 'Patch-HTTPSocket' with: #('Zinc-Patch-HTTPSocket') ].
	spec for: #'pharo1.x' do: [ 
		spec
			package: 'Zinc-FileSystem-Legacy';
			package: 'Zinc-Pharo-Forward-Compatibility';
			package: 'Zinc-HTTP' with: [ spec requires: #('Zinc-FileSystem-Legacy' 'Zinc-Pharo-Forward-Compatibility') ] ].
	spec for: #'pharo2.x' do: [
		spec
			package: 'Zinc-FileSystem';
			package: 'Zinc-HTTP' with: [ spec requires: 'Zinc-FileSystem' ] ].
	spec for: #gemstone do: [ 
		spec
			repository: 'http://seaside.gemstone.com/ss/ZincHTTPComponents';
			package: 'Zinc-HTTP' with: [ spec includes: #('Zinc-Gemstone') ];
			package: 'SocketStream' with: [ spec repository: 'http://seaside.gemstone.com/ss/PharoCompat' ];
			package: 'Zinc-GemstonePreliminary' with: [ spec requires: #('SocketStream') ];
			package: 'Zinc-HTTP' with: [ spec requires: #('Zinc-GemstonePreliminary') ];
			package: 'Zinc-Gemstone' with: [ spec requires: #('Zinc-HTTP') ];
			package: 'Zinc-Tests' with: [ spec requires: 'Zinc-Gemstone' ] ]
]

{ #category : 'baselines' }
ConfigurationOfZincHTTPComponents >> baseline21: spec [
	<version: '2.1-baseline'>
	spec for: #common do: [ 
		spec
			blessing: #baseline;
			description: 'Baseline for Zinc HTTP Components, a framework to deal with HTTP networking';
			author: 'SvenVanCaekenberghe';
			repository: 'http://mc.stfx.eu/ZincHTTPComponents'.
		spec project: 'XML Support' with: [
			spec
				className: 'ConfigurationOfXMLSupport';
				versionString: #'stable';
				repository: 'http://www.squeaksource.com/MetacelloRepository' ].
		spec project: 'Neo JSON' with: [
			spec
				className: 'ConfigurationOfNeoJSON';
				versionString: #'stable';
				repository: 'http://mc.stfx.eu/Neo' ].
		spec package: 'Zodiac-Core' with: [ spec repository: 'http://mc.stfx.eu/Zodiac' ].
		spec package: 'Zodiac-Tests' with: [ spec repository: 'http://mc.stfx.eu/Zodiac' ].
		spec
			package: 'Zinc-Character-Encoding-Core';
			package: 'Zinc-Character-Encoding-Tests' with: [ spec requires: 'Zinc-Character-Encoding-Core' ];
			package: 'Zinc-Resource-Meta-Core' with: [ spec requires: 'Zinc-Character-Encoding-Core' ];
			package: 'Zinc-Resource-Meta-Tests' with: [ spec requires: 'Zinc-Resource-Meta-Core' ];
			package: 'Zinc-HTTP' with: [ spec requires: #( 'Zinc-Character-Encoding-Core' 'Zinc-Resource-Meta-Core' ) ];
			package: 'Zinc-Patch-HTTPSocket' with: [ spec requires: 'Zinc-HTTP' ];
			package: 'Zinc-AWS' with: [ spec requires: #('Zinc-HTTP' 'XML Support') ];
			package: 'Zinc-REST' with: [ spec requires: #('Zinc-HTTP' 'Neo JSON') ];
			package: 'Zinc-Zodiac' with: [ spec requires: #('Zinc-HTTP' 'Zodiac-Core' 'Zodiac-Tests') ];
			package: 'Zinc-WebSocket-Core' with: [ spec requires: 'Zinc-HTTP' ];
			package: 'Zinc-WebSocket-Tests' with: [ spec requires: 'Zinc-WebSocket-Core' ];
			package: 'Zinc-WebDAV' with: [ spec requires: 'Zinc-HTTP' ];
			package: 'Zinc-WWS-Server' with: [ spec requires: 'Zinc-HTTP' ];
			package: 'Zinc-WWS-Client' with: [ spec requires: 'Zinc-HTTP' ];
			package: 'Zinc-Tests' with: [ spec requires: 'Zinc-HTTP' ].
		spec
			group: 'default' with: #('Core');
			group: 'Core' with: #('Zinc-HTTP');
			group: 'Tests' with: #('Zinc-Tests');
			group: 'Character-Encoding' with: #('Zinc-Character-Encoding-Core' 'Zinc-Character-Encoding-Tests');
			group: 'Resource-Meta' with: #('Zinc-Resource-Meta-Core' 'Zinc-Resource-Meta-Tests');
			group: 'Zodiac' with: #('Zinc-Zodiac');
			group: 'AWS' with: #('Zinc-AWS');
			group: 'WebDAV' with: #('Zinc-WebDAV');
			group: 'WebSocket' with: #('Zinc-WebSocket-Core' 'Zinc-WebSocket-Tests');
			group: 'WWS' with: #('Zinc-WWS-Server' 'Zinc-WWS-Client');
			group: 'REST' with: #('Zinc-REST');
			group: 'Patch-HTTPSocket' with: #('Zinc-Patch-HTTPSocket') ].
	spec for: #'pharo1.x' do: [ 
		spec
			package: 'Zinc-FileSystem-Legacy';
			package: 'Zinc-Pharo-Forward-Compatibility';
			package: 'Zinc-HTTP' with: [ spec requires: #('Zinc-FileSystem-Legacy' 'Zinc-Pharo-Forward-Compatibility') ] ].
	spec for: #'pharo2.x' do: [
		spec
			package: 'Zinc-FileSystem';
			package: 'Zinc-HTTP' with: [ spec requires: 'Zinc-FileSystem' ] ].
	spec for: #gemstone do: [ 
		spec
			repository: 'http://seaside.gemstone.com/ss/ZincHTTPComponents';
			package: 'Zinc-HTTP' with: [ spec includes: #('Zinc-Gemstone') ];
			package: 'SocketStream' with: [ spec repository: 'http://seaside.gemstone.com/ss/PharoCompat' ];
			package: 'Zinc-GemstonePreliminary' with: [ spec requires: #('SocketStream') ];
			package: 'Zinc-HTTP' with: [ spec requires: #('Zinc-GemstonePreliminary') ];
			package: 'Zinc-Gemstone' with: [ spec requires: #('Zinc-HTTP') ];
			package: 'Zinc-Tests' with: [ spec requires: 'Zinc-Gemstone' ] ]
]

{ #category : 'baselines' }
ConfigurationOfZincHTTPComponents >> baseline22: spec [
	<version: '2.2-baseline'>
	spec for: #common do: [ 
		spec
			blessing: #baseline;
			description: 'Baseline for Zinc HTTP Components, a framework to deal with HTTP networking';
			author: 'SvenVanCaekenberghe';
			repository: 'http://mc.stfx.eu/ZincHTTPComponents'.
		spec project: 'XML Support' with: [
			spec
				className: 'ConfigurationOfXMLSupport';
				versionString: #'stable';
				repository: 'http://www.squeaksource.com/MetacelloRepository' ].
		spec project: 'Neo JSON' with: [
			spec
				className: 'ConfigurationOfNeoJSON';
				versionString: #'stable';
				repository: 'http://mc.stfx.eu/Neo' ].
		spec package: 'Zodiac-Core' with: [ spec repository: 'http://mc.stfx.eu/Zodiac' ].
		spec package: 'Zodiac-Tests' with: [ spec repository: 'http://mc.stfx.eu/Zodiac' ].
		spec
			package: 'Zinc-Character-Encoding-Core';
			package: 'Zinc-Character-Encoding-Tests' with: [ spec requires: 'Zinc-Character-Encoding-Core' ];
			package: 'Zinc-Resource-Meta-Core' with: [ spec requires: 'Zinc-Character-Encoding-Core' ];
			package: 'Zinc-Resource-Meta-Tests' with: [ spec requires: 'Zinc-Resource-Meta-Core' ];
			package: 'Zinc-HTTP' with: [ spec requires: #( 'Zinc-Character-Encoding-Core' 'Zinc-Resource-Meta-Core' ) ];
			package: 'Zinc-Patch-HTTPSocket' with: [ spec requires: 'Zinc-HTTP' ];
			package: 'Zinc-AWS' with: [ spec requires: #( 'Zinc-HTTP' 'XML Support' ) ];
			package: 'Zinc-REST' with: [ spec requires: #( 'Zinc-HTTP' 'Neo JSON' ) ];
			package: 'Zinc-Zodiac' with: [ spec requires: #( 'Zinc-HTTP' 'Zodiac-Core' 'Zodiac-Tests' ) ];
			package: 'Zinc-WebSocket-Core' with: [ spec requires: 'Zinc-HTTP' ];
			package: 'Zinc-WebSocket-Tests' with: [ spec requires: 'Zinc-WebSocket-Core' ];
			package: 'Zinc-SSO-OAuth1-Core' with: [ spec requires: #( 'Zinc-HTTP' 'Neo JSON' ) ];
			package: 'Zinc-SSO-OAuth2-Core' with: [ spec requires: #( 'Zinc-HTTP' 'Neo JSON' ) ];
			package: 'Zinc-SSO-OpenID-Core' with: [ spec requires: #( 'Zinc-HTTP' 'XML Support' ) ];
			package: 'Zinc-SSO-Demo' with: [ spec requires: #( 'Zinc-SSO-OAuth1-Core' 'Zinc-SSO-OAuth2-Core' 'Zinc-SSO-OpenID-Core' ) ];
			package: 'Zinc-SSO-OAuth1-Tests' with: [ spec requires: #( 'Zinc-SSO-OAuth1-Core' ) ];
			package: 'Zinc-SSO-OpenID-Tests' with: [ spec requires: #( 'Zinc-SSO-OpenID-Core' ) ];
			package: 'Zinc-WebDAV' with: [ spec requires: 'Zinc-HTTP' ];
			package: 'Zinc-WWS-Server' with: [ spec requires: 'Zinc-HTTP' ];
			package: 'Zinc-WWS-Client' with: [ spec requires: 'Zinc-HTTP' ];
			package: 'Zinc-Tests' with: [ spec requires: 'Zinc-HTTP' ].
		spec
			group: 'default' with: #('Core');
			group: 'Core' with: #('Zinc-HTTP');
			group: 'Tests' with: #('Zinc-Tests');
			group: 'Character-Encoding' with: #('Zinc-Character-Encoding-Core' 'Zinc-Character-Encoding-Tests');
			group: 'Resource-Meta' with: #('Zinc-Resource-Meta-Core' 'Zinc-Resource-Meta-Tests');
			group: 'Zodiac' with: #('Zinc-Zodiac');
			group: 'AWS' with: #('Zinc-AWS');
			group: 'WebDAV' with: #('Zinc-WebDAV');
			group: 'WebSocket' with: #('Zinc-WebSocket-Core' 'Zinc-WebSocket-Tests');
			group: 'SSO-OAuth1' with: #('Zinc-SSO-OAuth1-Core' 'Zinc-SSO-OAuth1-Tests');
			group: 'SSO-OAuth2' with: #('Zinc-SSO-OAuth2-Core');
			group: 'SSO-OpenID' with: #('Zinc-SSO-OpenID-Core' 'Zinc-SSO-OpenID-Tests');
			group: 'SSO-Demo' with: #('Zinc-SSO-OAuth1-Core' 'Zinc-SSO-OAuth2-Core' 'Zinc-SSO-OpenID-Core');
			group: 'SSO' with: #('SSO-OAuth1' 'SSO-OAuth2' 'SSO-OpenID' 'SSO-Demo' 'Zinc-SSO-Demo');
			group: 'WWS' with: #('Zinc-WWS-Server' 'Zinc-WWS-Client');
			group: 'REST' with: #('Zinc-REST');
			group: 'Patch-HTTPSocket' with: #('Zinc-Patch-HTTPSocket') ].
	spec for: #'pharo1.x' do: [ 
		spec
			package: 'Zinc-FileSystem-Legacy';
			package: 'Zinc-Pharo-Forward-Compatibility';
			package: 'Zinc-HTTP' with: [ spec requires: #('Zinc-FileSystem-Legacy' 'Zinc-Pharo-Forward-Compatibility') ] ].
	spec for: #'pharo2.x' do: [
		spec
			package: 'Zinc-FileSystem';
			package: 'Zinc-HTTP' with: [ spec requires: 'Zinc-FileSystem' ] ].
	spec for: #gemstone do: [ 
		spec
			repository: 'http://seaside.gemstone.com/ss/ZincHTTPComponents';
			package: 'Zinc-HTTP' with: [ spec includes: #('Zinc-Gemstone') ];
			package: 'SocketStream' with: [ spec repository: 'http://seaside.gemstone.com/ss/PharoCompat' ];
			package: 'Zinc-GemstonePreliminary' with: [ spec requires: #('SocketStream') ];
			package: 'Zinc-HTTP' with: [ spec requires: #('Zinc-GemstonePreliminary') ];
			package: 'Zinc-Gemstone' with: [ spec requires: #('Zinc-HTTP') ];
			package: 'Zinc-Tests' with: [ spec requires: 'Zinc-Gemstone' ] ]
]

{ #category : 'baselines' }
ConfigurationOfZincHTTPComponents >> baseline23: spec [
	<version: '2.3-baseline'>
	spec for: #common do: [ 
		spec
			blessing: #baseline;
			description: 'Baseline for Zinc HTTP Components, a framework to deal with HTTP networking';
			author: 'SvenVanCaekenberghe';
			repository: 'http://mc.stfx.eu/ZincHTTPComponents'.
		spec project: 'XML Support' with: [
			spec
				className: 'ConfigurationOfXMLSupport';
				versionString: #'stable';
				repository: 'http://www.squeaksource.com/MetacelloRepository' ].
		spec project: 'Neo JSON' with: [
			spec
				className: 'ConfigurationOfNeoJSON';
				versionString: #'stable';
				repository: 'http://mc.stfx.eu/Neo' ].
		spec package: 'Zodiac-Core' with: [ spec repository: 'http://mc.stfx.eu/Zodiac' ].
		spec package: 'Zodiac-Tests' with: [ spec repository: 'http://mc.stfx.eu/Zodiac' ].
		spec
			package: 'Zinc-Character-Encoding-Core';
			package: 'Zinc-Character-Encoding-Tests' with: [ spec requires: 'Zinc-Character-Encoding-Core' ];
			package: 'Zinc-Resource-Meta-Core' with: [ spec requires: 'Zinc-Character-Encoding-Core' ];
			package: 'Zinc-Resource-Meta-Tests' with: [ spec requires: 'Zinc-Resource-Meta-Core' ];
			package: 'Zinc-HTTP' with: [ spec requires: #( 'Zinc-Character-Encoding-Core' 'Zinc-Resource-Meta-Core' ) ];
			package: 'Zinc-Patch-HTTPSocket' with: [ spec requires: 'Zinc-HTTP' ];
			package: 'Zinc-AWS' with: [ spec requires: #( 'Zinc-HTTP' 'XML Support' ) ];
			package: 'Zinc-REST' with: [ spec requires: #( 'Zinc-HTTP' 'Neo JSON' ) ];
			package: 'Zinc-Zodiac' with: [ spec requires: #( 'Zinc-HTTP' 'Zodiac-Core' 'Zodiac-Tests' ) ];
			package: 'Zinc-WebSocket-Core' with: [ spec requires: 'Zinc-HTTP' ];
			package: 'Zinc-WebSocket-Tests' with: [ spec requires: 'Zinc-WebSocket-Core' ];
			package: 'Zinc-SSO-OAuth1-Core' with: [ spec requires: #( 'Zinc-HTTP' 'Neo JSON' ) ];
			package: 'Zinc-SSO-OAuth2-Core' with: [ spec requires: #( 'Zinc-HTTP' 'Neo JSON' ) ];
			package: 'Zinc-SSO-OpenID-Core' with: [ spec requires: #( 'Zinc-HTTP' 'XML Support' ) ];
			package: 'Zinc-SSO-Demo' with: [ spec requires: #( 'Zinc-SSO-OAuth1-Core' 'Zinc-SSO-OAuth2-Core' 'Zinc-SSO-OpenID-Core' ) ];
			package: 'Zinc-SSO-OAuth1-Tests' with: [ spec requires: #( 'Zinc-SSO-OAuth1-Core' ) ];
			package: 'Zinc-SSO-OpenID-Tests' with: [ spec requires: #( 'Zinc-SSO-OpenID-Core' ) ];
			package: 'Zinc-WebDAV' with: [ spec requires: 'Zinc-HTTP' ];
			package: 'Zinc-WWS-Server' with: [ spec requires: 'Zinc-HTTP' ];
			package: 'Zinc-WWS-Client' with: [ spec requires: 'Zinc-HTTP' ];
			package: 'Zinc-Tests' with: [ spec requires: 'Zinc-HTTP' ].
		spec
			group: 'default' with: #('Core');
			group: 'Core' with: #('Zinc-HTTP');
			group: 'Tests' with: #('Zinc-Tests' 'Zinc-Character-Encoding-Tests' 'Zinc-Resource-Meta-Tests');
			group: 'Character-Encoding' with: #('Zinc-Character-Encoding-Core' 'Zinc-Character-Encoding-Tests');
			group: 'Resource-Meta' with: #('Zinc-Resource-Meta-Core' 'Zinc-Resource-Meta-Tests');
			group: 'Zodiac' with: #('Zinc-Zodiac');
			group: 'AWS' with: #('Zinc-AWS');
			group: 'WebDAV' with: #('Zinc-WebDAV');
			group: 'WebSocket' with: #('Zinc-WebSocket-Core' 'Zinc-WebSocket-Tests');
			group: 'SSO-OAuth1' with: #('Zinc-SSO-OAuth1-Core' 'Zinc-SSO-OAuth1-Tests');
			group: 'SSO-OAuth2' with: #('Zinc-SSO-OAuth2-Core');
			group: 'SSO-OpenID' with: #('Zinc-SSO-OpenID-Core' 'Zinc-SSO-OpenID-Tests');
			group: 'SSO-Demo' with: #('Zinc-SSO-OAuth1-Core' 'Zinc-SSO-OAuth2-Core' 'Zinc-SSO-OpenID-Core');
			group: 'SSO' with: #('SSO-OAuth1' 'SSO-OAuth2' 'SSO-OpenID' 'SSO-Demo' 'Zinc-SSO-Demo');
			group: 'WWS' with: #('Zinc-WWS-Server' 'Zinc-WWS-Client');
			group: 'REST' with: #('Zinc-REST');
			group: 'Patch-HTTPSocket' with: #('Zinc-Patch-HTTPSocket') ].
	spec for: #'pharo1.x' do: [ 
		spec
			package: 'Zinc-FileSystem-Legacy';
			package: 'Zinc-Pharo-Forward-Compatibility';
			package: 'Zinc-HTTP' with: [ spec requires: #('Zinc-FileSystem-Legacy' 'Zinc-Pharo-Forward-Compatibility') ] ].
	spec for: #'pharo2.x' do: [
		spec
			package: 'Zinc-FileSystem';
			package: 'Zinc-HTTP' with: [ spec requires: 'Zinc-FileSystem' ] ].
	spec for: #gemstone do: [ 
		spec
			repository: 'http://seaside.gemstone.com/ss/ZincHTTPComponents';
			package: 'Zinc-HTTP' with: [ spec includes: #('Zinc-Gemstone') ];
			package: 'SocketStream' with: [ spec repository: 'http://seaside.gemstone.com/ss/PharoCompat' ];
			package: 'Zinc-GemstonePreliminary' with: [ spec requires: #('SocketStream') ];
			package: 'Zinc-HTTP' with: [ spec requires: #('Zinc-GemstonePreliminary') ];
			package: 'Zinc-Gemstone' with: [ spec requires: #('Zinc-HTTP') ];
			package: 'Zinc-Tests' with: [ spec requires: 'Zinc-Gemstone' ] ]
]

{ #category : 'baselines' }
ConfigurationOfZincHTTPComponents >> baseline24: spec [
	<version: '2.4-baseline'>
	spec for: #pharo do: [ 
		spec
			blessing: #baseline;
			description: 'Baseline for Zinc HTTP Components, a framework to deal with HTTP networking';
			author: 'SvenVanCaekenberghe'.
		spec project: 'XML Support' with: [
			spec
				className: 'ConfigurationOfXMLSupport';
				versionString: #'stable';
				repository: 'http://www.squeaksource.com/MetacelloRepository' ].
		spec project: 'Neo JSON' with: [
			spec
				className: 'ConfigurationOfNeoJSON';
				versionString: #'stable';
				repository: 'http://mc.stfx.eu/Neo' ].
		spec package: 'Zodiac-Core' with: [ spec repository: 'http://mc.stfx.eu/Zodiac' ].
		spec package: 'Zodiac-Tests' with: [ spec repository: 'http://mc.stfx.eu/Zodiac' ].
		spec
			package: 'Zinc-Character-Encoding-Core';
			package: 'Zinc-Character-Encoding-Tests' with: [ spec requires: 'Zinc-Character-Encoding-Core' ];
			package: 'Zinc-Resource-Meta-Core' with: [ spec requires: 'Zinc-Character-Encoding-Core' ];
			package: 'Zinc-Resource-Meta-Tests' with: [ spec requires: 'Zinc-Resource-Meta-Core' ];
			package: 'Zinc-HTTP' with: [ spec requires: #( 'Zinc-Character-Encoding-Core' 'Zinc-Resource-Meta-Core' ) ];
			package: 'Zinc-Patch-HTTPSocket' with: [ spec requires: 'Zinc-HTTP' ];
			package: 'Zinc-AWS' with: [ spec requires: #( 'Zinc-HTTP' 'XML Support' ) ];
			package: 'Zinc-REST' with: [ spec requires: #( 'Zinc-HTTP' 'Neo JSON' ) ];
			package: 'Zinc-Zodiac' with: [ spec requires: #( 'Zinc-HTTP' 'Zodiac-Core' 'Zodiac-Tests' ) ];
			package: 'Zinc-WebSocket-Core' with: [ spec requires: 'Zinc-HTTP' ];
			package: 'Zinc-WebSocket-Tests' with: [ spec requires: 'Zinc-WebSocket-Core' ];
			package: 'Zinc-SSO-OAuth1-Core' with: [ spec requires: #( 'Zinc-HTTP' 'Neo JSON' ) ];
			package: 'Zinc-SSO-OAuth2-Core' with: [ spec requires: #( 'Zinc-HTTP' 'Neo JSON' ) ];
			package: 'Zinc-SSO-OpenID-Core' with: [ spec requires: #( 'Zinc-HTTP' 'XML Support' ) ];
			package: 'Zinc-SSO-Demo' with: [ spec requires: #( 'Zinc-SSO-OAuth1-Core' 'Zinc-SSO-OAuth2-Core' 'Zinc-SSO-OpenID-Core' ) ];
			package: 'Zinc-SSO-OAuth1-Tests' with: [ spec requires: #( 'Zinc-SSO-OAuth1-Core' ) ];
			package: 'Zinc-SSO-OpenID-Tests' with: [ spec requires: #( 'Zinc-SSO-OpenID-Core' ) ];
			package: 'Zinc-WebDAV' with: [ spec requires: 'Zinc-HTTP' ];
			package: 'Zinc-WWS-Server' with: [ spec requires: 'Zinc-HTTP' ];
			package: 'Zinc-WWS-Client' with: [ spec requires: 'Zinc-HTTP' ];
			package: 'Zinc-Tests' with: [ spec requires: 'Zinc-HTTP' ];
			package: 'Zinc-Seaside'. "For now, no dependence on Seaside itself"
		spec
			group: 'default' with: #('Core');
			group: 'Core' with: #('Zinc-HTTP');
			group: 'Tests' with: #('Zinc-Tests' 'Zinc-Character-Encoding-Tests' 'Zinc-Resource-Meta-Tests');
			group: 'Character-Encoding' with: #('Zinc-Character-Encoding-Core' 'Zinc-Character-Encoding-Tests');
			group: 'Resource-Meta' with: #('Zinc-Resource-Meta-Core' 'Zinc-Resource-Meta-Tests');
			group: 'Zodiac' with: #('Zinc-Zodiac');
			group: 'AWS' with: #('Zinc-AWS');
			group: 'WebDAV' with: #('Zinc-WebDAV');
			group: 'WebSocket' with: #('Zinc-WebSocket-Core' 'Zinc-WebSocket-Tests');
			group: 'SSO-OAuth1' with: #('Zinc-SSO-OAuth1-Core' 'Zinc-SSO-OAuth1-Tests');
			group: 'SSO-OAuth2' with: #('Zinc-SSO-OAuth2-Core');
			group: 'SSO-OpenID' with: #('Zinc-SSO-OpenID-Core' 'Zinc-SSO-OpenID-Tests');
			group: 'SSO-Demo' with: #('Zinc-SSO-OAuth1-Core' 'Zinc-SSO-OAuth2-Core' 'Zinc-SSO-OpenID-Core');
			group: 'SSO' with: #('SSO-OAuth1' 'SSO-OAuth2' 'SSO-OpenID' 'SSO-Demo' 'Zinc-SSO-Demo');
			group: 'WWS' with: #('Zinc-WWS-Server' 'Zinc-WWS-Client');
			group: 'REST' with: #('Zinc-REST');
			group: 'Patch-HTTPSocket' with: #('Zinc-Patch-HTTPSocket');
			group: 'Seaside' with: #('Zinc-Seaside') ].
		spec for: #squeakCommon do:[spec repository: 'http://mc.stfx.eu/ZincHTTPComponents'].
	spec for: #'pharo1.x' do: [ 
		spec
			package: 'Zinc-FileSystem-Legacy';
			package: 'Zinc-Pharo-Forward-Compatibility';
			package: 'Zinc-HTTP' with: [ spec requires: #('Zinc-FileSystem-Legacy' 'Zinc-Pharo-Forward-Compatibility') ] ].
	spec for: #'pharo2.x' do: [
		spec
			package: 'Zinc-FileSystem';
			package: 'Zinc-HTTP' with: [ spec requires: 'Zinc-FileSystem' ] ].

]

{ #category : 'baselines' }
ConfigurationOfZincHTTPComponents >> baseline25: spec [
	<version: '2.5-baseline'>
	spec for: #pharo do: [ 
		spec
			blessing: #baseline;
			description: 'Baseline for Zinc HTTP Components, a framework to deal with HTTP networking';
			author: 'SvenVanCaekenberghe'.
		spec project: 'XML Support' with: [
			spec
				className: 'ConfigurationOfXMLSupport';
				versionString: #'stable';
				repository: 'http://www.squeaksource.com/MetacelloRepository' ].
		spec project: 'Neo JSON' with: [
			spec
				className: 'ConfigurationOfNeoJSON';
				versionString: #'stable';
				repository: 'http://mc.stfx.eu/Neo' ].
		spec package: 'Zodiac-Core' with: [ spec repository: 'http://mc.stfx.eu/Zodiac' ].
		spec package: 'Zodiac-Tests' with: [ spec repository: 'http://mc.stfx.eu/Zodiac' ].
		spec
			package: 'Zinc-Character-Encoding-Core';
			package: 'Zinc-Character-Encoding-Tests' with: [ spec requires: 'Zinc-Character-Encoding-Core' ];
			package: 'Zinc-Resource-Meta-Core' with: [ spec requires: 'Zinc-Character-Encoding-Core' ];
			package: 'Zinc-Resource-Meta-Tests' with: [ spec requires: 'Zinc-Resource-Meta-Core' ];
			package: 'Zinc-HTTP' with: [ spec requires: #( 'Zinc-Character-Encoding-Core' 'Zinc-Resource-Meta-Core' ) ];
			package: 'Zinc-Patch-HTTPSocket' with: [ spec requires: 'Zinc-HTTP' ];
			package: 'Zinc-AWS' with: [ spec requires: #( 'Zinc-HTTP' 'XML Support' ) ];
			package: 'Zinc-REST' with: [ spec requires: #( 'Zinc-HTTP' 'Neo JSON' ) ];
			package: 'Zinc-Zodiac' with: [ spec requires: #( 'Zinc-HTTP' 'Zodiac-Core' 'Zodiac-Tests' ) ];
			package: 'Zinc-WebSocket-Core' with: [ spec requires: 'Zinc-HTTP' ];
			package: 'Zinc-WebSocket-Tests' with: [ spec requires: 'Zinc-WebSocket-Core' ];
			package: 'Zinc-SSO-OAuth1-Core' with: [ spec requires: #( 'Zinc-HTTP' 'Neo JSON' ) ];
			package: 'Zinc-SSO-OAuth2-Core' with: [ spec requires: #( 'Zinc-HTTP' 'Neo JSON' ) ];
			package: 'Zinc-SSO-OpenID-Core' with: [ spec requires: #( 'Zinc-HTTP' 'XML Support' ) ];
			package: 'Zinc-SSO-Demo' with: [ spec requires: #( 'Zinc-SSO-OAuth1-Core' 'Zinc-SSO-OAuth2-Core' 'Zinc-SSO-OpenID-Core' ) ];
			package: 'Zinc-SSO-OAuth1-Tests' with: [ spec requires: #( 'Zinc-SSO-OAuth1-Core' ) ];
			package: 'Zinc-SSO-OpenID-Tests' with: [ spec requires: #( 'Zinc-SSO-OpenID-Core' ) ];
			package: 'Zinc-WebDAV' with: [ spec requires: 'Zinc-HTTP' ];
			package: 'Zinc-WWS-Server' with: [ spec requires: 'Zinc-HTTP' ];
			package: 'Zinc-WWS-Client' with: [ spec requires: 'Zinc-HTTP' ];
			package: 'Zinc-Tests' with: [ spec requires: 'Zinc-HTTP' ];
			package: 'Zinc-Seaside'. "For now, no dependence on Seaside itself"
		spec
			group: 'default' with: #('Core');
			group: 'Core' with: #('Zinc-HTTP');
			group: 'Tests' with: #('Zinc-Tests' 'Zinc-Character-Encoding-Tests' 'Zinc-Resource-Meta-Tests');
			group: 'Character-Encoding' with: #('Zinc-Character-Encoding-Core' 'Zinc-Character-Encoding-Tests');
			group: 'Resource-Meta' with: #('Zinc-Resource-Meta-Core' 'Zinc-Resource-Meta-Tests');
			group: 'Zodiac' with: #('Zinc-Zodiac');
			group: 'AWS' with: #('Zinc-AWS');
			group: 'WebDAV' with: #('Zinc-WebDAV');
			group: 'WebSocket' with: #('Zinc-WebSocket-Core' 'Zinc-WebSocket-Tests');
			group: 'SSO-OAuth1' with: #('Zinc-SSO-OAuth1-Core' 'Zinc-SSO-OAuth1-Tests');
			group: 'SSO-OAuth2' with: #('Zinc-SSO-OAuth2-Core');
			group: 'SSO-OpenID' with: #('Zinc-SSO-OpenID-Core' 'Zinc-SSO-OpenID-Tests');
			group: 'SSO-Demo' with: #('Zinc-SSO-OAuth1-Core' 'Zinc-SSO-OAuth2-Core' 'Zinc-SSO-OpenID-Core');
			group: 'SSO' with: #('SSO-OAuth1' 'SSO-OAuth2' 'SSO-OpenID' 'SSO-Demo' 'Zinc-SSO-Demo');
			group: 'WWS' with: #('Zinc-WWS-Server' 'Zinc-WWS-Client');
			group: 'REST' with: #('Zinc-REST');
			group: 'Patch-HTTPSocket' with: #('Zinc-Patch-HTTPSocket');
			group: 'Seaside' with: #('Zinc-Seaside') ].
		spec for: #squeakCommon do:[spec repository: 'http://mc.stfx.eu/ZincHTTPComponents'].
	spec for: #'pharo1.x' do: [ 
		spec
			package: 'Zinc-FileSystem-Legacy';
			package: 'Zinc-Pharo-Forward-Compatibility';
			package: 'Zinc-HTTP' with: [ spec requires: #('Zinc-FileSystem-Legacy' 'Zinc-Pharo-Forward-Compatibility') ] ].
	spec for: #'pharo2.x' do: [
		spec
			package: 'Zinc-FileSystem';
			package: 'Zinc-HTTP' with: [ spec requires: 'Zinc-FileSystem' ];
			package: 'Zinc-Resource-Meta-FileSystem' with: [ spec requires: 'Zinc-HTTP' ] ]

]

{ #category : 'baselines' }
ConfigurationOfZincHTTPComponents >> baseline26: spec [
	<version: '2.6-baseline'>
	spec for: #pharo do: [ 
		spec
			blessing: #baseline;
			description: 'Baseline for Zinc HTTP Components, a framework to deal with HTTP networking';
			author: 'SvenVanCaekenberghe'.
		spec project: 'XML Support' with: [
			spec
				className: 'ConfigurationOfXMLSupport';
				versionString: #'stable';
				repository: 'http://www.squeaksource.com/MetacelloRepository' ].
		spec project: 'Neo JSON' with: [
			spec
				className: 'ConfigurationOfNeoJSON';
				versionString: #'stable';
				repository: 'http://mc.stfx.eu/Neo' ].
		spec package: 'Zodiac-Core' with: [ spec repository: 'http://mc.stfx.eu/Zodiac' ].
		spec package: 'Zodiac-Tests' with: [ spec repository: 'http://mc.stfx.eu/Zodiac' ].
		spec
			package: 'Zinc-Character-Encoding-Core';
			package: 'Zinc-Character-Encoding-Tests' with: [ spec requires: 'Zinc-Character-Encoding-Core' ];
			package: 'Zinc-Resource-Meta-Core' with: [ spec requires: 'Zinc-Character-Encoding-Core' ];
			package: 'Zinc-Resource-Meta-Tests' with: [ spec requires: 'Zinc-Resource-Meta-Core' ];
			package: 'Zinc-HTTP' with: [ spec requires: #( 'Zinc-Character-Encoding-Core' 'Zinc-Resource-Meta-Core' ) ];
			package: 'Zinc-Patch-HTTPSocket' with: [ spec requires: 'Zinc-HTTP' ];
			package: 'Zinc-AWS' with: [ spec requires: #( 'Zinc-HTTP' 'XML Support' ) ];
			package: 'Zinc-REST' with: [ spec requires: #( 'Zinc-HTTP' 'Neo JSON' ) ];
			package: 'Zinc-Zodiac' with: [ spec requires: #( 'Zinc-HTTP' 'Zodiac-Core' 'Zodiac-Tests' ) ];
			package: 'Zinc-WebSocket-Core' with: [ spec requires: 'Zinc-HTTP' ];
			package: 'Zinc-WebSocket-Tests' with: [ spec requires: 'Zinc-WebSocket-Core' ];
			package: 'Zinc-SSO-OAuth1-Core' with: [ spec requires: #( 'Zinc-HTTP' 'Neo JSON' ) ];
			package: 'Zinc-SSO-OAuth2-Core' with: [ spec requires: #( 'Zinc-HTTP' 'Neo JSON' ) ];
			package: 'Zinc-SSO-OpenID-Core' with: [ spec requires: #( 'Zinc-HTTP' 'XML Support' ) ];
			package: 'Zinc-SSO-Demo' with: [ spec requires: #( 'Zinc-SSO-OAuth1-Core' 'Zinc-SSO-OAuth2-Core' 'Zinc-SSO-OpenID-Core' ) ];
			package: 'Zinc-SSO-OAuth1-Tests' with: [ spec requires: #( 'Zinc-SSO-OAuth1-Core' ) ];
			package: 'Zinc-SSO-OpenID-Tests' with: [ spec requires: #( 'Zinc-SSO-OpenID-Core' ) ];
			package: 'Zinc-WebDAV' with: [ spec requires: 'Zinc-HTTP' ];
			package: 'Zinc-WWS-Server' with: [ spec requires: 'Zinc-HTTP' ];
			package: 'Zinc-WWS-Client' with: [ spec requires: 'Zinc-HTTP' ];
			package: 'Zinc-Tests' with: [ spec requires: 'Zinc-HTTP' ];
			package: 'Zinc-Seaside'. "For now, no dependence on Seaside itself"
		spec
			group: 'default' with: #('Core');
			group: 'Core' with: #('Zinc-HTTP');
			group: 'Tests' with: #('Zinc-Tests' 'Zinc-Character-Encoding-Tests' 'Zinc-Resource-Meta-Tests');
			group: 'Character-Encoding' with: #('Zinc-Character-Encoding-Core' 'Zinc-Character-Encoding-Tests');
			group: 'Resource-Meta' with: #('Zinc-Resource-Meta-Core' 'Zinc-Resource-Meta-Tests');
			group: 'Zodiac' with: #('Zinc-Zodiac');
			group: 'AWS' with: #('Zinc-AWS');
			group: 'WebDAV' with: #('Zinc-WebDAV');
			group: 'WebSocket' with: #('Zinc-WebSocket-Core' 'Zinc-WebSocket-Tests');
			group: 'SSO-OAuth1' with: #('Zinc-SSO-OAuth1-Core' 'Zinc-SSO-OAuth1-Tests');
			group: 'SSO-OAuth2' with: #('Zinc-SSO-OAuth2-Core');
			group: 'SSO-OpenID' with: #('Zinc-SSO-OpenID-Core' 'Zinc-SSO-OpenID-Tests');
			group: 'SSO-Demo' with: #('Zinc-SSO-OAuth1-Core' 'Zinc-SSO-OAuth2-Core' 'Zinc-SSO-OpenID-Core');
			group: 'SSO' with: #('SSO-OAuth1' 'SSO-OAuth2' 'SSO-OpenID' 'SSO-Demo' 'Zinc-SSO-Demo');
			group: 'WWS' with: #('Zinc-WWS-Server' 'Zinc-WWS-Client');
			group: 'REST' with: #('Zinc-REST');
			group: 'Patch-HTTPSocket' with: #('Zinc-Patch-HTTPSocket');
			group: 'Seaside' with: #('Zinc-Seaside') ].
	spec for: #squeakCommon do:[ spec repository: 'http://mc.stfx.eu/ZincHTTPComponents' ].
	spec for: #'pharo1.x' do: [ 
		spec
			package: 'Zinc-FileSystem-Legacy';
			package: 'Zinc-Pharo-Forward-Compatibility';
			package: 'Zinc-HTTP' with: [ spec requires: #('Zinc-FileSystem-Legacy' 'Zinc-Pharo-Forward-Compatibility') ] ].
	spec for: #'pharo2.x' do: [
		spec
			package: 'Zinc-FileSystem';
			package: 'Zinc-pharo2-forward-compatibility';
			package: 'Zinc-HTTP' with: [ spec requires: #('Zinc-FileSystem' 'Zinc-pharo2-forward-compatibility')];
			package: 'Zinc-Resource-Meta-FileSystem' with: [ spec requires: 'Zinc-HTTP' ] ].
	spec for: #'pharo3.x' do: [
		spec
			package: 'Zinc-FileSystem';
			package: 'Zinc-HTTP' with: [ spec requires: 'Zinc-FileSystem' ];
			package: 'Zinc-Resource-Meta-FileSystem' with: [ spec requires: 'Zinc-HTTP' ] ]

]

{ #category : 'baselines' }
ConfigurationOfZincHTTPComponents >> baseline27: spec [
	<version: '2.7-baseline'>
	spec for: #pharo do: [ 
		spec
			blessing: #baseline;
			description: 'Baseline for Zinc HTTP Components, a framework to deal with HTTP networking';
			author: 'SvenVanCaekenberghe'.
		spec project: 'XML Support' with: [
			spec
				className: 'ConfigurationOfXMLSupport';
				versionString: #'stable';
				repository: 'http://www.squeaksource.com/MetacelloRepository' ].
		spec project: 'Neo JSON' with: [
			spec
				className: 'ConfigurationOfNeoJSON';
				versionString: #'stable';
				repository: 'http://mc.stfx.eu/Neo' ].
		spec package: 'Zodiac-Core' with: [ spec repository: 'http://mc.stfx.eu/Zodiac' ].
		spec package: 'Zodiac-Tests' with: [ spec repository: 'http://mc.stfx.eu/Zodiac' ].
		spec
			package: 'Zinc-Character-Encoding-Core';
			package: 'Zinc-Character-Encoding-Tests' with: [ spec requires: 'Zinc-Character-Encoding-Core' ];
			package: 'Zinc-Resource-Meta-Core' with: [ spec requires: 'Zinc-Character-Encoding-Core' ];
			package: 'Zinc-Resource-Meta-Tests' with: [ spec requires: 'Zinc-Resource-Meta-Core' ];
			package: 'Zinc-HTTP' with: [ spec requires: #( 'Zinc-Character-Encoding-Core' 'Zinc-Resource-Meta-Core' ) ];
			package: 'Zinc-Patch-HTTPSocket' with: [ spec requires: 'Zinc-HTTP' ];
			package: 'Zinc-AWS' with: [ spec requires: #( 'Zinc-HTTP' 'XML Support' ) ];
			package: 'Zinc-REST' with: [ spec requires: #( 'Zinc-HTTP' 'Neo JSON' ) ];
			package: 'Zinc-Zodiac' with: [ spec requires: #( 'Zinc-HTTP' 'Zodiac-Core' 'Zodiac-Tests' ) ];
			package: 'Zinc-WebSocket-Core' with: [ spec requires: 'Zinc-HTTP' ];
			package: 'Zinc-WebSocket-Tests' with: [ spec requires: 'Zinc-WebSocket-Core' ];
			package: 'Zinc-SSO-OAuth1-Core' with: [ spec requires: #( 'Zinc-HTTP' 'Neo JSON' ) ];
			package: 'Zinc-SSO-OAuth2-Core' with: [ spec requires: #( 'Zinc-HTTP' 'Neo JSON' ) ];
			package: 'Zinc-SSO-OpenID-Core' with: [ spec requires: #( 'Zinc-HTTP' 'XML Support' ) ];
			package: 'Zinc-SSO-Demo' with: [ spec requires: #( 'Zinc-SSO-OAuth1-Core' 'Zinc-SSO-OAuth2-Core' 'Zinc-SSO-OpenID-Core' ) ];
			package: 'Zinc-SSO-OAuth1-Tests' with: [ spec requires: #( 'Zinc-SSO-OAuth1-Core' ) ];
			package: 'Zinc-SSO-OpenID-Tests' with: [ spec requires: #( 'Zinc-SSO-OpenID-Core' ) ];
			package: 'Zinc-WebDAV' with: [ spec requires: 'Zinc-HTTP' ];
			package: 'Zinc-WWS-Server' with: [ spec requires: 'Zinc-HTTP' ];
			package: 'Zinc-WWS-Client' with: [ spec requires: 'Zinc-HTTP' ];
			package: 'Zinc-Tests' with: [ spec requires: 'Zinc-HTTP' ];
			package: 'Zinc-Seaside'. "For now, no dependence on Seaside itself"
		spec
			group: 'default' with: #('Core');
			group: 'Core' with: #('Zinc-HTTP');
			group: 'Tests' with: #('Zinc-Tests' 'Zinc-Character-Encoding-Tests' 'Zinc-Resource-Meta-Tests');
			group: 'Character-Encoding' with: #('Zinc-Character-Encoding-Core' 'Zinc-Character-Encoding-Tests');
			group: 'Resource-Meta' with: #('Zinc-Resource-Meta-Core' 'Zinc-Resource-Meta-Tests');
			group: 'Zodiac' with: #('Zinc-Zodiac');
			group: 'AWS' with: #('Zinc-AWS');
			group: 'WebDAV' with: #('Zinc-WebDAV');
			group: 'WebSocket' with: #('Zinc-WebSocket-Core' 'Zinc-WebSocket-Tests');
			group: 'SSO-OAuth1' with: #('Zinc-SSO-OAuth1-Core' 'Zinc-SSO-OAuth1-Tests');
			group: 'SSO-OAuth2' with: #('Zinc-SSO-OAuth2-Core');
			group: 'SSO-OpenID' with: #('Zinc-SSO-OpenID-Core' 'Zinc-SSO-OpenID-Tests');
			group: 'SSO-Demo' with: #('Zinc-SSO-OAuth1-Core' 'Zinc-SSO-OAuth2-Core' 'Zinc-SSO-OpenID-Core');
			group: 'SSO' with: #('SSO-OAuth1' 'SSO-OAuth2' 'SSO-OpenID' 'SSO-Demo' 'Zinc-SSO-Demo');
			group: 'WWS' with: #('Zinc-WWS-Server' 'Zinc-WWS-Client');
			group: 'REST' with: #('Zinc-REST');
			group: 'Patch-HTTPSocket' with: #('Zinc-Patch-HTTPSocket');
			group: 'Seaside' with: #('Zinc-Seaside') ].
	spec for: #squeakCommon do:[ spec repository: 'http://mc.stfx.eu/ZincHTTPComponents' ].
	spec for: #'pharo1.x' do: [ 
		spec
			package: 'Zinc-FileSystem-Legacy';
			package: 'Zinc-Pharo-Forward-Compatibility';
			package: 'Zinc-HTTP' with: [ spec requires: #('Zinc-FileSystem-Legacy' 'Zinc-Pharo-Forward-Compatibility') ] ].
	spec for: #'pharo2.x' do: [
		spec
			package: 'Zinc-FileSystem';
			package: 'Zinc-pharo2-forward-compatibility';
			package: 'Zinc-HTTP' with: [ spec requires: #('Zinc-FileSystem' 'Zinc-pharo2-forward-compatibility')];
			package: 'Zinc-Resource-Meta-FileSystem' with: [ spec requires: 'Zinc-HTTP' ] ].
	spec for: #'pharo3.x' do: [
		spec
			package: 'Zinc-FileSystem';
			package: 'Zinc-HTTP' with: [ spec requires: 'Zinc-FileSystem' ];
			package: 'Zinc-Resource-Meta-FileSystem' with: [ spec requires: 'Zinc-HTTP' ] ].
	spec for: #'pharo4.x' do: [
		spec
			package: 'Zinc-FileSystem';
			package: 'Zinc-HTTP' with: [ spec requires: 'Zinc-FileSystem' ];
			package: 'Zinc-Resource-Meta-FileSystem' with: [ spec requires: 'Zinc-HTTP' ] ].
	spec for: #'pharo5.x' do: [
		spec
			package: 'Zinc-FileSystem';
			package: 'Zinc-HTTP' with: [ spec requires: 'Zinc-FileSystem' ];
			package: 'Zinc-Resource-Meta-FileSystem' with: [ spec requires: 'Zinc-HTTP' ] ]

]

{ #category : 'baselines' }
ConfigurationOfZincHTTPComponents >> baseline28: spec [
	<version: '2.8-baseline'>
	spec for: #pharo do: [ 
		spec
			blessing: #baseline;
			description: 'Baseline for Zinc HTTP Components, a framework to deal with HTTP networking';
			author: 'SvenVanCaekenberghe'.
		spec project: 'XML Support' with: [
			spec
				className: 'ConfigurationOfXMLSupport';
				versionString: #'stable';
				repository: 'http://www.squeaksource.com/MetacelloRepository' ].
		spec project: 'Neo JSON' with: [
			spec
				className: 'ConfigurationOfNeoJSON';
				versionString: #'stable';
				repository: 'http://mc.stfx.eu/Neo' ].
		spec package: 'Zodiac-Core' with: [ spec repository: 'http://mc.stfx.eu/Zodiac' ].
		spec package: 'Zodiac-Tests' with: [ spec repository: 'http://mc.stfx.eu/Zodiac' ].
		spec
			package: 'Zinc-Character-Encoding-Core';
			package: 'Zinc-Character-Encoding-Tests' with: [ spec requires: 'Zinc-Character-Encoding-Core' ];
			package: 'Zinc-Resource-Meta-Core' with: [ spec requires: 'Zinc-Character-Encoding-Core' ];
			package: 'Zinc-Resource-Meta-Tests' with: [ spec requires: 'Zinc-Resource-Meta-Core' ];
			package: 'Zinc-HTTP' with: [ spec requires: #( 'Zinc-Character-Encoding-Core' 'Zinc-Resource-Meta-Core' ) ];
			package: 'Zinc-Patch-HTTPSocket' with: [ spec requires: 'Zinc-HTTP' ];
			package: 'Zinc-AWS' with: [ spec requires: #( 'Zinc-HTTP' 'XML Support' ) ];
			package: 'Zinc-REST' with: [ spec requires: #( 'Zinc-HTTP' 'Neo JSON' ) ];
			package: 'Zinc-Zodiac' with: [ spec requires: #( 'Zinc-HTTP' 'Zodiac-Core' 'Zodiac-Tests' ) ];
			package: 'Zinc-WebSocket-Core' with: [ spec requires: 'Zinc-HTTP' ];
			package: 'Zinc-WebSocket-Tests' with: [ spec requires: 'Zinc-WebSocket-Core' ];
			package: 'Zinc-SSO-OAuth1-Core' with: [ spec requires: #( 'Zinc-HTTP' 'Neo JSON' ) ];
			package: 'Zinc-SSO-OAuth2-Core' with: [ spec requires: #( 'Zinc-HTTP' 'Neo JSON' ) ];
			package: 'Zinc-SSO-OpenID-Core' with: [ spec requires: #( 'Zinc-HTTP' 'XML Support' ) ];
			package: 'Zinc-SSO-Demo' with: [ spec requires: #( 'Zinc-SSO-OAuth1-Core' 'Zinc-SSO-OAuth2-Core' 'Zinc-SSO-OpenID-Core' ) ];
			package: 'Zinc-SSO-OAuth1-Tests' with: [ spec requires: #( 'Zinc-SSO-OAuth1-Core' ) ];
			package: 'Zinc-SSO-OpenID-Tests' with: [ spec requires: #( 'Zinc-SSO-OpenID-Core' ) ];
			package: 'Zinc-WebDAV' with: [ spec requires: 'Zinc-HTTP' ];
			package: 'Zinc-WWS-Server' with: [ spec requires: 'Zinc-HTTP' ];
			package: 'Zinc-WWS-Client' with: [ spec requires: 'Zinc-HTTP' ];
			package: 'Zinc-Tests' with: [ spec requires: 'Zinc-HTTP' ];
			package: 'Zinc-Seaside'. "For now, no dependence on Seaside itself"
		spec
			group: 'default' with: #('Core');
			group: 'Core' with: #('Zinc-HTTP');
			group: 'Tests' with: #('Zinc-Tests' 'Zinc-Character-Encoding-Tests' 'Zinc-Resource-Meta-Tests');
			group: 'Character-Encoding' with: #('Zinc-Character-Encoding-Core' 'Zinc-Character-Encoding-Tests');
			group: 'Resource-Meta' with: #('Zinc-Resource-Meta-Core' 'Zinc-Resource-Meta-Tests');
			group: 'Zodiac' with: #('Zinc-Zodiac');
			group: 'AWS' with: #('Zinc-AWS');
			group: 'WebDAV' with: #('Zinc-WebDAV');
			group: 'WebSocket' with: #('Zinc-WebSocket-Core' 'Zinc-WebSocket-Tests');
			group: 'SSO-OAuth1' with: #('Zinc-SSO-OAuth1-Core' 'Zinc-SSO-OAuth1-Tests');
			group: 'SSO-OAuth2' with: #('Zinc-SSO-OAuth2-Core');
			group: 'SSO-OpenID' with: #('Zinc-SSO-OpenID-Core' 'Zinc-SSO-OpenID-Tests');
			group: 'SSO-Demo' with: #('Zinc-SSO-OAuth1-Core' 'Zinc-SSO-OAuth2-Core' 'Zinc-SSO-OpenID-Core');
			group: 'SSO' with: #('SSO-OAuth1' 'SSO-OAuth2' 'SSO-OpenID' 'SSO-Demo' 'Zinc-SSO-Demo');
			group: 'WWS' with: #('Zinc-WWS-Server' 'Zinc-WWS-Client');
			group: 'REST' with: #('Zinc-REST');
			group: 'Patch-HTTPSocket' with: #('Zinc-Patch-HTTPSocket');
			group: 'Seaside' with: #('Zinc-Seaside') ].
	spec for: #squeakCommon do:[ spec repository: 'http://mc.stfx.eu/ZincHTTPComponents' ].
	spec for: #'pharo1.x' do: [ 
		spec
			package: 'Zinc-FileSystem-Legacy';
			package: 'Zinc-Pharo-Forward-Compatibility';
			package: 'Zinc-HTTP' with: [ spec requires: #('Zinc-FileSystem-Legacy' 'Zinc-Pharo-Forward-Compatibility') ] ].
	spec for: #'pharo2.x' do: [
		spec
			package: 'Zinc-FileSystem';
			package: 'Zinc-pharo2-forward-compatibility';
			package: 'Zinc-HTTP' with: [ spec requires: #('Zinc-FileSystem' 'Zinc-pharo2-forward-compatibility')];
			package: 'Zinc-Resource-Meta-FileSystem' with: [ spec requires: 'Zinc-HTTP' ] ].
	spec for: #'pharo3.x' do: [
		spec
			package: 'Zinc-FileSystem';
			package: 'Zinc-HTTP' with: [ spec requires: 'Zinc-FileSystem' ];
			package: 'Zinc-Resource-Meta-FileSystem' with: [ spec requires: 'Zinc-HTTP' ] ].
	spec for: #'pharo4.x' do: [
		spec
			package: 'Zinc-FileSystem';
			package: 'Zinc-HTTP' with: [ spec requires: 'Zinc-FileSystem' ];
			package: 'Zinc-Resource-Meta-FileSystem' with: [ spec requires: 'Zinc-HTTP' ] ].
	spec for: #'pharo5.x' do: [
		spec
			package: 'Zinc-FileSystem';
			package: 'Zinc-HTTP' with: [ spec requires: 'Zinc-FileSystem' ];
			package: 'Zinc-Resource-Meta-FileSystem' with: [ spec requires: 'Zinc-HTTP' ] ].
	spec for: #'pharo6.x' do: [
		spec
			package: 'Zinc-FileSystem';
			package: 'Zinc-HTTP' with: [ spec requires: 'Zinc-FileSystem' ];
			package: 'Zinc-Resource-Meta-FileSystem' with: [ spec requires: 'Zinc-HTTP' ] ]

]

{ #category : 'baselines' }
ConfigurationOfZincHTTPComponents >> baseline29: spec [
	<version: '2.9-baseline'>
	spec for: #pharo do: [ 
		spec
			blessing: #baseline;
			description: 'Baseline for Zinc HTTP Components, a framework to deal with HTTP networking';
			author: 'SvenVanCaekenberghe'.
		spec project: 'XML Support' with: [
			spec
				className: 'ConfigurationOfXMLSupport';
				versionString: #'stable';
				repository: 'http://www.squeaksource.com/MetacelloRepository' ].
		spec project: 'Neo JSON' with: [
			spec
				className: 'ConfigurationOfNeoJSON';
				versionString: #'stable';
				repository: 'http://mc.stfx.eu/Neo' ].
		spec package: 'Zodiac-Core' with: [ spec repository: 'http://mc.stfx.eu/Zodiac' ].
		spec package: 'Zodiac-Tests' with: [ spec repository: 'http://mc.stfx.eu/Zodiac' ].
		spec package: 'Zodiac-Extra' with: [ spec repository: 'http://mc.stfx.eu/Zodiac' ].
		spec
			package: 'Zinc-Character-Encoding-Core';
			package: 'Zinc-Character-Encoding-Tests' with: [ spec requires: 'Zinc-Character-Encoding-Core' ];
			package: 'Zinc-Resource-Meta-Core' with: [ spec requires: 'Zinc-Character-Encoding-Core' ];
			package: 'Zinc-Resource-Meta-Tests' with: [ spec requires: 'Zinc-Resource-Meta-Core' ];
			package: 'Zinc-HTTP' with: [ spec requires: #( 'Zinc-Character-Encoding-Core' 'Zinc-Resource-Meta-Core' ) ];
			package: 'Zinc-Patch-HTTPSocket' with: [ spec requires: 'Zinc-HTTP' ];
			package: 'Zinc-AWS' with: [ spec requires: #( 'Zinc-HTTP' 'XML Support' ) ];
			package: 'Zinc-REST' with: [ spec requires: #( 'Zinc-HTTP' 'Neo JSON' ) ];
			package: 'Zinc-Zodiac' with: [ spec requires: #( 'Zinc-HTTP' 'Zodiac-Core' 'Zodiac-Tests' ) ];
			package: 'Zinc-WebSocket-Core' with: [ spec requires: 'Zinc-HTTP' ];
			package: 'Zinc-WebSocket-Tests' with: [ spec requires: 'Zinc-WebSocket-Core' ];
			package: 'Zinc-SSO-OAuth1-Core' with: [ spec requires: #( 'Zinc-HTTP' 'Neo JSON' ) ];
			package: 'Zinc-SSO-OAuth2-Core' with: [ spec requires: #( 'Zinc-HTTP' 'Neo JSON' ) ];
			package: 'Zinc-SSO-OpenID-Core' with: [ spec requires: #( 'Zinc-HTTP' 'XML Support' ) ];
			package: 'Zinc-SSO-Demo' with: [ spec requires: #( 'Zinc-SSO-OAuth1-Core' 'Zinc-SSO-OAuth2-Core' 'Zinc-SSO-OpenID-Core' ) ];
			package: 'Zinc-SSO-OAuth1-Tests' with: [ spec requires: #( 'Zinc-SSO-OAuth1-Core' ) ];
			package: 'Zinc-SSO-OpenID-Tests' with: [ spec requires: #( 'Zinc-SSO-OpenID-Core' ) ];
			package: 'Zinc-WebDAV' with: [ spec requires: 'Zinc-HTTP' ];
			package: 'Zinc-WWS-Server' with: [ spec requires: 'Zinc-HTTP' ];
			package: 'Zinc-WWS-Client' with: [ spec requires: 'Zinc-HTTP' ];
			package: 'Zinc-Tests' with: [ spec requires: 'Zinc-HTTP' ];
			package: 'Zinc-Seaside'. "For now, no dependence on Seaside itself"
		spec
			group: 'default' with: #('Core');
			group: 'Core' with: #('Zinc-HTTP');
			group: 'Tests' with: #('Zinc-Tests' 'Zinc-Character-Encoding-Tests' 'Zinc-Resource-Meta-Tests');
			group: 'Character-Encoding' with: #('Zinc-Character-Encoding-Core' 'Zinc-Character-Encoding-Tests');
			group: 'Resource-Meta' with: #('Zinc-Resource-Meta-Core' 'Zinc-Resource-Meta-Tests');
			group: 'Zodiac' with: #('Zinc-Zodiac');
			group: 'AWS' with: #('Zinc-AWS');
			group: 'WebDAV' with: #('Zinc-WebDAV');
			group: 'WebSocket' with: #('Zinc-WebSocket-Core' 'Zinc-WebSocket-Tests');
			group: 'SSO-OAuth1' with: #('Zinc-SSO-OAuth1-Core' 'Zinc-SSO-OAuth1-Tests');
			group: 'SSO-OAuth2' with: #('Zinc-SSO-OAuth2-Core');
			group: 'SSO-OpenID' with: #('Zinc-SSO-OpenID-Core' 'Zinc-SSO-OpenID-Tests');
			group: 'SSO-Demo' with: #('Zinc-SSO-OAuth1-Core' 'Zinc-SSO-OAuth2-Core' 'Zinc-SSO-OpenID-Core');
			group: 'SSO' with: #('SSO-OAuth1' 'SSO-OAuth2' 'SSO-OpenID' 'SSO-Demo' 'Zinc-SSO-Demo');
			group: 'WWS' with: #('Zinc-WWS-Server' 'Zinc-WWS-Client');
			group: 'REST' with: #('Zinc-REST');
			group: 'Patch-HTTPSocket' with: #('Zinc-Patch-HTTPSocket');
			group: 'Seaside' with: #('Zinc-Seaside') ].
	spec for: #squeakCommon do:[ spec repository: 'http://mc.stfx.eu/ZincHTTPComponents' ].
	spec for: #'pharo1.x' do: [ 
		spec
			package: 'Zinc-FileSystem-Legacy';
			package: 'Zinc-Pharo-Forward-Compatibility';
			package: 'Zinc-HTTP' with: [ spec requires: #('Zinc-FileSystem-Legacy' 'Zinc-Pharo-Forward-Compatibility') ] ].
	spec for: #'pharo2.x' do: [
		spec
			package: 'Zinc-FileSystem';
			package: 'Zinc-pharo2-forward-compatibility';
			package: 'Zinc-HTTP' with: [ spec requires: #('Zinc-FileSystem' 'Zinc-pharo2-forward-compatibility')];
			package: 'Zinc-Resource-Meta-FileSystem' with: [ spec requires: 'Zinc-HTTP' ] ].
	spec for: #'pharo3.x' do: [
		spec
			package: 'Zinc-FileSystem';
			package: 'Zinc-HTTP' with: [ spec requires: 'Zinc-FileSystem' ];
			package: 'Zinc-Resource-Meta-FileSystem' with: [ spec requires: 'Zinc-HTTP' ] ].
	spec for: #'pharo4.x' do: [
		spec
			package: 'Zinc-FileSystem';
			package: 'Zinc-HTTP' with: [ spec requires: 'Zinc-FileSystem' ];
			package: 'Zinc-Resource-Meta-FileSystem' with: [ spec requires: 'Zinc-HTTP' ] ].
	spec for: #'pharo5.x' do: [
		spec
			package: 'Zinc-FileSystem';
			package: 'Zinc-HTTP' with: [ spec requires: 'Zinc-FileSystem' ];
			package: 'Zinc-Resource-Meta-FileSystem' with: [ spec requires: 'Zinc-HTTP' ] ].
	spec for: #'pharo6.x' do: [
		spec
			package: 'Zinc-FileSystem';
			package: 'Zinc-HTTP' with: [ spec requires: 'Zinc-FileSystem' ];
			package: 'Zinc-Resource-Meta-FileSystem' with: [ spec requires: 'Zinc-HTTP' ] ].
	spec for: #'pharo7.x' do: [
		spec
			package: 'Zinc-FileSystem';
			package: 'Zinc-HTTP' with: [ spec requires: 'Zinc-FileSystem' ];
			package: 'Zinc-Resource-Meta-FileSystem' with: [ spec requires: 'Zinc-HTTP' ] ]

]

{ #category : 'baselines' }
ConfigurationOfZincHTTPComponents >> baseline30: spec [
	<version: '3.0-baseline'>
	spec for: #common do: [ 
		spec
			blessing: #baseline;
			description: 'Baseline for Zinc HTTP Components, a framework to deal with HTTP networking';
			author: 'SvenVanCaekenberghe';
			repository: 'http://mc.stfx.eu/ZincHTTPComponents'.
		spec baseline: 'NeoJSON' with: [ spec repository: 'github://svenvc/NeoJSON:master/repository' ].
		spec project: 'XML Support' with: [ spec className: 'ConfigurationOfXMLSupport'; repository: 'http://www.squeaksource.com/MetacelloRepository' ].
		spec package: 'Zodiac-Core' with: [ spec repository: 'http://mc.stfx.eu/Zodiac' ].
		spec package: 'Zodiac-Tests' with: [ spec repository: 'http://mc.stfx.eu/Zodiac' ].
		spec
			package: 'Zinc-Character-Encoding-Core';
			package: 'Zinc-Character-Encoding-Tests' with: [ spec requires: 'Zinc-Character-Encoding-Core' ];
			package: 'Zinc-Resource-Meta-Core' with: [ spec requires: 'Zinc-Character-Encoding-Core' ];
			package: 'Zinc-Resource-Meta-Tests' with: [ spec requires: 'Zinc-Resource-Meta-Core' ];
			package: 'Zinc-HTTP' with: [ spec requires: #('Zinc-Character-Encoding-Core' 'Zinc-Resource-Meta-Core') ];
			package: 'Zinc-HTTP-Examples' with: [ spec requires: #('Zinc-HTTP') ];
			package: 'Zinc-Tests' with: [ spec requires: 'Zinc-HTTP' ];
			package: 'Zinc-Zodiac-Core' with: [ spec requires: #('Zinc-HTTP' 'Zodiac-Core') ];
			package: 'Zinc-Zodiac-Tests' with: [ spec requires:  #('Zinc-Zodiac-Core') ].
		spec
			package: 'Zinc-Seaside';	"For now, no dependence on Seaside itself"
			package: 'Zinc-AWS' with: [ spec requires: #('Zinc-HTTP' 'XML Support') ];
			package: 'Zinc-REST' with: [ spec requires: #('Zinc-HTTP' 'NeoJSON') ];
			package: 'Zinc-WebSocket-Core' with: [ spec requires: 'Zinc-HTTP' ];
			package: 'Zinc-WebSocket-Tests' with: [ spec requires: 'Zinc-WebSocket-Core' ];
			package: 'Zinc-SSO-OAuth1-Core' with: [ spec requires: #('Zinc-HTTP' 'NeoJSON') ];
			package: 'Zinc-SSO-OAuth2-Core' with: [ spec requires: #('Zinc-HTTP' 'NeoJSON') ];
			package: 'Zinc-SSO-OpenID-Core' with: [ spec requires: #('Zinc-HTTP' 'XML Support') ];
			package: 'Zinc-SSO-Demo' with: [ spec requires: #('Zinc-SSO-OAuth1-Core' 'Zinc-SSO-OAuth2-Core' 'Zinc-SSO-OpenID-Core') ];
			package: 'Zinc-SSO-OAuth1-Tests' with: [ spec requires: #('Zinc-SSO-OAuth1-Core') ];
			package: 'Zinc-SSO-OpenID-Tests' with: [ spec requires: #('Zinc-SSO-OpenID-Core') ];
			package: 'Zinc-WebDAV' with: [ spec requires: 'Zinc-HTTP' ];
			package: 'Zinc-WWS-Server' with: [ spec requires: 'Zinc-HTTP' ];
			package: 'Zinc-WWS-Client' with: [ spec requires: 'Zinc-HTTP' ].
		spec
			group: 'default' with: #('Core' 'Tests');
			group: 'Core' with: #('Zinc-HTTP' 'Zinc-HTTP-Examples' 'Zinc-Zodiac-Core');
			group: 'Tests' with: #('Zinc-Tests' 'Zinc-Character-Encoding-Tests' 'Zinc-Resource-Meta-Tests' 'Zodiac-Tests' 'Zinc-Zodiac-Tests');
			group: 'Character-Encoding' with: #('Zinc-Character-Encoding-Core' 'Zinc-Character-Encoding-Tests');
			group: 'Resource-Meta' with: #('Zinc-Resource-Meta-Core' 'Zinc-Resource-Meta-Tests');
			group: 'Zodiac' with: #('Zodiac-Core' 'Zodiac-Tests');
			group: 'AWS' with: #('Zinc-AWS');
			group: 'WebDAV' with: #('Zinc-WebDAV');
			group: 'WebSocket' with: #('Zinc-WebSocket-Core' 'Zinc-WebSocket-Tests');
			group: 'SSO-OAuth1' with: #('Zinc-SSO-OAuth1-Core' 'Zinc-SSO-OAuth1-Tests');
			group: 'SSO-OAuth2' with: #('Zinc-SSO-OAuth2-Core');
			group: 'SSO-OpenID' with: #('Zinc-SSO-OpenID-Core' 'Zinc-SSO-OpenID-Tests');
			group: 'SSO-Demo' with: #('Zinc-SSO-OAuth1-Core' 'Zinc-SSO-OAuth2-Core' 'Zinc-SSO-OpenID-Core');
			group: 'SSO' with: #('SSO-OAuth1' 'SSO-OAuth2' 'SSO-OpenID' 'SSO-Demo' 'Zinc-SSO-Demo');
			group: 'WWS' with: #('Zinc-WWS-Server' 'Zinc-WWS-Client');
			group: 'REST' with: #('Zinc-REST');
			group: 'Seaside' with: #('Zinc-Seaside') ]
]

{ #category : 'accessing' }
ConfigurationOfZincHTTPComponents >> project [

	^ project ifNil: [ | constructor |
		"Bootstrap Metacello if it is not already loaded"
		self class ensureMetacello.
		"Construct Metacello project"
		constructor := (Smalltalk at: #MetacelloVersionConstructor) on: self.
		project := constructor project.
		project loadType: #linear. "change to #atomic if desired"
		project ]
]

{ #category : 'accessing' }
ConfigurationOfZincHTTPComponents >> stable: spec [
	<symbolicVersion: #stable>
	spec for: #'pharo3.x' version: '3.0.1'.
	spec for: #'pharo4.x' version: '3.0.1'.
	spec for: #'pharo5.x' version: '3.0.1'.
	spec for: #'pharo6.x' version: '3.0.1'.
	spec for: #'pharo7.x' version: '3.0.1'.
	spec for: #'pharo8.x' version: '3.0.1'.
	spec for: #gemstone version: '2.4.3'
]

{ #category : 'versions' }
ConfigurationOfZincHTTPComponents >> version10: spec [ 
	<version: '1.0' imports: #('1.0-baseline') >
	
	spec for: #common do: [
		spec blessing: #release.
		spec 
			package: 'Zinc-HTTP' with: 'Zinc-HTTP-PaulDeBruicker.140';
			package: 'Zinc-Tests' with: 'Zinc-Tests-SvenVanCaekenberghe.75';
			package: 'Zinc-AWS' with:'Zinc-AWS-SvenVanCaekenberghe.7';
			package: 'Zinc-Patch-HTTPSocket' with:'Zinc-Patch-HTTPSocket-SvenVanCaekenberghe.1';
			package: 'Zinc-Seaside' with:'Zinc-Seaside-PaulDeBruicker.13';
			project:'Seaside30' with: '3.0.4' ].
		
	spec for: #gemstone do:[
		spec blessing: #release.
		spec 
			package: 'Zinc-GemstonePreliminary' with: 'Zinc-GemstonePreliminary-PaulDeBruicker.2';
			package: 'Zinc-Gemstone' with: 'Zinc-Gemstone-PaulDeBruicker.8';
			package:'SocketStream' with:'SocketStream-PaulDeBruicker.12';
			package:'Seaside-GemStone-Adaptors-Zinc' with: 'Seaside-GemStone-Adaptors-Zinc-PaulDeBruicker.3'   		
		]
]

{ #category : 'versions' }
ConfigurationOfZincHTTPComponents >> version11: spec [ 
	<version: '1.1' imports: #('1.1-baseline') >
	
	spec for: #common do: [
		spec blessing: #release.
		spec 
			package: 'Zinc-HTTP' with: 'Zinc-HTTP-SvenVanCaekenberghe.162';
			package: 'Zinc-Tests' with: 'Zinc-Tests-SvenVanCaekenberghe.84';
			package: 'Zinc-AWS' with:'Zinc-AWS-SvenVanCaekenberghe.7';
			package: 'Zinc-Zodiac' with:'Zinc-Zodiac-SvenVanCaekenberghe.4';
			package: 'Zinc-Patch-HTTPSocket' with:'Zinc-Patch-HTTPSocket-SvenVanCaekenberghe.1';
			package: 'Zinc-Seaside' with:'Zinc-Seaside-SvenVanCaekenberghe.16';
			package: 'Zodiac' with: 'Zodiac-Core-SvenVanCaekenberghe.8' ;
			project:'Seaside30' with: '3.0.5'
			].
		
	spec for: #gemstone do:[
		spec blessing: #release.
		spec 
			package: 'Zinc-GemstonePreliminary' with: 'Zinc-GemstonePreliminary-PaulDeBruicker.2';
			package: 'Zinc-Gemstone' with: 'Zinc-Gemstone-PaulDeBruicker.14';
			package:'SocketStream' with:'SocketStream-PaulDeBruicker.12';
			package:'Seaside-GemStone-Adaptors-Zinc' with: 'Seaside-GemStone-Adaptors-Zinc-PaulDeBruicker.3'   		
		]
]

{ #category : 'versions' }
ConfigurationOfZincHTTPComponents >> version12: spec [
	<version: '1.2' imports: #('1.2-baseline' )>

	spec for: #'common' do: [
		spec blessing: #'development'.
		spec description: '- Move Seaside support into ConfigurationOfSeaside30
- update to latest set of packages.'.
		spec author: 'dkh'.
		spec timestamp: '9/1/2011 16:33'.
		spec 
			package: 'Zinc-HTTP' with: 'Zinc-HTTP-SvenVanCaekenberghe.188';
			package: 'Zinc-Tests' with: 'Zinc-Tests-SvenVanCaekenberghe.98';
			package: 'Zinc-AWS' with: 'Zinc-AWS-SvenVanCaekenberghe.7';
			package: 'Zinc-Zodiac' with: 'Zinc-Zodiac-SvenVanCaekenberghe.4';
			package: 'Zinc-Patch-HTTPSocket' with: 'Zinc-Patch-HTTPSocket-StephaneDucasse.2';
			package: 'Zodiac' with: 'Zodiac-Core-SvenVanCaekenberghe.8'. ].

	spec for: #'gemstone' do: [
		spec blessing: #'release'.
		spec 
			package: 'Zinc-GemstonePreliminary' with: 'Zinc-GemstonePreliminary-PaulDeBruicker.2';
			package: 'Zinc-Gemstone' with: 'Zinc-Gemstone-PaulDeBruicker.14';
			package: 'SocketStream' with: 'SocketStream-PaulDeBruicker.12'. ].

]

{ #category : 'versions' }
ConfigurationOfZincHTTPComponents >> version13: spec [
	<version: '1.3' imports: #('1.3-baseline' )>

	spec for: #'common' do: [
		spec blessing: #'release'.
		spec description: '-added Zinc-REST - update to latest set of packages.'.
		spec author: 'PaulDeBruicker'.
		spec timestamp: '10/26/2011 17:15'.
		spec 
			package: 'Zinc-HTTP' with: 'Zinc-HTTP-SvenVanCaekenberghe.214';
			package: 'Zinc-Tests' with: 'Zinc-Tests-SvenVanCaekenberghe.110';
			package: 'Zinc-AWS' with: 'Zinc-AWS-SvenVanCaekenberghe.9';
			package: 'Zinc-REST' with: 'Zinc-REST-SvenVanCaekenberghe.5';
			package: 'Zinc-Zodiac' with: 'Zinc-Zodiac-SvenVanCaekenberghe.8';
			package: 'Zinc-Patch-HTTPSocket' with: 'Zinc-Patch-HTTPSocket-StephaneDucasse.2';
			package: 'Zodiac' with: 'Zodiac-Core-SvenVanCaekenberghe.11'. ].

	spec for: #'gemstone' do: [
		spec blessing: #'release'.
		spec 
			package: 'Zinc-GemstonePreliminary' with: 'Zinc-GemstonePreliminary-PaulDeBruicker.2';
			package: 'Zinc-Gemstone' with: 'Zinc-Gemstone-PaulDeBruicker.14';
			package: 'SocketStream' with: 'SocketStream-PaulDeBruicker.12'. ].

]

{ #category : 'versions' }
ConfigurationOfZincHTTPComponents >> version14: spec [
	<version: '1.4' imports: #('1.4-baseline' )>

	spec for: #'common' do: [
		spec blessing: #'release'.
		spec description: 'update to latest set of packages.'.
		spec author: 'FrancoisStephany'.
		spec timestamp: '12/12/2011 11:52'.
		spec 
			package: 'Zinc-HTTP' with: 'Zinc-HTTP-SvenVanCaekenberghe.227';
			package: 'Zinc-Tests' with: 'Zinc-Tests-SvenVanCaekenberghe.118';
			package: 'Zinc-AWS' with: 'Zinc-AWS-SvenVanCaekenberghe.15';
			package: 'Zinc-REST' with: 'Zinc-REST-SvenVanCaekenberghe.5';
			package: 'Zinc-Zodiac' with: 'Zinc-Zodiac-SvenVanCaekenberghe.10';
			package: 'Zinc-Patch-HTTPSocket' with: 'Zinc-Patch-HTTPSocket-StephaneDucasse.2';
			package: 'Zodiac' with: 'Zodiac-Core-SvenVanCaekenberghe.16'. ].

	spec for: #'gemstone' do: [
		spec blessing: #'release'.
		spec 
			package: 'Zinc-GemstonePreliminary' with: 'Zinc-GemstonePreliminary-PaulDeBruicker.2';
			package: 'Zinc-Gemstone' with: 'Zinc-Gemstone-PaulDeBruicker.14';
			package: 'SocketStream' with: 'SocketStream-PaulDeBruicker.12'. ].

]

{ #category : 'versions' }
ConfigurationOfZincHTTPComponents >> version151: spec [
	<version: '1.5.1' imports: #('1.5-baseline' )>

	spec for: #'common' do: [
		spec blessing: #release.
		spec description: 'fixed Zodiac-Core package name; updated to latest packages; all tests pass on Pharo 1.4'.
		spec author: 'SeanDeNigris'.
		spec timestamp: '6/7/2012 00:23'.
		spec 
			package: 'Zodiac-Core' with: 'Zodiac-Core-SvenVanCaekenberghe.17';
			package: 'Zinc-HTTP' with: 'Zinc-HTTP-SvenVanCaekenberghe.280';
			package: 'Zinc-Patch-HTTPSocket' with: 'Zinc-Patch-HTTPSocket-StephaneDucasse.2';
			package: 'Zinc-AWS' with: 'Zinc-AWS-SvenVanCaekenberghe.15';
			package: 'Zinc-REST' with: 'Zinc-REST-SvenVanCaekenberghe.5';
			package: 'Zinc-Zodiac' with: 'Zinc-Zodiac-SvenVanCaekenberghe.12';
			package: 'Zinc-WebDAV' with: 'Zinc-WebDAV-SvenVanCaekenberghe.3';
			package: 'Zinc-WWS-Server' with: 'Zinc-WWS-Server-SvenVanCaekenberghe.7';
			package: 'Zinc-WWS-Client' with: 'Zinc-WWS-Client-SvenVanCaekenberghe.2';
			package: 'Zinc-Tests' with: 'Zinc-Tests-SvenVanCaekenberghe.144'. ].
]

{ #category : 'versions' }
ConfigurationOfZincHTTPComponents >> version15: spec [
	<version: '1.5' imports: #('1.5-baseline')>
	spec
		for: #common
		do: [ 
			spec blessing: #release.
			spec description: 'update to latest set of packages.'.
			spec author: 'PaulDeBruicker'.
			spec timestamp: '4/4/2012 09:12'.
			spec
				package: 'Zinc-HTTP' with: 'Zinc-HTTP-SvenVanCaekenberghe.254';
				package: 'Zinc-Tests' with: 'Zinc-Tests-SvenVanCaekenberghe.130';
				package: 'Zinc-AWS' with: 'Zinc-AWS-SvenVanCaekenberghe.15';
				package: 'Zinc-REST' with: 'Zinc-REST-SvenVanCaekenberghe.5';
				package: 'Zinc-WebDAV' with: 'Zinc-WebDAV-SvenVanCaekenberghe.3';
				package: 'Zinc-WWS-Client' with: 'Zinc-WWS-Client-SvenVanCaekenberghe.2';
				package: 'Zinc-WWS-Server' with: 'Zinc-WWS-Server-SvenVanCaekenberghe.7';
				package: 'Zinc-Zodiac' with: 'Zinc-Zodiac-SvenVanCaekenberghe.12';
				package: 'Zinc-Patch-HTTPSocket' with: 'Zinc-Patch-HTTPSocket-StephaneDucasse.2';
				package: 'Zodiac-Core' with: 'Zodiac-Core-SvenVanCaekenberghe.17' ].
	spec
		for: #gemstone
		do: [ 
			spec blessing: #release.
			spec
				package: 'Zinc-GemstonePreliminary' with: 'Zinc-GemstonePreliminary-PaulDeBruicker.2';
				package: 'Zinc-Gemstone' with: 'Zinc-Gemstone-PaulDeBruicker.14';
				package: 'SocketStream' with: 'SocketStream-PaulDeBruicker.12' ]
]

{ #category : 'versions' }
ConfigurationOfZincHTTPComponents >> version16: spec [
	<version: '1.6' imports: #('1.5-baseline')>
	spec
		for: #common
		do: [ 
			spec blessing: #release.
			spec description: 'update to latest set of packages.'.
			spec author: 'PaulDeBruicker'.
			spec timestamp: '6/6/2012 13:12-7:00'.
			spec
				package: 'Zinc-HTTP' with: 'Zinc-HTTP-SvenVanCaekenberghe.280';
				package: 'Zinc-Tests' with: 'Zinc-Tests-SvenVanCaekenberghe.144';
				package: 'Zinc-AWS' with: 'Zinc-AWS-SvenVanCaekenberghe.15';
				package: 'Zinc-REST' with: 'Zinc-REST-SvenVanCaekenberghe.5';
				package: 'Zinc-WebDAV' with: 'Zinc-WebDAV-SvenVanCaekenberghe.3';
				package: 'Zinc-WWS-Client' with: 'Zinc-WWS-Client-SvenVanCaekenberghe.2';
				package: 'Zinc-WWS-Server' with: 'Zinc-WWS-Server-SvenVanCaekenberghe.7';
				package: 'Zinc-Zodiac' with: 'Zinc-Zodiac-SvenVanCaekenberghe.12';
				package: 'Zinc-Patch-HTTPSocket' with: 'Zinc-Patch-HTTPSocket-StephaneDucasse.2';
				package: 'Zodiac-Core' with: 'Zodiac-Core-SvenVanCaekenberghe.17' ].
	spec
		for: #gemstone
		do: [ 
			spec blessing: #release.
			spec
				package: 'Zinc-GemstonePreliminary' with: 'Zinc-GemstonePreliminary-PaulDeBruicker.2';
				package: 'Zinc-Gemstone' with: 'Zinc-Gemstone-PaulDeBruicker.14';
				package: 'SocketStream' with: 'SocketStream-PaulDeBruicker.12' ]
]

{ #category : 'versions' }
ConfigurationOfZincHTTPComponents >> version17: spec [
	<version: '1.7' imports: #('1.7-baseline')>
	spec
		for: #common
		do: [ 
			spec blessing: #release.
			spec description: '
- update to latest package versions
- add  FileSystem-Legacy to Pharo 1.x and FileSystem to Pharo 2.x'.
			spec author: 'SeanDeNigris'.
			spec timestamp: '7/4/2012 12:12-4:00'.
			spec
				package: 'Zinc-HTTP' with: 'Zinc-HTTP-SvenVanCaekenberghe.282';
				package: 'Zinc-Tests' with: 'Zinc-Tests-SvenVanCaekenberghe.147';
				package: 'Zinc-AWS' with: 'Zinc-AWS-SvenVanCaekenberghe.15';
				package: 'Zinc-REST' with: 'Zinc-REST-SvenVanCaekenberghe.5';
				package: 'Zinc-WebDAV' with: 'Zinc-WebDAV-SvenVanCaekenberghe.3';
				package: 'Zinc-WWS-Client' with: 'Zinc-WWS-Client-SvenVanCaekenberghe.2';
				package: 'Zinc-WWS-Server' with: 'Zinc-WWS-Server-SvenVanCaekenberghe.7';
				package: 'Zinc-Zodiac' with: 'Zinc-Zodiac-SvenVanCaekenberghe.14';
				package: 'Zinc-Patch-HTTPSocket' with: 'Zinc-Patch-HTTPSocket-StephaneDucasse.2';
				package: 'Zodiac-Core' with: 'Zodiac-Core-SvenVanCaekenberghe.18' ].
	spec for: #'pharo1.x' do: [ spec package: 'Zinc-FileSystem-Legacy' with: 'Zinc-FileSystem-Legacy-SvenVanCaekenberghe.1' ].
	spec for: #'pharo2.x' do: [ spec package: 'Zinc-FileSystem' with: 'Zinc-FileSystem-SeanDeNigris.2' ].
	spec
		for: #gemstone
		do: [ 
			spec blessing: #release.
			spec
				package: 'Zinc-GemstonePreliminary' with: 'Zinc-GemstonePreliminary-PaulDeBruicker.2';
				package: 'Zinc-Gemstone' with: 'Zinc-Gemstone-PaulDeBruicker.14';
				package: 'SocketStream' with: 'SocketStream-PaulDeBruicker.12' ]
]

{ #category : 'versions' }
ConfigurationOfZincHTTPComponents >> version181: spec [
	<version: '1.8.1' imports: #('1.8-baseline')>
	spec for: #common do: [ 
		spec 
			blessing: #release;
			description: 'Update to latest package versions';
			author: 'SvenVanCaekenberghe';
			package: 'Zinc-HTTP' with: 'Zinc-HTTP-SvenVanCaekenberghe.297';
			package: 'Zinc-Tests' with: 'Zinc-Tests-SvenVanCaekenberghe.153';
			package: 'Zinc-AWS' with: 'Zinc-AWS-SvenVanCaekenberghe.15';
			package: 'Zinc-REST' with: 'Zinc-REST-SvenVanCaekenberghe.5';
			package: 'Zinc-WebDAV' with: 'Zinc-WebDAV-SvenVanCaekenberghe.3';
			package: 'Zinc-WebSocket-Core' with: 'Zinc-WebSocket-Core-SvenVanCaekenberghe.11';
			package: 'Zinc-WebSocket-Tests' with: 'Zinc-WebSocket-Tests-SvenVanCaekenberghe.5';
			package: 'Zinc-WWS-Client' with: 'Zinc-WWS-Client-SvenVanCaekenberghe.2';
			package: 'Zinc-WWS-Server' with: 'Zinc-WWS-Server-SvenVanCaekenberghe.8';
			package: 'Zinc-Zodiac' with: 'Zinc-Zodiac-SvenVanCaekenberghe.18';
			package: 'Zinc-Patch-HTTPSocket' with: 'Zinc-Patch-HTTPSocket-SvenVanCaekenberghe.1';
			package: 'Zodiac-Core' with: 'Zodiac-Core-SvenVanCaekenberghe.25' ].
	spec for: #'pharo1.x' do: [ 
		spec 
			package: 'Zinc-FileSystem-Legacy' with: 'Zinc-FileSystem-Legacy-SvenVanCaekenberghe.3';
			package: 'Zinc-Pharo-Forward-Compatibility' with: 'Zinc-Pharo-Forward-Compatibility-SvenVanCaekenberghe.1' ].
	spec for: #'pharo2.x' do: [ 
		spec package: 'Zinc-FileSystem' with: 'Zinc-FileSystem-SvenVanCaekenberghe.6' ].
	spec for: #gemstone do: [ 
		spec blessing: #release.
		spec
			package: 'Zinc-GemstonePreliminary' with: 'Zinc-GemstonePreliminary-PaulDeBruicker.2';
			package: 'Zinc-Gemstone' with: 'Zinc-Gemstone-PaulDeBruicker.14';
			package: 'SocketStream' with: 'SocketStream-PaulDeBruicker.12' ]

]

{ #category : 'versions' }
ConfigurationOfZincHTTPComponents >> version182: spec [
	<version: '1.8.2' imports: #('1.8-baseline')>
	spec for: #common do: [ 
		spec 
			blessing: #release;
			description: 'Update to latest package versions';
			author: 'SvenVanCaekenberghe';
			package: 'Zinc-HTTP' with: 'Zinc-HTTP-SvenVanCaekenberghe.300';
			package: 'Zinc-Tests' with: 'Zinc-Tests-SvenVanCaekenberghe.155';
			package: 'Zinc-AWS' with: 'Zinc-AWS-SvenVanCaekenberghe.15';
			package: 'Zinc-REST' with: 'Zinc-REST-SvenVanCaekenberghe.5';
			package: 'Zinc-WebDAV' with: 'Zinc-WebDAV-SvenVanCaekenberghe.3';
			package: 'Zinc-WebSocket-Core' with: 'Zinc-WebSocket-Core-SvenVanCaekenberghe.19';
			package: 'Zinc-WebSocket-Tests' with: 'Zinc-WebSocket-Tests-SvenVanCaekenberghe.7';
			package: 'Zinc-WWS-Client' with: 'Zinc-WWS-Client-SvenVanCaekenberghe.2';
			package: 'Zinc-WWS-Server' with: 'Zinc-WWS-Server-SvenVanCaekenberghe.8';
			package: 'Zinc-Zodiac' with: 'Zinc-Zodiac-SvenVanCaekenberghe.18';
			package: 'Zinc-Patch-HTTPSocket' with: 'Zinc-Patch-HTTPSocket-SvenVanCaekenberghe.1';
			package: 'Zodiac-Core' with: 'Zodiac-Core-SvenVanCaekenberghe.26' ].
	spec for: #'pharo1.x' do: [ 
		spec 
			package: 'Zinc-FileSystem-Legacy' with: 'Zinc-FileSystem-Legacy-SvenVanCaekenberghe.3';
			package: 'Zinc-Pharo-Forward-Compatibility' with: 'Zinc-Pharo-Forward-Compatibility-SvenVanCaekenberghe.1' ].
	spec for: #'pharo2.x' do: [ 
		spec package: 'Zinc-FileSystem' with: 'Zinc-FileSystem-SvenVanCaekenberghe.6' ].
	spec for: #gemstone do: [ 
		spec blessing: #release.
		spec
			package: 'Zinc-GemstonePreliminary' with: 'Zinc-GemstonePreliminary-PaulDeBruicker.2';
			package: 'Zinc-Gemstone' with: 'Zinc-Gemstone-PaulDeBruicker.14';
			package: 'SocketStream' with: 'SocketStream-PaulDeBruicker.12' ]

]

{ #category : 'versions' }
ConfigurationOfZincHTTPComponents >> version18: spec [
	<version: '1.8' imports: #('1.8-baseline')>
	spec for: #common do: [ 
		spec 
			blessing: #release;
			description: 'Update to latest package versions';
			author: 'SvenVanCaekenberghe';
			package: 'Zinc-HTTP' with: 'Zinc-HTTP-SvenVanCaekenberghe.297';
			package: 'Zinc-Tests' with: 'Zinc-Tests-SvenVanCaekenberghe.153';
			package: 'Zinc-AWS' with: 'Zinc-AWS-SvenVanCaekenberghe.15';
			package: 'Zinc-REST' with: 'Zinc-REST-SvenVanCaekenberghe.5';
			package: 'Zinc-WebDAV' with: 'Zinc-WebDAV-SvenVanCaekenberghe.3';
			package: 'Zinc-WebSocket-Core' with: 'Zinc-WebSocket-Core-SvenVanCaekenberghe.11';
			package: 'Zinc-WebSocket-Tests' with: 'Zinc-WebSocket-Tests-SvenVanCaekenberghe.5';
			package: 'Zinc-WWS-Client' with: 'Zinc-WWS-Client-SvenVanCaekenberghe.2';
			package: 'Zinc-WWS-Server' with: 'Zinc-WWS-Server-SvenVanCaekenberghe.7';
			package: 'Zinc-Zodiac' with: 'Zinc-Zodiac-SvenVanCaekenberghe.18';
			package: 'Zinc-Patch-HTTPSocket' with: 'Zinc-Patch-HTTPSocket-SvenVanCaekenberghe.1';
			package: 'Zodiac-Core' with: 'Zodiac-Core-SvenVanCaekenberghe.25' ].
	spec for: #'pharo1.x' do: [ 
		spec 
			package: 'Zinc-FileSystem-Legacy' with: 'Zinc-FileSystem-Legacy-SvenVanCaekenberghe.3';
			package: 'Zinc-Pharo-Forward-Compatibility' with: 'Zinc-Pharo-Forward-Compatibility-SvenVanCaekenberghe.1' ].
	spec for: #'pharo2.x' do: [ 
		spec package: 'Zinc-FileSystem' with: 'Zinc-FileSystem-SvenVanCaekenberghe.6' ].
	spec for: #gemstone do: [ 
		spec blessing: #release.
		spec
			package: 'Zinc-GemstonePreliminary' with: 'Zinc-GemstonePreliminary-PaulDeBruicker.2';
			package: 'Zinc-Gemstone' with: 'Zinc-Gemstone-PaulDeBruicker.14';
			package: 'SocketStream' with: 'SocketStream-PaulDeBruicker.12' ]

]

{ #category : 'versions' }
ConfigurationOfZincHTTPComponents >> version191: spec [
	<version: '1.9.1' imports: #('1.9-baseline')>
	spec for: #common do: [ 
		spec 
			blessing: #release;
			description: 'Update to latest package versions';
			author: 'SvenVanCaekenberghe';
			package: 'Zinc-HTTP' with: 'Zinc-HTTP-SvenVanCaekenberghe.310';
			package: 'Zinc-Tests' with: 'Zinc-Tests-SvenVanCaekenberghe.157';
			package: 'Zinc-AWS' with: 'Zinc-AWS-SvenVanCaekenberghe.16';
			package: 'Zinc-REST' with: 'Zinc-REST-SvenVanCaekenberghe.5';
			package: 'Zinc-WebDAV' with: 'Zinc-WebDAV-SvenVanCaekenberghe.3';
			package: 'Zinc-WebSocket-Core' with: 'Zinc-WebSocket-Core-SvenVanCaekenberghe.21';
			package: 'Zinc-WebSocket-Tests' with: 'Zinc-WebSocket-Tests-SvenVanCaekenberghe.7';
			package: 'Zinc-WWS-Client' with: 'Zinc-WWS-Client-SvenVanCaekenberghe.2';
			package: 'Zinc-WWS-Server' with: 'Zinc-WWS-Server-SvenVanCaekenberghe.8';
			package: 'Zinc-Zodiac' with: 'Zinc-Zodiac-SvenVanCaekenberghe.21';
			package: 'Zinc-Patch-HTTPSocket' with: 'Zinc-Patch-HTTPSocket-SvenVanCaekenberghe.1';
			package: 'Zodiac-Core' with: 'Zodiac-Core-SvenVanCaekenberghe.27' ].
	spec for: #'pharo1.x' do: [ 
		spec 
			package: 'Zinc-FileSystem-Legacy' with: 'Zinc-FileSystem-Legacy-SvenVanCaekenberghe.3';
			package: 'Zinc-Pharo-Forward-Compatibility' with: 'Zinc-Pharo-Forward-Compatibility-SvenVanCaekenberghe.1' ].
	spec for: #'pharo2.x' do: [ 
		spec package: 'Zinc-FileSystem' with: 'Zinc-FileSystem-SvenVanCaekenberghe.7' ].
	spec for: #gemstone do: [ 
		spec blessing: #release.
		spec
			package: 'Zinc-GemstonePreliminary' with: 'Zinc-GemstonePreliminary-PaulDeBruicker.2';
			package: 'Zinc-Gemstone' with: 'Zinc-Gemstone-PaulDeBruicker.14';
			package: 'SocketStream' with: 'SocketStream-PaulDeBruicker.12' ]

]

{ #category : 'versions' }
ConfigurationOfZincHTTPComponents >> version192: spec [
	<version: '1.9.2' imports: #('1.9-baseline')>
	spec for: #common do: [ 
		spec 
			blessing: #release;
			description: 'Update to latest package versions';
			author: 'SvenVanCaekenberghe';
			package: 'Zinc-HTTP' with: 'Zinc-HTTP-SvenVanCaekenberghe.310';
			package: 'Zinc-Tests' with: 'Zinc-Tests-SvenVanCaekenberghe.157';
			package: 'Zinc-AWS' with: 'Zinc-AWS-SvenVanCaekenberghe.16';
			package: 'Zinc-REST' with: 'Zinc-REST-SvenVanCaekenberghe.5';
			package: 'Zinc-WebDAV' with: 'Zinc-WebDAV-SvenVanCaekenberghe.3';
			package: 'Zinc-WebSocket-Core' with: 'Zinc-WebSocket-Core-SvenVanCaekenberghe.22';
			package: 'Zinc-WebSocket-Tests' with: 'Zinc-WebSocket-Tests-SvenVanCaekenberghe.7';
			package: 'Zinc-WWS-Client' with: 'Zinc-WWS-Client-SvenVanCaekenberghe.2';
			package: 'Zinc-WWS-Server' with: 'Zinc-WWS-Server-SvenVanCaekenberghe.8';
			package: 'Zinc-Zodiac' with: 'Zinc-Zodiac-SvenVanCaekenberghe.21';
			package: 'Zinc-Patch-HTTPSocket' with: 'Zinc-Patch-HTTPSocket-SvenVanCaekenberghe.1';
			package: 'Zodiac-Core' with: 'Zodiac-Core-SvenVanCaekenberghe.27' ].
	spec for: #'pharo1.x' do: [ 
		spec 
			package: 'Zinc-FileSystem-Legacy' with: 'Zinc-FileSystem-Legacy-SvenVanCaekenberghe.3';
			package: 'Zinc-Pharo-Forward-Compatibility' with: 'Zinc-Pharo-Forward-Compatibility-SvenVanCaekenberghe.1' ].
	spec for: #'pharo2.x' do: [ 
		spec package: 'Zinc-FileSystem' with: 'Zinc-FileSystem-SvenVanCaekenberghe.7' ].
	spec for: #gemstone do: [ 
		spec blessing: #release.
		spec
			package: 'Zinc-GemstonePreliminary' with: 'Zinc-GemstonePreliminary-PaulDeBruicker.2';
			package: 'Zinc-Gemstone' with: 'Zinc-Gemstone-PaulDeBruicker.14';
			package: 'SocketStream' with: 'SocketStream-PaulDeBruicker.12' ]

]

{ #category : 'versions' }
ConfigurationOfZincHTTPComponents >> version193: spec [
	<version: '1.9.3' imports: #('1.9-baseline')>
	spec for: #common do: [ 
		spec 
			blessing: #release;
			description: 'Update to latest package versions';
			author: 'SvenVanCaekenberghe';
			package: 'Zinc-HTTP' with: 'Zinc-HTTP-SvenVanCaekenberghe.310';
			package: 'Zinc-Tests' with: 'Zinc-Tests-SvenVanCaekenberghe.157';
			package: 'Zinc-AWS' with: 'Zinc-AWS-SvenVanCaekenberghe.16';
			package: 'Zinc-REST' with: 'Zinc-REST-SvenVanCaekenberghe.5';
			package: 'Zinc-WebDAV' with: 'Zinc-WebDAV-SvenVanCaekenberghe.3';
			package: 'Zinc-WebSocket-Core' with: 'Zinc-WebSocket-Core-SvenVanCaekenberghe.23';
			package: 'Zinc-WebSocket-Tests' with: 'Zinc-WebSocket-Tests-SvenVanCaekenberghe.7';
			package: 'Zinc-WWS-Client' with: 'Zinc-WWS-Client-SvenVanCaekenberghe.2';
			package: 'Zinc-WWS-Server' with: 'Zinc-WWS-Server-SvenVanCaekenberghe.8';
			package: 'Zinc-Zodiac' with: 'Zinc-Zodiac-SvenVanCaekenberghe.21';
			package: 'Zinc-Patch-HTTPSocket' with: 'Zinc-Patch-HTTPSocket-SvenVanCaekenberghe.1';
			package: 'Zodiac-Core' with: 'Zodiac-Core-SvenVanCaekenberghe.27' ].
	spec for: #'pharo1.x' do: [ 
		spec 
			package: 'Zinc-FileSystem-Legacy' with: 'Zinc-FileSystem-Legacy-SvenVanCaekenberghe.3';
			package: 'Zinc-Pharo-Forward-Compatibility' with: 'Zinc-Pharo-Forward-Compatibility-SvenVanCaekenberghe.1' ].
	spec for: #'pharo2.x' do: [ 
		spec package: 'Zinc-FileSystem' with: 'Zinc-FileSystem-SvenVanCaekenberghe.7' ].
	spec for: #gemstone do: [ 
		spec blessing: #release.
		spec
			package: 'Zinc-GemstonePreliminary' with: 'Zinc-GemstonePreliminary-PaulDeBruicker.2';
			package: 'Zinc-Gemstone' with: 'Zinc-Gemstone-PaulDeBruicker.14';
			package: 'SocketStream' with: 'SocketStream-PaulDeBruicker.12' ]

]

{ #category : 'versions' }
ConfigurationOfZincHTTPComponents >> version19: spec [
	<version: '1.9' imports: #('1.9-baseline')>
	spec for: #common do: [ 
		spec 
			blessing: #release;
			description: 'Update to latest package versions';
			author: 'SvenVanCaekenberghe';
			package: 'Zinc-HTTP' with: 'Zinc-HTTP-SvenVanCaekenberghe.306';
			package: 'Zinc-Tests' with: 'Zinc-Tests-SvenVanCaekenberghe.157';
			package: 'Zinc-AWS' with: 'Zinc-AWS-SvenVanCaekenberghe.16';
			package: 'Zinc-REST' with: 'Zinc-REST-SvenVanCaekenberghe.5';
			package: 'Zinc-WebDAV' with: 'Zinc-WebDAV-SvenVanCaekenberghe.3';
			package: 'Zinc-WebSocket-Core' with: 'Zinc-WebSocket-Core-SvenVanCaekenberghe.21';
			package: 'Zinc-WebSocket-Tests' with: 'Zinc-WebSocket-Tests-SvenVanCaekenberghe.7';
			package: 'Zinc-WWS-Client' with: 'Zinc-WWS-Client-SvenVanCaekenberghe.2';
			package: 'Zinc-WWS-Server' with: 'Zinc-WWS-Server-SvenVanCaekenberghe.8';
			package: 'Zinc-Zodiac' with: 'Zinc-Zodiac-SvenVanCaekenberghe.18';
			package: 'Zinc-Patch-HTTPSocket' with: 'Zinc-Patch-HTTPSocket-SvenVanCaekenberghe.1';
			package: 'Zodiac-Core' with: 'Zodiac-Core-SvenVanCaekenberghe.27' ].
	spec for: #'pharo1.x' do: [ 
		spec 
			package: 'Zinc-FileSystem-Legacy' with: 'Zinc-FileSystem-Legacy-SvenVanCaekenberghe.3';
			package: 'Zinc-Pharo-Forward-Compatibility' with: 'Zinc-Pharo-Forward-Compatibility-SvenVanCaekenberghe.1' ].
	spec for: #'pharo2.x' do: [ 
		spec package: 'Zinc-FileSystem' with: 'Zinc-FileSystem-SvenVanCaekenberghe.7' ].
	spec for: #gemstone do: [ 
		spec blessing: #release.
		spec
			package: 'Zinc-GemstonePreliminary' with: 'Zinc-GemstonePreliminary-PaulDeBruicker.2';
			package: 'Zinc-Gemstone' with: 'Zinc-Gemstone-PaulDeBruicker.14';
			package: 'SocketStream' with: 'SocketStream-PaulDeBruicker.12' ]

]

{ #category : 'versions' }
ConfigurationOfZincHTTPComponents >> version20: spec [
	<version: '2.0' imports: #('2.0-baseline')>
	spec for: #common do: [ 
		spec 
			blessing: #release;
			description: 'Update to latest package versions';
			author: 'SvenVanCaekenberghe';
			package: 'Zinc-Resource-Meta-Core' with: 'Zinc-Resource-Meta-Core-SvenVanCaekenberghe.2';
			package: 'Zinc-Resource-Meta-Tests' with: 'Zinc-Resource-Meta-Tests-SvenVanCaekenberghe.2';
			package: 'Zinc-HTTP' with: 'Zinc-HTTP-SvenVanCaekenberghe.319';
			package: 'Zinc-Tests' with: 'Zinc-Tests-SvenVanCaekenberghe.163';
			package: 'Zinc-AWS' with: 'Zinc-AWS-SvenVanCaekenberghe.16';
			package: 'Zinc-REST' with: 'Zinc-REST-SvenVanCaekenberghe.8';
			package: 'Zinc-WebDAV' with: 'Zinc-WebDAV-SvenVanCaekenberghe.3';
			package: 'Zinc-WebSocket-Core' with: 'Zinc-WebSocket-Core-SvenVanCaekenberghe.23';
			package: 'Zinc-WebSocket-Tests' with: 'Zinc-WebSocket-Tests-SvenVanCaekenberghe.7';
			package: 'Zinc-WWS-Client' with: 'Zinc-WWS-Client-SvenVanCaekenberghe.2';
			package: 'Zinc-WWS-Server' with: 'Zinc-WWS-Server-SvenVanCaekenberghe.8';
			package: 'Zinc-Zodiac' with: 'Zinc-Zodiac-SvenVanCaekenberghe.21';
			package: 'Zinc-Patch-HTTPSocket' with: 'Zinc-Patch-HTTPSocket-SvenVanCaekenberghe.1';
			package: 'Zodiac-Core' with: 'Zodiac-Core-SvenVanCaekenberghe.27';
			package: 'Zodiac-Tests' with: 'Zodiac-Tests-SvenVanCaekenberghe.10' ].
	spec for: #'pharo1.x' do: [ 
		spec 
			package: 'Zinc-FileSystem-Legacy' with: 'Zinc-FileSystem-Legacy-SvenVanCaekenberghe.3';
			package: 'Zinc-Pharo-Forward-Compatibility' with: 'Zinc-Pharo-Forward-Compatibility-SvenVanCaekenberghe.1' ].
	spec for: #'pharo2.x' do: [ 
		spec package: 'Zinc-FileSystem' with: 'Zinc-FileSystem-SvenVanCaekenberghe.7' ].
	spec for: #gemstone do: [ 
		spec blessing: #release.
		spec
			package: 'Zinc-GemstonePreliminary' with: 'Zinc-GemstonePreliminary-PaulDeBruicker.2';
			package: 'Zinc-Gemstone' with: 'Zinc-Gemstone-PaulDeBruicker.14';
			package: 'SocketStream' with: 'SocketStream-PaulDeBruicker.12' ]

]

{ #category : 'versions' }
ConfigurationOfZincHTTPComponents >> version211: spec [
	<version: '2.1.1' imports: #('2.1-baseline')>
	spec for: #common do: [ 
		spec 
			blessing: #release;
			description: 'Update to latest package versions';
			author: 'SvenVanCaekenberghe';
			package: 'Zinc-Character-Encoding-Core' with: 'Zinc-Character-Encoding-Core-SvenVanCaekenberghe.2';
			package: 'Zinc-Character-Encoding-Tests' with: 'Zinc-Character-Encoding-Tests-SvenVanCaekenberghe.2';
			package: 'Zinc-Resource-Meta-Core' with: 'Zinc-Resource-Meta-Core-SvenVanCaekenberghe.3';
			package: 'Zinc-Resource-Meta-Tests' with: 'Zinc-Resource-Meta-Tests-SvenVanCaekenberghe.3';
			package: 'Zinc-HTTP' with: 'Zinc-HTTP-SvenVanCaekenberghe.331';
			package: 'Zinc-Tests' with: 'Zinc-Tests-SvenVanCaekenberghe.170';
			package: 'Zinc-AWS' with: 'Zinc-AWS-SvenVanCaekenberghe.16';
			package: 'Zinc-REST' with: 'Zinc-REST-SvenVanCaekenberghe.8';
			package: 'Zinc-WebDAV' with: 'Zinc-WebDAV-SvenVanCaekenberghe.3';
			package: 'Zinc-WebSocket-Core' with: 'Zinc-WebSocket-Core-SvenVanCaekenberghe.23';
			package: 'Zinc-WebSocket-Tests' with: 'Zinc-WebSocket-Tests-SvenVanCaekenberghe.7';
			package: 'Zinc-WWS-Client' with: 'Zinc-WWS-Client-SvenVanCaekenberghe.2';
			package: 'Zinc-WWS-Server' with: 'Zinc-WWS-Server-SvenVanCaekenberghe.8';
			package: 'Zinc-Zodiac' with: 'Zinc-Zodiac-SvenVanCaekenberghe.23';
			package: 'Zodiac-Core' with: 'Zodiac-Core-SvenVanCaekenberghe.27';
			package: 'Zodiac-Tests' with: 'Zodiac-Tests-SvenVanCaekenberghe.10' ].
	spec for: #'pharo1.x' do: [ 
		spec 
			package: 'Zinc-Patch-HTTPSocket' with: 'Zinc-Patch-HTTPSocket-SvenVanCaekenberghe.1';
			package: 'Zinc-FileSystem-Legacy' with: 'Zinc-FileSystem-Legacy-SvenVanCaekenberghe.3';
			package: 'Zinc-Pharo-Forward-Compatibility' with: 'Zinc-Pharo-Forward-Compatibility-SvenVanCaekenberghe.1' ].
	spec for: #'pharo2.x' do: [ 
		spec 
			package: 'Zinc-Patch-HTTPSocket' with: 'Zinc-Patch-HTTPSocket-MarcusDenker.4';
			package: 'Zinc-FileSystem' with: 'Zinc-FileSystem-SvenVanCaekenberghe.7' ].
	spec for: #gemstone do: [ 
		spec blessing: #release.
		spec
			package: 'Zinc-GemstonePreliminary' with: 'Zinc-GemstonePreliminary-PaulDeBruicker.2';
			package: 'Zinc-Gemstone' with: 'Zinc-Gemstone-PaulDeBruicker.14';
			package: 'SocketStream' with: 'SocketStream-PaulDeBruicker.12' ]

]

{ #category : 'versions' }
ConfigurationOfZincHTTPComponents >> version212: spec [
	<version: '2.1.2' imports: #('2.1-baseline')>
	spec for: #common do: [ 
		spec 
			blessing: #release;
			description: 'Update to latest package versions';
			author: 'SvenVanCaekenberghe';
			package: 'Zinc-Character-Encoding-Core' with: 'Zinc-Character-Encoding-Core-SvenVanCaekenberghe.2';
			package: 'Zinc-Character-Encoding-Tests' with: 'Zinc-Character-Encoding-Tests-SvenVanCaekenberghe.2';
			package: 'Zinc-Resource-Meta-Core' with: 'Zinc-Resource-Meta-Core-SvenVanCaekenberghe.3';
			package: 'Zinc-Resource-Meta-Tests' with: 'Zinc-Resource-Meta-Tests-SvenVanCaekenberghe.3';
			package: 'Zinc-HTTP' with: 'Zinc-HTTP-SvenVanCaekenberghe.333';
			package: 'Zinc-Tests' with: 'Zinc-Tests-SvenVanCaekenberghe.172';
			package: 'Zinc-AWS' with: 'Zinc-AWS-SvenVanCaekenberghe.16';
			package: 'Zinc-REST' with: 'Zinc-REST-SvenVanCaekenberghe.8';
			package: 'Zinc-WebDAV' with: 'Zinc-WebDAV-SvenVanCaekenberghe.3';
			package: 'Zinc-WebSocket-Core' with: 'Zinc-WebSocket-Core-SvenVanCaekenberghe.23';
			package: 'Zinc-WebSocket-Tests' with: 'Zinc-WebSocket-Tests-SvenVanCaekenberghe.7';
			package: 'Zinc-WWS-Client' with: 'Zinc-WWS-Client-SvenVanCaekenberghe.2';
			package: 'Zinc-WWS-Server' with: 'Zinc-WWS-Server-SvenVanCaekenberghe.8';
			package: 'Zinc-Zodiac' with: 'Zinc-Zodiac-SvenVanCaekenberghe.23';
			package: 'Zodiac-Core' with: 'Zodiac-Core-SvenVanCaekenberghe.27';
			package: 'Zodiac-Tests' with: 'Zodiac-Tests-SvenVanCaekenberghe.10' ].
	spec for: #'pharo1.x' do: [ 
		spec 
			package: 'Zinc-Patch-HTTPSocket' with: 'Zinc-Patch-HTTPSocket-SvenVanCaekenberghe.1';
			package: 'Zinc-FileSystem-Legacy' with: 'Zinc-FileSystem-Legacy-SvenVanCaekenberghe.3';
			package: 'Zinc-Pharo-Forward-Compatibility' with: 'Zinc-Pharo-Forward-Compatibility-SvenVanCaekenberghe.1' ].
	spec for: #'pharo2.x' do: [ 
		spec 
			package: 'Zinc-Patch-HTTPSocket' with: 'Zinc-Patch-HTTPSocket-MarcusDenker.4';
			package: 'Zinc-FileSystem' with: 'Zinc-FileSystem-SvenVanCaekenberghe.7' ].
	spec for: #gemstone do: [ 
		spec blessing: #release.
		spec
			package: 'Zinc-GemstonePreliminary' with: 'Zinc-GemstonePreliminary-PaulDeBruicker.2';
			package: 'Zinc-Gemstone' with: 'Zinc-Gemstone-PaulDeBruicker.14';
			package: 'SocketStream' with: 'SocketStream-PaulDeBruicker.12' ]

]

{ #category : 'versions' }
ConfigurationOfZincHTTPComponents >> version213: spec [
	<version: '2.1.3' imports: #('2.1-baseline')>
	spec for: #common do: [ 
		spec 
			blessing: #release;
			description: 'Update to latest package versions';
			author: 'SvenVanCaekenberghe';
			package: 'Zinc-Character-Encoding-Core' with: 'Zinc-Character-Encoding-Core-SvenVanCaekenberghe.2';
			package: 'Zinc-Character-Encoding-Tests' with: 'Zinc-Character-Encoding-Tests-SvenVanCaekenberghe.2';
			package: 'Zinc-Resource-Meta-Core' with: 'Zinc-Resource-Meta-Core-SvenVanCaekenberghe.5';
			package: 'Zinc-Resource-Meta-Tests' with: 'Zinc-Resource-Meta-Tests-SvenVanCaekenberghe.4';
			package: 'Zinc-HTTP' with: 'Zinc-HTTP-SvenVanCaekenberghe.335';
			package: 'Zinc-Tests' with: 'Zinc-Tests-SvenVanCaekenberghe.174';
			package: 'Zinc-AWS' with: 'Zinc-AWS-SvenVanCaekenberghe.16';
			package: 'Zinc-REST' with: 'Zinc-REST-SvenVanCaekenberghe.8';
			package: 'Zinc-WebDAV' with: 'Zinc-WebDAV-SvenVanCaekenberghe.3';
			package: 'Zinc-WebSocket-Core' with: 'Zinc-WebSocket-Core-SvenVanCaekenberghe.24';
			package: 'Zinc-WebSocket-Tests' with: 'Zinc-WebSocket-Tests-SvenVanCaekenberghe.7';
			package: 'Zinc-WWS-Client' with: 'Zinc-WWS-Client-SvenVanCaekenberghe.2';
			package: 'Zinc-WWS-Server' with: 'Zinc-WWS-Server-SvenVanCaekenberghe.8';
			package: 'Zinc-Zodiac' with: 'Zinc-Zodiac-SvenVanCaekenberghe.24';
			package: 'Zodiac-Core' with: 'Zodiac-Core-SvenVanCaekenberghe.27';
			package: 'Zodiac-Tests' with: 'Zodiac-Tests-SvenVanCaekenberghe.10' ].
	spec for: #'pharo1.x' do: [ 
		spec 
			package: 'Zinc-Patch-HTTPSocket' with: 'Zinc-Patch-HTTPSocket-SvenVanCaekenberghe.1';
			package: 'Zinc-FileSystem-Legacy' with: 'Zinc-FileSystem-Legacy-SvenVanCaekenberghe.3';
			package: 'Zinc-Pharo-Forward-Compatibility' with: 'Zinc-Pharo-Forward-Compatibility-SvenVanCaekenberghe.1' ].
	spec for: #'pharo2.x' do: [ 
		spec 
			package: 'Zinc-Patch-HTTPSocket' with: 'Zinc-Patch-HTTPSocket-MarcusDenker.4';
			package: 'Zinc-FileSystem' with: 'Zinc-FileSystem-SvenVanCaekenberghe.7' ].
	spec for: #gemstone do: [ 
		spec blessing: #release.
		spec
			package: 'Zinc-GemstonePreliminary' with: 'Zinc-GemstonePreliminary-PaulDeBruicker.2';
			package: 'Zinc-Gemstone' with: 'Zinc-Gemstone-PaulDeBruicker.14';
			package: 'SocketStream' with: 'SocketStream-PaulDeBruicker.12' ]

]

{ #category : 'versions' }
ConfigurationOfZincHTTPComponents >> version21: spec [
	<version: '2.1' imports: #('2.1-baseline')>
	spec for: #common do: [ 
		spec 
			blessing: #release;
			description: 'Update to latest package versions';
			author: 'SvenVanCaekenberghe';
			package: 'Zinc-Character-Encoding-Core' with: 'Zinc-Character-Encoding-Core-SvenVanCaekenberghe.2';
			package: 'Zinc-Character-Encoding-Tests' with: 'Zinc-Character-Encoding-Tests-SvenVanCaekenberghe.2';
			package: 'Zinc-Resource-Meta-Core' with: 'Zinc-Resource-Meta-Core-SvenVanCaekenberghe.3';
			package: 'Zinc-Resource-Meta-Tests' with: 'Zinc-Resource-Meta-Tests-SvenVanCaekenberghe.3';
			package: 'Zinc-HTTP' with: 'Zinc-HTTP-SvenVanCaekenberghe.328';
			package: 'Zinc-Tests' with: 'Zinc-Tests-SvenVanCaekenberghe.169';
			package: 'Zinc-AWS' with: 'Zinc-AWS-SvenVanCaekenberghe.16';
			package: 'Zinc-REST' with: 'Zinc-REST-SvenVanCaekenberghe.8';
			package: 'Zinc-WebDAV' with: 'Zinc-WebDAV-SvenVanCaekenberghe.3';
			package: 'Zinc-WebSocket-Core' with: 'Zinc-WebSocket-Core-SvenVanCaekenberghe.23';
			package: 'Zinc-WebSocket-Tests' with: 'Zinc-WebSocket-Tests-SvenVanCaekenberghe.7';
			package: 'Zinc-WWS-Client' with: 'Zinc-WWS-Client-SvenVanCaekenberghe.2';
			package: 'Zinc-WWS-Server' with: 'Zinc-WWS-Server-SvenVanCaekenberghe.8';
			package: 'Zinc-Zodiac' with: 'Zinc-Zodiac-SvenVanCaekenberghe.23';
			package: 'Zinc-Patch-HTTPSocket' with: 'Zinc-Patch-HTTPSocket-SvenVanCaekenberghe.1';
			package: 'Zodiac-Core' with: 'Zodiac-Core-SvenVanCaekenberghe.27';
			package: 'Zodiac-Tests' with: 'Zodiac-Tests-SvenVanCaekenberghe.10' ].
	spec for: #'pharo1.x' do: [ 
		spec 
			package: 'Zinc-FileSystem-Legacy' with: 'Zinc-FileSystem-Legacy-SvenVanCaekenberghe.3';
			package: 'Zinc-Pharo-Forward-Compatibility' with: 'Zinc-Pharo-Forward-Compatibility-SvenVanCaekenberghe.1' ].
	spec for: #'pharo2.x' do: [ 
		spec package: 'Zinc-FileSystem' with: 'Zinc-FileSystem-SvenVanCaekenberghe.7' ].
	spec for: #gemstone do: [ 
		spec blessing: #release.
		spec
			package: 'Zinc-GemstonePreliminary' with: 'Zinc-GemstonePreliminary-PaulDeBruicker.2';
			package: 'Zinc-Gemstone' with: 'Zinc-Gemstone-PaulDeBruicker.14';
			package: 'SocketStream' with: 'SocketStream-PaulDeBruicker.12' ]

]

{ #category : 'versions' }
ConfigurationOfZincHTTPComponents >> version22: spec [
	<version: '2.2' imports: #('2.2-baseline')>
	spec for: #common do: [ 
		spec 
			blessing: #release;
			description: 'Update to latest package versions';
			author: 'SvenVanCaekenberghe';
			package: 'Zinc-Character-Encoding-Core' with: 'Zinc-Character-Encoding-Core-SvenVanCaekenberghe.2';
			package: 'Zinc-Character-Encoding-Tests' with: 'Zinc-Character-Encoding-Tests-SvenVanCaekenberghe.2';
			package: 'Zinc-Resource-Meta-Core' with: 'Zinc-Resource-Meta-Core-SvenVanCaekenberghe.5';
			package: 'Zinc-Resource-Meta-Tests' with: 'Zinc-Resource-Meta-Tests-SvenVanCaekenberghe.4';
			package: 'Zinc-HTTP' with: 'Zinc-HTTP-SvenVanCaekenberghe.335';
			package: 'Zinc-Tests' with: 'Zinc-Tests-SvenVanCaekenberghe.174';
			package: 'Zinc-AWS' with: 'Zinc-AWS-SvenVanCaekenberghe.16';
			package: 'Zinc-REST' with: 'Zinc-REST-SvenVanCaekenberghe.9';
			package: 'Zinc-WebDAV' with: 'Zinc-WebDAV-SvenVanCaekenberghe.3';
			package: 'Zinc-WebSocket-Core' with: 'Zinc-WebSocket-Core-SvenVanCaekenberghe.24';
			package: 'Zinc-WebSocket-Tests' with: 'Zinc-WebSocket-Tests-SvenVanCaekenberghe.7';
			package: 'Zinc-SSO-OAuth1-Core' with: 'Zinc-SSO-OAuth1-Core-JanVanDeSandt.8';
			package: 'Zinc-SSO-OAuth2-Core' with: 'Zinc-SSO-OAuth2-Core-JanVanDeSandt.13';
			package: 'Zinc-SSO-OpenID-Core' with: 'Zinc-SSO-OpenID-Core-JanVanDeSandt.5';
			package: 'Zinc-SSO-Demo' with: 'Zinc-SSO-Demo-JanVanDeSandt.1';
			package: 'Zinc-SSO-OAuth1-Tests' with: 'Zinc-SSO-OAuth1-Tests-SvenVanCaekenberghe.2';
			package: 'Zinc-SSO-OpenID-Tests' with: 'Zinc-SSO-OpenID-Tests-JanVanDeSandt.2';
			package: 'Zinc-WWS-Client' with: 'Zinc-WWS-Client-SvenVanCaekenberghe.2';
			package: 'Zinc-WWS-Server' with: 'Zinc-WWS-Server-SvenVanCaekenberghe.8';
			package: 'Zinc-Zodiac' with: 'Zinc-Zodiac-SvenVanCaekenberghe.24';
			package: 'Zodiac-Core' with: 'Zodiac-Core-SvenVanCaekenberghe.27';
			package: 'Zodiac-Tests' with: 'Zodiac-Tests-SvenVanCaekenberghe.10' ].
	spec for: #'pharo1.x' do: [ 
		spec 
			package: 'Zinc-Patch-HTTPSocket' with: 'Zinc-Patch-HTTPSocket-SvenVanCaekenberghe.1';
			package: 'Zinc-FileSystem-Legacy' with: 'Zinc-FileSystem-Legacy-SvenVanCaekenberghe.3';
			package: 'Zinc-Pharo-Forward-Compatibility' with: 'Zinc-Pharo-Forward-Compatibility-SvenVanCaekenberghe.1' ].
	spec for: #'pharo2.x' do: [ 
		spec 
			package: 'Zinc-Patch-HTTPSocket' with: 'Zinc-Patch-HTTPSocket-MarcusDenker.4';
			package: 'Zinc-FileSystem' with: 'Zinc-FileSystem-SvenVanCaekenberghe.7' ].
	spec for: #gemstone do: [ 
		spec blessing: #release.
		spec
			package: 'Zinc-GemstonePreliminary' with: 'Zinc-GemstonePreliminary-PaulDeBruicker.2';
			package: 'Zinc-Gemstone' with: 'Zinc-Gemstone-PaulDeBruicker.14';
			package: 'SocketStream' with: 'SocketStream-PaulDeBruicker.12' ]

]

{ #category : 'versions' }
ConfigurationOfZincHTTPComponents >> version231: spec [
	<version: '2.3.1' imports: #('2.3-baseline')>
	spec for: #common do: [ 
		spec 
			blessing: #release;
			description: 'Update to latest package versions';
			author: 'SvenVanCaekenberghe';
			package: 'Zinc-Character-Encoding-Core' with: 'Zinc-Character-Encoding-Core-SvenVanCaekenberghe.5';
			package: 'Zinc-Character-Encoding-Tests' with: 'Zinc-Character-Encoding-Tests-SvenVanCaekenberghe.3';
			package: 'Zinc-Resource-Meta-Core' with: 'Zinc-Resource-Meta-Core-SvenVanCaekenberghe.9';
			package: 'Zinc-Resource-Meta-Tests' with: 'Zinc-Resource-Meta-Tests-SvenVanCaekenberghe.6';
			package: 'Zinc-HTTP' with: 'Zinc-HTTP-SvenVanCaekenberghe.342';
			package: 'Zinc-Tests' with: 'Zinc-Tests-SvenVanCaekenberghe.176';
			package: 'Zinc-AWS' with: 'Zinc-AWS-SvenVanCaekenberghe.16';
			package: 'Zinc-REST' with: 'Zinc-REST-SvenVanCaekenberghe.10';
			package: 'Zinc-WebDAV' with: 'Zinc-WebDAV-SvenVanCaekenberghe.3';
			package: 'Zinc-WebSocket-Core' with: 'Zinc-WebSocket-Core-SvenVanCaekenberghe.25';
			package: 'Zinc-WebSocket-Tests' with: 'Zinc-WebSocket-Tests-SvenVanCaekenberghe.7';
			package: 'Zinc-SSO-OAuth1-Core' with: 'Zinc-SSO-OAuth1-Core-SvenVanCaekenberghe.12';
			package: 'Zinc-SSO-OAuth2-Core' with: 'Zinc-SSO-OAuth2-Core-JanVanDeSandt.13';
			package: 'Zinc-SSO-OpenID-Core' with: 'Zinc-SSO-OpenID-Core-JanVanDeSandt.6';
			package: 'Zinc-SSO-Demo' with: 'Zinc-SSO-Demo-SvenVanCaekenberghe.4';
			package: 'Zinc-SSO-OAuth1-Tests' with: 'Zinc-SSO-OAuth1-Tests-SvenVanCaekenberghe.2';
			package: 'Zinc-SSO-OpenID-Tests' with: 'Zinc-SSO-OpenID-Tests-JanVanDeSandt.3';
			package: 'Zinc-WWS-Client' with: 'Zinc-WWS-Client-SvenVanCaekenberghe.2';
			package: 'Zinc-WWS-Server' with: 'Zinc-WWS-Server-SvenVanCaekenberghe.8';
			package: 'Zinc-Zodiac' with: 'Zinc-Zodiac-SvenVanCaekenberghe.24';
			package: 'Zodiac-Core' with: 'Zodiac-Core-SvenVanCaekenberghe.27';
			package: 'Zodiac-Tests' with: 'Zodiac-Tests-SvenVanCaekenberghe.10' ].
	spec for: #'pharo1.x' do: [ 
		spec 
			package: 'Zinc-Patch-HTTPSocket' with: 'Zinc-Patch-HTTPSocket-SvenVanCaekenberghe.1';
			package: 'Zinc-FileSystem-Legacy' with: 'Zinc-FileSystem-Legacy-SvenVanCaekenberghe.5';
			package: 'Zinc-Pharo-Forward-Compatibility' with: 'Zinc-Pharo-Forward-Compatibility-SvenVanCaekenberghe.1' ].
	spec for: #'pharo2.x' do: [ 
		spec 
			package: 'Zinc-Patch-HTTPSocket' with: 'Zinc-Patch-HTTPSocket-MarcusDenker.4';
			package: 'Zinc-FileSystem' with: 'Zinc-FileSystem-SvenVanCaekenberghe.9' ].
	spec for: #gemstone do: [ 
		spec blessing: #release.
		spec
			package: 'Zinc-GemstonePreliminary' with: 'Zinc-GemstonePreliminary-PaulDeBruicker.2';
			package: 'Zinc-Gemstone' with: 'Zinc-Gemstone-PaulDeBruicker.14';
			package: 'SocketStream' with: 'SocketStream-PaulDeBruicker.12' ]

]

{ #category : 'versions' }
ConfigurationOfZincHTTPComponents >> version232: spec [
	<version: '2.3.2' imports: #('2.3-baseline')>
	spec for: #common do: [ 
		spec 
			blessing: #release;
			description: 'Update to latest package versions';
			author: 'SvenVanCaekenberghe';
			package: 'Zinc-Character-Encoding-Core' with: 'Zinc-Character-Encoding-Core-SvenVanCaekenberghe.5';
			package: 'Zinc-Character-Encoding-Tests' with: 'Zinc-Character-Encoding-Tests-SvenVanCaekenberghe.3';
			package: 'Zinc-Resource-Meta-Core' with: 'Zinc-Resource-Meta-Core-SvenVanCaekenberghe.9';
			package: 'Zinc-Resource-Meta-Tests' with: 'Zinc-Resource-Meta-Tests-SvenVanCaekenberghe.6';
			package: 'Zinc-HTTP' with: 'Zinc-HTTP-SvenVanCaekenberghe.343';
			package: 'Zinc-Tests' with: 'Zinc-Tests-SvenVanCaekenberghe.176';
			package: 'Zinc-AWS' with: 'Zinc-AWS-SvenVanCaekenberghe.16';
			package: 'Zinc-REST' with: 'Zinc-REST-SvenVanCaekenberghe.10';
			package: 'Zinc-WebDAV' with: 'Zinc-WebDAV-SvenVanCaekenberghe.3';
			package: 'Zinc-WebSocket-Core' with: 'Zinc-WebSocket-Core-SvenVanCaekenberghe.25';
			package: 'Zinc-WebSocket-Tests' with: 'Zinc-WebSocket-Tests-SvenVanCaekenberghe.7';
			package: 'Zinc-SSO-OAuth1-Core' with: 'Zinc-SSO-OAuth1-Core-SvenVanCaekenberghe.12';
			package: 'Zinc-SSO-OAuth2-Core' with: 'Zinc-SSO-OAuth2-Core-JanVanDeSandt.13';
			package: 'Zinc-SSO-OpenID-Core' with: 'Zinc-SSO-OpenID-Core-JanVanDeSandt.6';
			package: 'Zinc-SSO-Demo' with: 'Zinc-SSO-Demo-SvenVanCaekenberghe.4';
			package: 'Zinc-SSO-OAuth1-Tests' with: 'Zinc-SSO-OAuth1-Tests-SvenVanCaekenberghe.2';
			package: 'Zinc-SSO-OpenID-Tests' with: 'Zinc-SSO-OpenID-Tests-JanVanDeSandt.3';
			package: 'Zinc-WWS-Client' with: 'Zinc-WWS-Client-SvenVanCaekenberghe.2';
			package: 'Zinc-WWS-Server' with: 'Zinc-WWS-Server-SvenVanCaekenberghe.8';
			package: 'Zinc-Zodiac' with: 'Zinc-Zodiac-SvenVanCaekenberghe.24';
			package: 'Zodiac-Core' with: 'Zodiac-Core-SvenVanCaekenberghe.27';
			package: 'Zodiac-Tests' with: 'Zodiac-Tests-SvenVanCaekenberghe.10' ].
	spec for: #'pharo1.x' do: [ 
		spec 
			package: 'Zinc-Patch-HTTPSocket' with: 'Zinc-Patch-HTTPSocket-SvenVanCaekenberghe.1';
			package: 'Zinc-FileSystem-Legacy' with: 'Zinc-FileSystem-Legacy-SvenVanCaekenberghe.5';
			package: 'Zinc-Pharo-Forward-Compatibility' with: 'Zinc-Pharo-Forward-Compatibility-SvenVanCaekenberghe.1' ].
	spec for: #'pharo2.x' do: [ 
		spec 
			package: 'Zinc-Patch-HTTPSocket' with: 'Zinc-Patch-HTTPSocket-MarcusDenker.4';
			package: 'Zinc-FileSystem' with: 'Zinc-FileSystem-SvenVanCaekenberghe.9' ].
	spec for: #gemstone do: [ 
		spec blessing: #release.
		spec
			package: 'Zinc-GemstonePreliminary' with: 'Zinc-GemstonePreliminary-PaulDeBruicker.2';
			package: 'Zinc-Gemstone' with: 'Zinc-Gemstone-PaulDeBruicker.14';
			package: 'SocketStream' with: 'SocketStream-PaulDeBruicker.12' ]

]

{ #category : 'versions' }
ConfigurationOfZincHTTPComponents >> version233: spec [
	<version: '2.3.3' imports: #('2.3-baseline')>
	spec for: #common do: [ 
		spec 
			blessing: #release;
			description: 'Update to latest package versions';
			author: 'SvenVanCaekenberghe';
			package: 'Zinc-Character-Encoding-Core' with: 'Zinc-Character-Encoding-Core-SvenVanCaekenberghe.5';
			package: 'Zinc-Character-Encoding-Tests' with: 'Zinc-Character-Encoding-Tests-SvenVanCaekenberghe.3';
			package: 'Zinc-Resource-Meta-Core' with: 'Zinc-Resource-Meta-Core-SvenVanCaekenberghe.10';
			package: 'Zinc-Resource-Meta-Tests' with: 'Zinc-Resource-Meta-Tests-SvenVanCaekenberghe.7';
			package: 'Zinc-HTTP' with: 'Zinc-HTTP-SvenVanCaekenberghe.345';
			package: 'Zinc-Tests' with: 'Zinc-Tests-SvenVanCaekenberghe.176';
			package: 'Zinc-AWS' with: 'Zinc-AWS-SvenVanCaekenberghe.16';
			package: 'Zinc-REST' with: 'Zinc-REST-SvenVanCaekenberghe.10';
			package: 'Zinc-WebDAV' with: 'Zinc-WebDAV-SvenVanCaekenberghe.3';
			package: 'Zinc-WebSocket-Core' with: 'Zinc-WebSocket-Core-SvenVanCaekenberghe.25';
			package: 'Zinc-WebSocket-Tests' with: 'Zinc-WebSocket-Tests-SvenVanCaekenberghe.7';
			package: 'Zinc-SSO-OAuth1-Core' with: 'Zinc-SSO-OAuth1-Core-SvenVanCaekenberghe.12';
			package: 'Zinc-SSO-OAuth2-Core' with: 'Zinc-SSO-OAuth2-Core-JanVanDeSandt.13';
			package: 'Zinc-SSO-OpenID-Core' with: 'Zinc-SSO-OpenID-Core-JanVanDeSandt.6';
			package: 'Zinc-SSO-Demo' with: 'Zinc-SSO-Demo-SvenVanCaekenberghe.4';
			package: 'Zinc-SSO-OAuth1-Tests' with: 'Zinc-SSO-OAuth1-Tests-SvenVanCaekenberghe.2';
			package: 'Zinc-SSO-OpenID-Tests' with: 'Zinc-SSO-OpenID-Tests-JanVanDeSandt.3';
			package: 'Zinc-WWS-Client' with: 'Zinc-WWS-Client-SvenVanCaekenberghe.2';
			package: 'Zinc-WWS-Server' with: 'Zinc-WWS-Server-SvenVanCaekenberghe.8';
			package: 'Zinc-Zodiac' with: 'Zinc-Zodiac-SvenVanCaekenberghe.25';
			package: 'Zodiac-Core' with: 'Zodiac-Core-SvenVanCaekenberghe.27';
			package: 'Zodiac-Tests' with: 'Zodiac-Tests-SvenVanCaekenberghe.10' ].
	spec for: #'pharo1.x' do: [ 
		spec 
			package: 'Zinc-Patch-HTTPSocket' with: 'Zinc-Patch-HTTPSocket-SvenVanCaekenberghe.1';
			package: 'Zinc-FileSystem-Legacy' with: 'Zinc-FileSystem-Legacy-SvenVanCaekenberghe.5';
			package: 'Zinc-Pharo-Forward-Compatibility' with: 'Zinc-Pharo-Forward-Compatibility-SvenVanCaekenberghe.1' ].
	spec for: #'pharo2.x' do: [ 
		spec 
			package: 'Zinc-Patch-HTTPSocket' with: 'Zinc-Patch-HTTPSocket-MarcusDenker.4';
			package: 'Zinc-FileSystem' with: 'Zinc-FileSystem-SvenVanCaekenberghe.9' ].
	spec for: #gemstone do: [ 
		spec blessing: #release.
		spec
			package: 'Zinc-GemstonePreliminary' with: 'Zinc-GemstonePreliminary-PaulDeBruicker.2';
			package: 'Zinc-Gemstone' with: 'Zinc-Gemstone-PaulDeBruicker.14';
			package: 'SocketStream' with: 'SocketStream-PaulDeBruicker.12' ]

]

{ #category : 'versions' }
ConfigurationOfZincHTTPComponents >> version234: spec [
	<version: '2.3.4' imports: #('2.3-baseline')>
	spec for: #common do: [ 
		spec 
			blessing: #release;
			description: 'Update to latest package versions';
			author: 'SvenVanCaekenberghe';
			package: 'Zinc-Character-Encoding-Core' with: 'Zinc-Character-Encoding-Core-SvenVanCaekenberghe.6';
			package: 'Zinc-Character-Encoding-Tests' with: 'Zinc-Character-Encoding-Tests-SvenVanCaekenberghe.4';
			package: 'Zinc-Resource-Meta-Core' with: 'Zinc-Resource-Meta-Core-SvenVanCaekenberghe.10';
			package: 'Zinc-Resource-Meta-Tests' with: 'Zinc-Resource-Meta-Tests-SvenVanCaekenberghe.7';
			package: 'Zinc-HTTP' with: 'Zinc-HTTP-SvenVanCaekenberghe.346';
			package: 'Zinc-Tests' with: 'Zinc-Tests-SvenVanCaekenberghe.177';
			package: 'Zinc-AWS' with: 'Zinc-AWS-SvenVanCaekenberghe.17';
			package: 'Zinc-REST' with: 'Zinc-REST-SvenVanCaekenberghe.10';
			package: 'Zinc-WebDAV' with: 'Zinc-WebDAV-SvenVanCaekenberghe.3';
			package: 'Zinc-WebSocket-Core' with: 'Zinc-WebSocket-Core-SvenVanCaekenberghe.25';
			package: 'Zinc-WebSocket-Tests' with: 'Zinc-WebSocket-Tests-SvenVanCaekenberghe.7';
			package: 'Zinc-SSO-OAuth1-Core' with: 'Zinc-SSO-OAuth1-Core-SvenVanCaekenberghe.12';
			package: 'Zinc-SSO-OAuth2-Core' with: 'Zinc-SSO-OAuth2-Core-JanVanDeSandt.13';
			package: 'Zinc-SSO-OpenID-Core' with: 'Zinc-SSO-OpenID-Core-JanVanDeSandt.6';
			package: 'Zinc-SSO-Demo' with: 'Zinc-SSO-Demo-SvenVanCaekenberghe.4';
			package: 'Zinc-SSO-OAuth1-Tests' with: 'Zinc-SSO-OAuth1-Tests-SvenVanCaekenberghe.2';
			package: 'Zinc-SSO-OpenID-Tests' with: 'Zinc-SSO-OpenID-Tests-JanVanDeSandt.3';
			package: 'Zinc-WWS-Client' with: 'Zinc-WWS-Client-SvenVanCaekenberghe.2';
			package: 'Zinc-WWS-Server' with: 'Zinc-WWS-Server-SvenVanCaekenberghe.9';
			package: 'Zinc-Zodiac' with: 'Zinc-Zodiac-SvenVanCaekenberghe.25';
			package: 'Zodiac-Core' with: 'Zodiac-Core-SvenVanCaekenberghe.27';
			package: 'Zodiac-Tests' with: 'Zodiac-Tests-SvenVanCaekenberghe.10' ].
	spec for: #'pharo1.x' do: [ 
		spec 
			package: 'Zinc-Patch-HTTPSocket' with: 'Zinc-Patch-HTTPSocket-SvenVanCaekenberghe.1';
			package: 'Zinc-FileSystem-Legacy' with: 'Zinc-FileSystem-Legacy-SvenVanCaekenberghe.5';
			package: 'Zinc-Pharo-Forward-Compatibility' with: 'Zinc-Pharo-Forward-Compatibility-SvenVanCaekenberghe.1' ].
	spec for: #'pharo2.x' do: [ 
		spec 
			package: 'Zinc-Patch-HTTPSocket' with: 'Zinc-Patch-HTTPSocket-MarcusDenker.4';
			package: 'Zinc-FileSystem' with: 'Zinc-FileSystem-SvenVanCaekenberghe.9' ].
	spec for: #gemstone do: [ 
		spec blessing: #release.
		spec
			package: 'Zinc-GemstonePreliminary' with: 'Zinc-GemstonePreliminary-PaulDeBruicker.2';
			package: 'Zinc-Gemstone' with: 'Zinc-Gemstone-PaulDeBruicker.14';
			package: 'SocketStream' with: 'SocketStream-PaulDeBruicker.12' ]

]

{ #category : 'versions' }
ConfigurationOfZincHTTPComponents >> version23: spec [
	<version: '2.3' imports: #('2.3-baseline')>
	spec for: #common do: [ 
		spec 
			blessing: #release;
			description: 'Update to latest package versions';
			author: 'SvenVanCaekenberghe';
			package: 'Zinc-Character-Encoding-Core' with: 'Zinc-Character-Encoding-Core-SvenVanCaekenberghe.5';
			package: 'Zinc-Character-Encoding-Tests' with: 'Zinc-Character-Encoding-Tests-SvenVanCaekenberghe.3';
			package: 'Zinc-Resource-Meta-Core' with: 'Zinc-Resource-Meta-Core-SvenVanCaekenberghe.8';
			package: 'Zinc-Resource-Meta-Tests' with: 'Zinc-Resource-Meta-Tests-SvenVanCaekenberghe.5';
			package: 'Zinc-HTTP' with: 'Zinc-HTTP-SvenVanCaekenberghe.337';
			package: 'Zinc-Tests' with: 'Zinc-Tests-SvenVanCaekenberghe.174';
			package: 'Zinc-AWS' with: 'Zinc-AWS-SvenVanCaekenberghe.16';
			package: 'Zinc-REST' with: 'Zinc-REST-SvenVanCaekenberghe.10';
			package: 'Zinc-WebDAV' with: 'Zinc-WebDAV-SvenVanCaekenberghe.3';
			package: 'Zinc-WebSocket-Core' with: 'Zinc-WebSocket-Core-SvenVanCaekenberghe.25';
			package: 'Zinc-WebSocket-Tests' with: 'Zinc-WebSocket-Tests-SvenVanCaekenberghe.7';
			package: 'Zinc-SSO-OAuth1-Core' with: 'Zinc-SSO-OAuth1-Core-JanVanDeSandt.9';
			package: 'Zinc-SSO-OAuth2-Core' with: 'Zinc-SSO-OAuth2-Core-JanVanDeSandt.13';
			package: 'Zinc-SSO-OpenID-Core' with: 'Zinc-SSO-OpenID-Core-JanVanDeSandt.6';
			package: 'Zinc-SSO-Demo' with: 'Zinc-SSO-Demo-JanVanDeSandt.1';
			package: 'Zinc-SSO-OAuth1-Tests' with: 'Zinc-SSO-OAuth1-Tests-SvenVanCaekenberghe.2';
			package: 'Zinc-SSO-OpenID-Tests' with: 'Zinc-SSO-OpenID-Tests-JanVanDeSandt.3';
			package: 'Zinc-WWS-Client' with: 'Zinc-WWS-Client-SvenVanCaekenberghe.2';
			package: 'Zinc-WWS-Server' with: 'Zinc-WWS-Server-SvenVanCaekenberghe.8';
			package: 'Zinc-Zodiac' with: 'Zinc-Zodiac-SvenVanCaekenberghe.24';
			package: 'Zodiac-Core' with: 'Zodiac-Core-SvenVanCaekenberghe.27';
			package: 'Zodiac-Tests' with: 'Zodiac-Tests-SvenVanCaekenberghe.10' ].
	spec for: #'pharo1.x' do: [ 
		spec 
			package: 'Zinc-Patch-HTTPSocket' with: 'Zinc-Patch-HTTPSocket-SvenVanCaekenberghe.1';
			package: 'Zinc-FileSystem-Legacy' with: 'Zinc-FileSystem-Legacy-SvenVanCaekenberghe.3';
			package: 'Zinc-Pharo-Forward-Compatibility' with: 'Zinc-Pharo-Forward-Compatibility-SvenVanCaekenberghe.1' ].
	spec for: #'pharo2.x' do: [ 
		spec 
			package: 'Zinc-Patch-HTTPSocket' with: 'Zinc-Patch-HTTPSocket-MarcusDenker.4';
			package: 'Zinc-FileSystem' with: 'Zinc-FileSystem-SvenVanCaekenberghe.8' ].
	spec for: #gemstone do: [ 
		spec blessing: #release.
		spec
			package: 'Zinc-GemstonePreliminary' with: 'Zinc-GemstonePreliminary-PaulDeBruicker.2';
			package: 'Zinc-Gemstone' with: 'Zinc-Gemstone-PaulDeBruicker.14';
			package: 'SocketStream' with: 'SocketStream-PaulDeBruicker.12' ]

]

{ #category : 'versions' }
ConfigurationOfZincHTTPComponents >> version241: spec [
	<version: '2.4.1' imports: #('2.3-baseline')>
	spec for: #common do: [ 
		spec 
			blessing: #release;
			description: 'Update to latest package versions';
			author: 'SvenVanCaekenberghe';
			package: 'Zinc-Character-Encoding-Core' with: 'Zinc-Character-Encoding-Core-SvenVanCaekenberghe.17';
			package: 'Zinc-Character-Encoding-Tests' with: 'Zinc-Character-Encoding-Tests-SvenVanCaekenberghe.8';
			package: 'Zinc-Resource-Meta-Core' with: 'Zinc-Resource-Meta-Core-SvenVanCaekenberghe.14';
			package: 'Zinc-Resource-Meta-Tests' with: 'Zinc-Resource-Meta-Tests-SvenVanCaekenberghe.9';
			package: 'Zinc-HTTP' with: 'Zinc-HTTP-SvenVanCaekenberghe.365';
			package: 'Zinc-Tests' with: 'Zinc-Tests-SvenVanCaekenberghe.187';
			package: 'Zinc-AWS' with: 'Zinc-AWS-SvenVanCaekenberghe.17';
			package: 'Zinc-REST' with: 'Zinc-REST-SvenVanCaekenberghe.10';
			package: 'Zinc-WebDAV' with: 'Zinc-WebDAV-SvenVanCaekenberghe.3';
			package: 'Zinc-WebSocket-Core' with: 'Zinc-WebSocket-Core-SvenVanCaekenberghe.25';
			package: 'Zinc-WebSocket-Tests' with: 'Zinc-WebSocket-Tests-SvenVanCaekenberghe.7';
			package: 'Zinc-SSO-OAuth1-Core' with: 'Zinc-SSO-OAuth1-Core-SvenVanCaekenberghe.12';
			package: 'Zinc-SSO-OAuth2-Core' with: 'Zinc-SSO-OAuth2-Core-JanVanDeSandt.13';
			package: 'Zinc-SSO-OpenID-Core' with: 'Zinc-SSO-OpenID-Core-JanVanDeSandt.6';
			package: 'Zinc-SSO-Demo' with: 'Zinc-SSO-Demo-SvenVanCaekenberghe.4';
			package: 'Zinc-SSO-OAuth1-Tests' with: 'Zinc-SSO-OAuth1-Tests-SvenVanCaekenberghe.2';
			package: 'Zinc-SSO-OpenID-Tests' with: 'Zinc-SSO-OpenID-Tests-JanVanDeSandt.3';
			package: 'Zinc-WWS-Client' with: 'Zinc-WWS-Client-SvenVanCaekenberghe.2';
			package: 'Zinc-WWS-Server' with: 'Zinc-WWS-Server-SvenVanCaekenberghe.9';
			package: 'Zinc-Zodiac' with: 'Zinc-Zodiac-SvenVanCaekenberghe.27';
			package: 'Zodiac-Core' with: 'Zodiac-Core-SvenVanCaekenberghe.30';
			package: 'Zodiac-Tests' with: 'Zodiac-Tests-SvenVanCaekenberghe.12' ].
	spec for: #'pharo1.x' do: [ 
		spec 
			package: 'Zinc-Patch-HTTPSocket' with: 'Zinc-Patch-HTTPSocket-SvenVanCaekenberghe.1';
			package: 'Zinc-FileSystem-Legacy' with: 'Zinc-FileSystem-Legacy-SvenVanCaekenberghe.5';
			package: 'Zinc-Pharo-Forward-Compatibility' with: 'Zinc-Pharo-Forward-Compatibility-SvenVanCaekenberghe.1' ].
	spec for: #'pharo2.x' do: [ 
		spec 
			package: 'Zinc-Patch-HTTPSocket' with: 'Zinc-Patch-HTTPSocket-MarcusDenker.4';
			package: 'Zinc-FileSystem' with: 'Zinc-FileSystem-SvenVanCaekenberghe.9' ].
	spec for: #gemstone do: [ 
		spec blessing: #release.
		spec
			package: 'Zinc-GemstonePreliminary' with: 'Zinc-GemstonePreliminary-PaulDeBruicker.2';
			package: 'Zinc-Gemstone' with: 'Zinc-Gemstone-PaulDeBruicker.14';
			package: 'SocketStream' with: 'SocketStream-PaulDeBruicker.12' ]

]

{ #category : 'versions' }
ConfigurationOfZincHTTPComponents >> version242: spec [
	<version: '2.4.2' imports: #('2.4-baseline')>
	spec for: #common do: [ 
		spec 
			blessing: #release;
			description: 'Update to latest package versions';
			author: 'SvenVanCaekenberghe';
			package: 'Zinc-Character-Encoding-Core' with: 'Zinc-Character-Encoding-Core-SvenVanCaekenberghe.18';
			package: 'Zinc-Character-Encoding-Tests' with: 'Zinc-Character-Encoding-Tests-SvenVanCaekenberghe.9';
			package: 'Zinc-Resource-Meta-Core' with: 'Zinc-Resource-Meta-Core-SvenVanCaekenberghe.16';
			package: 'Zinc-Resource-Meta-Tests' with: 'Zinc-Resource-Meta-Tests-SvenVanCaekenberghe.10';
			package: 'Zinc-HTTP' with: 'Zinc-HTTP-SvenVanCaekenberghe.367';
			package: 'Zinc-Tests' with: 'Zinc-Tests-SvenVanCaekenberghe.188';
			package: 'Zinc-AWS' with: 'Zinc-AWS-SvenVanCaekenberghe.17';
			package: 'Zinc-REST' with: 'Zinc-REST-SvenVanCaekenberghe.10';
			package: 'Zinc-WebDAV' with: 'Zinc-WebDAV-SvenVanCaekenberghe.3';
			package: 'Zinc-WebSocket-Core' with: 'Zinc-WebSocket-Core-SvenVanCaekenberghe.25';
			package: 'Zinc-WebSocket-Tests' with: 'Zinc-WebSocket-Tests-SvenVanCaekenberghe.7';
			package: 'Zinc-SSO-OAuth1-Core' with: 'Zinc-SSO-OAuth1-Core-SvenVanCaekenberghe.13';
			package: 'Zinc-SSO-OAuth2-Core' with: 'Zinc-SSO-OAuth2-Core-JanVanDeSandt.15';
			package: 'Zinc-SSO-OpenID-Core' with: 'Zinc-SSO-OpenID-Core-JanVanDeSandt.6';
			package: 'Zinc-SSO-Demo' with: 'Zinc-SSO-Demo-SvenVanCaekenberghe.5';
			package: 'Zinc-SSO-OAuth1-Tests' with: 'Zinc-SSO-OAuth1-Tests-SvenVanCaekenberghe.2';
			package: 'Zinc-SSO-OpenID-Tests' with: 'Zinc-SSO-OpenID-Tests-JanVanDeSandt.3';
			package: 'Zinc-WWS-Client' with: 'Zinc-WWS-Client-SvenVanCaekenberghe.2';
			package: 'Zinc-WWS-Server' with: 'Zinc-WWS-Server-SvenVanCaekenberghe.9';
			package: 'Zinc-Zodiac' with: 'Zinc-Zodiac-SvenVanCaekenberghe.27';
			package: 'Zodiac-Core' with: 'Zodiac-Core-SvenVanCaekenberghe.30';
			package: 'Zodiac-Tests' with: 'Zodiac-Tests-SvenVanCaekenberghe.12';
			package: 'Zinc-Seaside' with: 'Zinc-Seaside-SvenVanCaekenberghe.40' ].
	spec for: #'pharo1.x' do: [ 
		spec 
			package: 'Zinc-Patch-HTTPSocket' with: 'Zinc-Patch-HTTPSocket-SvenVanCaekenberghe.1';
			package: 'Zinc-FileSystem-Legacy' with: 'Zinc-FileSystem-Legacy-SvenVanCaekenberghe.5';
			package: 'Zinc-Pharo-Forward-Compatibility' with: 'Zinc-Pharo-Forward-Compatibility-SvenVanCaekenberghe.1' ].
	spec for: #'pharo2.x' do: [ 
		spec 
			package: 'Zinc-Patch-HTTPSocket' with: 'Zinc-Patch-HTTPSocket-MarcusDenker.4';
			package: 'Zinc-FileSystem' with: 'Zinc-FileSystem-SvenVanCaekenberghe.9' ].
	spec for: #gemstone do: [ 
		spec blessing: #release.
		spec
			package: 'Zinc-GemstonePreliminary' with: 'Zinc-GemstonePreliminary-PaulDeBruicker.2';
			package: 'Zinc-Gemstone' with: 'Zinc-Gemstone-PaulDeBruicker.14';
			package: 'SocketStream' with: 'SocketStream-PaulDeBruicker.12' ]

]

{ #category : 'versions' }
ConfigurationOfZincHTTPComponents >> version243: spec [
  <version: '2.4.3' imports: #('2.4-baseline')>
  spec
    for: #'pharo'
    do: [ 
      spec
        blessing: #'release';
        description: 'Update to latest package versions';
        author: 'SvenVanCaekenberghe';
        package: 'Zinc-Character-Encoding-Core'
          with: 'Zinc-Character-Encoding-Core-SvenVanCaekenberghe.21';
        package: 'Zinc-Character-Encoding-Tests'
          with: 'Zinc-Character-Encoding-Tests-SvenVanCaekenberghe.12';
        package: 'Zinc-Resource-Meta-Core'
          with: 'Zinc-Resource-Meta-Core-SvenVanCaekenberghe.17';
        package: 'Zinc-Resource-Meta-Tests'
          with: 'Zinc-Resource-Meta-Tests-SvenVanCaekenberghe.10';
        package: 'Zinc-HTTP' with: 'Zinc-HTTP-SvenVanCaekenberghe.371';
        package: 'Zinc-Tests' with: 'Zinc-Tests-SvenVanCaekenberghe.190';
        package: 'Zinc-AWS' with: 'Zinc-AWS-SvenVanCaekenberghe.17';
        package: 'Zinc-REST' with: 'Zinc-REST-SvenVanCaekenberghe.11';
        package: 'Zinc-WebDAV' with: 'Zinc-WebDAV-SvenVanCaekenberghe.3';
        package: 'Zinc-WebSocket-Core'
          with: 'Zinc-WebSocket-Core-SvenVanCaekenberghe.25';
        package: 'Zinc-WebSocket-Tests'
          with: 'Zinc-WebSocket-Tests-SvenVanCaekenberghe.7';
        package: 'Zinc-SSO-OAuth1-Core'
          with: 'Zinc-SSO-OAuth1-Core-SvenVanCaekenberghe.13';
        package: 'Zinc-SSO-OAuth2-Core'
          with: 'Zinc-SSO-OAuth2-Core-JanVanDeSandt.15';
        package: 'Zinc-SSO-OpenID-Core'
          with: 'Zinc-SSO-OpenID-Core-JanVanDeSandt.6';
        package: 'Zinc-SSO-Demo' with: 'Zinc-SSO-Demo-SvenVanCaekenberghe.5';
        package: 'Zinc-SSO-OAuth1-Tests'
          with: 'Zinc-SSO-OAuth1-Tests-SvenVanCaekenberghe.2';
        package: 'Zinc-SSO-OpenID-Tests'
          with: 'Zinc-SSO-OpenID-Tests-JanVanDeSandt.3';
        package: 'Zinc-WWS-Client'
          with: 'Zinc-WWS-Client-SvenVanCaekenberghe.2';
        package: 'Zinc-WWS-Server'
          with: 'Zinc-WWS-Server-SvenVanCaekenberghe.9';
        package: 'Zinc-Zodiac' with: 'Zinc-Zodiac-SvenVanCaekenberghe.27';
        package: 'Zodiac-Core' with: 'Zodiac-Core-SvenVanCaekenberghe.30';
        package: 'Zodiac-Tests' with: 'Zodiac-Tests-SvenVanCaekenberghe.12';
        package: 'Zinc-Seaside' with: 'Zinc-Seaside-SvenVanCaekenberghe.40' ].
  spec
    for: #'pharo1.x'
    do: [ 
      spec
        package: 'Zinc-Patch-HTTPSocket'
          with: 'Zinc-Patch-HTTPSocket-SvenVanCaekenberghe.1';
        package: 'Zinc-FileSystem-Legacy'
          with: 'Zinc-FileSystem-Legacy-SvenVanCaekenberghe.5';
        package: 'Zinc-Pharo-Forward-Compatibility'
          with: 'Zinc-Pharo-Forward-Compatibility-SvenVanCaekenberghe.1' ].
  spec
    for: #'pharo2.x'
    do: [ 
      spec
        package: 'Zinc-Patch-HTTPSocket'
          with: 'Zinc-Patch-HTTPSocket-MarcusDenker.4';
        package: 'Zinc-FileSystem'
          with: 'Zinc-FileSystem-SvenVanCaekenberghe.9' ].
  spec
    for: #(#'gs2.4.x' #'gs3.1.x' #'gs3.2.x')
    do: [ 
      spec
        baseline: 'ZincHTTPComponents'
          with: [ spec repository: 'github://GsDevKit/zinc:2.4.3/repository' ];
        import: 'ZincHTTPComponents' ]
]

{ #category : 'versions' }
ConfigurationOfZincHTTPComponents >> version244: spec [
	<version: '2.4.4' imports: #('2.4-baseline')>
	spec for: #pharo do: [ 
		spec 
			blessing: #release;
			description: 'Update to latest package versions';
			author: 'SvenVanCaekenberghe';
			package: 'Zinc-Character-Encoding-Core' with: 'Zinc-Character-Encoding-Core-SvenVanCaekenberghe.21';
			package: 'Zinc-Character-Encoding-Tests' with: 'Zinc-Character-Encoding-Tests-SvenVanCaekenberghe.12';
			package: 'Zinc-Resource-Meta-Core' with: 'Zinc-Resource-Meta-Core-SvenVanCaekenberghe.17';
			package: 'Zinc-Resource-Meta-Tests' with: 'Zinc-Resource-Meta-Tests-SvenVanCaekenberghe.11';
			package: 'Zinc-HTTP' with: 'Zinc-HTTP-SvenVanCaekenberghe.375';
			package: 'Zinc-Tests' with: 'Zinc-Tests-SvenVanCaekenberghe.194';
			package: 'Zinc-AWS' with: 'Zinc-AWS-SvenVanCaekenberghe.17';
			package: 'Zinc-REST' with: 'Zinc-REST-SvenVanCaekenberghe.12';
			package: 'Zinc-WebDAV' with: 'Zinc-WebDAV-SvenVanCaekenberghe.3';
			package: 'Zinc-WebSocket-Core' with: 'Zinc-WebSocket-Core-SvenVanCaekenberghe.25';
			package: 'Zinc-WebSocket-Tests' with: 'Zinc-WebSocket-Tests-SvenVanCaekenberghe.7';
			package: 'Zinc-SSO-OAuth1-Core' with: 'Zinc-SSO-OAuth1-Core-SvenVanCaekenberghe.13';
			package: 'Zinc-SSO-OAuth2-Core' with: 'Zinc-SSO-OAuth2-Core-JanVanDeSandt.16';
			package: 'Zinc-SSO-OpenID-Core' with: 'Zinc-SSO-OpenID-Core-JanVanDeSandt.6';
			package: 'Zinc-SSO-Demo' with: 'Zinc-SSO-Demo-SvenVanCaekenberghe.5';
			package: 'Zinc-SSO-OAuth1-Tests' with: 'Zinc-SSO-OAuth1-Tests-SvenVanCaekenberghe.2';
			package: 'Zinc-SSO-OpenID-Tests' with: 'Zinc-SSO-OpenID-Tests-JanVanDeSandt.3';
			package: 'Zinc-WWS-Client' with: 'Zinc-WWS-Client-SvenVanCaekenberghe.2';
			package: 'Zinc-WWS-Server' with: 'Zinc-WWS-Server-SvenVanCaekenberghe.9';
			package: 'Zinc-Zodiac' with: 'Zinc-Zodiac-SvenVanCaekenberghe.27';
			package: 'Zodiac-Core' with: 'Zodiac-Core-SvenVanCaekenberghe.30';
			package: 'Zodiac-Tests' with: 'Zodiac-Tests-SvenVanCaekenberghe.12';
			package: 'Zinc-Seaside' with: 'Zinc-Seaside-SvenVanCaekenberghe.40' ].
	spec for: #'pharo1.x' do: [ 
		spec 
			package: 'Zinc-Patch-HTTPSocket' with: 'Zinc-Patch-HTTPSocket-SvenVanCaekenberghe.1';
			package: 'Zinc-FileSystem-Legacy' with: 'Zinc-FileSystem-Legacy-SvenVanCaekenberghe.5';
			package: 'Zinc-Pharo-Forward-Compatibility' with: 'Zinc-Pharo-Forward-Compatibility-SvenVanCaekenberghe.1' ].
	spec for: #'pharo2.x' do: [ 
		spec 
			package: 'Zinc-Patch-HTTPSocket' with: 'Zinc-Patch-HTTPSocket-MarcusDenker.4';
			package: 'Zinc-FileSystem' with: 'Zinc-FileSystem-SvenVanCaekenberghe.9' ]
]

{ #category : 'versions' }
ConfigurationOfZincHTTPComponents >> version245: spec [
	<version: '2.4.5' imports: #('2.4-baseline')>
	spec for: #pharo do: [ 
		spec 
			blessing: #release;
			description: 'Update to latest package versions';
			author: 'SvenVanCaekenberghe';
			package: 'Zinc-Character-Encoding-Core' with: 'Zinc-Character-Encoding-Core-SvenVanCaekenberghe.21';
			package: 'Zinc-Character-Encoding-Tests' with: 'Zinc-Character-Encoding-Tests-SvenVanCaekenberghe.12';
			package: 'Zinc-Resource-Meta-Core' with: 'Zinc-Resource-Meta-Core-SvenVanCaekenberghe.17';
			package: 'Zinc-Resource-Meta-Tests' with: 'Zinc-Resource-Meta-Tests-SvenVanCaekenberghe.11';
			package: 'Zinc-HTTP' with: 'Zinc-HTTP-SvenVanCaekenberghe.376';
			package: 'Zinc-Tests' with: 'Zinc-Tests-SvenVanCaekenberghe.194';
			package: 'Zinc-AWS' with: 'Zinc-AWS-SvenVanCaekenberghe.17';
			package: 'Zinc-REST' with: 'Zinc-REST-SvenVanCaekenberghe.13';
			package: 'Zinc-WebDAV' with: 'Zinc-WebDAV-SvenVanCaekenberghe.3';
			package: 'Zinc-WebSocket-Core' with: 'Zinc-WebSocket-Core-SvenVanCaekenberghe.25';
			package: 'Zinc-WebSocket-Tests' with: 'Zinc-WebSocket-Tests-SvenVanCaekenberghe.7';
			package: 'Zinc-SSO-OAuth1-Core' with: 'Zinc-SSO-OAuth1-Core-SvenVanCaekenberghe.13';
			package: 'Zinc-SSO-OAuth2-Core' with: 'Zinc-SSO-OAuth2-Core-JanVanDeSandt.16';
			package: 'Zinc-SSO-OpenID-Core' with: 'Zinc-SSO-OpenID-Core-JanVanDeSandt.6';
			package: 'Zinc-SSO-Demo' with: 'Zinc-SSO-Demo-SvenVanCaekenberghe.5';
			package: 'Zinc-SSO-OAuth1-Tests' with: 'Zinc-SSO-OAuth1-Tests-SvenVanCaekenberghe.2';
			package: 'Zinc-SSO-OpenID-Tests' with: 'Zinc-SSO-OpenID-Tests-JanVanDeSandt.3';
			package: 'Zinc-WWS-Client' with: 'Zinc-WWS-Client-SvenVanCaekenberghe.2';
			package: 'Zinc-WWS-Server' with: 'Zinc-WWS-Server-SvenVanCaekenberghe.9';
			package: 'Zinc-Zodiac' with: 'Zinc-Zodiac-SvenVanCaekenberghe.27';
			package: 'Zodiac-Core' with: 'Zodiac-Core-SvenVanCaekenberghe.30';
			package: 'Zodiac-Tests' with: 'Zodiac-Tests-SvenVanCaekenberghe.12';
			package: 'Zinc-Seaside' with: 'Zinc-Seaside-SvenVanCaekenberghe.40' ].
	spec for: #'pharo1.x' do: [ 
		spec 
			package: 'Zinc-Patch-HTTPSocket' with: 'Zinc-Patch-HTTPSocket-SvenVanCaekenberghe.1';
			package: 'Zinc-FileSystem-Legacy' with: 'Zinc-FileSystem-Legacy-SvenVanCaekenberghe.5';
			package: 'Zinc-Pharo-Forward-Compatibility' with: 'Zinc-Pharo-Forward-Compatibility-SvenVanCaekenberghe.1' ].
	spec for: #'pharo2.x' do: [ 
		spec 
			package: 'Zinc-Patch-HTTPSocket' with: 'Zinc-Patch-HTTPSocket-MarcusDenker.4';
			package: 'Zinc-FileSystem' with: 'Zinc-FileSystem-SvenVanCaekenberghe.9' ].
]

{ #category : 'versions' }
ConfigurationOfZincHTTPComponents >> version246: spec [
	<version: '2.4.6' imports: #('2.4-baseline')>
	spec for: #pharo do: [ 
		spec 
			blessing: #release;
			description: 'Update to latest package versions';
			author: 'SvenVanCaekenberghe';
			package: 'Zinc-Character-Encoding-Core' with: 'Zinc-Character-Encoding-Core-SvenVanCaekenberghe.28';
			package: 'Zinc-Character-Encoding-Tests' with: 'Zinc-Character-Encoding-Tests-SvenVanCaekenberghe.15';
			package: 'Zinc-Resource-Meta-Core' with: 'Zinc-Resource-Meta-Core-SvenVanCaekenberghe.28';
			package: 'Zinc-Resource-Meta-Tests' with: 'Zinc-Resource-Meta-Tests-SvenVanCaekenberghe.16';
			package: 'Zinc-HTTP' with: 'Zinc-HTTP-SvenVanCaekenberghe.383';
			package: 'Zinc-Tests' with: 'Zinc-Tests-SvenVanCaekenberghe.199';
			package: 'Zinc-AWS' with: 'Zinc-AWS-SvenVanCaekenberghe.17';
			package: 'Zinc-REST' with: 'Zinc-REST-SvenVanCaekenberghe.13';
			package: 'Zinc-WebDAV' with: 'Zinc-WebDAV-SvenVanCaekenberghe.3';
			package: 'Zinc-WebSocket-Core' with: 'Zinc-WebSocket-Core-SvenVanCaekenberghe.25';
			package: 'Zinc-WebSocket-Tests' with: 'Zinc-WebSocket-Tests-SvenVanCaekenberghe.7';
			package: 'Zinc-SSO-OAuth1-Core' with: 'Zinc-SSO-OAuth1-Core-SvenVanCaekenberghe.13';
			package: 'Zinc-SSO-OAuth2-Core' with: 'Zinc-SSO-OAuth2-Core-JanVanDeSandt.16';
			package: 'Zinc-SSO-OpenID-Core' with: 'Zinc-SSO-OpenID-Core-JanVanDeSandt.6';
			package: 'Zinc-SSO-Demo' with: 'Zinc-SSO-Demo-SvenVanCaekenberghe.5';
			package: 'Zinc-SSO-OAuth1-Tests' with: 'Zinc-SSO-OAuth1-Tests-SvenVanCaekenberghe.2';
			package: 'Zinc-SSO-OpenID-Tests' with: 'Zinc-SSO-OpenID-Tests-JanVanDeSandt.3';
			package: 'Zinc-WWS-Client' with: 'Zinc-WWS-Client-SvenVanCaekenberghe.2';
			package: 'Zinc-WWS-Server' with: 'Zinc-WWS-Server-SvenVanCaekenberghe.9';
			package: 'Zinc-Zodiac' with: 'Zinc-Zodiac-SvenVanCaekenberghe.27';
			package: 'Zodiac-Core' with: 'Zodiac-Core-SvenVanCaekenberghe.30';
			package: 'Zodiac-Tests' with: 'Zodiac-Tests-SvenVanCaekenberghe.12';
			package: 'Zinc-Seaside' with: 'Zinc-Seaside-SvenVanCaekenberghe.40' ].
	spec for: #'pharo1.x' do: [ 
		spec 
			package: 'Zinc-Patch-HTTPSocket' with: 'Zinc-Patch-HTTPSocket-SvenVanCaekenberghe.1';
			package: 'Zinc-FileSystem-Legacy' with: 'Zinc-FileSystem-Legacy-SvenVanCaekenberghe.5';
			package: 'Zinc-Pharo-Forward-Compatibility' with: 'Zinc-Pharo-Forward-Compatibility-SvenVanCaekenberghe.1' ].
	spec for: #'pharo2.x' do: [ 
		spec 
			package: 'Zinc-Patch-HTTPSocket' with: 'Zinc-Patch-HTTPSocket-MarcusDenker.4';
			package: 'Zinc-FileSystem' with: 'Zinc-FileSystem-SvenVanCaekenberghe.10' ].
]

{ #category : 'versions' }
ConfigurationOfZincHTTPComponents >> version247: spec [
	<version: '2.4.7' imports: #('2.4-baseline')>
	spec for: #pharo do: [ 
		spec 
			blessing: #release;
			description: 'Update to latest package versions';
			author: 'SvenVanCaekenberghe';
			package: 'Zinc-Character-Encoding-Core' with: 'Zinc-Character-Encoding-Core-SvenVanCaekenberghe.28';
			package: 'Zinc-Character-Encoding-Tests' with: 'Zinc-Character-Encoding-Tests-SvenVanCaekenberghe.15';
			package: 'Zinc-Resource-Meta-Core' with: 'Zinc-Resource-Meta-Core-SvenVanCaekenberghe.30';
			package: 'Zinc-Resource-Meta-Tests' with: 'Zinc-Resource-Meta-Tests-SvenVanCaekenberghe.18';
			package: 'Zinc-HTTP' with: 'Zinc-HTTP-SvenVanCaekenberghe.388';
			package: 'Zinc-Tests' with: 'Zinc-Tests-SvenVanCaekenberghe.200';
			package: 'Zinc-AWS' with: 'Zinc-AWS-SvenVanCaekenberghe.17';
			package: 'Zinc-REST' with: 'Zinc-REST-SvenVanCaekenberghe.13';
			package: 'Zinc-WebDAV' with: 'Zinc-WebDAV-SvenVanCaekenberghe.3';
			package: 'Zinc-WebSocket-Core' with: 'Zinc-WebSocket-Core-SvenVanCaekenberghe.25';
			package: 'Zinc-WebSocket-Tests' with: 'Zinc-WebSocket-Tests-SvenVanCaekenberghe.7';
			package: 'Zinc-SSO-OAuth1-Core' with: 'Zinc-SSO-OAuth1-Core-SvenVanCaekenberghe.13';
			package: 'Zinc-SSO-OAuth2-Core' with: 'Zinc-SSO-OAuth2-Core-JanVanDeSandt.16';
			package: 'Zinc-SSO-OpenID-Core' with: 'Zinc-SSO-OpenID-Core-JanVanDeSandt.6';
			package: 'Zinc-SSO-Demo' with: 'Zinc-SSO-Demo-SvenVanCaekenberghe.5';
			package: 'Zinc-SSO-OAuth1-Tests' with: 'Zinc-SSO-OAuth1-Tests-SvenVanCaekenberghe.2';
			package: 'Zinc-SSO-OpenID-Tests' with: 'Zinc-SSO-OpenID-Tests-JanVanDeSandt.3';
			package: 'Zinc-WWS-Client' with: 'Zinc-WWS-Client-SvenVanCaekenberghe.2';
			package: 'Zinc-WWS-Server' with: 'Zinc-WWS-Server-SvenVanCaekenberghe.10';
			package: 'Zinc-Zodiac' with: 'Zinc-Zodiac-SvenVanCaekenberghe.29';
			package: 'Zodiac-Core' with: 'Zodiac-Core-SvenVanCaekenberghe.30';
			package: 'Zodiac-Tests' with: 'Zodiac-Tests-SvenVanCaekenberghe.12';
			package: 'Zinc-Seaside' with: 'Zinc-Seaside-SvenVanCaekenberghe.40' ].
	spec for: #'pharo1.x' do: [ 
		spec 
			package: 'Zinc-Patch-HTTPSocket' with: 'Zinc-Patch-HTTPSocket-SvenVanCaekenberghe.1';
			package: 'Zinc-FileSystem-Legacy' with: 'Zinc-FileSystem-Legacy-SvenVanCaekenberghe.5';
			package: 'Zinc-Pharo-Forward-Compatibility' with: 'Zinc-Pharo-Forward-Compatibility-SvenVanCaekenberghe.1' ].
	spec for: #'pharo2.x' do: [ 
		spec 
			package: 'Zinc-Patch-HTTPSocket' with: 'Zinc-Patch-HTTPSocket-MarcusDenker.4';
			package: 'Zinc-FileSystem' with: 'Zinc-FileSystem-SvenVanCaekenberghe.10' ].
]

{ #category : 'versions' }
ConfigurationOfZincHTTPComponents >> version248: spec [
	<version: '2.4.8' imports: #('2.4-baseline')>
	spec for: #pharo do: [ 
		spec 
			blessing: #release;
			description: 'Update to latest package versions';
			author: 'SvenVanCaekenberghe';
			package: 'Zinc-Character-Encoding-Core' with: 'Zinc-Character-Encoding-Core-SvenVanCaekenberghe.28';
			package: 'Zinc-Character-Encoding-Tests' with: 'Zinc-Character-Encoding-Tests-SvenVanCaekenberghe.15';
			package: 'Zinc-Resource-Meta-Core' with: 'Zinc-Resource-Meta-Core-SvenVanCaekenberghe.30';
			package: 'Zinc-Resource-Meta-Tests' with: 'Zinc-Resource-Meta-Tests-SvenVanCaekenberghe.18';
			package: 'Zinc-HTTP' with: 'Zinc-HTTP-SvenVanCaekenberghe.388';
			package: 'Zinc-Tests' with: 'Zinc-Tests-SvenVanCaekenberghe.201';
			package: 'Zinc-AWS' with: 'Zinc-AWS-SvenVanCaekenberghe.17';
			package: 'Zinc-REST' with: 'Zinc-REST-SvenVanCaekenberghe.13';
			package: 'Zinc-WebDAV' with: 'Zinc-WebDAV-SvenVanCaekenberghe.3';
			package: 'Zinc-WebSocket-Core' with: 'Zinc-WebSocket-Core-SvenVanCaekenberghe.25';
			package: 'Zinc-WebSocket-Tests' with: 'Zinc-WebSocket-Tests-SvenVanCaekenberghe.7';
			package: 'Zinc-SSO-OAuth1-Core' with: 'Zinc-SSO-OAuth1-Core-SvenVanCaekenberghe.13';
			package: 'Zinc-SSO-OAuth2-Core' with: 'Zinc-SSO-OAuth2-Core-JanVanDeSandt.16';
			package: 'Zinc-SSO-OpenID-Core' with: 'Zinc-SSO-OpenID-Core-JanVanDeSandt.6';
			package: 'Zinc-SSO-Demo' with: 'Zinc-SSO-Demo-SvenVanCaekenberghe.5';
			package: 'Zinc-SSO-OAuth1-Tests' with: 'Zinc-SSO-OAuth1-Tests-SvenVanCaekenberghe.2';
			package: 'Zinc-SSO-OpenID-Tests' with: 'Zinc-SSO-OpenID-Tests-JanVanDeSandt.3';
			package: 'Zinc-WWS-Client' with: 'Zinc-WWS-Client-SvenVanCaekenberghe.2';
			package: 'Zinc-WWS-Server' with: 'Zinc-WWS-Server-SvenVanCaekenberghe.10';
			package: 'Zinc-Zodiac' with: 'Zinc-Zodiac-SvenVanCaekenberghe.29';
			package: 'Zodiac-Core' with: 'Zodiac-Core-SvenVanCaekenberghe.30';
			package: 'Zodiac-Tests' with: 'Zodiac-Tests-SvenVanCaekenberghe.12';
			package: 'Zinc-Seaside' with: 'Zinc-Seaside-SvenVanCaekenberghe.40' ].
	spec for: #'pharo1.x' do: [ 
		spec 
			package: 'Zinc-Patch-HTTPSocket' with: 'Zinc-Patch-HTTPSocket-SvenVanCaekenberghe.1';
			package: 'Zinc-FileSystem-Legacy' with: 'Zinc-FileSystem-Legacy-SvenVanCaekenberghe.5';
			package: 'Zinc-Pharo-Forward-Compatibility' with: 'Zinc-Pharo-Forward-Compatibility-SvenVanCaekenberghe.1' ].
	spec for: #'pharo2.x' do: [ 
		spec 
			package: 'Zinc-Patch-HTTPSocket' with: 'Zinc-Patch-HTTPSocket-MarcusDenker.4';
			package: 'Zinc-FileSystem' with: 'Zinc-FileSystem-SvenVanCaekenberghe.10' ].
]

{ #category : 'versions' }
ConfigurationOfZincHTTPComponents >> version249: spec [
	<version: '2.4.9' imports: #('2.4-baseline')>
	spec for: #pharo do: [ 
		spec 
			blessing: #release;
			description: 'Update to latest package versions';
			author: 'SvenVanCaekenberghe';
			package: 'Zinc-Character-Encoding-Core' with: 'Zinc-Character-Encoding-Core-SvenVanCaekenberghe.30';
			package: 'Zinc-Character-Encoding-Tests' with: 'Zinc-Character-Encoding-Tests-SvenVanCaekenberghe.17';
			package: 'Zinc-Resource-Meta-Core' with: 'Zinc-Resource-Meta-Core-SvenVanCaekenberghe.32';
			package: 'Zinc-Resource-Meta-Tests' with: 'Zinc-Resource-Meta-Tests-SvenVanCaekenberghe.20';
			package: 'Zinc-HTTP' with: 'Zinc-HTTP-SvenVanCaekenberghe.392';
			package: 'Zinc-Tests' with: 'Zinc-Tests-SvenVanCaekenberghe.204';
			package: 'Zinc-AWS' with: 'Zinc-AWS-SvenVanCaekenberghe.17';
			package: 'Zinc-REST' with: 'Zinc-REST-SvenVanCaekenberghe.13';
			package: 'Zinc-WebDAV' with: 'Zinc-WebDAV-SvenVanCaekenberghe.3';
			package: 'Zinc-WebSocket-Core' with: 'Zinc-WebSocket-Core-SvenVanCaekenberghe.26';
			package: 'Zinc-WebSocket-Tests' with: 'Zinc-WebSocket-Tests-SvenVanCaekenberghe.7';
			package: 'Zinc-SSO-OAuth1-Core' with: 'Zinc-SSO-OAuth1-Core-SvenVanCaekenberghe.13';
			package: 'Zinc-SSO-OAuth2-Core' with: 'Zinc-SSO-OAuth2-Core-JanVanDeSandt.16';
			package: 'Zinc-SSO-OpenID-Core' with: 'Zinc-SSO-OpenID-Core-JanVanDeSandt.6';
			package: 'Zinc-SSO-Demo' with: 'Zinc-SSO-Demo-SvenVanCaekenberghe.5';
			package: 'Zinc-SSO-OAuth1-Tests' with: 'Zinc-SSO-OAuth1-Tests-SvenVanCaekenberghe.2';
			package: 'Zinc-SSO-OpenID-Tests' with: 'Zinc-SSO-OpenID-Tests-JanVanDeSandt.3';
			package: 'Zinc-WWS-Client' with: 'Zinc-WWS-Client-SvenVanCaekenberghe.2';
			package: 'Zinc-WWS-Server' with: 'Zinc-WWS-Server-SvenVanCaekenberghe.10';
			package: 'Zinc-Zodiac' with: 'Zinc-Zodiac-SvenVanCaekenberghe.29';
			package: 'Zodiac-Core' with: 'Zodiac-Core-SvenVanCaekenberghe.30';
			package: 'Zodiac-Tests' with: 'Zodiac-Tests-SvenVanCaekenberghe.12';
			package: 'Zinc-Seaside' with: 'Zinc-Seaside-SvenVanCaekenberghe.41' ].
	spec for: #'pharo1.x' do: [ 
		spec 
			package: 'Zinc-Patch-HTTPSocket' with: 'Zinc-Patch-HTTPSocket-SvenVanCaekenberghe.1';
			package: 'Zinc-FileSystem-Legacy' with: 'Zinc-FileSystem-Legacy-SvenVanCaekenberghe.5';
			package: 'Zinc-Pharo-Forward-Compatibility' with: 'Zinc-Pharo-Forward-Compatibility-SvenVanCaekenberghe.1' ].
	spec for: #'pharo2.x' do: [ 
		spec 
			package: 'Zinc-Patch-HTTPSocket' with: 'Zinc-Patch-HTTPSocket-MarcusDenker.4';
			package: 'Zinc-FileSystem' with: 'Zinc-FileSystem-SvenVanCaekenberghe.10' ].
]

{ #category : 'versions' }
ConfigurationOfZincHTTPComponents >> version24: spec [
	<version: '2.4' imports: #('2.3-baseline')>
	spec for: #common do: [ 
		spec 
			blessing: #release;
			description: 'Update to latest package versions';
			author: 'SvenVanCaekenberghe';
			package: 'Zinc-Character-Encoding-Core' with: 'Zinc-Character-Encoding-Core-SvenVanCaekenberghe.16';
			package: 'Zinc-Character-Encoding-Tests' with: 'Zinc-Character-Encoding-Tests-SvenVanCaekenberghe.7';
			package: 'Zinc-Resource-Meta-Core' with: 'Zinc-Resource-Meta-Core-SvenVanCaekenberghe.14';
			package: 'Zinc-Resource-Meta-Tests' with: 'Zinc-Resource-Meta-Tests-SvenVanCaekenberghe.9';
			package: 'Zinc-HTTP' with: 'Zinc-HTTP-SvenVanCaekenberghe.365';
			package: 'Zinc-Tests' with: 'Zinc-Tests-SvenVanCaekenberghe.187';
			package: 'Zinc-AWS' with: 'Zinc-AWS-SvenVanCaekenberghe.17';
			package: 'Zinc-REST' with: 'Zinc-REST-SvenVanCaekenberghe.10';
			package: 'Zinc-WebDAV' with: 'Zinc-WebDAV-SvenVanCaekenberghe.3';
			package: 'Zinc-WebSocket-Core' with: 'Zinc-WebSocket-Core-SvenVanCaekenberghe.25';
			package: 'Zinc-WebSocket-Tests' with: 'Zinc-WebSocket-Tests-SvenVanCaekenberghe.7';
			package: 'Zinc-SSO-OAuth1-Core' with: 'Zinc-SSO-OAuth1-Core-SvenVanCaekenberghe.12';
			package: 'Zinc-SSO-OAuth2-Core' with: 'Zinc-SSO-OAuth2-Core-JanVanDeSandt.13';
			package: 'Zinc-SSO-OpenID-Core' with: 'Zinc-SSO-OpenID-Core-JanVanDeSandt.6';
			package: 'Zinc-SSO-Demo' with: 'Zinc-SSO-Demo-SvenVanCaekenberghe.4';
			package: 'Zinc-SSO-OAuth1-Tests' with: 'Zinc-SSO-OAuth1-Tests-SvenVanCaekenberghe.2';
			package: 'Zinc-SSO-OpenID-Tests' with: 'Zinc-SSO-OpenID-Tests-JanVanDeSandt.3';
			package: 'Zinc-WWS-Client' with: 'Zinc-WWS-Client-SvenVanCaekenberghe.2';
			package: 'Zinc-WWS-Server' with: 'Zinc-WWS-Server-SvenVanCaekenberghe.9';
			package: 'Zinc-Zodiac' with: 'Zinc-Zodiac-SvenVanCaekenberghe.27';
			package: 'Zodiac-Core' with: 'Zodiac-Core-SvenVanCaekenberghe.29';
			package: 'Zodiac-Tests' with: 'Zodiac-Tests-SvenVanCaekenberghe.12' ].
	spec for: #'pharo1.x' do: [ 
		spec 
			package: 'Zinc-Patch-HTTPSocket' with: 'Zinc-Patch-HTTPSocket-SvenVanCaekenberghe.1';
			package: 'Zinc-FileSystem-Legacy' with: 'Zinc-FileSystem-Legacy-SvenVanCaekenberghe.5';
			package: 'Zinc-Pharo-Forward-Compatibility' with: 'Zinc-Pharo-Forward-Compatibility-SvenVanCaekenberghe.1' ].
	spec for: #'pharo2.x' do: [ 
		spec 
			package: 'Zinc-Patch-HTTPSocket' with: 'Zinc-Patch-HTTPSocket-MarcusDenker.4';
			package: 'Zinc-FileSystem' with: 'Zinc-FileSystem-SvenVanCaekenberghe.9' ].
	spec for: #gemstone do: [ 
		spec blessing: #release.
		spec
			package: 'Zinc-GemstonePreliminary' with: 'Zinc-GemstonePreliminary-PaulDeBruicker.2';
			package: 'Zinc-Gemstone' with: 'Zinc-Gemstone-PaulDeBruicker.14';
			package: 'SocketStream' with: 'SocketStream-PaulDeBruicker.12' ]

]

{ #category : 'versions' }
ConfigurationOfZincHTTPComponents >> version250: spec [
	<version: '2.5.0' imports: #('2.4-baseline')>
	spec for: #pharo do: [ 
		spec 
			blessing: #release;
			description: 'Update to latest package versions';
			author: 'SvenVanCaekenberghe';
			package: 'Zinc-Character-Encoding-Core' with: 'Zinc-Character-Encoding-Core-SvenVanCaekenberghe.31';
			package: 'Zinc-Character-Encoding-Tests' with: 'Zinc-Character-Encoding-Tests-SvenVanCaekenberghe.18';
			package: 'Zinc-Resource-Meta-Core' with: 'Zinc-Resource-Meta-Core-SvenVanCaekenberghe.34';
			package: 'Zinc-Resource-Meta-Tests' with: 'Zinc-Resource-Meta-Tests-SvenVanCaekenberghe.21';
			package: 'Zinc-HTTP' with: 'Zinc-HTTP-SvenVanCaekenberghe.395';
			package: 'Zinc-Tests' with: 'Zinc-Tests-SvenVanCaekenberghe.204';
			package: 'Zinc-AWS' with: 'Zinc-AWS-SvenVanCaekenberghe.17';
			package: 'Zinc-REST' with: 'Zinc-REST-SvenVanCaekenberghe.13';
			package: 'Zinc-WebDAV' with: 'Zinc-WebDAV-SvenVanCaekenberghe.3';
			package: 'Zinc-WebSocket-Core' with: 'Zinc-WebSocket-Core-SvenVanCaekenberghe.26';
			package: 'Zinc-WebSocket-Tests' with: 'Zinc-WebSocket-Tests-SvenVanCaekenberghe.7';
			package: 'Zinc-SSO-OAuth1-Core' with: 'Zinc-SSO-OAuth1-Core-SvenVanCaekenberghe.13';
			package: 'Zinc-SSO-OAuth2-Core' with: 'Zinc-SSO-OAuth2-Core-JanVanDeSandt.16';
			package: 'Zinc-SSO-OpenID-Core' with: 'Zinc-SSO-OpenID-Core-JanVanDeSandt.6';
			package: 'Zinc-SSO-Demo' with: 'Zinc-SSO-Demo-SvenVanCaekenberghe.5';
			package: 'Zinc-SSO-OAuth1-Tests' with: 'Zinc-SSO-OAuth1-Tests-SvenVanCaekenberghe.2';
			package: 'Zinc-SSO-OpenID-Tests' with: 'Zinc-SSO-OpenID-Tests-JanVanDeSandt.3';
			package: 'Zinc-WWS-Client' with: 'Zinc-WWS-Client-SvenVanCaekenberghe.2';
			package: 'Zinc-WWS-Server' with: 'Zinc-WWS-Server-SvenVanCaekenberghe.10';
			package: 'Zinc-Zodiac' with: 'Zinc-Zodiac-SvenVanCaekenberghe.29';
			package: 'Zodiac-Core' with: 'Zodiac-Core-SvenVanCaekenberghe.30';
			package: 'Zodiac-Tests' with: 'Zodiac-Tests-SvenVanCaekenberghe.12';
			package: 'Zinc-Seaside' with: 'Zinc-Seaside-SvenVanCaekenberghe.41' ].
	spec for: #'pharo1.x' do: [ 
		spec 
			package: 'Zinc-Patch-HTTPSocket' with: 'Zinc-Patch-HTTPSocket-SvenVanCaekenberghe.1';
			package: 'Zinc-FileSystem-Legacy' with: 'Zinc-FileSystem-Legacy-SvenVanCaekenberghe.5';
			package: 'Zinc-Pharo-Forward-Compatibility' with: 'Zinc-Pharo-Forward-Compatibility-SvenVanCaekenberghe.1' ].
	spec for: #'pharo2.x' do: [ 
		spec 
			package: 'Zinc-Patch-HTTPSocket' with: 'Zinc-Patch-HTTPSocket-MarcusDenker.4';
			package: 'Zinc-FileSystem' with: 'Zinc-FileSystem-SvenVanCaekenberghe.10' ].
]

{ #category : 'versions' }
ConfigurationOfZincHTTPComponents >> version251: spec [
	<version: '2.5.1' imports: #('2.4-baseline')>
	spec for: #pharo do: [ 
		spec 
			blessing: #release;
			description: 'Update to latest package versions';
			author: 'SvenVanCaekenberghe';
			package: 'Zinc-Character-Encoding-Core' with: 'Zinc-Character-Encoding-Core-SvenVanCaekenberghe.32';
			package: 'Zinc-Character-Encoding-Tests' with: 'Zinc-Character-Encoding-Tests-SvenVanCaekenberghe.19';
			package: 'Zinc-Resource-Meta-Core' with: 'Zinc-Resource-Meta-Core-SvenVanCaekenberghe.36';
			package: 'Zinc-Resource-Meta-Tests' with: 'Zinc-Resource-Meta-Tests-SvenVanCaekenberghe.24';
			package: 'Zinc-HTTP' with: 'Zinc-HTTP-SvenVanCaekenberghe.397';
			package: 'Zinc-Tests' with: 'Zinc-Tests-SvenVanCaekenberghe.209';
			package: 'Zinc-AWS' with: 'Zinc-AWS-SvenVanCaekenberghe.17';
			package: 'Zinc-REST' with: 'Zinc-REST-SvenVanCaekenberghe.13';
			package: 'Zinc-WebDAV' with: 'Zinc-WebDAV-SvenVanCaekenberghe.3';
			package: 'Zinc-WebSocket-Core' with: 'Zinc-WebSocket-Core-SvenVanCaekenberghe.26';
			package: 'Zinc-WebSocket-Tests' with: 'Zinc-WebSocket-Tests-SvenVanCaekenberghe.7';
			package: 'Zinc-SSO-OAuth1-Core' with: 'Zinc-SSO-OAuth1-Core-SvenVanCaekenberghe.13';
			package: 'Zinc-SSO-OAuth2-Core' with: 'Zinc-SSO-OAuth2-Core-JanVanDeSandt.16';
			package: 'Zinc-SSO-OpenID-Core' with: 'Zinc-SSO-OpenID-Core-JanVanDeSandt.6';
			package: 'Zinc-SSO-Demo' with: 'Zinc-SSO-Demo-SvenVanCaekenberghe.5';
			package: 'Zinc-SSO-OAuth1-Tests' with: 'Zinc-SSO-OAuth1-Tests-SvenVanCaekenberghe.2';
			package: 'Zinc-SSO-OpenID-Tests' with: 'Zinc-SSO-OpenID-Tests-JanVanDeSandt.3';
			package: 'Zinc-WWS-Client' with: 'Zinc-WWS-Client-SvenVanCaekenberghe.2';
			package: 'Zinc-WWS-Server' with: 'Zinc-WWS-Server-SvenVanCaekenberghe.10';
			package: 'Zinc-Zodiac' with: 'Zinc-Zodiac-SvenVanCaekenberghe.33';
			package: 'Zodiac-Core' with: 'Zodiac-Core-SvenVanCaekenberghe.30';
			package: 'Zodiac-Tests' with: 'Zodiac-Tests-SvenVanCaekenberghe.12';
			package: 'Zinc-Seaside' with: 'Zinc-Seaside-SvenVanCaekenberghe.41' ].
	spec for: #'pharo1.x' do: [ 
		spec 
			package: 'Zinc-Patch-HTTPSocket' with: 'Zinc-Patch-HTTPSocket-SvenVanCaekenberghe.1';
			package: 'Zinc-FileSystem-Legacy' with: 'Zinc-FileSystem-Legacy-SvenVanCaekenberghe.5';
			package: 'Zinc-Pharo-Forward-Compatibility' with: 'Zinc-Pharo-Forward-Compatibility-SvenVanCaekenberghe.1' ].
	spec for: #'pharo2.x' do: [ 
		spec 
			package: 'Zinc-Patch-HTTPSocket' with: 'Zinc-Patch-HTTPSocket-MarcusDenker.4';
			package: 'Zinc-FileSystem' with: 'Zinc-FileSystem-SvenVanCaekenberghe.10' ].
]

{ #category : 'versions' }
ConfigurationOfZincHTTPComponents >> version252: spec [
	<version: '2.5.2' imports: #('2.4-baseline')>
	spec for: #pharo do: [ 
		spec 
			blessing: #release;
			description: 'Update to latest package versions';
			author: 'SvenVanCaekenberghe';
			package: 'Zinc-Character-Encoding-Core' with: 'Zinc-Character-Encoding-Core-SvenVanCaekenberghe.32';
			package: 'Zinc-Character-Encoding-Tests' with: 'Zinc-Character-Encoding-Tests-SvenVanCaekenberghe.19';
			package: 'Zinc-Resource-Meta-Core' with: 'Zinc-Resource-Meta-Core-KrisGybels.37';
			package: 'Zinc-Resource-Meta-Tests' with: 'Zinc-Resource-Meta-Tests-SvenVanCaekenberghe.25';
			package: 'Zinc-HTTP' with: 'Zinc-HTTP-SvenVanCaekenberghe.405';
			package: 'Zinc-Tests' with: 'Zinc-Tests-SvenVanCaekenberghe.215';
			package: 'Zinc-AWS' with: 'Zinc-AWS-SvenVanCaekenberghe.17';
			package: 'Zinc-REST' with: 'Zinc-REST-SvenVanCaekenberghe.14';
			package: 'Zinc-WebDAV' with: 'Zinc-WebDAV-SvenVanCaekenberghe.3';
			package: 'Zinc-WebSocket-Core' with: 'Zinc-WebSocket-Core-SvenVanCaekenberghe.27';
			package: 'Zinc-WebSocket-Tests' with: 'Zinc-WebSocket-Tests-SvenVanCaekenberghe.7';
			package: 'Zinc-SSO-OAuth1-Core' with: 'Zinc-SSO-OAuth1-Core-SvenVanCaekenberghe.13';
			package: 'Zinc-SSO-OAuth2-Core' with: 'Zinc-SSO-OAuth2-Core-JanVanDeSandt.16';
			package: 'Zinc-SSO-OpenID-Core' with: 'Zinc-SSO-OpenID-Core-JanVanDeSandt.6';
			package: 'Zinc-SSO-Demo' with: 'Zinc-SSO-Demo-SvenVanCaekenberghe.5';
			package: 'Zinc-SSO-OAuth1-Tests' with: 'Zinc-SSO-OAuth1-Tests-SvenVanCaekenberghe.2';
			package: 'Zinc-SSO-OpenID-Tests' with: 'Zinc-SSO-OpenID-Tests-JanVanDeSandt.3';
			package: 'Zinc-WWS-Client' with: 'Zinc-WWS-Client-SvenVanCaekenberghe.2';
			package: 'Zinc-WWS-Server' with: 'Zinc-WWS-Server-SvenVanCaekenberghe.10';
			package: 'Zinc-Zodiac' with: 'Zinc-Zodiac-SvenVanCaekenberghe.34';
			package: 'Zodiac-Core' with: 'Zodiac-Core-SvenVanCaekenberghe.30';
			package: 'Zodiac-Tests' with: 'Zodiac-Tests-SvenVanCaekenberghe.12';
			package: 'Zinc-Seaside' with: 'Zinc-Seaside-SvenVanCaekenberghe.41' ].
	spec for: #'pharo1.x' do: [ 
		spec 
			package: 'Zinc-Patch-HTTPSocket' with: 'Zinc-Patch-HTTPSocket-SvenVanCaekenberghe.1';
			package: 'Zinc-FileSystem-Legacy' with: 'Zinc-FileSystem-Legacy-SvenVanCaekenberghe.5';
			package: 'Zinc-Pharo-Forward-Compatibility' with: 'Zinc-Pharo-Forward-Compatibility-SvenVanCaekenberghe.1' ].
	spec for: #'pharo2.x' do: [ 
		spec 
			package: 'Zinc-Patch-HTTPSocket' with: 'Zinc-Patch-HTTPSocket-MarcusDenker.4';
			package: 'Zinc-FileSystem' with: 'Zinc-FileSystem-SvenVanCaekenberghe.10' ].
]

{ #category : 'versions' }
ConfigurationOfZincHTTPComponents >> version253: spec [
	<version: '2.5.3' imports: #('2.4-baseline')>
	spec for: #pharo do: [ 
		spec 
			blessing: #release;
			description: 'Update to latest package versions';
			author: 'SvenVanCaekenberghe';
			package: 'Zinc-Character-Encoding-Core' with: 'Zinc-Character-Encoding-Core-SvenVanCaekenberghe.35';
			package: 'Zinc-Character-Encoding-Tests' with: 'Zinc-Character-Encoding-Tests-SvenVanCaekenberghe.21';
			package: 'Zinc-Resource-Meta-Core' with: 'Zinc-Resource-Meta-Core-SvenVanCaekenberghe.38';
			package: 'Zinc-Resource-Meta-Tests' with: 'Zinc-Resource-Meta-Tests-SvenVanCaekenberghe.25';
			package: 'Zinc-HTTP' with: 'Zinc-HTTP-SvenVanCaekenberghe.410';
			package: 'Zinc-Tests' with: 'Zinc-Tests-SvenVanCaekenberghe.217';
			package: 'Zinc-AWS' with: 'Zinc-AWS-SvenVanCaekenberghe.17';
			package: 'Zinc-REST' with: 'Zinc-REST-SvenVanCaekenberghe.16';
			package: 'Zinc-WebDAV' with: 'Zinc-WebDAV-SvenVanCaekenberghe.3';
			package: 'Zinc-WebSocket-Core' with: 'Zinc-WebSocket-Core-SvenVanCaekenberghe.28';
			package: 'Zinc-WebSocket-Tests' with: 'Zinc-WebSocket-Tests-SvenVanCaekenberghe.7';
			package: 'Zinc-SSO-OAuth1-Core' with: 'Zinc-SSO-OAuth1-Core-SvenVanCaekenberghe.13';
			package: 'Zinc-SSO-OAuth2-Core' with: 'Zinc-SSO-OAuth2-Core-JanVanDeSandt.17';
			package: 'Zinc-SSO-OpenID-Core' with: 'Zinc-SSO-OpenID-Core-JanVanDeSandt.6';
			package: 'Zinc-SSO-Demo' with: 'Zinc-SSO-Demo-SvenVanCaekenberghe.5';
			package: 'Zinc-SSO-OAuth1-Tests' with: 'Zinc-SSO-OAuth1-Tests-SvenVanCaekenberghe.2';
			package: 'Zinc-SSO-OpenID-Tests' with: 'Zinc-SSO-OpenID-Tests-JanVanDeSandt.3';
			package: 'Zinc-WWS-Client' with: 'Zinc-WWS-Client-PhilippeBack.3';
			package: 'Zinc-WWS-Server' with: 'Zinc-WWS-Server-SvenVanCaekenberghe.10';
			package: 'Zinc-Zodiac' with: 'Zinc-Zodiac-SvenVanCaekenberghe.34';
			package: 'Zodiac-Core' with: 'Zodiac-Core-SvenVanCaekenberghe.30';
			package: 'Zodiac-Tests' with: 'Zodiac-Tests-SvenVanCaekenberghe.12';
			package: 'Zinc-Seaside' with: 'Zinc-Seaside-pmm.42' ].
	spec for: #'pharo1.x' do: [ 
		spec 
			package: 'Zinc-Patch-HTTPSocket' with: 'Zinc-Patch-HTTPSocket-SvenVanCaekenberghe.1';
			package: 'Zinc-FileSystem-Legacy' with: 'Zinc-FileSystem-Legacy-SvenVanCaekenberghe.5';
			package: 'Zinc-Pharo-Forward-Compatibility' with: 'Zinc-Pharo-Forward-Compatibility-SvenVanCaekenberghe.1' ].
	spec for: #'pharo2.x' do: [ 
		spec 
			package: 'Zinc-Patch-HTTPSocket' with: 'Zinc-Patch-HTTPSocket-MarcusDenker.4';
			package: 'Zinc-FileSystem' with: 'Zinc-FileSystem-SvenVanCaekenberghe.10' ].
]

{ #category : 'versions' }
ConfigurationOfZincHTTPComponents >> version254: spec [
	<version: '2.5.4' imports: #('2.4-baseline')>
	spec for: #pharo do: [ 
		spec 
			blessing: #release;
			description: 'Update to latest package versions';
			author: 'SvenVanCaekenberghe';
			package: 'Zinc-Character-Encoding-Core' with: 'Zinc-Character-Encoding-Core-SvenVanCaekenberghe.36';
			package: 'Zinc-Character-Encoding-Tests' with: 'Zinc-Character-Encoding-Tests-SvenVanCaekenberghe.21';
			package: 'Zinc-Resource-Meta-Core' with: 'Zinc-Resource-Meta-Core-SvenVanCaekenberghe.39';
			package: 'Zinc-Resource-Meta-Tests' with: 'Zinc-Resource-Meta-Tests-SvenVanCaekenberghe.27';
			package: 'Zinc-HTTP' with: 'Zinc-HTTP-SvenVanCaekenberghe.411';
			package: 'Zinc-Tests' with: 'Zinc-Tests-SvenVanCaekenberghe.217';
			package: 'Zinc-AWS' with: 'Zinc-AWS-SvenVanCaekenberghe.17';
			package: 'Zinc-REST' with: 'Zinc-REST-SvenVanCaekenberghe.16';
			package: 'Zinc-WebDAV' with: 'Zinc-WebDAV-SvenVanCaekenberghe.3';
			package: 'Zinc-WebSocket-Core' with: 'Zinc-WebSocket-Core-SvenVanCaekenberghe.28';
			package: 'Zinc-WebSocket-Tests' with: 'Zinc-WebSocket-Tests-SvenVanCaekenberghe.7';
			package: 'Zinc-SSO-OAuth1-Core' with: 'Zinc-SSO-OAuth1-Core-SvenVanCaekenberghe.13';
			package: 'Zinc-SSO-OAuth2-Core' with: 'Zinc-SSO-OAuth2-Core-JanVanDeSandt.17';
			package: 'Zinc-SSO-OpenID-Core' with: 'Zinc-SSO-OpenID-Core-JanVanDeSandt.6';
			package: 'Zinc-SSO-Demo' with: 'Zinc-SSO-Demo-SvenVanCaekenberghe.5';
			package: 'Zinc-SSO-OAuth1-Tests' with: 'Zinc-SSO-OAuth1-Tests-SvenVanCaekenberghe.2';
			package: 'Zinc-SSO-OpenID-Tests' with: 'Zinc-SSO-OpenID-Tests-JanVanDeSandt.3';
			package: 'Zinc-WWS-Client' with: 'Zinc-WWS-Client-PhilippeBack.3';
			package: 'Zinc-WWS-Server' with: 'Zinc-WWS-Server-SvenVanCaekenberghe.10';
			package: 'Zinc-Zodiac' with: 'Zinc-Zodiac-SvenVanCaekenberghe.34';
			package: 'Zodiac-Core' with: 'Zodiac-Core-SvenVanCaekenberghe.30';
			package: 'Zodiac-Tests' with: 'Zodiac-Tests-SvenVanCaekenberghe.12';
			package: 'Zinc-Seaside' with: 'Zinc-Seaside-pmm.42' ].
	spec for: #'pharo1.x' do: [ 
		spec 
			package: 'Zinc-Patch-HTTPSocket' with: 'Zinc-Patch-HTTPSocket-SvenVanCaekenberghe.1';
			package: 'Zinc-FileSystem-Legacy' with: 'Zinc-FileSystem-Legacy-SvenVanCaekenberghe.5';
			package: 'Zinc-Pharo-Forward-Compatibility' with: 'Zinc-Pharo-Forward-Compatibility-SvenVanCaekenberghe.1' ].
	spec for: #'pharo2.x' do: [ 
		spec 
			package: 'Zinc-Patch-HTTPSocket' with: 'Zinc-Patch-HTTPSocket-MarcusDenker.4';
			package: 'Zinc-FileSystem' with: 'Zinc-FileSystem-SvenVanCaekenberghe.10' ].
]

{ #category : 'versions' }
ConfigurationOfZincHTTPComponents >> version255: spec [
	<version: '2.5.5' imports: #('2.4-baseline')>
	spec for: #pharo do: [ 
		spec 
			blessing: #release;
			description: 'Update to latest package versions';
			author: 'SvenVanCaekenberghe';
			package: 'Zinc-Character-Encoding-Core' with: 'Zinc-Character-Encoding-Core-SvenVanCaekenberghe.36';
			package: 'Zinc-Character-Encoding-Tests' with: 'Zinc-Character-Encoding-Tests-SvenVanCaekenberghe.21';
			package: 'Zinc-Resource-Meta-Core' with: 'Zinc-Resource-Meta-Core-SvenVanCaekenberghe.39';
			package: 'Zinc-Resource-Meta-Tests' with: 'Zinc-Resource-Meta-Tests-SvenVanCaekenberghe.27';
			package: 'Zinc-HTTP' with: 'Zinc-HTTP-SvenVanCaekenberghe.411';
			package: 'Zinc-Tests' with: 'Zinc-Tests-SvenVanCaekenberghe.218';
			package: 'Zinc-AWS' with: 'Zinc-AWS-SvenVanCaekenberghe.17';
			package: 'Zinc-REST' with: 'Zinc-REST-SvenVanCaekenberghe.16';
			package: 'Zinc-WebDAV' with: 'Zinc-WebDAV-SvenVanCaekenberghe.3';
			package: 'Zinc-WebSocket-Core' with: 'Zinc-WebSocket-Core-SvenVanCaekenberghe.28';
			package: 'Zinc-WebSocket-Tests' with: 'Zinc-WebSocket-Tests-SvenVanCaekenberghe.7';
			package: 'Zinc-SSO-OAuth1-Core' with: 'Zinc-SSO-OAuth1-Core-SvenVanCaekenberghe.13';
			package: 'Zinc-SSO-OAuth2-Core' with: 'Zinc-SSO-OAuth2-Core-JanVanDeSandt.17';
			package: 'Zinc-SSO-OpenID-Core' with: 'Zinc-SSO-OpenID-Core-JanVanDeSandt.6';
			package: 'Zinc-SSO-Demo' with: 'Zinc-SSO-Demo-SvenVanCaekenberghe.5';
			package: 'Zinc-SSO-OAuth1-Tests' with: 'Zinc-SSO-OAuth1-Tests-SvenVanCaekenberghe.2';
			package: 'Zinc-SSO-OpenID-Tests' with: 'Zinc-SSO-OpenID-Tests-JanVanDeSandt.3';
			package: 'Zinc-WWS-Client' with: 'Zinc-WWS-Client-PhilippeBack.3';
			package: 'Zinc-WWS-Server' with: 'Zinc-WWS-Server-SvenVanCaekenberghe.10';
			package: 'Zinc-Zodiac' with: 'Zinc-Zodiac-SvenVanCaekenberghe.34';
			package: 'Zodiac-Core' with: 'Zodiac-Core-SvenVanCaekenberghe.30';
			package: 'Zodiac-Tests' with: 'Zodiac-Tests-SvenVanCaekenberghe.12';
			package: 'Zinc-Seaside' with: 'Zinc-Seaside-pmm.42' ].
	spec for: #'pharo1.x' do: [ 
		spec 
			package: 'Zinc-Patch-HTTPSocket' with: 'Zinc-Patch-HTTPSocket-SvenVanCaekenberghe.1';
			package: 'Zinc-FileSystem-Legacy' with: 'Zinc-FileSystem-Legacy-SvenVanCaekenberghe.5';
			package: 'Zinc-Pharo-Forward-Compatibility' with: 'Zinc-Pharo-Forward-Compatibility-SvenVanCaekenberghe.1' ].
	spec for: #'pharo2.x' do: [ 
		spec 
			package: 'Zinc-Patch-HTTPSocket' with: 'Zinc-Patch-HTTPSocket-MarcusDenker.4';
			package: 'Zinc-FileSystem' with: 'Zinc-FileSystem-SvenVanCaekenberghe.10' ].
]

{ #category : 'versions' }
ConfigurationOfZincHTTPComponents >> version256: spec [
	<version: '2.5.6' imports: #('2.5-baseline')>
	spec for: #pharo do: [ 
		spec 
			blessing: #release;
			description: 'Update to latest package versions';
			author: 'SvenVanCaekenberghe';
			package: 'Zinc-Character-Encoding-Core' with: 'Zinc-Character-Encoding-Core-SvenVanCaekenberghe.37';
			package: 'Zinc-Character-Encoding-Tests' with: 'Zinc-Character-Encoding-Tests-SvenVanCaekenberghe.22';
			package: 'Zinc-Resource-Meta-Core' with: 'Zinc-Resource-Meta-Core-SvenVanCaekenberghe.47';
			package: 'Zinc-Resource-Meta-Tests' with: 'Zinc-Resource-Meta-Tests-SvenVanCaekenberghe.32';
			package: 'Zinc-HTTP' with: 'Zinc-HTTP-SvenVanCaekenberghe.422';
			package: 'Zinc-Tests' with: 'Zinc-Tests-SvenVanCaekenberghe.221';
			package: 'Zinc-AWS' with: 'Zinc-AWS-SvenVanCaekenberghe.17';
			package: 'Zinc-REST' with: 'Zinc-REST-SvenVanCaekenberghe.16';
			package: 'Zinc-WebDAV' with: 'Zinc-WebDAV-SvenVanCaekenberghe.3';
			package: 'Zinc-WebSocket-Core' with: 'Zinc-WebSocket-Core-SvenVanCaekenberghe.28';
			package: 'Zinc-WebSocket-Tests' with: 'Zinc-WebSocket-Tests-SvenVanCaekenberghe.7';
			package: 'Zinc-SSO-OAuth1-Core' with: 'Zinc-SSO-OAuth1-Core-SvenVanCaekenberghe.13';
			package: 'Zinc-SSO-OAuth2-Core' with: 'Zinc-SSO-OAuth2-Core-JanVanDeSandt.17';
			package: 'Zinc-SSO-OpenID-Core' with: 'Zinc-SSO-OpenID-Core-JanVanDeSandt.6';
			package: 'Zinc-SSO-Demo' with: 'Zinc-SSO-Demo-SvenVanCaekenberghe.5';
			package: 'Zinc-SSO-OAuth1-Tests' with: 'Zinc-SSO-OAuth1-Tests-SvenVanCaekenberghe.2';
			package: 'Zinc-SSO-OpenID-Tests' with: 'Zinc-SSO-OpenID-Tests-JanVanDeSandt.3';
			package: 'Zinc-WWS-Client' with: 'Zinc-WWS-Client-PhilippeBack.3';
			package: 'Zinc-WWS-Server' with: 'Zinc-WWS-Server-SvenVanCaekenberghe.10';
			package: 'Zinc-Zodiac' with: 'Zinc-Zodiac-SvenVanCaekenberghe.34';
			package: 'Zodiac-Core' with: 'Zodiac-Core-SvenVanCaekenberghe.35';
			package: 'Zodiac-Tests' with: 'Zodiac-Tests-SvenVanCaekenberghe.12';
			package: 'Zinc-Seaside' with: 'Zinc-Seaside-JohanBrichau.43' ].
	spec for: #'pharo1.x' do: [ 
		spec 
			package: 'Zinc-Patch-HTTPSocket' with: 'Zinc-Patch-HTTPSocket-SvenVanCaekenberghe.1';
			package: 'Zinc-FileSystem-Legacy' with: 'Zinc-FileSystem-Legacy-SvenVanCaekenberghe.5';
			package: 'Zinc-Pharo-Forward-Compatibility' with: 'Zinc-Pharo-Forward-Compatibility-SvenVanCaekenberghe.1' ].
	spec for: #'pharo2.x' do: [ 
		spec 
			package: 'Zinc-Patch-HTTPSocket' with: 'Zinc-Patch-HTTPSocket-MarcusDenker.4';
			package: 'Zinc-FileSystem' with: 'Zinc-FileSystem-SvenVanCaekenberghe.10' ].
]

{ #category : 'versions' }
ConfigurationOfZincHTTPComponents >> version261: spec [
	<version: '2.6.1' imports: #('2.6-baseline')>
	spec for: #pharo do: [ 
		spec 
			blessing: #release;
			description: 'Update to latest package versions';
			author: 'SvenVanCaekenberghe';
			package: 'Zinc-Character-Encoding-Core' with: 'Zinc-Character-Encoding-Core-SvenVanCaekenberghe.37';
			package: 'Zinc-Character-Encoding-Tests' with: 'Zinc-Character-Encoding-Tests-SvenVanCaekenberghe.22';
			package: 'Zinc-Resource-Meta-Core' with: 'Zinc-Resource-Meta-Core-SvenVanCaekenberghe.47';
			package: 'Zinc-Resource-Meta-Tests' with: 'Zinc-Resource-Meta-Tests-SvenVanCaekenberghe.32';
			package: 'Zinc-HTTP' with: 'Zinc-HTTP-SvenVanCaekenberghe.422';
			package: 'Zinc-Tests' with: 'Zinc-Tests-SvenVanCaekenberghe.221';
			package: 'Zinc-AWS' with: 'Zinc-AWS-SvenVanCaekenberghe.17';
			package: 'Zinc-REST' with: 'Zinc-REST-SvenVanCaekenberghe.16';
			package: 'Zinc-WebDAV' with: 'Zinc-WebDAV-SvenVanCaekenberghe.3';
			package: 'Zinc-WebSocket-Core' with: 'Zinc-WebSocket-Core-SvenVanCaekenberghe.28';
			package: 'Zinc-WebSocket-Tests' with: 'Zinc-WebSocket-Tests-SvenVanCaekenberghe.7';
			package: 'Zinc-SSO-OAuth1-Core' with: 'Zinc-SSO-OAuth1-Core-SvenVanCaekenberghe.13';
			package: 'Zinc-SSO-OAuth2-Core' with: 'Zinc-SSO-OAuth2-Core-JanVanDeSandt.17';
			package: 'Zinc-SSO-OpenID-Core' with: 'Zinc-SSO-OpenID-Core-JanVanDeSandt.6';
			package: 'Zinc-SSO-Demo' with: 'Zinc-SSO-Demo-SvenVanCaekenberghe.5';
			package: 'Zinc-SSO-OAuth1-Tests' with: 'Zinc-SSO-OAuth1-Tests-SvenVanCaekenberghe.2';
			package: 'Zinc-SSO-OpenID-Tests' with: 'Zinc-SSO-OpenID-Tests-JanVanDeSandt.3';
			package: 'Zinc-WWS-Client' with: 'Zinc-WWS-Client-PhilippeBack.3';
			package: 'Zinc-WWS-Server' with: 'Zinc-WWS-Server-SvenVanCaekenberghe.10';
			package: 'Zinc-Zodiac' with: 'Zinc-Zodiac-SvenVanCaekenberghe.34';
			package: 'Zodiac-Core' with: 'Zodiac-Core-SvenVanCaekenberghe.35';
			package: 'Zodiac-Tests' with: 'Zodiac-Tests-SvenVanCaekenberghe.12';
			package: 'Zinc-Seaside' with: 'Zinc-Seaside-JohanBrichau.43' ].
	spec for: #'pharo1.x' do: [ 
		spec 
			package: 'Zinc-Patch-HTTPSocket' with: 'Zinc-Patch-HTTPSocket-SvenVanCaekenberghe.1';
			package: 'Zinc-FileSystem-Legacy' with: 'Zinc-FileSystem-Legacy-SvenVanCaekenberghe.5';
			package: 'Zinc-Pharo-Forward-Compatibility' with: 'Zinc-Pharo-Forward-Compatibility-SvenVanCaekenberghe.1' ].
	spec for: #'pharo2.x' do: [ 
		spec 
			package: 'Zinc-Patch-HTTPSocket' with: 'Zinc-Patch-HTTPSocket-MarcusDenker.4';
			package: 'Zinc-FileSystem' with: 'Zinc-FileSystem-SvenVanCaekenberghe.10';
			package: 'Zinc-pharo2-forward-compatibility' with: 'Zinc-pharo2-forward-compatibility-SvenVanCaekenberghe.1' ].
	spec for: #'pharo3.x' do: [ 
		spec 
			package: 'Zinc-FileSystem' with: 'Zinc-FileSystem-SvenVanCaekenberghe.10' ]
]

{ #category : 'versions' }
ConfigurationOfZincHTTPComponents >> version262: spec [
	<version: '2.6.2' imports: #('2.6-baseline')>
	spec for: #pharo do: [ 
		spec 
			blessing: #release;
			description: 'Update to latest package versions';
			author: 'SvenVanCaekenberghe';
			package: 'Zinc-Character-Encoding-Core' with: 'Zinc-Character-Encoding-Core-SvenVanCaekenberghe.37';
			package: 'Zinc-Character-Encoding-Tests' with: 'Zinc-Character-Encoding-Tests-SvenVanCaekenberghe.22';
			package: 'Zinc-Resource-Meta-Core' with: 'Zinc-Resource-Meta-Core-SvenVanCaekenberghe.47';
			package: 'Zinc-Resource-Meta-Tests' with: 'Zinc-Resource-Meta-Tests-SvenVanCaekenberghe.32';
			package: 'Zinc-HTTP' with: 'Zinc-HTTP-SvenVanCaekenberghe.422';
			package: 'Zinc-Tests' with: 'Zinc-Tests-SvenVanCaekenberghe.221';
			package: 'Zinc-AWS' with: 'Zinc-AWS-SvenVanCaekenberghe.17';
			package: 'Zinc-REST' with: 'Zinc-REST-SvenVanCaekenberghe.16';
			package: 'Zinc-WebDAV' with: 'Zinc-WebDAV-SvenVanCaekenberghe.3';
			package: 'Zinc-WebSocket-Core' with: 'Zinc-WebSocket-Core-SvenVanCaekenberghe.28';
			package: 'Zinc-WebSocket-Tests' with: 'Zinc-WebSocket-Tests-SvenVanCaekenberghe.7';
			package: 'Zinc-SSO-OAuth1-Core' with: 'Zinc-SSO-OAuth1-Core-SvenVanCaekenberghe.13';
			package: 'Zinc-SSO-OAuth2-Core' with: 'Zinc-SSO-OAuth2-Core-JanVanDeSandt.17';
			package: 'Zinc-SSO-OpenID-Core' with: 'Zinc-SSO-OpenID-Core-JanVanDeSandt.6';
			package: 'Zinc-SSO-Demo' with: 'Zinc-SSO-Demo-SvenVanCaekenberghe.5';
			package: 'Zinc-SSO-OAuth1-Tests' with: 'Zinc-SSO-OAuth1-Tests-SvenVanCaekenberghe.2';
			package: 'Zinc-SSO-OpenID-Tests' with: 'Zinc-SSO-OpenID-Tests-JanVanDeSandt.3';
			package: 'Zinc-WWS-Client' with: 'Zinc-WWS-Client-PhilippeBack.3';
			package: 'Zinc-WWS-Server' with: 'Zinc-WWS-Server-SvenVanCaekenberghe.10';
			package: 'Zinc-Zodiac' with: 'Zinc-Zodiac-SvenVanCaekenberghe.34';
			package: 'Zodiac-Core' with: 'Zodiac-Core-SvenVanCaekenberghe.35';
			package: 'Zodiac-Tests' with: 'Zodiac-Tests-SvenVanCaekenberghe.12';
			package: 'Zinc-Seaside' with: 'Zinc-Seaside-JohanBrichau.43' ].
	spec for: #'pharo1.x' do: [ 
		spec 
			package: 'Zinc-Patch-HTTPSocket' with: 'Zinc-Patch-HTTPSocket-SvenVanCaekenberghe.1';
			package: 'Zinc-FileSystem-Legacy' with: 'Zinc-FileSystem-Legacy-SvenVanCaekenberghe.5';
			package: 'Zinc-Pharo-Forward-Compatibility' with: 'Zinc-Pharo-Forward-Compatibility-SvenVanCaekenberghe.1' ].
	spec for: #'pharo2.x' do: [ 
		spec 
			package: 'Zinc-Patch-HTTPSocket' with: 'Zinc-Patch-HTTPSocket-MarcusDenker.4';
			package: 'Zinc-FileSystem' with: 'Zinc-FileSystem-SvenVanCaekenberghe.10';
			package: 'Zinc-pharo2-forward-compatibility' with: 'Zinc-pharo2-forward-compatibility-SvenVanCaekenberghe.1' ].
	spec for: #'pharo3.x' do: [ 
		spec 
			package: 'Zinc-FileSystem' with: 'Zinc-FileSystem-SvenVanCaekenberghe.10';
			package: 'Zinc-Resouce-Meta-FileSystem' with: 'Zinc-Resouce-Meta-FileSystem-SvenVanCaekenberghe.7' ]
]

{ #category : 'versions' }
ConfigurationOfZincHTTPComponents >> version263: spec [
	<version: '2.6.3' imports: #('2.6-baseline')>
	spec for: #pharo do: [ 
		spec 
			blessing: #release;
			description: 'Update to latest package versions';
			author: 'SvenVanCaekenberghe';
			package: 'Zinc-Character-Encoding-Core' with: 'Zinc-Character-Encoding-Core-SvenVanCaekenberghe.37';
			package: 'Zinc-Character-Encoding-Tests' with: 'Zinc-Character-Encoding-Tests-SvenVanCaekenberghe.22';
			package: 'Zinc-Resource-Meta-Core' with: 'Zinc-Resource-Meta-Core-SvenVanCaekenberghe.48';
			package: 'Zinc-Resource-Meta-Tests' with: 'Zinc-Resource-Meta-Tests-SvenVanCaekenberghe.33';
			package: 'Zinc-HTTP' with: 'Zinc-HTTP-SvenVanCaekenberghe.423';
			package: 'Zinc-Tests' with: 'Zinc-Tests-SvenVanCaekenberghe.223';
			package: 'Zinc-AWS' with: 'Zinc-AWS-SvenVanCaekenberghe.17';
			package: 'Zinc-REST' with: 'Zinc-REST-SvenVanCaekenberghe.16';
			package: 'Zinc-WebDAV' with: 'Zinc-WebDAV-SvenVanCaekenberghe.3';
			package: 'Zinc-WebSocket-Core' with: 'Zinc-WebSocket-Core-SvenVanCaekenberghe.28';
			package: 'Zinc-WebSocket-Tests' with: 'Zinc-WebSocket-Tests-SvenVanCaekenberghe.7';
			package: 'Zinc-SSO-OAuth1-Core' with: 'Zinc-SSO-OAuth1-Core-SvenVanCaekenberghe.13';
			package: 'Zinc-SSO-OAuth2-Core' with: 'Zinc-SSO-OAuth2-Core-JanVanDeSandt.17';
			package: 'Zinc-SSO-OpenID-Core' with: 'Zinc-SSO-OpenID-Core-JanVanDeSandt.6';
			package: 'Zinc-SSO-Demo' with: 'Zinc-SSO-Demo-SvenVanCaekenberghe.5';
			package: 'Zinc-SSO-OAuth1-Tests' with: 'Zinc-SSO-OAuth1-Tests-SvenVanCaekenberghe.2';
			package: 'Zinc-SSO-OpenID-Tests' with: 'Zinc-SSO-OpenID-Tests-JanVanDeSandt.3';
			package: 'Zinc-WWS-Client' with: 'Zinc-WWS-Client-PhilippeBack.3';
			package: 'Zinc-WWS-Server' with: 'Zinc-WWS-Server-SvenVanCaekenberghe.10';
			package: 'Zinc-Zodiac' with: 'Zinc-Zodiac-SvenVanCaekenberghe.34';
			package: 'Zodiac-Core' with: 'Zodiac-Core-SvenVanCaekenberghe.38';
			package: 'Zodiac-Tests' with: 'Zodiac-Tests-SvenVanCaekenberghe.12';
			package: 'Zinc-Seaside' with: 'Zinc-Seaside-JohanBrichau.43' ].
	spec for: #'pharo1.x' do: [ 
		spec 
			package: 'Zinc-Patch-HTTPSocket' with: 'Zinc-Patch-HTTPSocket-SvenVanCaekenberghe.1';
			package: 'Zinc-FileSystem-Legacy' with: 'Zinc-FileSystem-Legacy-SvenVanCaekenberghe.5';
			package: 'Zinc-Pharo-Forward-Compatibility' with: 'Zinc-Pharo-Forward-Compatibility-SvenVanCaekenberghe.1' ].
	spec for: #'pharo2.x' do: [ 
		spec 
			package: 'Zinc-Patch-HTTPSocket' with: 'Zinc-Patch-HTTPSocket-MarcusDenker.4';
			package: 'Zinc-FileSystem' with: 'Zinc-FileSystem-SvenVanCaekenberghe.10';
			package: 'Zinc-Resource-Meta-FileSystem' with: 'Zinc-Resource-Meta-FileSystem-SvenVanCaekenberghe.7';
			package: 'Zinc-pharo2-forward-compatibility' with: 'Zinc-pharo2-forward-compatibility-SvenVanCaekenberghe.1' ].
	spec for: #'pharo3.x' do: [ 
		spec 
			package: 'Zinc-FileSystem' with: 'Zinc-FileSystem-SvenVanCaekenberghe.10';
			package: 'Zinc-Resource-Meta-FileSystem' with: 'Zinc-Resource-Meta-FileSystem-SvenVanCaekenberghe.7' ]
]

{ #category : 'versions' }
ConfigurationOfZincHTTPComponents >> version264: spec [
	<version: '2.6.4' imports: #('2.6-baseline')>
	spec for: #pharo do: [ 
		spec 
			blessing: #release;
			description: 'Update to latest package versions';
			author: 'SvenVanCaekenberghe';
			package: 'Zinc-Character-Encoding-Core' with: 'Zinc-Character-Encoding-Core-SvenVanCaekenberghe.37';
			package: 'Zinc-Character-Encoding-Tests' with: 'Zinc-Character-Encoding-Tests-SvenVanCaekenberghe.22';
			package: 'Zinc-Resource-Meta-Core' with: 'Zinc-Resource-Meta-Core-SvenVanCaekenberghe.52';
			package: 'Zinc-Resource-Meta-Tests' with: 'Zinc-Resource-Meta-Tests-monty.35';
			package: 'Zinc-HTTP' with: 'Zinc-HTTP-SvenVanCaekenberghe.427';
			package: 'Zinc-Tests' with: 'Zinc-Tests-SvenVanCaekenberghe.225';
			package: 'Zinc-AWS' with: 'Zinc-AWS-SvenVanCaekenberghe.17';
			package: 'Zinc-REST' with: 'Zinc-REST-SvenVanCaekenberghe.16';
			package: 'Zinc-WebDAV' with: 'Zinc-WebDAV-SvenVanCaekenberghe.3';
			package: 'Zinc-WebSocket-Core' with: 'Zinc-WebSocket-Core-SvenVanCaekenberghe.28';
			package: 'Zinc-WebSocket-Tests' with: 'Zinc-WebSocket-Tests-SvenVanCaekenberghe.7';
			package: 'Zinc-SSO-OAuth1-Core' with: 'Zinc-SSO-OAuth1-Core-SvenVanCaekenberghe.13';
			package: 'Zinc-SSO-OAuth2-Core' with: 'Zinc-SSO-OAuth2-Core-JanVanDeSandt.17';
			package: 'Zinc-SSO-OpenID-Core' with: 'Zinc-SSO-OpenID-Core-JanVanDeSandt.6';
			package: 'Zinc-SSO-Demo' with: 'Zinc-SSO-Demo-SvenVanCaekenberghe.5';
			package: 'Zinc-SSO-OAuth1-Tests' with: 'Zinc-SSO-OAuth1-Tests-SvenVanCaekenberghe.2';
			package: 'Zinc-SSO-OpenID-Tests' with: 'Zinc-SSO-OpenID-Tests-JanVanDeSandt.3';
			package: 'Zinc-WWS-Client' with: 'Zinc-WWS-Client-PhilippeBack.3';
			package: 'Zinc-WWS-Server' with: 'Zinc-WWS-Server-SvenVanCaekenberghe.10';
			package: 'Zinc-Zodiac' with: 'Zinc-Zodiac-SvenVanCaekenberghe.34';
			package: 'Zodiac-Core' with: 'Zodiac-Core-SvenVanCaekenberghe.38';
			package: 'Zodiac-Tests' with: 'Zodiac-Tests-SvenVanCaekenberghe.12';
			package: 'Zinc-Seaside' with: 'Zinc-Seaside-JohanBrichau.43' ].
	spec for: #'pharo1.x' do: [ 
		spec 
			package: 'Zinc-Patch-HTTPSocket' with: 'Zinc-Patch-HTTPSocket-SvenVanCaekenberghe.1';
			package: 'Zinc-FileSystem-Legacy' with: 'Zinc-FileSystem-Legacy-SvenVanCaekenberghe.5';
			package: 'Zinc-Pharo-Forward-Compatibility' with: 'Zinc-Pharo-Forward-Compatibility-SvenVanCaekenberghe.1' ].
	spec for: #'pharo2.x' do: [ 
		spec 
			package: 'Zinc-Patch-HTTPSocket' with: 'Zinc-Patch-HTTPSocket-MarcusDenker.4';
			package: 'Zinc-FileSystem' with: 'Zinc-FileSystem-SvenVanCaekenberghe.10';
			package: 'Zinc-Resource-Meta-FileSystem' with: 'Zinc-Resource-Meta-FileSystem-SvenVanCaekenberghe.7';
			package: 'Zinc-pharo2-forward-compatibility' with: 'Zinc-pharo2-forward-compatibility-SvenVanCaekenberghe.1' ].
	spec for: #'pharo3.x' do: [ 
		spec 
			package: 'Zinc-FileSystem' with: 'Zinc-FileSystem-SvenVanCaekenberghe.10';
			package: 'Zinc-Resource-Meta-FileSystem' with: 'Zinc-Resource-Meta-FileSystem-SvenVanCaekenberghe.7' ]
]

{ #category : 'versions' }
ConfigurationOfZincHTTPComponents >> version265: spec [
	<version: '2.6.5' imports: #('2.6-baseline')>
	spec for: #pharo do: [ 
		spec 
			blessing: #release;
			description: 'Update to latest package versions';
			author: 'SvenVanCaekenberghe';
			package: 'Zinc-Character-Encoding-Core' with: 'Zinc-Character-Encoding-Core-SvenVanCaekenberghe.40';
			package: 'Zinc-Character-Encoding-Tests' with: 'Zinc-Character-Encoding-Tests-SvenVanCaekenberghe.22';
			package: 'Zinc-Resource-Meta-Core' with: 'Zinc-Resource-Meta-Core-SvenVanCaekenberghe.53';
			package: 'Zinc-Resource-Meta-Tests' with: 'Zinc-Resource-Meta-Tests-SvenVanCaekenberghe.36';
			package: 'Zinc-HTTP' with: 'Zinc-HTTP-SvenVanCaekenberghe.436';
			package: 'Zinc-Tests' with: 'Zinc-Tests-SvenVanCaekenberghe.232';
			package: 'Zinc-AWS' with: 'Zinc-AWS-SvenVanCaekenberghe.18';
			package: 'Zinc-REST' with: 'Zinc-REST-SvenVanCaekenberghe.18';
			package: 'Zinc-WebDAV' with: 'Zinc-WebDAV-SvenVanCaekenberghe.3';
			package: 'Zinc-WebSocket-Core' with: 'Zinc-WebSocket-Core-SvenVanCaekenberghe.29';
			package: 'Zinc-WebSocket-Tests' with: 'Zinc-WebSocket-Tests-SvenVanCaekenberghe.9';
			package: 'Zinc-SSO-OAuth1-Core' with: 'Zinc-SSO-OAuth1-Core-SvenVanCaekenberghe.13';
			package: 'Zinc-SSO-OAuth2-Core' with: 'Zinc-SSO-OAuth2-Core-JanVanDeSandt.20';
			package: 'Zinc-SSO-OpenID-Core' with: 'Zinc-SSO-OpenID-Core-JanVanDeSandt.6';
			package: 'Zinc-SSO-Demo' with: 'Zinc-SSO-Demo-SvenVanCaekenberghe.5';
			package: 'Zinc-SSO-OAuth1-Tests' with: 'Zinc-SSO-OAuth1-Tests-SvenVanCaekenberghe.2';
			package: 'Zinc-SSO-OpenID-Tests' with: 'Zinc-SSO-OpenID-Tests-JanVanDeSandt.3';
			package: 'Zinc-WWS-Client' with: 'Zinc-WWS-Client-PhilippeBack.3';
			package: 'Zinc-WWS-Server' with: 'Zinc-WWS-Server-SvenVanCaekenberghe.11';
			package: 'Zinc-Zodiac' with: 'Zinc-Zodiac-SvenVanCaekenberghe.35';
			package: 'Zodiac-Core' with: 'Zodiac-Core-SvenVanCaekenberghe.42';
			package: 'Zodiac-Tests' with: 'Zodiac-Tests-SvenVanCaekenberghe.13';
			package: 'Zinc-Seaside' with: 'Zinc-Seaside-JohanBrichau.43' ].
	spec for: #'pharo1.x' do: [ 
		spec 
			package: 'Zinc-Patch-HTTPSocket' with: 'Zinc-Patch-HTTPSocket-SvenVanCaekenberghe.1';
			package: 'Zinc-FileSystem-Legacy' with: 'Zinc-FileSystem-Legacy-SvenVanCaekenberghe.5';
			package: 'Zinc-Pharo-Forward-Compatibility' with: 'Zinc-Pharo-Forward-Compatibility-SvenVanCaekenberghe.1' ].
	spec for: #'pharo2.x' do: [ 
		spec 
			package: 'Zinc-Patch-HTTPSocket' with: 'Zinc-Patch-HTTPSocket-MarcusDenker.4';
			package: 'Zinc-FileSystem' with: 'Zinc-FileSystem-SvenVanCaekenberghe.10';
			package: 'Zinc-Resource-Meta-FileSystem' with: 'Zinc-Resource-Meta-FileSystem-SvenVanCaekenberghe.7';
			package: 'Zinc-pharo2-forward-compatibility' with: 'Zinc-pharo2-forward-compatibility-SvenVanCaekenberghe.1' ].
	spec for: #'pharo3.x' do: [ 
		spec 
			package: 'Zinc-FileSystem' with: 'Zinc-FileSystem-SvenVanCaekenberghe.10';
			package: 'Zinc-Resource-Meta-FileSystem' with: 'Zinc-Resource-Meta-FileSystem-SvenVanCaekenberghe.7' ]
]

{ #category : 'versions' }
ConfigurationOfZincHTTPComponents >> version266: spec [
	<version: '2.6.6' imports: #('2.6-baseline')>
	spec for: #pharo do: [ 
		spec 
			blessing: #release;
			description: 'Update to latest package versions';
			author: 'SvenVanCaekenberghe';
			package: 'Zinc-Character-Encoding-Core' with: 'Zinc-Character-Encoding-Core-SvenVanCaekenberghe.40';
			package: 'Zinc-Character-Encoding-Tests' with: 'Zinc-Character-Encoding-Tests-SvenVanCaekenberghe.22';
			package: 'Zinc-Resource-Meta-Core' with: 'Zinc-Resource-Meta-Core-SvenVanCaekenberghe.53';
			package: 'Zinc-Resource-Meta-Tests' with: 'Zinc-Resource-Meta-Tests-SvenVanCaekenberghe.36';
			package: 'Zinc-HTTP' with: 'Zinc-HTTP-SvenVanCaekenberghe.436';
			package: 'Zinc-Tests' with: 'Zinc-Tests-SvenVanCaekenberghe.233';
			package: 'Zinc-AWS' with: 'Zinc-AWS-SvenVanCaekenberghe.18';
			package: 'Zinc-REST' with: 'Zinc-REST-SvenVanCaekenberghe.18';
			package: 'Zinc-WebDAV' with: 'Zinc-WebDAV-SvenVanCaekenberghe.3';
			package: 'Zinc-WebSocket-Core' with: 'Zinc-WebSocket-Core-LucFabresse.29';
			package: 'Zinc-WebSocket-Tests' with: 'Zinc-WebSocket-Tests-SvenVanCaekenberghe.9';
			package: 'Zinc-SSO-OAuth1-Core' with: 'Zinc-SSO-OAuth1-Core-SvenVanCaekenberghe.13';
			package: 'Zinc-SSO-OAuth2-Core' with: 'Zinc-SSO-OAuth2-Core-JanVanDeSandt.20';
			package: 'Zinc-SSO-OpenID-Core' with: 'Zinc-SSO-OpenID-Core-JanVanDeSandt.6';
			package: 'Zinc-SSO-Demo' with: 'Zinc-SSO-Demo-SvenVanCaekenberghe.5';
			package: 'Zinc-SSO-OAuth1-Tests' with: 'Zinc-SSO-OAuth1-Tests-SvenVanCaekenberghe.2';
			package: 'Zinc-SSO-OpenID-Tests' with: 'Zinc-SSO-OpenID-Tests-JanVanDeSandt.3';
			package: 'Zinc-WWS-Client' with: 'Zinc-WWS-Client-PhilippeBack.3';
			package: 'Zinc-WWS-Server' with: 'Zinc-WWS-Server-SvenVanCaekenberghe.11';
			package: 'Zinc-Zodiac' with: 'Zinc-Zodiac-SvenVanCaekenberghe.35';
			package: 'Zodiac-Core' with: 'Zodiac-Core-SvenVanCaekenberghe.42';
			package: 'Zodiac-Tests' with: 'Zodiac-Tests-SvenVanCaekenberghe.13';
			package: 'Zinc-Seaside' with: 'Zinc-Seaside-JohanBrichau.43' ].
	spec for: #'pharo1.x' do: [ 
		spec 
			package: 'Zinc-Patch-HTTPSocket' with: 'Zinc-Patch-HTTPSocket-SvenVanCaekenberghe.1';
			package: 'Zinc-FileSystem-Legacy' with: 'Zinc-FileSystem-Legacy-SvenVanCaekenberghe.5';
			package: 'Zinc-Pharo-Forward-Compatibility' with: 'Zinc-Pharo-Forward-Compatibility-SvenVanCaekenberghe.1' ].
	spec for: #'pharo2.x' do: [ 
		spec 
			package: 'Zinc-Patch-HTTPSocket' with: 'Zinc-Patch-HTTPSocket-MarcusDenker.4';
			package: 'Zinc-FileSystem' with: 'Zinc-FileSystem-SvenVanCaekenberghe.10';
			package: 'Zinc-Resource-Meta-FileSystem' with: 'Zinc-Resource-Meta-FileSystem-SvenVanCaekenberghe.7';
			package: 'Zinc-pharo2-forward-compatibility' with: 'Zinc-pharo2-forward-compatibility-SvenVanCaekenberghe.1' ].
	spec for: #'pharo3.x' do: [ 
		spec 
			package: 'Zinc-FileSystem' with: 'Zinc-FileSystem-SvenVanCaekenberghe.10';
			package: 'Zinc-Resource-Meta-FileSystem' with: 'Zinc-Resource-Meta-FileSystem-SvenVanCaekenberghe.7' ]
]

{ #category : 'versions' }
ConfigurationOfZincHTTPComponents >> version267: spec [
	<version: '2.6.7' imports: #('2.6-baseline')>
	spec for: #pharo do: [ 
		spec 
			blessing: #release;
			description: 'Update to latest package versions';
			author: 'SvenVanCaekenberghe';
			package: 'Zinc-Character-Encoding-Core' with: 'Zinc-Character-Encoding-Core-SvenVanCaekenberghe.41';
			package: 'Zinc-Character-Encoding-Tests' with: 'Zinc-Character-Encoding-Tests-SvenVanCaekenberghe.23';
			package: 'Zinc-Resource-Meta-Core' with: 'Zinc-Resource-Meta-Core-SvenVanCaekenberghe.55';
			package: 'Zinc-Resource-Meta-Tests' with: 'Zinc-Resource-Meta-Tests-SvenVanCaekenberghe.36';
			package: 'Zinc-HTTP' with: 'Zinc-HTTP-SvenVanCaekenberghe.440';
			package: 'Zinc-Tests' with: 'Zinc-Tests-SvenVanCaekenberghe.235';
			package: 'Zinc-AWS' with: 'Zinc-AWS-SvenVanCaekenberghe.18';
			package: 'Zinc-REST' with: 'Zinc-REST-HolgerHansPeterFreyther.19';
			package: 'Zinc-WebDAV' with: 'Zinc-WebDAV-SvenVanCaekenberghe.3';
			package: 'Zinc-WebSocket-Core' with: 'Zinc-WebSocket-Core-LucFabresse.29';
			package: 'Zinc-WebSocket-Tests' with: 'Zinc-WebSocket-Tests-LucFabresse.9';
			package: 'Zinc-SSO-OAuth1-Core' with: 'Zinc-SSO-OAuth1-Core-SvenVanCaekenberghe.13';
			package: 'Zinc-SSO-OAuth2-Core' with: 'Zinc-SSO-OAuth2-Core-JanVanDeSandt.20';
			package: 'Zinc-SSO-OpenID-Core' with: 'Zinc-SSO-OpenID-Core-JanVanDeSandt.6';
			package: 'Zinc-SSO-Demo' with: 'Zinc-SSO-Demo-SvenVanCaekenberghe.5';
			package: 'Zinc-SSO-OAuth1-Tests' with: 'Zinc-SSO-OAuth1-Tests-SvenVanCaekenberghe.2';
			package: 'Zinc-SSO-OpenID-Tests' with: 'Zinc-SSO-OpenID-Tests-JanVanDeSandt.3';
			package: 'Zinc-WWS-Client' with: 'Zinc-WWS-Client-PhilippeBack.3';
			package: 'Zinc-WWS-Server' with: 'Zinc-WWS-Server-SvenVanCaekenberghe.11';
			package: 'Zinc-Zodiac' with: 'Zinc-Zodiac-SvenVanCaekenberghe.35';
			package: 'Zodiac-Core' with: 'Zodiac-Core-SvenVanCaekenberghe.42';
			package: 'Zodiac-Tests' with: 'Zodiac-Tests-SvenVanCaekenberghe.13';
			package: 'Zinc-Seaside' with: 'Zinc-Seaside-JohanBrichau.43' ].
	spec for: #'pharo1.x' do: [ 
		spec 
			package: 'Zinc-Patch-HTTPSocket' with: 'Zinc-Patch-HTTPSocket-SvenVanCaekenberghe.1';
			package: 'Zinc-FileSystem-Legacy' with: 'Zinc-FileSystem-Legacy-SvenVanCaekenberghe.5';
			package: 'Zinc-Pharo-Forward-Compatibility' with: 'Zinc-Pharo-Forward-Compatibility-SvenVanCaekenberghe.1' ].
	spec for: #'pharo2.x' do: [ 
		spec 
			package: 'Zinc-Patch-HTTPSocket' with: 'Zinc-Patch-HTTPSocket-MarcusDenker.4';
			package: 'Zinc-FileSystem' with: 'Zinc-FileSystem-SvenVanCaekenberghe.10';
			package: 'Zinc-Resource-Meta-FileSystem' with: 'Zinc-Resource-Meta-FileSystem-SvenVanCaekenberghe.8';
			package: 'Zinc-pharo2-forward-compatibility' with: 'Zinc-pharo2-forward-compatibility-SvenVanCaekenberghe.1' ].
	spec for: #'pharo3.x' do: [ 
		spec 
			package: 'Zinc-FileSystem' with: 'Zinc-FileSystem-SvenVanCaekenberghe.10';
			package: 'Zinc-Resource-Meta-FileSystem' with: 'Zinc-Resource-Meta-FileSystem-SvenVanCaekenberghe.8' ]
]

{ #category : 'versions' }
ConfigurationOfZincHTTPComponents >> version268: spec [
	<version: '2.6.8' imports: #('2.6-baseline')>
	spec for: #pharo do: [ 
		spec 
			blessing: #release;
			description: 'Update to latest package versions';
			author: 'SvenVanCaekenberghe';
			package: 'Zinc-Character-Encoding-Core' with: 'Zinc-Character-Encoding-Core-SvenVanCaekenberghe.45';
			package: 'Zinc-Character-Encoding-Tests' with: 'Zinc-Character-Encoding-Tests-SvenVanCaekenberghe.27';
			package: 'Zinc-Resource-Meta-Core' with: 'Zinc-Resource-Meta-Core-PavelKrivanek.56';
			package: 'Zinc-Resource-Meta-Tests' with: 'Zinc-Resource-Meta-Tests-SvenVanCaekenberghe.36';
			package: 'Zinc-HTTP' with: 'Zinc-HTTP-SvenVanCaekenberghe.447';
			package: 'Zinc-Tests' with: 'Zinc-Tests-SvenVanCaekenberghe.236';
			package: 'Zinc-AWS' with: 'Zinc-AWS-SvenVanCaekenberghe.18';
			package: 'Zinc-REST' with: 'Zinc-REST-HolgerHansPeterFreyther.20';
			package: 'Zinc-WebDAV' with: 'Zinc-WebDAV-SvenVanCaekenberghe.3';
			package: 'Zinc-WebSocket-Core' with: 'Zinc-WebSocket-Core-LucFabresse.29';
			package: 'Zinc-WebSocket-Tests' with: 'Zinc-WebSocket-Tests-LucFabresse.9';
			package: 'Zinc-SSO-OAuth1-Core' with: 'Zinc-SSO-OAuth1-Core-SvenVanCaekenberghe.13';
			package: 'Zinc-SSO-OAuth2-Core' with: 'Zinc-SSO-OAuth2-Core-JanVanDeSandt.20';
			package: 'Zinc-SSO-OpenID-Core' with: 'Zinc-SSO-OpenID-Core-JanVanDeSandt.6';
			package: 'Zinc-SSO-Demo' with: 'Zinc-SSO-Demo-SvenVanCaekenberghe.5';
			package: 'Zinc-SSO-OAuth1-Tests' with: 'Zinc-SSO-OAuth1-Tests-SvenVanCaekenberghe.2';
			package: 'Zinc-SSO-OpenID-Tests' with: 'Zinc-SSO-OpenID-Tests-JanVanDeSandt.3';
			package: 'Zinc-WWS-Client' with: 'Zinc-WWS-Client-PhilippeBack.3';
			package: 'Zinc-WWS-Server' with: 'Zinc-WWS-Server-SvenVanCaekenberghe.11';
			package: 'Zinc-Zodiac' with: 'Zinc-Zodiac-SvenVanCaekenberghe.35';
			package: 'Zodiac-Core' with: 'Zodiac-Core-SvenVanCaekenberghe.42';
			package: 'Zodiac-Tests' with: 'Zodiac-Tests-SvenVanCaekenberghe.13';
			package: 'Zinc-Seaside' with: 'Zinc-Seaside-JohanBrichau.43' ].
	spec for: #'pharo1.x' do: [ 
		spec 
			package: 'Zinc-Patch-HTTPSocket' with: 'Zinc-Patch-HTTPSocket-SvenVanCaekenberghe.1';
			package: 'Zinc-FileSystem-Legacy' with: 'Zinc-FileSystem-Legacy-SvenVanCaekenberghe.5';
			package: 'Zinc-Pharo-Forward-Compatibility' with: 'Zinc-Pharo-Forward-Compatibility-SvenVanCaekenberghe.1' ].
	spec for: #'pharo2.x' do: [ 
		spec 
			package: 'Zinc-Patch-HTTPSocket' with: 'Zinc-Patch-HTTPSocket-MarcusDenker.4';
			package: 'Zinc-FileSystem' with: 'Zinc-FileSystem-SvenVanCaekenberghe.12';
			package: 'Zinc-Resource-Meta-FileSystem' with: 'Zinc-Resource-Meta-FileSystem-SvenVanCaekenberghe.8';
			package: 'Zinc-pharo2-forward-compatibility' with: 'Zinc-pharo2-forward-compatibility-SvenVanCaekenberghe.1' ].
	spec for: #'pharo3.x' do: [ 
		spec 
			package: 'Zinc-FileSystem' with: 'Zinc-FileSystem-SvenVanCaekenberghe.12';
			package: 'Zinc-Resource-Meta-FileSystem' with: 'Zinc-Resource-Meta-FileSystem-SvenVanCaekenberghe.8' ]
]

{ #category : 'versions' }
ConfigurationOfZincHTTPComponents >> version270: spec [
	<version: '2.7.0' imports: #('2.7-baseline')>
	spec for: #pharo do: [ 
		spec 
			blessing: #release;
			description: 'Update to latest package versions';
			author: 'SvenVanCaekenberghe';
			package: 'Zinc-Character-Encoding-Core' with: 'Zinc-Character-Encoding-Core-SvenVanCaekenberghe.45';
			package: 'Zinc-Character-Encoding-Tests' with: 'Zinc-Character-Encoding-Tests-SvenVanCaekenberghe.27';
			package: 'Zinc-Resource-Meta-Core' with: 'Zinc-Resource-Meta-Core-PavelKrivanek.56';
			package: 'Zinc-Resource-Meta-Tests' with: 'Zinc-Resource-Meta-Tests-SvenVanCaekenberghe.36';
			package: 'Zinc-HTTP' with: 'Zinc-HTTP-SvenVanCaekenberghe.447';
			package: 'Zinc-Tests' with: 'Zinc-Tests-SvenVanCaekenberghe.236';
			package: 'Zinc-AWS' with: 'Zinc-AWS-SvenVanCaekenberghe.18';
			package: 'Zinc-REST' with: 'Zinc-REST-HolgerHansPeterFreyther.20';
			package: 'Zinc-WebDAV' with: 'Zinc-WebDAV-SvenVanCaekenberghe.3';
			package: 'Zinc-WebSocket-Core' with: 'Zinc-WebSocket-Core-LucFabresse.29';
			package: 'Zinc-WebSocket-Tests' with: 'Zinc-WebSocket-Tests-LucFabresse.9';
			package: 'Zinc-SSO-OAuth1-Core' with: 'Zinc-SSO-OAuth1-Core-SvenVanCaekenberghe.13';
			package: 'Zinc-SSO-OAuth2-Core' with: 'Zinc-SSO-OAuth2-Core-JanVanDeSandt.20';
			package: 'Zinc-SSO-OpenID-Core' with: 'Zinc-SSO-OpenID-Core-JanVanDeSandt.6';
			package: 'Zinc-SSO-Demo' with: 'Zinc-SSO-Demo-SvenVanCaekenberghe.5';
			package: 'Zinc-SSO-OAuth1-Tests' with: 'Zinc-SSO-OAuth1-Tests-SvenVanCaekenberghe.2';
			package: 'Zinc-SSO-OpenID-Tests' with: 'Zinc-SSO-OpenID-Tests-JanVanDeSandt.3';
			package: 'Zinc-WWS-Client' with: 'Zinc-WWS-Client-PhilippeBack.3';
			package: 'Zinc-WWS-Server' with: 'Zinc-WWS-Server-SvenVanCaekenberghe.11';
			package: 'Zinc-Zodiac' with: 'Zinc-Zodiac-SvenVanCaekenberghe.35';
			package: 'Zodiac-Core' with: 'Zodiac-Core-SvenVanCaekenberghe.42';
			package: 'Zodiac-Tests' with: 'Zodiac-Tests-SvenVanCaekenberghe.13';
			package: 'Zinc-Seaside' with: 'Zinc-Seaside-JohanBrichau.43' ].
	spec for: #'pharo1.x' do: [ 
		spec 
			package: 'Zinc-Patch-HTTPSocket' with: 'Zinc-Patch-HTTPSocket-SvenVanCaekenberghe.1';
			package: 'Zinc-FileSystem-Legacy' with: 'Zinc-FileSystem-Legacy-SvenVanCaekenberghe.5';
			package: 'Zinc-Pharo-Forward-Compatibility' with: 'Zinc-Pharo-Forward-Compatibility-SvenVanCaekenberghe.1' ].
	spec for: #'pharo2.x' do: [ 
		spec 
			package: 'Zinc-Patch-HTTPSocket' with: 'Zinc-Patch-HTTPSocket-MarcusDenker.4';
			package: 'Zinc-FileSystem' with: 'Zinc-FileSystem-SvenVanCaekenberghe.12';
			package: 'Zinc-Resource-Meta-FileSystem' with: 'Zinc-Resource-Meta-FileSystem-SvenVanCaekenberghe.8';
			package: 'Zinc-pharo2-forward-compatibility' with: 'Zinc-pharo2-forward-compatibility-SvenVanCaekenberghe.1' ].
	spec for: #'pharo3.x' do: [ 
		spec 
			package: 'Zinc-FileSystem' with: 'Zinc-FileSystem-SvenVanCaekenberghe.12';
			package: 'Zinc-Resource-Meta-FileSystem' with: 'Zinc-Resource-Meta-FileSystem-SvenVanCaekenberghe.8' ].
	spec for: #'pharo4.x' do: [ 
		spec 
			package: 'Zinc-FileSystem' with: 'Zinc-FileSystem-SvenVanCaekenberghe.12';
			package: 'Zinc-Resource-Meta-FileSystem' with: 'Zinc-Resource-Meta-FileSystem-SvenVanCaekenberghe.8' ].
	spec for: #'pharo5.x' do: [ 
		spec 
			package: 'Zinc-FileSystem' with: 'Zinc-FileSystem-SvenVanCaekenberghe.12';
			package: 'Zinc-Resource-Meta-FileSystem' with: 'Zinc-Resource-Meta-FileSystem-SvenVanCaekenberghe.8' ]
]

{ #category : 'versions' }
ConfigurationOfZincHTTPComponents >> version271: spec [
	<version: '2.7.1' imports: #('2.7-baseline')>
	spec for: #pharo do: [ 
		spec 
			blessing: #release;
			description: 'Update to latest package versions';
			author: 'SvenVanCaekenberghe';
			package: 'Zinc-Character-Encoding-Core' with: 'Zinc-Character-Encoding-Core-SvenVanCaekenberghe.45';
			package: 'Zinc-Character-Encoding-Tests' with: 'Zinc-Character-Encoding-Tests-SvenVanCaekenberghe.27';
			package: 'Zinc-Resource-Meta-Core' with: 'Zinc-Resource-Meta-Core-PavelKrivanek.56';
			package: 'Zinc-Resource-Meta-Tests' with: 'Zinc-Resource-Meta-Tests-SvenVanCaekenberghe.36';
			package: 'Zinc-HTTP' with: 'Zinc-HTTP-SvenVanCaekenberghe.448';
			package: 'Zinc-Tests' with: 'Zinc-Tests-SvenVanCaekenberghe.236';
			package: 'Zinc-AWS' with: 'Zinc-AWS-SvenVanCaekenberghe.18';
			package: 'Zinc-REST' with: 'Zinc-REST-HolgerHansPeterFreyther.20';
			package: 'Zinc-WebDAV' with: 'Zinc-WebDAV-SvenVanCaekenberghe.3';
			package: 'Zinc-WebSocket-Core' with: 'Zinc-WebSocket-Core-LucFabresse.29';
			package: 'Zinc-WebSocket-Tests' with: 'Zinc-WebSocket-Tests-LucFabresse.9';
			package: 'Zinc-SSO-OAuth1-Core' with: 'Zinc-SSO-OAuth1-Core-SvenVanCaekenberghe.13';
			package: 'Zinc-SSO-OAuth2-Core' with: 'Zinc-SSO-OAuth2-Core-JanVanDeSandt.20';
			package: 'Zinc-SSO-OpenID-Core' with: 'Zinc-SSO-OpenID-Core-JanVanDeSandt.6';
			package: 'Zinc-SSO-Demo' with: 'Zinc-SSO-Demo-SvenVanCaekenberghe.5';
			package: 'Zinc-SSO-OAuth1-Tests' with: 'Zinc-SSO-OAuth1-Tests-SvenVanCaekenberghe.2';
			package: 'Zinc-SSO-OpenID-Tests' with: 'Zinc-SSO-OpenID-Tests-JanVanDeSandt.3';
			package: 'Zinc-WWS-Client' with: 'Zinc-WWS-Client-PhilippeBack.3';
			package: 'Zinc-WWS-Server' with: 'Zinc-WWS-Server-SvenVanCaekenberghe.11';
			package: 'Zinc-Zodiac' with: 'Zinc-Zodiac-SvenVanCaekenberghe.35';
			package: 'Zodiac-Core' with: 'Zodiac-Core-SvenVanCaekenberghe.42';
			package: 'Zodiac-Tests' with: 'Zodiac-Tests-SvenVanCaekenberghe.13';
			package: 'Zinc-Seaside' with: 'Zinc-Seaside-JohanBrichau.43' ].
	spec for: #'pharo1.x' do: [ 
		spec 
			package: 'Zinc-Patch-HTTPSocket' with: 'Zinc-Patch-HTTPSocket-SvenVanCaekenberghe.1';
			package: 'Zinc-FileSystem-Legacy' with: 'Zinc-FileSystem-Legacy-SvenVanCaekenberghe.5';
			package: 'Zinc-Pharo-Forward-Compatibility' with: 'Zinc-Pharo-Forward-Compatibility-SvenVanCaekenberghe.1' ].
	spec for: #'pharo2.x' do: [ 
		spec 
			package: 'Zinc-Patch-HTTPSocket' with: 'Zinc-Patch-HTTPSocket-MarcusDenker.4';
			package: 'Zinc-FileSystem' with: 'Zinc-FileSystem-SvenVanCaekenberghe.12';
			package: 'Zinc-Resource-Meta-FileSystem' with: 'Zinc-Resource-Meta-FileSystem-SvenVanCaekenberghe.8';
			package: 'Zinc-pharo2-forward-compatibility' with: 'Zinc-pharo2-forward-compatibility-SvenVanCaekenberghe.1' ].
	spec for: #'pharo3.x' do: [ 
		spec 
			package: 'Zinc-FileSystem' with: 'Zinc-FileSystem-SvenVanCaekenberghe.12';
			package: 'Zinc-Resource-Meta-FileSystem' with: 'Zinc-Resource-Meta-FileSystem-SvenVanCaekenberghe.8' ].
	spec for: #'pharo4.x' do: [ 
		spec 
			package: 'Zinc-FileSystem' with: 'Zinc-FileSystem-SvenVanCaekenberghe.12';
			package: 'Zinc-Resource-Meta-FileSystem' with: 'Zinc-Resource-Meta-FileSystem-SvenVanCaekenberghe.8' ].
	spec for: #'pharo5.x' do: [ 
		spec 
			package: 'Zinc-FileSystem' with: 'Zinc-FileSystem-SvenVanCaekenberghe.12';
			package: 'Zinc-Resource-Meta-FileSystem' with: 'Zinc-Resource-Meta-FileSystem-SvenVanCaekenberghe.8' ]
]

{ #category : 'versions' }
ConfigurationOfZincHTTPComponents >> version280: spec [
	<version: '2.8.0' imports: #('2.8-baseline')>
	spec for: #pharo do: [ 
		spec 
			blessing: #release;
			description: 'Update to latest package versions';
			author: 'SvenVanCaekenberghe';
			package: 'Zinc-Character-Encoding-Core' with: 'Zinc-Character-Encoding-Core-SvenVanCaekenberghe.45';
			package: 'Zinc-Character-Encoding-Tests' with: 'Zinc-Character-Encoding-Tests-SvenVanCaekenberghe.27';
			package: 'Zinc-Resource-Meta-Core' with: 'Zinc-Resource-Meta-Core-PavelKrivanek.56';
			package: 'Zinc-Resource-Meta-Tests' with: 'Zinc-Resource-Meta-Tests-SvenVanCaekenberghe.36';
			package: 'Zinc-HTTP' with: 'Zinc-HTTP-SvenVanCaekenberghe.448';
			package: 'Zinc-Tests' with: 'Zinc-Tests-SvenVanCaekenberghe.236';
			package: 'Zinc-AWS' with: 'Zinc-AWS-SvenVanCaekenberghe.18';
			package: 'Zinc-REST' with: 'Zinc-REST-HolgerHansPeterFreyther.20';
			package: 'Zinc-WebDAV' with: 'Zinc-WebDAV-SvenVanCaekenberghe.3';
			package: 'Zinc-WebSocket-Core' with: 'Zinc-WebSocket-Core-LucFabresse.29';
			package: 'Zinc-WebSocket-Tests' with: 'Zinc-WebSocket-Tests-LucFabresse.9';
			package: 'Zinc-SSO-OAuth1-Core' with: 'Zinc-SSO-OAuth1-Core-SvenVanCaekenberghe.13';
			package: 'Zinc-SSO-OAuth2-Core' with: 'Zinc-SSO-OAuth2-Core-JanVanDeSandt.20';
			package: 'Zinc-SSO-OpenID-Core' with: 'Zinc-SSO-OpenID-Core-JanVanDeSandt.6';
			package: 'Zinc-SSO-Demo' with: 'Zinc-SSO-Demo-SvenVanCaekenberghe.5';
			package: 'Zinc-SSO-OAuth1-Tests' with: 'Zinc-SSO-OAuth1-Tests-SvenVanCaekenberghe.2';
			package: 'Zinc-SSO-OpenID-Tests' with: 'Zinc-SSO-OpenID-Tests-JanVanDeSandt.3';
			package: 'Zinc-WWS-Client' with: 'Zinc-WWS-Client-PhilippeBack.3';
			package: 'Zinc-WWS-Server' with: 'Zinc-WWS-Server-SvenVanCaekenberghe.11';
			package: 'Zinc-Zodiac' with: 'Zinc-Zodiac-SvenVanCaekenberghe.35';
			package: 'Zodiac-Core' with: 'Zodiac-Core-SvenVanCaekenberghe.42';
			package: 'Zodiac-Tests' with: 'Zodiac-Tests-SvenVanCaekenberghe.13';
			package: 'Zinc-Seaside' with: 'Zinc-Seaside-JohanBrichau.43' ].
	spec for: #'pharo1.x' do: [ 
		spec 
			package: 'Zinc-Patch-HTTPSocket' with: 'Zinc-Patch-HTTPSocket-SvenVanCaekenberghe.1';
			package: 'Zinc-FileSystem-Legacy' with: 'Zinc-FileSystem-Legacy-SvenVanCaekenberghe.5';
			package: 'Zinc-Pharo-Forward-Compatibility' with: 'Zinc-Pharo-Forward-Compatibility-SvenVanCaekenberghe.1' ].
	spec for: #'pharo2.x' do: [ 
		spec 
			package: 'Zinc-Patch-HTTPSocket' with: 'Zinc-Patch-HTTPSocket-MarcusDenker.4';
			package: 'Zinc-FileSystem' with: 'Zinc-FileSystem-SvenVanCaekenberghe.12';
			package: 'Zinc-Resource-Meta-FileSystem' with: 'Zinc-Resource-Meta-FileSystem-SvenVanCaekenberghe.8';
			package: 'Zinc-pharo2-forward-compatibility' with: 'Zinc-pharo2-forward-compatibility-SvenVanCaekenberghe.1' ].
	spec for: #'pharo3.x' do: [ 
		spec 
			package: 'Zinc-FileSystem' with: 'Zinc-FileSystem-SvenVanCaekenberghe.12';
			package: 'Zinc-Resource-Meta-FileSystem' with: 'Zinc-Resource-Meta-FileSystem-SvenVanCaekenberghe.8' ].
	spec for: #'pharo4.x' do: [ 
		spec 
			package: 'Zinc-FileSystem' with: 'Zinc-FileSystem-SvenVanCaekenberghe.12';
			package: 'Zinc-Resource-Meta-FileSystem' with: 'Zinc-Resource-Meta-FileSystem-SvenVanCaekenberghe.8' ].
	spec for: #'pharo5.x' do: [ 
		spec 
			package: 'Zinc-FileSystem' with: 'Zinc-FileSystem-SvenVanCaekenberghe.12';
			package: 'Zinc-Resource-Meta-FileSystem' with: 'Zinc-Resource-Meta-FileSystem-SvenVanCaekenberghe.8' ].
	spec for: #'pharo6.x' do: [ 
		spec 
			package: 'Zinc-FileSystem' with: 'Zinc-FileSystem-SvenVanCaekenberghe.12';
			package: 'Zinc-Resource-Meta-FileSystem' with: 'Zinc-Resource-Meta-FileSystem-SvenVanCaekenberghe.8' ]
]

{ #category : 'versions' }
ConfigurationOfZincHTTPComponents >> version2810: spec [
	<version: '2.8.10' imports: #('2.8-baseline')>
	spec for: #pharo do: [ 
		spec 
			blessing: #release;
			description: 'Update to latest package versions';
			author: 'SvenVanCaekenberghe';
			package: 'Zinc-Character-Encoding-Core' with: 'Zinc-Character-Encoding-Core-SvenVanCaekenberghe.56';
			package: 'Zinc-Character-Encoding-Tests' with: 'Zinc-Character-Encoding-Tests-SvenVanCaekenberghe.37';
			package: 'Zinc-Resource-Meta-Core' with: 'Zinc-Resource-Meta-Core-SvenVanCaekenberghe.66';
			package: 'Zinc-Resource-Meta-Tests' with: 'Zinc-Resource-Meta-Tests-SvenVanCaekenberghe.38';
			package: 'Zinc-HTTP' with: 'Zinc-HTTP-SvenVanCaekenberghe.471';
			package: 'Zinc-Tests' with: 'Zinc-Tests-SvenVanCaekenberghe.244';
			package: 'Zinc-AWS' with: 'Zinc-AWS-SvenVanCaekenberghe.18';
			package: 'Zinc-REST' with: 'Zinc-REST-HolgerHansPeterFreyther.20';
			package: 'Zinc-WebDAV' with: 'Zinc-WebDAV-SvenVanCaekenberghe.3';
			package: 'Zinc-WebSocket-Core' with: 'Zinc-WebSocket-Core-SvenVanCaekenberghe.30';
			package: 'Zinc-WebSocket-Tests' with: 'Zinc-WebSocket-Tests-LucFabresse.9';
			package: 'Zinc-SSO-OAuth1-Core' with: 'Zinc-SSO-OAuth1-Core-SvenVanCaekenberghe.13';
			package: 'Zinc-SSO-OAuth2-Core' with: 'Zinc-SSO-OAuth2-Core-JanVanDeSandt.20';
			package: 'Zinc-SSO-OpenID-Core' with: 'Zinc-SSO-OpenID-Core-JanVanDeSandt.6';
			package: 'Zinc-SSO-Demo' with: 'Zinc-SSO-Demo-SvenVanCaekenberghe.5';
			package: 'Zinc-SSO-OAuth1-Tests' with: 'Zinc-SSO-OAuth1-Tests-SvenVanCaekenberghe.2';
			package: 'Zinc-SSO-OpenID-Tests' with: 'Zinc-SSO-OpenID-Tests-JanVanDeSandt.3';
			package: 'Zinc-WWS-Client' with: 'Zinc-WWS-Client-PhilippeBack.3';
			package: 'Zinc-WWS-Server' with: 'Zinc-WWS-Server-SvenVanCaekenberghe.11';
			package: 'Zinc-Zodiac' with: 'Zinc-Zodiac-SvenVanCaekenberghe.40';
			package: 'Zodiac-Core' with: 'Zodiac-Core-TheIntegrator.46';
			package: 'Zodiac-Tests' with: 'Zodiac-Tests-SvenVanCaekenberghe.18';
			package: 'Zinc-Seaside' with: 'Zinc-Seaside-SvenVanCaekenberghe.47' ].
	spec for: #'pharo1.x' do: [ 
		spec 
			package: 'Zinc-Patch-HTTPSocket' with: 'Zinc-Patch-HTTPSocket-SvenVanCaekenberghe.1';
			package: 'Zinc-FileSystem-Legacy' with: 'Zinc-FileSystem-Legacy-SvenVanCaekenberghe.5';
			package: 'Zinc-Pharo-Forward-Compatibility' with: 'Zinc-Pharo-Forward-Compatibility-SvenVanCaekenberghe.1' ].
	spec for: #'pharo2.x' do: [ 
		spec 
			package: 'Zinc-Patch-HTTPSocket' with: 'Zinc-Patch-HTTPSocket-MarcusDenker.4';
			package: 'Zinc-FileSystem' with: 'Zinc-FileSystem-SvenVanCaekenberghe.13';
			package: 'Zinc-Resource-Meta-FileSystem' with: 'Zinc-Resource-Meta-FileSystem-SvenVanCaekenberghe.8';
			package: 'Zinc-pharo2-forward-compatibility' with: 'Zinc-pharo2-forward-compatibility-SvenVanCaekenberghe.1' ].
	spec for: #'pharo3.x' do: [ 
		spec 
			package: 'Zinc-FileSystem' with: 'Zinc-FileSystem-SvenVanCaekenberghe.13';
			package: 'Zinc-Resource-Meta-FileSystem' with: 'Zinc-Resource-Meta-FileSystem-SvenVanCaekenberghe.9' ].
	spec for: #'pharo4.x' do: [ 
		spec 
			package: 'Zinc-FileSystem' with: 'Zinc-FileSystem-SvenVanCaekenberghe.13';
			package: 'Zinc-Resource-Meta-FileSystem' with: 'Zinc-Resource-Meta-FileSystem-SvenVanCaekenberghe.9' ].
	spec for: #'pharo5.x' do: [ 
		spec 
			package: 'Zinc-FileSystem' with: 'Zinc-FileSystem-SvenVanCaekenberghe.13';
			package: 'Zinc-Resource-Meta-FileSystem' with: 'Zinc-Resource-Meta-FileSystem-SvenVanCaekenberghe.9' ].
	spec for: #'pharo6.x' do: [ 
		spec 
			package: 'Zinc-FileSystem' with: 'Zinc-FileSystem-SvenVanCaekenberghe.13';
			package: 'Zinc-Resource-Meta-FileSystem' with: 'Zinc-Resource-Meta-FileSystem-SvenVanCaekenberghe.9' ].
	spec for: #'pharo7.x' do: [ 
		spec 
			package: 'Zinc-FileSystem' with: 'Zinc-FileSystem-SvenVanCaekenberghe.13';
			package: 'Zinc-Resource-Meta-FileSystem' with: 'Zinc-Resource-Meta-FileSystem-SvenVanCaekenberghe.9' ]
]

{ #category : 'versions' }
ConfigurationOfZincHTTPComponents >> version281: spec [
	<version: '2.8.1' imports: #('2.8-baseline')>
	spec for: #pharo do: [ 
		spec 
			blessing: #release;
			description: 'Update to latest package versions';
			author: 'SvenVanCaekenberghe';
			package: 'Zinc-Character-Encoding-Core' with: 'Zinc-Character-Encoding-Core-SvenVanCaekenberghe.45';
			package: 'Zinc-Character-Encoding-Tests' with: 'Zinc-Character-Encoding-Tests-SvenVanCaekenberghe.27';
			package: 'Zinc-Resource-Meta-Core' with: 'Zinc-Resource-Meta-Core-SvenVanCaekenberghe.61';
			package: 'Zinc-Resource-Meta-Tests' with: 'Zinc-Resource-Meta-Tests-SvenVanCaekenberghe.37';
			package: 'Zinc-HTTP' with: 'Zinc-HTTP-SvenVanCaekenberghe.453';
			package: 'Zinc-Tests' with: 'Zinc-Tests-SvenVanCaekenberghe.238';
			package: 'Zinc-AWS' with: 'Zinc-AWS-SvenVanCaekenberghe.18';
			package: 'Zinc-REST' with: 'Zinc-REST-HolgerHansPeterFreyther.20';
			package: 'Zinc-WebDAV' with: 'Zinc-WebDAV-SvenVanCaekenberghe.3';
			package: 'Zinc-WebSocket-Core' with: 'Zinc-WebSocket-Core-LucFabresse.29';
			package: 'Zinc-WebSocket-Tests' with: 'Zinc-WebSocket-Tests-LucFabresse.9';
			package: 'Zinc-SSO-OAuth1-Core' with: 'Zinc-SSO-OAuth1-Core-SvenVanCaekenberghe.13';
			package: 'Zinc-SSO-OAuth2-Core' with: 'Zinc-SSO-OAuth2-Core-JanVanDeSandt.20';
			package: 'Zinc-SSO-OpenID-Core' with: 'Zinc-SSO-OpenID-Core-JanVanDeSandt.6';
			package: 'Zinc-SSO-Demo' with: 'Zinc-SSO-Demo-SvenVanCaekenberghe.5';
			package: 'Zinc-SSO-OAuth1-Tests' with: 'Zinc-SSO-OAuth1-Tests-SvenVanCaekenberghe.2';
			package: 'Zinc-SSO-OpenID-Tests' with: 'Zinc-SSO-OpenID-Tests-JanVanDeSandt.3';
			package: 'Zinc-WWS-Client' with: 'Zinc-WWS-Client-PhilippeBack.3';
			package: 'Zinc-WWS-Server' with: 'Zinc-WWS-Server-SvenVanCaekenberghe.11';
			package: 'Zinc-Zodiac' with: 'Zinc-Zodiac-SvenVanCaekenberghe.36';
			package: 'Zodiac-Core' with: 'Zodiac-Core-SvenVanCaekenberghe.42';
			package: 'Zodiac-Tests' with: 'Zodiac-Tests-SvenVanCaekenberghe.13';
			package: 'Zinc-Seaside' with: 'Zinc-Seaside-JohanBrichau.46' ].
	spec for: #'pharo1.x' do: [ 
		spec 
			package: 'Zinc-Patch-HTTPSocket' with: 'Zinc-Patch-HTTPSocket-SvenVanCaekenberghe.1';
			package: 'Zinc-FileSystem-Legacy' with: 'Zinc-FileSystem-Legacy-SvenVanCaekenberghe.5';
			package: 'Zinc-Pharo-Forward-Compatibility' with: 'Zinc-Pharo-Forward-Compatibility-SvenVanCaekenberghe.1' ].
	spec for: #'pharo2.x' do: [ 
		spec 
			package: 'Zinc-Patch-HTTPSocket' with: 'Zinc-Patch-HTTPSocket-MarcusDenker.4';
			package: 'Zinc-FileSystem' with: 'Zinc-FileSystem-SvenVanCaekenberghe.12';
			package: 'Zinc-Resource-Meta-FileSystem' with: 'Zinc-Resource-Meta-FileSystem-SvenVanCaekenberghe.8';
			package: 'Zinc-pharo2-forward-compatibility' with: 'Zinc-pharo2-forward-compatibility-SvenVanCaekenberghe.1' ].
	spec for: #'pharo3.x' do: [ 
		spec 
			package: 'Zinc-FileSystem' with: 'Zinc-FileSystem-SvenVanCaekenberghe.12';
			package: 'Zinc-Resource-Meta-FileSystem' with: 'Zinc-Resource-Meta-FileSystem-SvenVanCaekenberghe.8' ].
	spec for: #'pharo4.x' do: [ 
		spec 
			package: 'Zinc-FileSystem' with: 'Zinc-FileSystem-SvenVanCaekenberghe.12';
			package: 'Zinc-Resource-Meta-FileSystem' with: 'Zinc-Resource-Meta-FileSystem-SvenVanCaekenberghe.8' ].
	spec for: #'pharo5.x' do: [ 
		spec 
			package: 'Zinc-FileSystem' with: 'Zinc-FileSystem-SvenVanCaekenberghe.12';
			package: 'Zinc-Resource-Meta-FileSystem' with: 'Zinc-Resource-Meta-FileSystem-SvenVanCaekenberghe.8' ].
	spec for: #'pharo6.x' do: [ 
		spec 
			package: 'Zinc-FileSystem' with: 'Zinc-FileSystem-SvenVanCaekenberghe.12';
			package: 'Zinc-Resource-Meta-FileSystem' with: 'Zinc-Resource-Meta-FileSystem-SvenVanCaekenberghe.8' ]
]

{ #category : 'versions' }
ConfigurationOfZincHTTPComponents >> version282: spec [
	<version: '2.8.2' imports: #('2.8-baseline')>
	spec for: #pharo do: [ 
		spec 
			blessing: #release;
			description: 'Update to latest package versions';
			author: 'SvenVanCaekenberghe';
			package: 'Zinc-Character-Encoding-Core' with: 'Zinc-Character-Encoding-Core-SvenVanCaekenberghe.45';
			package: 'Zinc-Character-Encoding-Tests' with: 'Zinc-Character-Encoding-Tests-SvenVanCaekenberghe.27';
			package: 'Zinc-Resource-Meta-Core' with: 'Zinc-Resource-Meta-Core-SvenVanCaekenberghe.61';
			package: 'Zinc-Resource-Meta-Tests' with: 'Zinc-Resource-Meta-Tests-SvenVanCaekenberghe.37';
			package: 'Zinc-HTTP' with: 'Zinc-HTTP-SvenVanCaekenberghe.453';
			package: 'Zinc-Tests' with: 'Zinc-Tests-SvenVanCaekenberghe.238';
			package: 'Zinc-AWS' with: 'Zinc-AWS-SvenVanCaekenberghe.18';
			package: 'Zinc-REST' with: 'Zinc-REST-HolgerHansPeterFreyther.20';
			package: 'Zinc-WebDAV' with: 'Zinc-WebDAV-SvenVanCaekenberghe.3';
			package: 'Zinc-WebSocket-Core' with: 'Zinc-WebSocket-Core-LucFabresse.29';
			package: 'Zinc-WebSocket-Tests' with: 'Zinc-WebSocket-Tests-LucFabresse.9';
			package: 'Zinc-SSO-OAuth1-Core' with: 'Zinc-SSO-OAuth1-Core-SvenVanCaekenberghe.13';
			package: 'Zinc-SSO-OAuth2-Core' with: 'Zinc-SSO-OAuth2-Core-JanVanDeSandt.20';
			package: 'Zinc-SSO-OpenID-Core' with: 'Zinc-SSO-OpenID-Core-JanVanDeSandt.6';
			package: 'Zinc-SSO-Demo' with: 'Zinc-SSO-Demo-SvenVanCaekenberghe.5';
			package: 'Zinc-SSO-OAuth1-Tests' with: 'Zinc-SSO-OAuth1-Tests-SvenVanCaekenberghe.2';
			package: 'Zinc-SSO-OpenID-Tests' with: 'Zinc-SSO-OpenID-Tests-JanVanDeSandt.3';
			package: 'Zinc-WWS-Client' with: 'Zinc-WWS-Client-PhilippeBack.3';
			package: 'Zinc-WWS-Server' with: 'Zinc-WWS-Server-SvenVanCaekenberghe.11';
			package: 'Zinc-Zodiac' with: 'Zinc-Zodiac-SvenVanCaekenberghe.36';
			package: 'Zodiac-Core' with: 'Zodiac-Core-SvenVanCaekenberghe.42';
			package: 'Zodiac-Tests' with: 'Zodiac-Tests-SvenVanCaekenberghe.13';
			package: 'Zinc-Seaside' with: 'Zinc-Seaside-SvenVanCaekenberghe.46' ].
	spec for: #'pharo1.x' do: [ 
		spec 
			package: 'Zinc-Patch-HTTPSocket' with: 'Zinc-Patch-HTTPSocket-SvenVanCaekenberghe.1';
			package: 'Zinc-FileSystem-Legacy' with: 'Zinc-FileSystem-Legacy-SvenVanCaekenberghe.5';
			package: 'Zinc-Pharo-Forward-Compatibility' with: 'Zinc-Pharo-Forward-Compatibility-SvenVanCaekenberghe.1' ].
	spec for: #'pharo2.x' do: [ 
		spec 
			package: 'Zinc-Patch-HTTPSocket' with: 'Zinc-Patch-HTTPSocket-MarcusDenker.4';
			package: 'Zinc-FileSystem' with: 'Zinc-FileSystem-SvenVanCaekenberghe.12';
			package: 'Zinc-Resource-Meta-FileSystem' with: 'Zinc-Resource-Meta-FileSystem-SvenVanCaekenberghe.8';
			package: 'Zinc-pharo2-forward-compatibility' with: 'Zinc-pharo2-forward-compatibility-SvenVanCaekenberghe.1' ].
	spec for: #'pharo3.x' do: [ 
		spec 
			package: 'Zinc-FileSystem' with: 'Zinc-FileSystem-SvenVanCaekenberghe.12';
			package: 'Zinc-Resource-Meta-FileSystem' with: 'Zinc-Resource-Meta-FileSystem-SvenVanCaekenberghe.8' ].
	spec for: #'pharo4.x' do: [ 
		spec 
			package: 'Zinc-FileSystem' with: 'Zinc-FileSystem-SvenVanCaekenberghe.12';
			package: 'Zinc-Resource-Meta-FileSystem' with: 'Zinc-Resource-Meta-FileSystem-SvenVanCaekenberghe.8' ].
	spec for: #'pharo5.x' do: [ 
		spec 
			package: 'Zinc-FileSystem' with: 'Zinc-FileSystem-SvenVanCaekenberghe.12';
			package: 'Zinc-Resource-Meta-FileSystem' with: 'Zinc-Resource-Meta-FileSystem-SvenVanCaekenberghe.8' ].
	spec for: #'pharo6.x' do: [ 
		spec 
			package: 'Zinc-FileSystem' with: 'Zinc-FileSystem-SvenVanCaekenberghe.12';
			package: 'Zinc-Resource-Meta-FileSystem' with: 'Zinc-Resource-Meta-FileSystem-SvenVanCaekenberghe.8' ]
]

{ #category : 'versions' }
ConfigurationOfZincHTTPComponents >> version283: spec [
	<version: '2.8.3' imports: #('2.8-baseline')>
	spec for: #pharo do: [ 
		spec 
			blessing: #release;
			description: 'Update to latest package versions';
			author: 'SvenVanCaekenberghe';
			package: 'Zinc-Character-Encoding-Core' with: 'Zinc-Character-Encoding-Core-SvenVanCaekenberghe.46';
			package: 'Zinc-Character-Encoding-Tests' with: 'Zinc-Character-Encoding-Tests-SvenVanCaekenberghe.29';
			package: 'Zinc-Resource-Meta-Core' with: 'Zinc-Resource-Meta-Core-SvenVanCaekenberghe.61';
			package: 'Zinc-Resource-Meta-Tests' with: 'Zinc-Resource-Meta-Tests-SvenVanCaekenberghe.37';
			package: 'Zinc-HTTP' with: 'Zinc-HTTP-SvenVanCaekenberghe.453';
			package: 'Zinc-Tests' with: 'Zinc-Tests-SvenVanCaekenberghe.238';
			package: 'Zinc-AWS' with: 'Zinc-AWS-SvenVanCaekenberghe.18';
			package: 'Zinc-REST' with: 'Zinc-REST-HolgerHansPeterFreyther.20';
			package: 'Zinc-WebDAV' with: 'Zinc-WebDAV-SvenVanCaekenberghe.3';
			package: 'Zinc-WebSocket-Core' with: 'Zinc-WebSocket-Core-LucFabresse.29';
			package: 'Zinc-WebSocket-Tests' with: 'Zinc-WebSocket-Tests-LucFabresse.9';
			package: 'Zinc-SSO-OAuth1-Core' with: 'Zinc-SSO-OAuth1-Core-SvenVanCaekenberghe.13';
			package: 'Zinc-SSO-OAuth2-Core' with: 'Zinc-SSO-OAuth2-Core-JanVanDeSandt.20';
			package: 'Zinc-SSO-OpenID-Core' with: 'Zinc-SSO-OpenID-Core-JanVanDeSandt.6';
			package: 'Zinc-SSO-Demo' with: 'Zinc-SSO-Demo-SvenVanCaekenberghe.5';
			package: 'Zinc-SSO-OAuth1-Tests' with: 'Zinc-SSO-OAuth1-Tests-SvenVanCaekenberghe.2';
			package: 'Zinc-SSO-OpenID-Tests' with: 'Zinc-SSO-OpenID-Tests-JanVanDeSandt.3';
			package: 'Zinc-WWS-Client' with: 'Zinc-WWS-Client-PhilippeBack.3';
			package: 'Zinc-WWS-Server' with: 'Zinc-WWS-Server-SvenVanCaekenberghe.11';
			package: 'Zinc-Zodiac' with: 'Zinc-Zodiac-SvenVanCaekenberghe.36';
			package: 'Zodiac-Core' with: 'Zodiac-Core-SvenVanCaekenberghe.42';
			package: 'Zodiac-Tests' with: 'Zodiac-Tests-SvenVanCaekenberghe.13';
			package: 'Zinc-Seaside' with: 'Zinc-Seaside-SvenVanCaekenberghe.46' ].
	spec for: #'pharo1.x' do: [ 
		spec 
			package: 'Zinc-Patch-HTTPSocket' with: 'Zinc-Patch-HTTPSocket-SvenVanCaekenberghe.1';
			package: 'Zinc-FileSystem-Legacy' with: 'Zinc-FileSystem-Legacy-SvenVanCaekenberghe.5';
			package: 'Zinc-Pharo-Forward-Compatibility' with: 'Zinc-Pharo-Forward-Compatibility-SvenVanCaekenberghe.1' ].
	spec for: #'pharo2.x' do: [ 
		spec 
			package: 'Zinc-Patch-HTTPSocket' with: 'Zinc-Patch-HTTPSocket-MarcusDenker.4';
			package: 'Zinc-FileSystem' with: 'Zinc-FileSystem-SvenVanCaekenberghe.12';
			package: 'Zinc-Resource-Meta-FileSystem' with: 'Zinc-Resource-Meta-FileSystem-SvenVanCaekenberghe.8';
			package: 'Zinc-pharo2-forward-compatibility' with: 'Zinc-pharo2-forward-compatibility-SvenVanCaekenberghe.1' ].
	spec for: #'pharo3.x' do: [ 
		spec 
			package: 'Zinc-FileSystem' with: 'Zinc-FileSystem-SvenVanCaekenberghe.12';
			package: 'Zinc-Resource-Meta-FileSystem' with: 'Zinc-Resource-Meta-FileSystem-SvenVanCaekenberghe.8' ].
	spec for: #'pharo4.x' do: [ 
		spec 
			package: 'Zinc-FileSystem' with: 'Zinc-FileSystem-SvenVanCaekenberghe.12';
			package: 'Zinc-Resource-Meta-FileSystem' with: 'Zinc-Resource-Meta-FileSystem-SvenVanCaekenberghe.8' ].
	spec for: #'pharo5.x' do: [ 
		spec 
			package: 'Zinc-FileSystem' with: 'Zinc-FileSystem-SvenVanCaekenberghe.12';
			package: 'Zinc-Resource-Meta-FileSystem' with: 'Zinc-Resource-Meta-FileSystem-SvenVanCaekenberghe.8' ].
	spec for: #'pharo6.x' do: [ 
		spec 
			package: 'Zinc-FileSystem' with: 'Zinc-FileSystem-SvenVanCaekenberghe.12';
			package: 'Zinc-Resource-Meta-FileSystem' with: 'Zinc-Resource-Meta-FileSystem-SvenVanCaekenberghe.8' ]
]

{ #category : 'versions' }
ConfigurationOfZincHTTPComponents >> version284: spec [
	<version: '2.8.4' imports: #('2.8-baseline')>
	spec for: #pharo do: [ 
		spec 
			blessing: #release;
			description: 'Update to latest package versions';
			author: 'SvenVanCaekenberghe';
			package: 'Zinc-Character-Encoding-Core' with: 'Zinc-Character-Encoding-Core-SvenVanCaekenberghe.51';
			package: 'Zinc-Character-Encoding-Tests' with: 'Zinc-Character-Encoding-Tests-SvenVanCaekenberghe.32';
			package: 'Zinc-Resource-Meta-Core' with: 'Zinc-Resource-Meta-Core-SvenVanCaekenberghe.62';
			package: 'Zinc-Resource-Meta-Tests' with: 'Zinc-Resource-Meta-Tests-SvenVanCaekenberghe.37';
			package: 'Zinc-HTTP' with: 'Zinc-HTTP-SvenVanCaekenberghe.460';
			package: 'Zinc-Tests' with: 'Zinc-Tests-SvenVanCaekenberghe.239';
			package: 'Zinc-AWS' with: 'Zinc-AWS-SvenVanCaekenberghe.18';
			package: 'Zinc-REST' with: 'Zinc-REST-HolgerHansPeterFreyther.20';
			package: 'Zinc-WebDAV' with: 'Zinc-WebDAV-SvenVanCaekenberghe.3';
			package: 'Zinc-WebSocket-Core' with: 'Zinc-WebSocket-Core-LucFabresse.29';
			package: 'Zinc-WebSocket-Tests' with: 'Zinc-WebSocket-Tests-LucFabresse.9';
			package: 'Zinc-SSO-OAuth1-Core' with: 'Zinc-SSO-OAuth1-Core-SvenVanCaekenberghe.13';
			package: 'Zinc-SSO-OAuth2-Core' with: 'Zinc-SSO-OAuth2-Core-JanVanDeSandt.20';
			package: 'Zinc-SSO-OpenID-Core' with: 'Zinc-SSO-OpenID-Core-JanVanDeSandt.6';
			package: 'Zinc-SSO-Demo' with: 'Zinc-SSO-Demo-SvenVanCaekenberghe.5';
			package: 'Zinc-SSO-OAuth1-Tests' with: 'Zinc-SSO-OAuth1-Tests-SvenVanCaekenberghe.2';
			package: 'Zinc-SSO-OpenID-Tests' with: 'Zinc-SSO-OpenID-Tests-JanVanDeSandt.3';
			package: 'Zinc-WWS-Client' with: 'Zinc-WWS-Client-PhilippeBack.3';
			package: 'Zinc-WWS-Server' with: 'Zinc-WWS-Server-SvenVanCaekenberghe.11';
			package: 'Zinc-Zodiac' with: 'Zinc-Zodiac-SvenVanCaekenberghe.36';
			package: 'Zodiac-Core' with: 'Zodiac-Core-SvenVanCaekenberghe.42';
			package: 'Zodiac-Tests' with: 'Zodiac-Tests-SvenVanCaekenberghe.13';
			package: 'Zinc-Seaside' with: 'Zinc-Seaside-SvenVanCaekenberghe.46' ].
	spec for: #'pharo1.x' do: [ 
		spec 
			package: 'Zinc-Patch-HTTPSocket' with: 'Zinc-Patch-HTTPSocket-SvenVanCaekenberghe.1';
			package: 'Zinc-FileSystem-Legacy' with: 'Zinc-FileSystem-Legacy-SvenVanCaekenberghe.5';
			package: 'Zinc-Pharo-Forward-Compatibility' with: 'Zinc-Pharo-Forward-Compatibility-SvenVanCaekenberghe.1' ].
	spec for: #'pharo2.x' do: [ 
		spec 
			package: 'Zinc-Patch-HTTPSocket' with: 'Zinc-Patch-HTTPSocket-MarcusDenker.4';
			package: 'Zinc-FileSystem' with: 'Zinc-FileSystem-SvenVanCaekenberghe.13';
			package: 'Zinc-Resource-Meta-FileSystem' with: 'Zinc-Resource-Meta-FileSystem-SvenVanCaekenberghe.8';
			package: 'Zinc-pharo2-forward-compatibility' with: 'Zinc-pharo2-forward-compatibility-SvenVanCaekenberghe.1' ].
	spec for: #'pharo3.x' do: [ 
		spec 
			package: 'Zinc-FileSystem' with: 'Zinc-FileSystem-SvenVanCaekenberghe.13';
			package: 'Zinc-Resource-Meta-FileSystem' with: 'Zinc-Resource-Meta-FileSystem-SvenVanCaekenberghe.8' ].
	spec for: #'pharo4.x' do: [ 
		spec 
			package: 'Zinc-FileSystem' with: 'Zinc-FileSystem-SvenVanCaekenberghe.13';
			package: 'Zinc-Resource-Meta-FileSystem' with: 'Zinc-Resource-Meta-FileSystem-SvenVanCaekenberghe.8' ].
	spec for: #'pharo5.x' do: [ 
		spec 
			package: 'Zinc-FileSystem' with: 'Zinc-FileSystem-SvenVanCaekenberghe.13';
			package: 'Zinc-Resource-Meta-FileSystem' with: 'Zinc-Resource-Meta-FileSystem-SvenVanCaekenberghe.8' ].
	spec for: #'pharo6.x' do: [ 
		spec 
			package: 'Zinc-FileSystem' with: 'Zinc-FileSystem-SvenVanCaekenberghe.13';
			package: 'Zinc-Resource-Meta-FileSystem' with: 'Zinc-Resource-Meta-FileSystem-SvenVanCaekenberghe.8' ]
]

{ #category : 'versions' }
ConfigurationOfZincHTTPComponents >> version285: spec [
	<version: '2.8.5' imports: #('2.8-baseline')>
	spec for: #pharo do: [ 
		spec 
			blessing: #release;
			description: 'Update to latest package versions';
			author: 'SvenVanCaekenberghe';
			package: 'Zinc-Character-Encoding-Core' with: 'Zinc-Character-Encoding-Core-SvenVanCaekenberghe.51';
			package: 'Zinc-Character-Encoding-Tests' with: 'Zinc-Character-Encoding-Tests-SvenVanCaekenberghe.33';
			package: 'Zinc-Resource-Meta-Core' with: 'Zinc-Resource-Meta-Core-SvenVanCaekenberghe.62';
			package: 'Zinc-Resource-Meta-Tests' with: 'Zinc-Resource-Meta-Tests-SvenVanCaekenberghe.37';
			package: 'Zinc-HTTP' with: 'Zinc-HTTP-SvenVanCaekenberghe.460';
			package: 'Zinc-Tests' with: 'Zinc-Tests-SvenVanCaekenberghe.239';
			package: 'Zinc-AWS' with: 'Zinc-AWS-SvenVanCaekenberghe.18';
			package: 'Zinc-REST' with: 'Zinc-REST-HolgerHansPeterFreyther.20';
			package: 'Zinc-WebDAV' with: 'Zinc-WebDAV-SvenVanCaekenberghe.3';
			package: 'Zinc-WebSocket-Core' with: 'Zinc-WebSocket-Core-LucFabresse.29';
			package: 'Zinc-WebSocket-Tests' with: 'Zinc-WebSocket-Tests-LucFabresse.9';
			package: 'Zinc-SSO-OAuth1-Core' with: 'Zinc-SSO-OAuth1-Core-SvenVanCaekenberghe.13';
			package: 'Zinc-SSO-OAuth2-Core' with: 'Zinc-SSO-OAuth2-Core-JanVanDeSandt.20';
			package: 'Zinc-SSO-OpenID-Core' with: 'Zinc-SSO-OpenID-Core-JanVanDeSandt.6';
			package: 'Zinc-SSO-Demo' with: 'Zinc-SSO-Demo-SvenVanCaekenberghe.5';
			package: 'Zinc-SSO-OAuth1-Tests' with: 'Zinc-SSO-OAuth1-Tests-SvenVanCaekenberghe.2';
			package: 'Zinc-SSO-OpenID-Tests' with: 'Zinc-SSO-OpenID-Tests-JanVanDeSandt.3';
			package: 'Zinc-WWS-Client' with: 'Zinc-WWS-Client-PhilippeBack.3';
			package: 'Zinc-WWS-Server' with: 'Zinc-WWS-Server-SvenVanCaekenberghe.11';
			package: 'Zinc-Zodiac' with: 'Zinc-Zodiac-SvenVanCaekenberghe.36';
			package: 'Zodiac-Core' with: 'Zodiac-Core-SvenVanCaekenberghe.42';
			package: 'Zodiac-Tests' with: 'Zodiac-Tests-SvenVanCaekenberghe.13';
			package: 'Zinc-Seaside' with: 'Zinc-Seaside-SvenVanCaekenberghe.46' ].
	spec for: #'pharo1.x' do: [ 
		spec 
			package: 'Zinc-Patch-HTTPSocket' with: 'Zinc-Patch-HTTPSocket-SvenVanCaekenberghe.1';
			package: 'Zinc-FileSystem-Legacy' with: 'Zinc-FileSystem-Legacy-SvenVanCaekenberghe.5';
			package: 'Zinc-Pharo-Forward-Compatibility' with: 'Zinc-Pharo-Forward-Compatibility-SvenVanCaekenberghe.1' ].
	spec for: #'pharo2.x' do: [ 
		spec 
			package: 'Zinc-Patch-HTTPSocket' with: 'Zinc-Patch-HTTPSocket-MarcusDenker.4';
			package: 'Zinc-FileSystem' with: 'Zinc-FileSystem-SvenVanCaekenberghe.13';
			package: 'Zinc-Resource-Meta-FileSystem' with: 'Zinc-Resource-Meta-FileSystem-SvenVanCaekenberghe.8';
			package: 'Zinc-pharo2-forward-compatibility' with: 'Zinc-pharo2-forward-compatibility-SvenVanCaekenberghe.1' ].
	spec for: #'pharo3.x' do: [ 
		spec 
			package: 'Zinc-FileSystem' with: 'Zinc-FileSystem-SvenVanCaekenberghe.13';
			package: 'Zinc-Resource-Meta-FileSystem' with: 'Zinc-Resource-Meta-FileSystem-SvenVanCaekenberghe.8' ].
	spec for: #'pharo4.x' do: [ 
		spec 
			package: 'Zinc-FileSystem' with: 'Zinc-FileSystem-SvenVanCaekenberghe.13';
			package: 'Zinc-Resource-Meta-FileSystem' with: 'Zinc-Resource-Meta-FileSystem-SvenVanCaekenberghe.8' ].
	spec for: #'pharo5.x' do: [ 
		spec 
			package: 'Zinc-FileSystem' with: 'Zinc-FileSystem-SvenVanCaekenberghe.13';
			package: 'Zinc-Resource-Meta-FileSystem' with: 'Zinc-Resource-Meta-FileSystem-SvenVanCaekenberghe.8' ].
	spec for: #'pharo6.x' do: [ 
		spec 
			package: 'Zinc-FileSystem' with: 'Zinc-FileSystem-SvenVanCaekenberghe.13';
			package: 'Zinc-Resource-Meta-FileSystem' with: 'Zinc-Resource-Meta-FileSystem-SvenVanCaekenberghe.8' ]
]

{ #category : 'versions' }
ConfigurationOfZincHTTPComponents >> version286: spec [
	<version: '2.8.6' imports: #('2.8-baseline')>
	spec for: #pharo do: [ 
		spec 
			blessing: #release;
			description: 'Update to latest package versions';
			author: 'SvenVanCaekenberghe';
			package: 'Zinc-Character-Encoding-Core' with: 'Zinc-Character-Encoding-Core-SvenVanCaekenberghe.51';
			package: 'Zinc-Character-Encoding-Tests' with: 'Zinc-Character-Encoding-Tests-SvenVanCaekenberghe.33';
			package: 'Zinc-Resource-Meta-Core' with: 'Zinc-Resource-Meta-Core-SvenVanCaekenberghe.62';
			package: 'Zinc-Resource-Meta-Tests' with: 'Zinc-Resource-Meta-Tests-SvenVanCaekenberghe.37';
			package: 'Zinc-HTTP' with: 'Zinc-HTTP-SvenVanCaekenberghe.461';
			package: 'Zinc-Tests' with: 'Zinc-Tests-SvenVanCaekenberghe.239';
			package: 'Zinc-AWS' with: 'Zinc-AWS-SvenVanCaekenberghe.18';
			package: 'Zinc-REST' with: 'Zinc-REST-HolgerHansPeterFreyther.20';
			package: 'Zinc-WebDAV' with: 'Zinc-WebDAV-SvenVanCaekenberghe.3';
			package: 'Zinc-WebSocket-Core' with: 'Zinc-WebSocket-Core-LucFabresse.29';
			package: 'Zinc-WebSocket-Tests' with: 'Zinc-WebSocket-Tests-LucFabresse.9';
			package: 'Zinc-SSO-OAuth1-Core' with: 'Zinc-SSO-OAuth1-Core-SvenVanCaekenberghe.13';
			package: 'Zinc-SSO-OAuth2-Core' with: 'Zinc-SSO-OAuth2-Core-JanVanDeSandt.20';
			package: 'Zinc-SSO-OpenID-Core' with: 'Zinc-SSO-OpenID-Core-JanVanDeSandt.6';
			package: 'Zinc-SSO-Demo' with: 'Zinc-SSO-Demo-SvenVanCaekenberghe.5';
			package: 'Zinc-SSO-OAuth1-Tests' with: 'Zinc-SSO-OAuth1-Tests-SvenVanCaekenberghe.2';
			package: 'Zinc-SSO-OpenID-Tests' with: 'Zinc-SSO-OpenID-Tests-JanVanDeSandt.3';
			package: 'Zinc-WWS-Client' with: 'Zinc-WWS-Client-PhilippeBack.3';
			package: 'Zinc-WWS-Server' with: 'Zinc-WWS-Server-SvenVanCaekenberghe.11';
			package: 'Zinc-Zodiac' with: 'Zinc-Zodiac-SvenVanCaekenberghe.36';
			package: 'Zodiac-Core' with: 'Zodiac-Core-SvenVanCaekenberghe.42';
			package: 'Zodiac-Tests' with: 'Zodiac-Tests-SvenVanCaekenberghe.13';
			package: 'Zinc-Seaside' with: 'Zinc-Seaside-SvenVanCaekenberghe.46' ].
	spec for: #'pharo1.x' do: [ 
		spec 
			package: 'Zinc-Patch-HTTPSocket' with: 'Zinc-Patch-HTTPSocket-SvenVanCaekenberghe.1';
			package: 'Zinc-FileSystem-Legacy' with: 'Zinc-FileSystem-Legacy-SvenVanCaekenberghe.5';
			package: 'Zinc-Pharo-Forward-Compatibility' with: 'Zinc-Pharo-Forward-Compatibility-SvenVanCaekenberghe.1' ].
	spec for: #'pharo2.x' do: [ 
		spec 
			package: 'Zinc-Patch-HTTPSocket' with: 'Zinc-Patch-HTTPSocket-MarcusDenker.4';
			package: 'Zinc-FileSystem' with: 'Zinc-FileSystem-SvenVanCaekenberghe.13';
			package: 'Zinc-Resource-Meta-FileSystem' with: 'Zinc-Resource-Meta-FileSystem-SvenVanCaekenberghe.8';
			package: 'Zinc-pharo2-forward-compatibility' with: 'Zinc-pharo2-forward-compatibility-SvenVanCaekenberghe.1' ].
	spec for: #'pharo3.x' do: [ 
		spec 
			package: 'Zinc-FileSystem' with: 'Zinc-FileSystem-SvenVanCaekenberghe.13';
			package: 'Zinc-Resource-Meta-FileSystem' with: 'Zinc-Resource-Meta-FileSystem-SvenVanCaekenberghe.8' ].
	spec for: #'pharo4.x' do: [ 
		spec 
			package: 'Zinc-FileSystem' with: 'Zinc-FileSystem-SvenVanCaekenberghe.13';
			package: 'Zinc-Resource-Meta-FileSystem' with: 'Zinc-Resource-Meta-FileSystem-SvenVanCaekenberghe.8' ].
	spec for: #'pharo5.x' do: [ 
		spec 
			package: 'Zinc-FileSystem' with: 'Zinc-FileSystem-SvenVanCaekenberghe.13';
			package: 'Zinc-Resource-Meta-FileSystem' with: 'Zinc-Resource-Meta-FileSystem-SvenVanCaekenberghe.8' ].
	spec for: #'pharo6.x' do: [ 
		spec 
			package: 'Zinc-FileSystem' with: 'Zinc-FileSystem-SvenVanCaekenberghe.13';
			package: 'Zinc-Resource-Meta-FileSystem' with: 'Zinc-Resource-Meta-FileSystem-SvenVanCaekenberghe.8' ]
]

{ #category : 'versions' }
ConfigurationOfZincHTTPComponents >> version287: spec [
	<version: '2.8.7' imports: #('2.8-baseline')>
	spec for: #pharo do: [ 
		spec 
			blessing: #release;
			description: 'Update to latest package versions';
			author: 'SvenVanCaekenberghe';
			package: 'Zinc-Character-Encoding-Core' with: 'Zinc-Character-Encoding-Core-SvenVanCaekenberghe.51';
			package: 'Zinc-Character-Encoding-Tests' with: 'Zinc-Character-Encoding-Tests-SvenVanCaekenberghe.33';
			package: 'Zinc-Resource-Meta-Core' with: 'Zinc-Resource-Meta-Core-SvenVanCaekenberghe.62';
			package: 'Zinc-Resource-Meta-Tests' with: 'Zinc-Resource-Meta-Tests-SvenVanCaekenberghe.37';
			package: 'Zinc-HTTP' with: 'Zinc-HTTP-SvenVanCaekenberghe.461';
			package: 'Zinc-Tests' with: 'Zinc-Tests-SvenVanCaekenberghe.239';
			package: 'Zinc-AWS' with: 'Zinc-AWS-SvenVanCaekenberghe.18';
			package: 'Zinc-REST' with: 'Zinc-REST-HolgerHansPeterFreyther.20';
			package: 'Zinc-WebDAV' with: 'Zinc-WebDAV-SvenVanCaekenberghe.3';
			package: 'Zinc-WebSocket-Core' with: 'Zinc-WebSocket-Core-LucFabresse.29';
			package: 'Zinc-WebSocket-Tests' with: 'Zinc-WebSocket-Tests-LucFabresse.9';
			package: 'Zinc-SSO-OAuth1-Core' with: 'Zinc-SSO-OAuth1-Core-SvenVanCaekenberghe.13';
			package: 'Zinc-SSO-OAuth2-Core' with: 'Zinc-SSO-OAuth2-Core-JanVanDeSandt.20';
			package: 'Zinc-SSO-OpenID-Core' with: 'Zinc-SSO-OpenID-Core-JanVanDeSandt.6';
			package: 'Zinc-SSO-Demo' with: 'Zinc-SSO-Demo-SvenVanCaekenberghe.5';
			package: 'Zinc-SSO-OAuth1-Tests' with: 'Zinc-SSO-OAuth1-Tests-SvenVanCaekenberghe.2';
			package: 'Zinc-SSO-OpenID-Tests' with: 'Zinc-SSO-OpenID-Tests-JanVanDeSandt.3';
			package: 'Zinc-WWS-Client' with: 'Zinc-WWS-Client-PhilippeBack.3';
			package: 'Zinc-WWS-Server' with: 'Zinc-WWS-Server-SvenVanCaekenberghe.11';
			package: 'Zinc-Zodiac' with: 'Zinc-Zodiac-SvenVanCaekenberghe.39';
			package: 'Zodiac-Core' with: 'Zodiac-Core-TheIntegrator.46';
			package: 'Zodiac-Tests' with: 'Zodiac-Tests-SvenVanCaekenberghe.18';
			package: 'Zinc-Seaside' with: 'Zinc-Seaside-SvenVanCaekenberghe.46' ].
	spec for: #'pharo1.x' do: [ 
		spec 
			package: 'Zinc-Patch-HTTPSocket' with: 'Zinc-Patch-HTTPSocket-SvenVanCaekenberghe.1';
			package: 'Zinc-FileSystem-Legacy' with: 'Zinc-FileSystem-Legacy-SvenVanCaekenberghe.5';
			package: 'Zinc-Pharo-Forward-Compatibility' with: 'Zinc-Pharo-Forward-Compatibility-SvenVanCaekenberghe.1' ].
	spec for: #'pharo2.x' do: [ 
		spec 
			package: 'Zinc-Patch-HTTPSocket' with: 'Zinc-Patch-HTTPSocket-MarcusDenker.4';
			package: 'Zinc-FileSystem' with: 'Zinc-FileSystem-SvenVanCaekenberghe.13';
			package: 'Zinc-Resource-Meta-FileSystem' with: 'Zinc-Resource-Meta-FileSystem-SvenVanCaekenberghe.8';
			package: 'Zinc-pharo2-forward-compatibility' with: 'Zinc-pharo2-forward-compatibility-SvenVanCaekenberghe.1' ].
	spec for: #'pharo3.x' do: [ 
		spec 
			package: 'Zinc-FileSystem' with: 'Zinc-FileSystem-SvenVanCaekenberghe.13';
			package: 'Zinc-Resource-Meta-FileSystem' with: 'Zinc-Resource-Meta-FileSystem-SvenVanCaekenberghe.8' ].
	spec for: #'pharo4.x' do: [ 
		spec 
			package: 'Zinc-FileSystem' with: 'Zinc-FileSystem-SvenVanCaekenberghe.13';
			package: 'Zinc-Resource-Meta-FileSystem' with: 'Zinc-Resource-Meta-FileSystem-SvenVanCaekenberghe.8' ].
	spec for: #'pharo5.x' do: [ 
		spec 
			package: 'Zinc-FileSystem' with: 'Zinc-FileSystem-SvenVanCaekenberghe.13';
			package: 'Zinc-Resource-Meta-FileSystem' with: 'Zinc-Resource-Meta-FileSystem-SvenVanCaekenberghe.8' ].
	spec for: #'pharo6.x' do: [ 
		spec 
			package: 'Zinc-FileSystem' with: 'Zinc-FileSystem-SvenVanCaekenberghe.13';
			package: 'Zinc-Resource-Meta-FileSystem' with: 'Zinc-Resource-Meta-FileSystem-SvenVanCaekenberghe.8' ]
]

{ #category : 'versions' }
ConfigurationOfZincHTTPComponents >> version288: spec [
	<version: '2.8.8' imports: #('2.8-baseline')>
	spec for: #pharo do: [ 
		spec 
			blessing: #release;
			description: 'Update to latest package versions';
			author: 'SvenVanCaekenberghe';
			package: 'Zinc-Character-Encoding-Core' with: 'Zinc-Character-Encoding-Core-SvenVanCaekenberghe.51';
			package: 'Zinc-Character-Encoding-Tests' with: 'Zinc-Character-Encoding-Tests-SvenVanCaekenberghe.33';
			package: 'Zinc-Resource-Meta-Core' with: 'Zinc-Resource-Meta-Core-SvenVanCaekenberghe.62';
			package: 'Zinc-Resource-Meta-Tests' with: 'Zinc-Resource-Meta-Tests-SvenVanCaekenberghe.37';
			package: 'Zinc-HTTP' with: 'Zinc-HTTP-SvenVanCaekenberghe.461';
			package: 'Zinc-Tests' with: 'Zinc-Tests-SvenVanCaekenberghe.239';
			package: 'Zinc-AWS' with: 'Zinc-AWS-SvenVanCaekenberghe.18';
			package: 'Zinc-REST' with: 'Zinc-REST-HolgerHansPeterFreyther.20';
			package: 'Zinc-WebDAV' with: 'Zinc-WebDAV-SvenVanCaekenberghe.3';
			package: 'Zinc-WebSocket-Core' with: 'Zinc-WebSocket-Core-LucFabresse.29';
			package: 'Zinc-WebSocket-Tests' with: 'Zinc-WebSocket-Tests-LucFabresse.9';
			package: 'Zinc-SSO-OAuth1-Core' with: 'Zinc-SSO-OAuth1-Core-SvenVanCaekenberghe.13';
			package: 'Zinc-SSO-OAuth2-Core' with: 'Zinc-SSO-OAuth2-Core-JanVanDeSandt.20';
			package: 'Zinc-SSO-OpenID-Core' with: 'Zinc-SSO-OpenID-Core-JanVanDeSandt.6';
			package: 'Zinc-SSO-Demo' with: 'Zinc-SSO-Demo-SvenVanCaekenberghe.5';
			package: 'Zinc-SSO-OAuth1-Tests' with: 'Zinc-SSO-OAuth1-Tests-SvenVanCaekenberghe.2';
			package: 'Zinc-SSO-OpenID-Tests' with: 'Zinc-SSO-OpenID-Tests-JanVanDeSandt.3';
			package: 'Zinc-WWS-Client' with: 'Zinc-WWS-Client-PhilippeBack.3';
			package: 'Zinc-WWS-Server' with: 'Zinc-WWS-Server-SvenVanCaekenberghe.11';
			package: 'Zinc-Zodiac' with: 'Zinc-Zodiac-SvenVanCaekenberghe.40';
			package: 'Zodiac-Core' with: 'Zodiac-Core-TheIntegrator.46';
			package: 'Zodiac-Tests' with: 'Zodiac-Tests-SvenVanCaekenberghe.18';
			package: 'Zinc-Seaside' with: 'Zinc-Seaside-SvenVanCaekenberghe.46' ].
	spec for: #'pharo1.x' do: [ 
		spec 
			package: 'Zinc-Patch-HTTPSocket' with: 'Zinc-Patch-HTTPSocket-SvenVanCaekenberghe.1';
			package: 'Zinc-FileSystem-Legacy' with: 'Zinc-FileSystem-Legacy-SvenVanCaekenberghe.5';
			package: 'Zinc-Pharo-Forward-Compatibility' with: 'Zinc-Pharo-Forward-Compatibility-SvenVanCaekenberghe.1' ].
	spec for: #'pharo2.x' do: [ 
		spec 
			package: 'Zinc-Patch-HTTPSocket' with: 'Zinc-Patch-HTTPSocket-MarcusDenker.4';
			package: 'Zinc-FileSystem' with: 'Zinc-FileSystem-SvenVanCaekenberghe.13';
			package: 'Zinc-Resource-Meta-FileSystem' with: 'Zinc-Resource-Meta-FileSystem-SvenVanCaekenberghe.8';
			package: 'Zinc-pharo2-forward-compatibility' with: 'Zinc-pharo2-forward-compatibility-SvenVanCaekenberghe.1' ].
	spec for: #'pharo3.x' do: [ 
		spec 
			package: 'Zinc-FileSystem' with: 'Zinc-FileSystem-SvenVanCaekenberghe.13';
			package: 'Zinc-Resource-Meta-FileSystem' with: 'Zinc-Resource-Meta-FileSystem-SvenVanCaekenberghe.8' ].
	spec for: #'pharo4.x' do: [ 
		spec 
			package: 'Zinc-FileSystem' with: 'Zinc-FileSystem-SvenVanCaekenberghe.13';
			package: 'Zinc-Resource-Meta-FileSystem' with: 'Zinc-Resource-Meta-FileSystem-SvenVanCaekenberghe.8' ].
	spec for: #'pharo5.x' do: [ 
		spec 
			package: 'Zinc-FileSystem' with: 'Zinc-FileSystem-SvenVanCaekenberghe.13';
			package: 'Zinc-Resource-Meta-FileSystem' with: 'Zinc-Resource-Meta-FileSystem-SvenVanCaekenberghe.8' ].
	spec for: #'pharo6.x' do: [ 
		spec 
			package: 'Zinc-FileSystem' with: 'Zinc-FileSystem-SvenVanCaekenberghe.13';
			package: 'Zinc-Resource-Meta-FileSystem' with: 'Zinc-Resource-Meta-FileSystem-SvenVanCaekenberghe.8' ]
]

{ #category : 'versions' }
ConfigurationOfZincHTTPComponents >> version289: spec [
	<version: '2.8.9' imports: #('2.8-baseline')>
	spec for: #pharo do: [ 
		spec 
			blessing: #release;
			description: 'Update to latest package versions';
			author: 'SvenVanCaekenberghe';
			package: 'Zinc-Character-Encoding-Core' with: 'Zinc-Character-Encoding-Core-SvenVanCaekenberghe.54';
			package: 'Zinc-Character-Encoding-Tests' with: 'Zinc-Character-Encoding-Tests-SvenVanCaekenberghe.35';
			package: 'Zinc-Resource-Meta-Core' with: 'Zinc-Resource-Meta-Core-SvenVanCaekenberghe.65';
			package: 'Zinc-Resource-Meta-Tests' with: 'Zinc-Resource-Meta-Tests-SvenVanCaekenberghe.38';
			package: 'Zinc-HTTP' with: 'Zinc-HTTP-SvenVanCaekenberghe.469';
			package: 'Zinc-Tests' with: 'Zinc-Tests-SvenVanCaekenberghe.243';
			package: 'Zinc-AWS' with: 'Zinc-AWS-SvenVanCaekenberghe.18';
			package: 'Zinc-REST' with: 'Zinc-REST-HolgerHansPeterFreyther.20';
			package: 'Zinc-WebDAV' with: 'Zinc-WebDAV-SvenVanCaekenberghe.3';
			package: 'Zinc-WebSocket-Core' with: 'Zinc-WebSocket-Core-LucFabresse.29';
			package: 'Zinc-WebSocket-Tests' with: 'Zinc-WebSocket-Tests-LucFabresse.9';
			package: 'Zinc-SSO-OAuth1-Core' with: 'Zinc-SSO-OAuth1-Core-SvenVanCaekenberghe.13';
			package: 'Zinc-SSO-OAuth2-Core' with: 'Zinc-SSO-OAuth2-Core-JanVanDeSandt.20';
			package: 'Zinc-SSO-OpenID-Core' with: 'Zinc-SSO-OpenID-Core-JanVanDeSandt.6';
			package: 'Zinc-SSO-Demo' with: 'Zinc-SSO-Demo-SvenVanCaekenberghe.5';
			package: 'Zinc-SSO-OAuth1-Tests' with: 'Zinc-SSO-OAuth1-Tests-SvenVanCaekenberghe.2';
			package: 'Zinc-SSO-OpenID-Tests' with: 'Zinc-SSO-OpenID-Tests-JanVanDeSandt.3';
			package: 'Zinc-WWS-Client' with: 'Zinc-WWS-Client-PhilippeBack.3';
			package: 'Zinc-WWS-Server' with: 'Zinc-WWS-Server-SvenVanCaekenberghe.11';
			package: 'Zinc-Zodiac' with: 'Zinc-Zodiac-SvenVanCaekenberghe.40';
			package: 'Zodiac-Core' with: 'Zodiac-Core-TheIntegrator.46';
			package: 'Zodiac-Tests' with: 'Zodiac-Tests-SvenVanCaekenberghe.18';
			package: 'Zinc-Seaside' with: 'Zinc-Seaside-SvenVanCaekenberghe.47' ].
	spec for: #'pharo1.x' do: [ 
		spec 
			package: 'Zinc-Patch-HTTPSocket' with: 'Zinc-Patch-HTTPSocket-SvenVanCaekenberghe.1';
			package: 'Zinc-FileSystem-Legacy' with: 'Zinc-FileSystem-Legacy-SvenVanCaekenberghe.5';
			package: 'Zinc-Pharo-Forward-Compatibility' with: 'Zinc-Pharo-Forward-Compatibility-SvenVanCaekenberghe.1' ].
	spec for: #'pharo2.x' do: [ 
		spec 
			package: 'Zinc-Patch-HTTPSocket' with: 'Zinc-Patch-HTTPSocket-MarcusDenker.4';
			package: 'Zinc-FileSystem' with: 'Zinc-FileSystem-SvenVanCaekenberghe.13';
			package: 'Zinc-Resource-Meta-FileSystem' with: 'Zinc-Resource-Meta-FileSystem-SvenVanCaekenberghe.8';
			package: 'Zinc-pharo2-forward-compatibility' with: 'Zinc-pharo2-forward-compatibility-SvenVanCaekenberghe.1' ].
	spec for: #'pharo3.x' do: [ 
		spec 
			package: 'Zinc-FileSystem' with: 'Zinc-FileSystem-SvenVanCaekenberghe.13';
			package: 'Zinc-Resource-Meta-FileSystem' with: 'Zinc-Resource-Meta-FileSystem-SvenVanCaekenberghe.8' ].
	spec for: #'pharo4.x' do: [ 
		spec 
			package: 'Zinc-FileSystem' with: 'Zinc-FileSystem-SvenVanCaekenberghe.13';
			package: 'Zinc-Resource-Meta-FileSystem' with: 'Zinc-Resource-Meta-FileSystem-SvenVanCaekenberghe.8' ].
	spec for: #'pharo5.x' do: [ 
		spec 
			package: 'Zinc-FileSystem' with: 'Zinc-FileSystem-SvenVanCaekenberghe.13';
			package: 'Zinc-Resource-Meta-FileSystem' with: 'Zinc-Resource-Meta-FileSystem-SvenVanCaekenberghe.8' ].
	spec for: #'pharo6.x' do: [ 
		spec 
			package: 'Zinc-FileSystem' with: 'Zinc-FileSystem-SvenVanCaekenberghe.13';
			package: 'Zinc-Resource-Meta-FileSystem' with: 'Zinc-Resource-Meta-FileSystem-SvenVanCaekenberghe.8' ].
	spec for: #'pharo7.x' do: [ 
		spec 
			package: 'Zinc-FileSystem' with: 'Zinc-FileSystem-SvenVanCaekenberghe.13';
			package: 'Zinc-Resource-Meta-FileSystem' with: 'Zinc-Resource-Meta-FileSystem-SvenVanCaekenberghe.8' ]
]

{ #category : 'versions' }
ConfigurationOfZincHTTPComponents >> version291: spec [
	<version: '2.9.1' imports: #('2.9-baseline')>
	spec for: #pharo do: [ 
		spec 
			blessing: #release;
			description: 'Update to latest package versions';
			author: 'SvenVanCaekenberghe';
			package: 'Zinc-Character-Encoding-Core' with: 'Zinc-Character-Encoding-Core-SvenVanCaekenberghe.58';
			package: 'Zinc-Character-Encoding-Tests' with: 'Zinc-Character-Encoding-Tests-SvenVanCaekenberghe.39';
			package: 'Zinc-Resource-Meta-Core' with: 'Zinc-Resource-Meta-Core-SvenVanCaekenberghe.67';
			package: 'Zinc-Resource-Meta-Tests' with: 'Zinc-Resource-Meta-Tests-SvenVanCaekenberghe.38';
			package: 'Zinc-HTTP' with: 'Zinc-HTTP-SvenVanCaekenberghe.472';
			package: 'Zinc-Tests' with: 'Zinc-Tests-SvenVanCaekenberghe.245';
			package: 'Zinc-AWS' with: 'Zinc-AWS-SvenVanCaekenberghe.18';
			package: 'Zinc-REST' with: 'Zinc-REST-HolgerHansPeterFreyther.20';
			package: 'Zinc-WebDAV' with: 'Zinc-WebDAV-SvenVanCaekenberghe.3';
			package: 'Zinc-WebSocket-Core' with: 'Zinc-WebSocket-Core-SvenVanCaekenberghe.30';
			package: 'Zinc-WebSocket-Tests' with: 'Zinc-WebSocket-Tests-LucFabresse.9';
			package: 'Zinc-SSO-OAuth1-Core' with: 'Zinc-SSO-OAuth1-Core-SvenVanCaekenberghe.13';
			package: 'Zinc-SSO-OAuth2-Core' with: 'Zinc-SSO-OAuth2-Core-JanVanDeSandt.20';
			package: 'Zinc-SSO-OpenID-Core' with: 'Zinc-SSO-OpenID-Core-JanVanDeSandt.6';
			package: 'Zinc-SSO-Demo' with: 'Zinc-SSO-Demo-SvenVanCaekenberghe.5';
			package: 'Zinc-SSO-OAuth1-Tests' with: 'Zinc-SSO-OAuth1-Tests-SvenVanCaekenberghe.2';
			package: 'Zinc-SSO-OpenID-Tests' with: 'Zinc-SSO-OpenID-Tests-JanVanDeSandt.3';
			package: 'Zinc-WWS-Client' with: 'Zinc-WWS-Client-PhilippeBack.3';
			package: 'Zinc-WWS-Server' with: 'Zinc-WWS-Server-SvenVanCaekenberghe.11';
			package: 'Zinc-Zodiac' with: 'Zinc-Zodiac-SvenVanCaekenberghe.43';
			package: 'Zodiac-Core' with: 'Zodiac-Core-SvenVanCaekenberghe.47';
			package: 'Zodiac-Tests' with: 'Zodiac-Tests-SvenVanCaekenberghe.19';
			package: 'Zodiac-Extra' with: 'Zodiac-Extra-SvenVanCaekenberghe.8';
			package: 'Zinc-Seaside' with: 'Zinc-Seaside-SvenVanCaekenberghe.47' ].
	spec for: #'pharo1.x' do: [ 
		spec 
			package: 'Zinc-Patch-HTTPSocket' with: 'Zinc-Patch-HTTPSocket-SvenVanCaekenberghe.1';
			package: 'Zinc-FileSystem-Legacy' with: 'Zinc-FileSystem-Legacy-SvenVanCaekenberghe.5';
			package: 'Zinc-Pharo-Forward-Compatibility' with: 'Zinc-Pharo-Forward-Compatibility-SvenVanCaekenberghe.1' ].
	spec for: #'pharo2.x' do: [ 
		spec 
			package: 'Zinc-Patch-HTTPSocket' with: 'Zinc-Patch-HTTPSocket-MarcusDenker.4';
			package: 'Zinc-FileSystem' with: 'Zinc-FileSystem-SvenVanCaekenberghe.15';
			package: 'Zinc-Resource-Meta-FileSystem' with: 'Zinc-Resource-Meta-FileSystem-SvenVanCaekenberghe.9';
			package: 'Zinc-pharo2-forward-compatibility' with: 'Zinc-pharo2-forward-compatibility-SvenVanCaekenberghe.1' ].
	spec for: #'pharo3.x' do: [ 
		spec 
			package: 'Zinc-FileSystem' with: 'Zinc-FileSystem-SvenVanCaekenberghe.15';
			package: 'Zinc-Resource-Meta-FileSystem' with: 'Zinc-Resource-Meta-FileSystem-SvenVanCaekenberghe.9' ].
	spec for: #'pharo4.x' do: [ 
		spec 
			package: 'Zinc-FileSystem' with: 'Zinc-FileSystem-SvenVanCaekenberghe.15';
			package: 'Zinc-Resource-Meta-FileSystem' with: 'Zinc-Resource-Meta-FileSystem-SvenVanCaekenberghe.9' ].
	spec for: #'pharo5.x' do: [ 
		spec 
			package: 'Zinc-FileSystem' with: 'Zinc-FileSystem-SvenVanCaekenberghe.15';
			package: 'Zinc-Resource-Meta-FileSystem' with: 'Zinc-Resource-Meta-FileSystem-SvenVanCaekenberghe.9' ].
	spec for: #'pharo6.x' do: [ 
		spec 
			package: 'Zinc-FileSystem' with: 'Zinc-FileSystem-SvenVanCaekenberghe.15';
			package: 'Zinc-Resource-Meta-FileSystem' with: 'Zinc-Resource-Meta-FileSystem-SvenVanCaekenberghe.9' ].
	spec for: #'pharo7.x' do: [ 
		spec 
			package: 'Zinc-FileSystem' with: 'Zinc-FileSystem-SvenVanCaekenberghe.15';
			package: 'Zinc-Resource-Meta-FileSystem' with: 'Zinc-Resource-Meta-FileSystem-SvenVanCaekenberghe.9' ]
]

{ #category : 'versions' }
ConfigurationOfZincHTTPComponents >> version292: spec [
	<version: '2.9.2' imports: #('2.9-baseline')>
	spec for: #pharo do: [ 
		spec 
			blessing: #release;
			description: 'Update to latest package versions';
			author: 'SvenVanCaekenberghe';
			package: 'Zinc-Character-Encoding-Core' with: 'Zinc-Character-Encoding-Core-SvenVanCaekenberghe.64';
			package: 'Zinc-Character-Encoding-Tests' with: 'Zinc-Character-Encoding-Tests-SvenVanCaekenberghe.43';
			package: 'Zinc-Resource-Meta-Core' with: 'Zinc-Resource-Meta-Core-SvenVanCaekenberghe.68';
			package: 'Zinc-Resource-Meta-Tests' with: 'Zinc-Resource-Meta-Tests-SvenVanCaekenberghe.38';
			package: 'Zinc-HTTP' with: 'Zinc-HTTP-SvenVanCaekenberghe.474';
			package: 'Zinc-Tests' with: 'Zinc-Tests-SvenVanCaekenberghe.245';
			package: 'Zinc-AWS' with: 'Zinc-AWS-SvenVanCaekenberghe.18';
			package: 'Zinc-REST' with: 'Zinc-REST-HolgerHansPeterFreyther.20';
			package: 'Zinc-WebDAV' with: 'Zinc-WebDAV-SvenVanCaekenberghe.3';
			package: 'Zinc-WebSocket-Core' with: 'Zinc-WebSocket-Core-SvenVanCaekenberghe.30';
			package: 'Zinc-WebSocket-Tests' with: 'Zinc-WebSocket-Tests-LucFabresse.9';
			package: 'Zinc-SSO-OAuth1-Core' with: 'Zinc-SSO-OAuth1-Core-SvenVanCaekenberghe.13';
			package: 'Zinc-SSO-OAuth2-Core' with: 'Zinc-SSO-OAuth2-Core-JanVanDeSandt.20';
			package: 'Zinc-SSO-OpenID-Core' with: 'Zinc-SSO-OpenID-Core-JanVanDeSandt.6';
			package: 'Zinc-SSO-Demo' with: 'Zinc-SSO-Demo-SvenVanCaekenberghe.5';
			package: 'Zinc-SSO-OAuth1-Tests' with: 'Zinc-SSO-OAuth1-Tests-SvenVanCaekenberghe.2';
			package: 'Zinc-SSO-OpenID-Tests' with: 'Zinc-SSO-OpenID-Tests-JanVanDeSandt.3';
			package: 'Zinc-WWS-Client' with: 'Zinc-WWS-Client-PhilippeBack.3';
			package: 'Zinc-WWS-Server' with: 'Zinc-WWS-Server-SvenVanCaekenberghe.11';
			package: 'Zinc-Zodiac' with: 'Zinc-Zodiac-SvenVanCaekenberghe.44';
			package: 'Zodiac-Core' with: 'Zodiac-Core-TorstenBergmann.48';
			package: 'Zodiac-Tests' with: 'Zodiac-Tests-SvenVanCaekenberghe.22';
			package: 'Zodiac-Extra' with: 'Zodiac-Extra-SvenVanCaekenberghe.8';
			package: 'Zinc-Seaside' with: 'Zinc-Seaside-SvenVanCaekenberghe.47' ].
	spec for: #'pharo1.x' do: [ 
		spec 
			package: 'Zinc-Patch-HTTPSocket' with: 'Zinc-Patch-HTTPSocket-SvenVanCaekenberghe.1';
			package: 'Zinc-FileSystem-Legacy' with: 'Zinc-FileSystem-Legacy-SvenVanCaekenberghe.5';
			package: 'Zinc-Pharo-Forward-Compatibility' with: 'Zinc-Pharo-Forward-Compatibility-SvenVanCaekenberghe.1' ].
	spec for: #'pharo2.x' do: [ 
		spec 
			package: 'Zinc-Patch-HTTPSocket' with: 'Zinc-Patch-HTTPSocket-MarcusDenker.4';
			package: 'Zinc-FileSystem' with: 'Zinc-FileSystem-SvenVanCaekenberghe.15';
			package: 'Zinc-Resource-Meta-FileSystem' with: 'Zinc-Resource-Meta-FileSystem-SvenVanCaekenberghe.9';
			package: 'Zinc-pharo2-forward-compatibility' with: 'Zinc-pharo2-forward-compatibility-SvenVanCaekenberghe.1' ].
	spec for: #'pharo3.x' do: [ 
		spec 
			package: 'Zinc-FileSystem' with: 'Zinc-FileSystem-SvenVanCaekenberghe.15';
			package: 'Zinc-Resource-Meta-FileSystem' with: 'Zinc-Resource-Meta-FileSystem-SvenVanCaekenberghe.9' ].
	spec for: #'pharo4.x' do: [ 
		spec 
			package: 'Zinc-FileSystem' with: 'Zinc-FileSystem-SvenVanCaekenberghe.15';
			package: 'Zinc-Resource-Meta-FileSystem' with: 'Zinc-Resource-Meta-FileSystem-SvenVanCaekenberghe.9' ].
	spec for: #'pharo5.x' do: [ 
		spec 
			package: 'Zinc-FileSystem' with: 'Zinc-FileSystem-SvenVanCaekenberghe.15';
			package: 'Zinc-Resource-Meta-FileSystem' with: 'Zinc-Resource-Meta-FileSystem-SvenVanCaekenberghe.9' ].
	spec for: #'pharo6.x' do: [ 
		spec 
			package: 'Zinc-FileSystem' with: 'Zinc-FileSystem-SvenVanCaekenberghe.15';
			package: 'Zinc-Resource-Meta-FileSystem' with: 'Zinc-Resource-Meta-FileSystem-SvenVanCaekenberghe.9' ].
	spec for: #'pharo7.x' do: [ 
		spec 
			package: 'Zinc-FileSystem' with: 'Zinc-FileSystem-SvenVanCaekenberghe.15';
			package: 'Zinc-Resource-Meta-FileSystem' with: 'Zinc-Resource-Meta-FileSystem-SvenVanCaekenberghe.9' ]
]

{ #category : 'versions' }
ConfigurationOfZincHTTPComponents >> version293: spec [
	<version: '2.9.3' imports: #('2.9-baseline')>
	spec for: #pharo do: [ 
		spec 
			blessing: #release;
			description: 'Update to latest package versions';
			author: 'SvenVanCaekenberghe';
			package: 'Zinc-Character-Encoding-Core' with: 'Zinc-Character-Encoding-Core-SvenVanCaekenberghe.64';
			package: 'Zinc-Character-Encoding-Tests' with: 'Zinc-Character-Encoding-Tests-SvenVanCaekenberghe.43';
			package: 'Zinc-Resource-Meta-Core' with: 'Zinc-Resource-Meta-Core-SvenVanCaekenberghe.68';
			package: 'Zinc-Resource-Meta-Tests' with: 'Zinc-Resource-Meta-Tests-SvenVanCaekenberghe.38';
			package: 'Zinc-HTTP' with: 'Zinc-HTTP-SvenVanCaekenberghe.475';
			package: 'Zinc-Tests' with: 'Zinc-Tests-SvenVanCaekenberghe.245';
			package: 'Zinc-AWS' with: 'Zinc-AWS-SvenVanCaekenberghe.18';
			package: 'Zinc-REST' with: 'Zinc-REST-HolgerHansPeterFreyther.20';
			package: 'Zinc-WebDAV' with: 'Zinc-WebDAV-SvenVanCaekenberghe.3';
			package: 'Zinc-WebSocket-Core' with: 'Zinc-WebSocket-Core-SvenVanCaekenberghe.30';
			package: 'Zinc-WebSocket-Tests' with: 'Zinc-WebSocket-Tests-LucFabresse.9';
			package: 'Zinc-SSO-OAuth1-Core' with: 'Zinc-SSO-OAuth1-Core-SvenVanCaekenberghe.13';
			package: 'Zinc-SSO-OAuth2-Core' with: 'Zinc-SSO-OAuth2-Core-JanVanDeSandt.20';
			package: 'Zinc-SSO-OpenID-Core' with: 'Zinc-SSO-OpenID-Core-JanVanDeSandt.6';
			package: 'Zinc-SSO-Demo' with: 'Zinc-SSO-Demo-SvenVanCaekenberghe.5';
			package: 'Zinc-SSO-OAuth1-Tests' with: 'Zinc-SSO-OAuth1-Tests-SvenVanCaekenberghe.2';
			package: 'Zinc-SSO-OpenID-Tests' with: 'Zinc-SSO-OpenID-Tests-JanVanDeSandt.3';
			package: 'Zinc-WWS-Client' with: 'Zinc-WWS-Client-PhilippeBack.3';
			package: 'Zinc-WWS-Server' with: 'Zinc-WWS-Server-SvenVanCaekenberghe.11';
			package: 'Zinc-Zodiac' with: 'Zinc-Zodiac-SvenVanCaekenberghe.44';
			package: 'Zodiac-Core' with: 'Zodiac-Core-TorstenBergmann.48';
			package: 'Zodiac-Tests' with: 'Zodiac-Tests-SvenVanCaekenberghe.22';
			package: 'Zodiac-Extra' with: 'Zodiac-Extra-SvenVanCaekenberghe.8';
			package: 'Zinc-Seaside' with: 'Zinc-Seaside-SvenVanCaekenberghe.47' ].
	spec for: #'pharo1.x' do: [ 
		spec 
			package: 'Zinc-Patch-HTTPSocket' with: 'Zinc-Patch-HTTPSocket-SvenVanCaekenberghe.1';
			package: 'Zinc-FileSystem-Legacy' with: 'Zinc-FileSystem-Legacy-SvenVanCaekenberghe.5';
			package: 'Zinc-Pharo-Forward-Compatibility' with: 'Zinc-Pharo-Forward-Compatibility-SvenVanCaekenberghe.1' ].
	spec for: #'pharo2.x' do: [ 
		spec 
			package: 'Zinc-Patch-HTTPSocket' with: 'Zinc-Patch-HTTPSocket-MarcusDenker.4';
			package: 'Zinc-FileSystem' with: 'Zinc-FileSystem-SvenVanCaekenberghe.16';
			package: 'Zinc-Resource-Meta-FileSystem' with: 'Zinc-Resource-Meta-FileSystem-SvenVanCaekenberghe.9';
			package: 'Zinc-pharo2-forward-compatibility' with: 'Zinc-pharo2-forward-compatibility-SvenVanCaekenberghe.1' ].
	spec for: #'pharo3.x' do: [ 
		spec 
			package: 'Zinc-FileSystem' with: 'Zinc-FileSystem-SvenVanCaekenberghe.16';
			package: 'Zinc-Resource-Meta-FileSystem' with: 'Zinc-Resource-Meta-FileSystem-SvenVanCaekenberghe.9' ].
	spec for: #'pharo4.x' do: [ 
		spec 
			package: 'Zinc-FileSystem' with: 'Zinc-FileSystem-SvenVanCaekenberghe.16';
			package: 'Zinc-Resource-Meta-FileSystem' with: 'Zinc-Resource-Meta-FileSystem-SvenVanCaekenberghe.9' ].
	spec for: #'pharo5.x' do: [ 
		spec 
			package: 'Zinc-FileSystem' with: 'Zinc-FileSystem-SvenVanCaekenberghe.16';
			package: 'Zinc-Resource-Meta-FileSystem' with: 'Zinc-Resource-Meta-FileSystem-SvenVanCaekenberghe.9' ].
	spec for: #'pharo6.x' do: [ 
		spec 
			package: 'Zinc-FileSystem' with: 'Zinc-FileSystem-SvenVanCaekenberghe.16';
			package: 'Zinc-Resource-Meta-FileSystem' with: 'Zinc-Resource-Meta-FileSystem-SvenVanCaekenberghe.9' ].
	spec for: #'pharo7.x' do: [ 
		spec 
			package: 'Zinc-FileSystem' with: 'Zinc-FileSystem-SvenVanCaekenberghe.16';
			package: 'Zinc-Resource-Meta-FileSystem' with: 'Zinc-Resource-Meta-FileSystem-SvenVanCaekenberghe.9' ]
]

{ #category : 'versions' }
ConfigurationOfZincHTTPComponents >> version294: spec [
	<version: '2.9.4' imports: #('2.9-baseline')>
	spec for: #pharo do: [ 
		spec 
			blessing: #release;
			description: 'Update to latest package versions';
			author: 'SvenVanCaekenberghe';
			package: 'Zinc-Character-Encoding-Core' with: 'Zinc-Character-Encoding-Core-SvenVanCaekenberghe.64';
			package: 'Zinc-Character-Encoding-Tests' with: 'Zinc-Character-Encoding-Tests-SvenVanCaekenberghe.43';
			package: 'Zinc-Resource-Meta-Core' with: 'Zinc-Resource-Meta-Core-SvenVanCaekenberghe.68';
			package: 'Zinc-Resource-Meta-Tests' with: 'Zinc-Resource-Meta-Tests-SvenVanCaekenberghe.38';
			package: 'Zinc-HTTP' with: 'Zinc-HTTP-SvenVanCaekenberghe.475';
			package: 'Zinc-Tests' with: 'Zinc-Tests-SvenVanCaekenberghe.245';
			package: 'Zinc-AWS' with: 'Zinc-AWS-SvenVanCaekenberghe.18';
			package: 'Zinc-REST' with: 'Zinc-REST-HolgerHansPeterFreyther.20';
			package: 'Zinc-WebDAV' with: 'Zinc-WebDAV-SvenVanCaekenberghe.3';
			package: 'Zinc-WebSocket-Core' with: 'Zinc-WebSocket-Core-SvenVanCaekenberghe.30';
			package: 'Zinc-WebSocket-Tests' with: 'Zinc-WebSocket-Tests-LucFabresse.9';
			package: 'Zinc-SSO-OAuth1-Core' with: 'Zinc-SSO-OAuth1-Core-SvenVanCaekenberghe.13';
			package: 'Zinc-SSO-OAuth2-Core' with: 'Zinc-SSO-OAuth2-Core-JanVanDeSandt.20';
			package: 'Zinc-SSO-OpenID-Core' with: 'Zinc-SSO-OpenID-Core-JanVanDeSandt.6';
			package: 'Zinc-SSO-Demo' with: 'Zinc-SSO-Demo-SvenVanCaekenberghe.5';
			package: 'Zinc-SSO-OAuth1-Tests' with: 'Zinc-SSO-OAuth1-Tests-SvenVanCaekenberghe.2';
			package: 'Zinc-SSO-OpenID-Tests' with: 'Zinc-SSO-OpenID-Tests-JanVanDeSandt.3';
			package: 'Zinc-WWS-Client' with: 'Zinc-WWS-Client-PhilippeBack.3';
			package: 'Zinc-WWS-Server' with: 'Zinc-WWS-Server-SvenVanCaekenberghe.11';
			package: 'Zinc-Zodiac' with: 'Zinc-Zodiac-SvenVanCaekenberghe.44';
			package: 'Zodiac-Core' with: 'Zodiac-Core-TorstenBergmann.48';
			package: 'Zodiac-Tests' with: 'Zodiac-Tests-SvenVanCaekenberghe.22';
			package: 'Zodiac-Extra' with: 'Zodiac-Extra-SvenVanCaekenberghe.8';
			package: 'Zinc-Seaside' with: 'Zinc-Seaside-SvenVanCaekenberghe.47' ].
	spec for: #'pharo1.x' do: [ 
		spec 
			package: 'Zinc-Patch-HTTPSocket' with: 'Zinc-Patch-HTTPSocket-SvenVanCaekenberghe.1';
			package: 'Zinc-FileSystem-Legacy' with: 'Zinc-FileSystem-Legacy-SvenVanCaekenberghe.5';
			package: 'Zinc-Pharo-Forward-Compatibility' with: 'Zinc-Pharo-Forward-Compatibility-SvenVanCaekenberghe.1' ].
	spec for: #'pharo2.x' do: [ 
		spec 
			package: 'Zinc-Patch-HTTPSocket' with: 'Zinc-Patch-HTTPSocket-MarcusDenker.4';
			package: 'Zinc-FileSystem' with: 'Zinc-FileSystem-SvenVanCaekenberghe.17';
			package: 'Zinc-Resource-Meta-FileSystem' with: 'Zinc-Resource-Meta-FileSystem-SvenVanCaekenberghe.9';
			package: 'Zinc-pharo2-forward-compatibility' with: 'Zinc-pharo2-forward-compatibility-SvenVanCaekenberghe.1' ].
	spec for: #'pharo3.x' do: [ 
		spec 
			package: 'Zinc-FileSystem' with: 'Zinc-FileSystem-SvenVanCaekenberghe.17';
			package: 'Zinc-Resource-Meta-FileSystem' with: 'Zinc-Resource-Meta-FileSystem-SvenVanCaekenberghe.9' ].
	spec for: #'pharo4.x' do: [ 
		spec 
			package: 'Zinc-FileSystem' with: 'Zinc-FileSystem-SvenVanCaekenberghe.17';
			package: 'Zinc-Resource-Meta-FileSystem' with: 'Zinc-Resource-Meta-FileSystem-SvenVanCaekenberghe.9' ].
	spec for: #'pharo5.x' do: [ 
		spec 
			package: 'Zinc-FileSystem' with: 'Zinc-FileSystem-SvenVanCaekenberghe.17';
			package: 'Zinc-Resource-Meta-FileSystem' with: 'Zinc-Resource-Meta-FileSystem-SvenVanCaekenberghe.9' ].
	spec for: #'pharo6.x' do: [ 
		spec 
			package: 'Zinc-FileSystem' with: 'Zinc-FileSystem-SvenVanCaekenberghe.17';
			package: 'Zinc-Resource-Meta-FileSystem' with: 'Zinc-Resource-Meta-FileSystem-SvenVanCaekenberghe.9' ].
	spec for: #'pharo7.x' do: [ 
		spec 
			package: 'Zinc-FileSystem' with: 'Zinc-FileSystem-SvenVanCaekenberghe.17';
			package: 'Zinc-Resource-Meta-FileSystem' with: 'Zinc-Resource-Meta-FileSystem-SvenVanCaekenberghe.9' ]
]

{ #category : 'versions' }
ConfigurationOfZincHTTPComponents >> version301: spec [
	<version: '3.0.1' imports: #('3.0-baseline')>
	spec for: #pharo do: [ 
		spec 
			blessing: #release;
			description: 'Update to latest package versions';
			author: 'SvenVanCaekenberghe';
			package: 'Zinc-Character-Encoding-Core' with: 'Zinc-Character-Encoding-Core-SvenVanCaekenberghe.66';
			package: 'Zinc-Character-Encoding-Tests' with: 'Zinc-Character-Encoding-Tests-SvenVanCaekenberghe.46';
			package: 'Zinc-Resource-Meta-Core' with: 'Zinc-Resource-Meta-Core-SvenVanCaekenberghe.71';
			package: 'Zinc-Resource-Meta-Tests' with: 'Zinc-Resource-Meta-Tests-SvenVanCaekenberghe.39';
			package: 'Zinc-HTTP' with: 'Zinc-HTTP-SvenVanCaekenberghe.481';
			package: 'Zinc-HTTP-Examples' with: 'Zinc-HTTP-Examples-SvenVanCaekenberghe.3';
			package: 'Zinc-Tests' with: 'Zinc-Tests-SvenVanCaekenberghe.251';
			package: 'Zinc-Zodiac-Core' with: 'Zinc-Zodiac-Core-SvenVanCaekenberghe.1';
			package: 'Zinc-Zodiac-Tests' with: 'Zinc-Zodiac-Tests-SvenVanCaekenberghe.1';
			package: 'Zodiac-Core' with: 'Zodiac-Core-SvenVanCaekenberghe.49';
			package: 'Zodiac-Tests' with: 'Zodiac-Tests-SvenVanCaekenberghe.22';
			package: 'Zinc-Seaside' with: 'Zinc-Seaside-pmm.48';
			package: 'Zinc-REST' with: 'Zinc-REST-HolgerHansPeterFreyther.20';
			package: 'Zinc-WebSocket-Core' with: 'Zinc-WebSocket-Core-SvenVanCaekenberghe.30';
			package: 'Zinc-WebSocket-Tests' with: 'Zinc-WebSocket-Tests-LucFabresse.9';
			package: 'Zinc-AWS' with: 'Zinc-AWS-SvenVanCaekenberghe.18';
			package: 'Zinc-WebDAV' with: 'Zinc-WebDAV-SvenVanCaekenberghe.3';
			package: 'Zinc-SSO-OAuth1-Core' with: 'Zinc-SSO-OAuth1-Core-SvenVanCaekenberghe.13';
			package: 'Zinc-SSO-OAuth2-Core' with: 'Zinc-SSO-OAuth2-Core-JanVanDeSandt.20';
			package: 'Zinc-SSO-OpenID-Core' with: 'Zinc-SSO-OpenID-Core-JanVanDeSandt.6';
			package: 'Zinc-SSO-Demo' with: 'Zinc-SSO-Demo-SvenVanCaekenberghe.5';
			package: 'Zinc-SSO-OAuth1-Tests' with: 'Zinc-SSO-OAuth1-Tests-SvenVanCaekenberghe.2';
			package: 'Zinc-SSO-OpenID-Tests' with: 'Zinc-SSO-OpenID-Tests-JanVanDeSandt.3';
			package: 'Zinc-WWS-Client' with: 'Zinc-WWS-Client-PhilippeBack.3';
			package: 'Zinc-WWS-Server' with: 'Zinc-WWS-Server-SvenVanCaekenberghe.11' ]
]
