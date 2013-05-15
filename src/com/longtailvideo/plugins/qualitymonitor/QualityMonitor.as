package com.longtailvideo.plugins.qualitymonitor {


import com.longtailvideo.jwplayer.events.MediaEvent;
import com.longtailvideo.jwplayer.events.PlayerStateEvent;
import com.longtailvideo.jwplayer.player.IPlayer;
import com.longtailvideo.jwplayer.plugins.IPlugin;
import com.longtailvideo.jwplayer.plugins.PluginConfig;
import com.longtailvideo.plugins.qualitymonitor.Sparkline;

import flash.display.*;
import flash.events.*;
import flash.geom.Rectangle;
import flash.text.*;
import flash.utils.*;


/** Small plugin that displays bandwidth, screensize, droppedframes and quality level. **/
public class QualityMonitor extends Sprite implements IPlugin {


	/** Reference to the background clip. **/
	private var _back:Sprite;
	/** Object with data. **/
	private var _data:Object;
	/** Reference to the textfield. **/
	private var _field:TextField;
	/** Reference to the update interval. **/
	private var _interval:Number;
	/** List with sparkline instances. **/
	private var _lines:Array;
	/** Reference to the player. **/
	private var _player:IPlayer;
	/** Reference to the cetner-screen message field. **/
	private var _message:TextField;
	/** visible / hide */
	private var _isvisible:Boolean = false;

	/** Add sparklines to the plugin. **/
	private function addLine(max:Number,clr:Number):Sparkline {
		var lne:Sparkline = new Sparkline(200,90,0,max,clr);
		lne.x = 190;
		lne.y = 12;
		addChild(lne);
		return lne;
	};


	/** Build the plugin graphics. **/
	private function buildStage():void {
	   
		_back = new Sprite();
		_back.mouseEnabled = true;
		_back.mouseChildren = false;
		_back.addEventListener(MouseEvent.CLICK, clickHandler);
		addChild(_back);
		_field = new TextField();
		_field.width = 180;
		var fmt:TextFormat = new TextFormat("_sans",11,0xFFFFFF);
		fmt.leading = 10;
		_field.defaultTextFormat = fmt;
		_field.multiline = true;
		_field.y = 12;
		_field.x = 16;
		_field.mouseEnabled = false;
		addChild(_field);
		_lines = new Array(
			addLine(2000,0x00FF00),
			addLine(60,0xFF0000),
			addLine(6,0xFFFFFF)
		);
		_message = new TextField();
		var mft:TextFormat = new TextFormat("_sans",15);
		mft.bold = true;
		mft.align = 'center';
		_message.defaultTextFormat = mft;
		_message.width = 300;
		_message.visible = false;
		_message.mouseEnabled = false;
		addChild(_message);
		toggleDisplay();
	};
	
   /** button is clicked, hide quality monitoring. **/
   private function clickHandler(evt:Event=null):void {
      _isvisible = !_isvisible;
      toggleDisplay();
   }
   
   private function toggleDisplay():void {
      if(_isvisible) {
         _back.graphics.beginFill(0x000000,0.5);
      } else {
         _back.graphics.clear();
         _back.graphics.beginFill(0xffffff,0);
      }
           _back.graphics.drawRect(0,0,400,116);
	   _field.visible = _isvisible;
	   _lines[0].visible = _isvisible;
	   _lines[1].visible = _isvisible;
	   _lines[2].visible = _isvisible;
   }

	/** Update quality metrics chart. **/
	private function checkQuality():void {
		var txt:String = _data.currentLevel;
		var idx:Number = Number(txt.substr(0,1));
		if(_player.playlist.length) {
			var arr:Array = _player.playlist.currentItem.levels;
			if(arr.length > 0) {
				var lvl:Number = _player.playlist.currentItem.currentLevel;
				idx = arr.length - lvl;
				txt = (lvl+1) + ' of '+arr.length;
				txt += ' (' + arr[lvl]['bitrate'] + 'kbps, ' + arr[lvl]['width'] + 'px)';
			}
		}
		_lines[0].spark(_data.bandwidth);
		_lines[1].spark(_data.buffer);
		_lines[2].spark(idx);
		_field.htmlText =
			'<font color="#00FF00"><b>bandwidth:</b> ' + _data.bandwidth + ' kbps<br/></font>' +
			'<font color="#FF0000"><b>buffer size:</b> ' + _data.buffer + ' sec<br/></font>' +
			'<font color="#FFFFFF"><b>level:</b> ' + txt + '</font>';
	};


	/** Returns the plugin name. **/
	public function get id():String {
		return "qualitymonitor";
	};


	/** Called by the player to initialize; setup events and dock buttons.  */
	public function initPlugin(player:IPlayer, config:PluginConfig):void {
		_player = player;
		_player.addEventListener(MediaEvent.JWPLAYER_MEDIA_META,metaHandler);
		_player.addEventListener(MediaEvent.JWPLAYER_MEDIA_TIME,mediaTimeHandler);
		_player.addEventListener(PlayerStateEvent.JWPLAYER_PLAYER_STATE,stateHandler);
		_data = {
			bandwidth: 0,
			droppedFrames: 0,
			currentLevel: '1 of 1 (0kbps, 320px)',
			width: _player.config.width,
			buffer:0
		};

		buildStage();
		checkQuality();
	};

	/** Blip a transition complete text in the display. **/
	private function metaHandler(event:MediaEvent):void {
		if(event.metadata.code && event.metadata.code == 'NetStream.Play.TransitionComplete') {
			setMessage("Transition completed",0x00FF00);
		}
		if(event.metadata.bandwidth) {
			_data.bandwidth = event.metadata.bandwidth;
		}
		if(event.metadata.droppedFrames > -1) {
			_data.droppedFrames = event.metadata.droppedFrames;
		}
		if(event.metadata.currentLevel) {
			_data.currentLevel = event.metadata.currentLevel;
		}
		if(event.metadata.type == 'blacklist') {
			if(event.metadata.state === false) {
				setMessage("Un-blacklisted level " + (event.metadata.level+1),0xff0000);
			} else {
				setMessage("Blacklisted level " + (event.metadata.level+1),0xff0000);
			}
		}
	};
	
	/** Blip a transition complete text in the display. **/
	private function mediaTimeHandler(event:MediaEvent):void {
		if((event.bufferPercent != 0) && (event.duration >0)) {
			_data.buffer = Math.round(event.bufferPercent*event.duration/10)/10;
		} else {
		   _data.buffer = 0;
		}
   }

	/** Reposition the monitor when the player resizes itself **/
	public function resize(wid:Number, hei:Number):void {
		_back.width = _data.width = wid;
		_field.width = wid/2-10;
		for(var i:Number=0; i<_lines.length; i++) {
			_lines[i].resize(wid - 200);
		}
		_message.x = wid / 2 - 150;
		_message.y = hei / 2 - 10;
	};


	/** Set the message in the middle of the screen. **/
	private function setMessage(txt:String,clr:Number):void {
		_message.text = txt;
		_message.textColor = clr;
		_message.visible = true;
		setTimeout(setMessageTimeout,6000);
	};


	/** Hide the transitioning text again. **/
	private function setMessageTimeout():void {
		_message.visible = false;
	};


	/** Only update the plugin when the video is playing. **/
	private function stateHandler(evt:PlayerStateEvent):void {
		if (evt.newstate == 'PLAYING') {
			_interval = setInterval(checkQuality,100);
		} else {
			clearInterval(_interval);
		}
	};


}


}