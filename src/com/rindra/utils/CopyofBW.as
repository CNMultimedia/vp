package com.rindra.utils{
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.net.URLRequest;

	public class BW extends EventDispatcher{
		public function BW(){
			initCheck();
		}
		private function initCheck():void{
			var l:Loader = new Loader();
			//l.load(new URLRequest('http://www.condenet.com/images_external/promo/2010/bw/f0.jpg'));
			l.load(new URLRequest('bw/f0.jpg'));
			l.contentLoaderInfo.addEventListener(Event.COMPLETE, _onComplete);
		}
		private function _onComplete($e:Event):void{
			dispatchEvent(new Event('complete'));
		}
	}
}