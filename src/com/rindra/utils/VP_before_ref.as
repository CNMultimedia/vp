package com.rindra.utils {
	import com.rindra.events.VPEvent;
	import com.rindra.utils.Calculus;
	
	import flash.display.Sprite;
	import flash.events.AsyncErrorEvent;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.NetStatusEvent;
	import flash.events.SecurityErrorEvent;
	import flash.geom.Rectangle;
	import flash.media.SoundTransform;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.net.NetStreamInfo;
	import flash.system.Capabilities;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	public class VP extends Sprite{
		
		private var ns:NetStream;
		private var nc:NetConnection;
		private var vid:Video;
		private var counter:Number=0;
		private var path:String;
		private var videoName:String;
		private var option:int;
		private var totalTime:int;
		private var vpc:VPClient;
		private var ref:Sprite;
		private var playing:Boolean;
		private var sounding:Boolean;
		private var stopping:Boolean;
		private var midPoint:Boolean = false;
		private var cc:Sprite;
		private var tf:TextFormat;
		private var ctrl:Sprite;
		private var customController:Sprite;
		private var overlayStatus:Boolean;
		private var VP_videoPath:String;
		private var VP_videoName:String;
		//private var mobileMode:String = 'AND';
		private var mobileMode:String;
		private var autoPlay:Boolean;
		private var loadOnce:Boolean = true;
		private var mVisible:Boolean;
		
		public function VP(ref:Sprite, VP_videoPath:String, VP_videoName:String = "", customController:Sprite = null, overlayStatus:Boolean = false, autoPlay:Boolean = true) {
			this.ref = ref;
			this.customController = customController;
			this.overlayStatus = overlayStatus;
			this.VP_videoPath = VP_videoPath;
			this.VP_videoName = VP_videoName;
			this.autoPlay = autoPlay;
			this.mobileMode = Capabilities.version.split(" ")[0];
			this.name = 'vp';
			init();
		}
		
		private function init():void{
			ctrl = (customController == null)?new VPController():customController;
			addChild(ctrl);
			vpc = new VPClient();
			
			Sprite(ctrl.getChildByName('play_btn')).visible = false;
			Sprite(ctrl.getChildByName('play_btn')).mouseChildren = false;
			Sprite(ctrl.getChildByName('play_btn')).buttonMode = true;
			Sprite(ctrl.getChildByName('pause_btn')).mouseChildren = false;
			Sprite(ctrl.getChildByName('pause_btn')).buttonMode = true;
			Sprite(ctrl.getChildByName('vol_on')).mouseChildren = false;
			Sprite(ctrl.getChildByName('vol_on')).buttonMode = true;	
			Sprite(ctrl.getChildByName('vol_off')).mouseChildren = false;
			Sprite(ctrl.getChildByName('vol_off')).buttonMode = true;
			Sprite(ctrl.getChildByName('bigPlay_btn')).mouseChildren = false;
			Sprite(ctrl.getChildByName('bigPlay_btn')).buttonMode = true;
			Sprite(ctrl.getChildByName('bigPause_btn')).mouseChildren = false;
			Sprite(ctrl.getChildByName('bigPause_btn')).buttonMode = true;
			Sprite(ctrl.getChildByName('bigReplay_btn')).mouseChildren = false;
			Sprite(ctrl.getChildByName('bigReplay_btn')).buttonMode = true;
			Sprite(Sprite(ctrl.getChildByName('sb')).getChildByName('scrub')).mouseChildren = false;
			Sprite(Sprite(ctrl.getChildByName('sb')).getChildByName('scrub')).buttonMode = true;
			//tf = new TextFormat();
			//tf.letterSpacing = 2;
			//TextField(ctrl.getChildByName('t')).defaultTextFormat = tf;
			Sprite(Sprite(ctrl.getChildByName('sb')).getChildByName('scrub')).addEventListener(MouseEvent.MOUSE_DOWN, _onDrag);
			if(mobileMode == 'AND'){
				mVisible = false;
				ref.addEventListener(MouseEvent.CLICK, _onShowCtrl, true);
				/*only when user actually clicks on ref, if it sets to default=false then if user clicks on any element 
				inside ref it will trigger both thefunction the element is associated with onclick and the ref onClick*/
			}else{
				ref.addEventListener(MouseEvent.ROLL_OVER, _onOver);
				ref.addEventListener(MouseEvent.ROLL_OUT, _onOut);
			}
			ref.addEventListener(Event.MOUSE_LEAVE, _onOut);
			Sprite(ctrl.getChildByName('play_btn')).addEventListener(MouseEvent.CLICK, _onPlay);
			Sprite(ctrl.getChildByName('bigPlay_btn')).addEventListener(MouseEvent.CLICK, _onPlay);
			Sprite(ctrl.getChildByName('bigReplay_btn')).addEventListener(MouseEvent.CLICK, _onReplay);
			Sprite(ctrl.getChildByName('pause_btn')).addEventListener(MouseEvent.CLICK, _onPause);
			Sprite(ctrl.getChildByName('bigPause_btn')).addEventListener(MouseEvent.CLICK, _onPause);
			Sprite(ctrl.getChildByName('vol_on')).addEventListener(MouseEvent.CLICK, _onSoundOn);
			Sprite(ctrl.getChildByName('vol_off')).addEventListener(MouseEvent.CLICK, _onSoundOff);
			allOff();
			connect();			
		}
		
		private function _onShowCtrl($e:MouseEvent):void{
			if(!mVisible){
				if($e.target.name == 'player'){
					mVisible = true;
					updatePlayer();
					//ref.removeEventListener(MouseEvent.CLICK, _onShowCtrl);
				}
			}else{
				if($e.target.name == 'player'){
					mVisible = false;
					allOff();
				}
			}
		}
		
		public function closeStream():void{
			ns.close();
		}
		
		public function makeSoundOn():void{
			ns.soundTransform = new SoundTransform(1);
			sounding = true;
			updatePlayer();
		}
		
		public function makeSoundOff():void{
			ns.soundTransform = new SoundTransform(0);
			sounding = false;
			updatePlayer();
		}
		
		private function _onSoundOn($e:MouseEvent):void{
			makeSoundOn();
		}
		
		private function _onSoundOff($e:MouseEvent):void{
			makeSoundOff();
		}
		
		private function _onPlay($e:MouseEvent):void{
			playVideo($e);
		}
		
		private function _onReplay($e:MouseEvent):void{
			replayVideo();
		}
		
		private function _onPause($e:MouseEvent):void{
			pauseVideo();
		}
		
		private function _onOver($e:MouseEvent):void{
			updatePlayer();
		}
		
		private function updatePlayer():void{
			allOn();
			Sprite(ctrl.getChildByName('play_btn')).visible = !playing;
			Sprite(ctrl.getChildByName('bigPlay_btn')).visible = !playing;
			Sprite(ctrl.getChildByName('pause_btn')).visible = playing;
			Sprite(ctrl.getChildByName('bigPause_btn')).visible = playing;
			Sprite(ctrl.getChildByName('vol_on')).visible = !sounding;
			Sprite(ctrl.getChildByName('vol_off')).visible = sounding;
			Sprite(ctrl.getChildByName('overlay_mc')).visible = overlayStatus;
		}
		
		private function _onOut($e:MouseEvent):void{
			allOff();
		}
		
		private function allOn():void{
			Sprite(ctrl.getChildByName('play_btn')).visible = true;
			Sprite(ctrl.getChildByName('pause_btn')).visible = true;
			Sprite(ctrl.getChildByName('vol_on')).visible = true;
			Sprite(ctrl.getChildByName('vol_off')).visible = true;
			Sprite(Sprite(ctrl.getChildByName('sb')).getChildByName('scrub')).visible = true;
			Sprite(Sprite(ctrl.getChildByName('sb')).getChildByName('scrollbar_bg')).visible = true;
			Sprite(ctrl.getChildByName('overlay_mc')).visible = true;
			Sprite(ctrl.getChildByName('bigPlay_btn')).visible = true;
			Sprite(ctrl.getChildByName('bigPause_btn')).visible = true;
			TextField(ctrl.getChildByName('t')).visible = true;
		}
		
		private function allOff():void{
			Sprite(ctrl.getChildByName('play_btn')).visible = false;
			Sprite(ctrl.getChildByName('pause_btn')).visible = false;
			Sprite(ctrl.getChildByName('vol_on')).visible = false;
			Sprite(ctrl.getChildByName('vol_off')).visible = false;
			Sprite(Sprite(ctrl.getChildByName('sb')).getChildByName('scrub')).visible = false;
			Sprite(Sprite(ctrl.getChildByName('sb')).getChildByName('scrollbar_bg')).visible = false;
			Sprite(ctrl.getChildByName('overlay_mc')).visible = false;
			Sprite(ctrl.getChildByName('bigPlay_btn')).visible = false;
			Sprite(ctrl.getChildByName('bigPause_btn')).visible = false;
			Sprite(ctrl.getChildByName('bigReplay_btn')).visible = false;
			TextField(ctrl.getChildByName('t')).visible = false;
		}
		
		private function connect():void {
			nc = new NetConnection();
			nc.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
			nc.addEventListener(AsyncErrorEvent.ASYNC_ERROR, asyncerror);
			if(VP_videoPath != "" && VP_videoName != ""){
				//nc.connect("rtmp://cp33413.edgefcs.net/ondemand/cs/estee_lauder/2010/");
				nc.connect(VP_videoPath);
			}else{
				nc.connect(null);
			}
		}
		
		NetConnection.prototype.onBWDone = function():void;
		NetStream.prototype.onXMPData = function():void;
		
		private function asyncerror(e:AsyncErrorEvent):void{}
		
		private function netStatusHandler(event:NetStatusEvent):void {
			//trace(event.info.code);
			switch(event.info.code){
				case "NetConnection.Connect.Success":
					ns = new NetStream(nc);
					ns.client = vpc;
					Sprite(ctrl.getChildByName('player')).alpha = 0;
					vid = new Video(Sprite(ctrl.getChildByName('player')).width,Sprite(ctrl.getChildByName('player')).height);
					vid.smoothing = true;
					vid.attachNetStream(ns);
					//VP_videoName = "mp4:elholiday_final4.mp4";
					if(autoPlay){
						initPlay();
					}
					Sprite(ctrl.getChildByName('player')).addChild(vid);
					//dispatchEvent(new VPEvent('video_start',true,false));
					ns.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
					ns.addEventListener(AsyncErrorEvent.ASYNC_ERROR, asyncerror);
					addEventListener(Event.ENTER_FRAME, _onEnterFrame);
					if(loadOnce && !autoPlay){
						loadOnce = false;
						dispatchEvent(new VPEvent('vp_ready', true, false));
					}
					nc.call('checkBandwith', null);
					break;
				case "NetStream.Play.Start":
					Sprite(ctrl.getChildByName('player')).alpha = 1;
					dispatchEvent(new VPEvent('video_start',true,false));
					break;
			}
		}
		private function initPlay():void{
			if(VP_videoPath != "" && VP_videoName != ""){
				ns.play("mp4:"+VP_videoName);
			}else{
				ns.play(VP_videoPath);	
			}
			playing = true;
			sounding = true;
			stopping = false;
		}
		private function _onDrag($e:MouseEvent):void{
			var rec:Rectangle = new Rectangle(0,0,Sprite(Sprite(ctrl.getChildByName('sb')).getChildByName('scrollbar_bg')).width - Sprite(Sprite(ctrl.getChildByName('sb')).getChildByName('scrub')).width,0);
			Sprite(Sprite(ctrl.getChildByName('sb')).getChildByName('scrub')).startDrag(false,rec);
			removeEventListener(Event.ENTER_FRAME, _onEnterFrame);
			ref.addEventListener(MouseEvent.MOUSE_UP, _onScrub);
		}
		private function _onScrub($e:MouseEvent):void{
			stopDrag();
			midPoint = false;
			scrubTo(Sprite(Sprite(ctrl.getChildByName('sb')).getChildByName('scrub')).x/(Sprite(Sprite(ctrl.getChildByName('sb')).getChildByName('scrollbar_bg')).width - Sprite(Sprite(ctrl.getChildByName('sb')).getChildByName('scrub')).width));
			addEventListener(Event.ENTER_FRAME, _onEnterFrame);
			ref.removeEventListener(MouseEvent.MOUSE_UP, _onScrub);
		}
		private function scrubTo(ratio:Number):void{
			var totalTime = vpc.totalTime;
			var s:int = Math.floor(totalTime*ratio);
			ns.seek(s);
		}
		public function _onEnterFrame($e:Event):void{
			var totalTime = vpc.totalTime;
			var length = Sprite(Sprite(ctrl.getChildByName('sb')).getChildByName('scrollbar_bg')).width - Sprite(Sprite(ctrl.getChildByName('sb')).getChildByName('scrub')).width;
			if(Math.abs(Sprite(Sprite(ctrl.getChildByName('sb')).getChildByName('scrub')).x-length)>1){
				Sprite(Sprite(ctrl.getChildByName('sb')).getChildByName('scrub')).x = (ns.time/totalTime)*(length);
				TextField(ctrl.getChildByName('t')).text = new Calculus().convertToMinSec(ns.time);
				if(Math.abs(Sprite(Sprite(ctrl.getChildByName('sb')).getChildByName('scrub')).x-length/2)<1 && !midPoint){
					midPoint = true;
					dispatchEvent(new VPEvent('video_midpoint',true,false));
				}
			}else{
				ns.seek(0);
				ns.pause();
				playing = false;
				stopping = true;
				allOff();
				Sprite(ctrl.getChildByName('bigReplay_btn')).visible = true;
				Sprite(Sprite(ctrl.getChildByName('sb')).getChildByName('scrub')).x = 0;
				TextField(ctrl.getChildByName('t')).text = "00:00";
				removeEventListener(Event.ENTER_FRAME, _onEnterFrame);
				ref.removeEventListener(MouseEvent.ROLL_OVER, _onOver);
				ref.removeEventListener(MouseEvent.ROLL_OUT, _onOut);
				dispatchEvent(new VPEvent('video_complete',true,false));
			}
		}
		
		public function pauseVideo():void{
			ns.pause();
			playing = false;
			updatePlayer();
			removeEventListener(Event.ENTER_FRAME, _onEnterFrame);
			dispatchEvent(new VPEvent('video_pause',true,false));
		}
		public function playVideo($e:Object = null):void{
			if(!autoPlay){
				autoPlay = true;
				initPlay();
				allOff();
			}else{
				ns.resume();
				playing = true;
				allOff();
				addEventListener(Event.ENTER_FRAME, _onEnterFrame);
			}
			try{
			if($e.type == 'click'){
				if(mobileMode == 'AND'){
					mVisible = false;
				//	ref.addEventListener(MouseEvent.CLICK, _onShowCtrl,true);
				}
			}
			}catch(e:Error){
				//trace('no mice were annoyed yet!')
			}
		}
		public function replayVideo():void{
			ns.resume();
			playing = true;
			midPoint = false;
			allOff();
			addEventListener(Event.ENTER_FRAME, _onEnterFrame);
			ref.addEventListener(MouseEvent.ROLL_OVER, _onOver);
			ref.addEventListener(MouseEvent.ROLL_OUT, _onOut);
			dispatchEvent(new VPEvent('video_replay',true,false));
			dispatchEvent(new VPEvent('video_start',true,false));
		}
	}
}