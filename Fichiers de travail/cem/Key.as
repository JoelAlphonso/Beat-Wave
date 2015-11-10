package cem {
	
	import flash.display.MovieClip;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	import flash.events.Event;
	import flash.media.Sound;
	import flash.events.MouseEvent;
	import flash.media.SoundChannel;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.media.SoundTransform;
	
	
	public class Key extends MovieClip {
		
		private var soundUrl:URLRequest;
		private var mySound:Sound;
		private var myChannel:SoundChannel;
		private var myTimer:Timer;
		public var isDown:Boolean = false;
		
		public function Key() {
			// constructor code
			
			
		}
		
		public function sound(SoundUrl){
			soundUrl = new URLRequest(SoundUrl)
			mySound = new Sound(soundUrl);
			addEventListener(MouseEvent.MOUSE_DOWN, playNote)
		}
		
		public function playNote(e:MouseEvent){
			
			myChannel = new SoundChannel;
			myChannel = mySound.play();
			var transformation:SoundTransform = myChannel.soundTransform;
			transformation.volume = Main.gameVolume;
			myChannel.soundTransform = transformation;
			this.alpha = 0.5;
			this.scaleX = 0.9;
			this.scaleY = 0.9;
			myTimer = new Timer(500, 1);
			myTimer.addEventListener(TimerEvent.TIMER, onTimer);
			myTimer.start();
		}
		
		private function onTimer(e:TimerEvent){
			this.alpha = 1
			this.scaleX = 1
			this.scaleY = 1
		}
		
	}
	
}
