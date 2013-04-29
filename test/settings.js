var settings = {
	/** Player versions to test. **/
	players: {
		'trunk':'/player/trunk/fl5/player.swf',
		'5.2':'/player/tags/mediaplayer-5.2/player.swf',
		'5.1':'/player/tags/mediaplayer-5.1/player.swf',
		'5.0':'/player/tags/mediaplayer-5.0/player.swf'
	},
	/** Plugins to test. **/
	plugins: {
		qualitymonitor:'../qualitymonitor.swf'
	},
	/** Skins to test. **/
	skins: {
		'':' ',
		beelden:'/player/skins/beelden/beelden.xml',
		bekle:'/player/skins/bekle/bekle.xml',
		bluemetal:'/player/skins/bluemetal/bluemetal.swf',
		classic:'/player/skins/classic/classic.swf',
		glow:'/player/skins/glow/glow.xml',
		modieus:'/player/skins/modieus/modieus.xml',
		snel:'/player/skins/snel/snel.swf',
        stijl:'/player/skins/stijl/stijl.xml'
	},
	/** All the setup examples with their flashvars. **/
	examples: {
		'': {},
		'HTTP bitrate switching video': {
		    controlbar:'over',
			file:'/player/testing/files/bitrates.xml',
			height:270,
			width:480,
			plugins:'qualitymonitor'
		},
		'RTMP dynamic streaming video': {
		    controlbar:'over',
			file:'/player/testing/files/dynamic.xml',
			height:270,
			width:480,
			plugins:'qualitymonitor'
		},
		'Single video (no levels)': {
		    controlbar:'over',
			file:'/player/testing/files/bunny.mp4',
			image:'/player/testing/files/bunny.jpg',
			height:270,
			width:480,
			plugins:'qualitymonitor'
		}
	}
}
