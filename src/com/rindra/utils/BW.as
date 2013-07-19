package com.rindra.utils{
	import com.rindra.events.VPEvent;
	
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.net.URLRequest;
	
	public class BW extends EventDispatcher{
		public function BW(){
			//initCheck();
			_onComplete();
		}
		private function initCheck():void{
			var l:Loader = new Loader();
			l.load(new URLRequest('http://www.condenet.com/images_external/promo/2010/bw/f0.jpg'));
			//l.load(new URLRequest('bw/f0.jpg'));
			l.contentLoaderInfo.addEventListener(Event.COMPLETE, _onComplete);
		}
		private function _onComplete($e:Event = null):void{
			dispatchEvent(new VPEvent('bw_check_complete', true, false));
		}
	}
}