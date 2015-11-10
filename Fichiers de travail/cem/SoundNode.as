package cem {
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import com.greensock.TweenLite;
	import flash.net.URLRequest;
	import flash.media.SoundChannel;
	import flash.media.Sound;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.media.SoundTransform;
	
	
	public class SoundNode extends MovieClip {
		
		private var myUrl:URLRequest;
		private var myChannel:SoundChannel;
		private var canPlay:Boolean;
		private var mySound:Sound;
		private var myTimer:Timer;
		private var ring:Ring;
		
		public function SoundNode(pSoundUrl:String) {
			// constructor code
			
			canPlay = true
			// var pour le son
			
			//charger le son
			myUrl = new URLRequest(pSoundUrl);
			mySound = new Sound(myUrl);
			
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage)

			this.name = "soundNode";
			
		}
		
		function onAddedToStage(e:Event){
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage)
			
			addEventListener(MouseEvent.MOUSE_UP, onMouseUp)
			
			this.buttonMode = true;
		}
		
		function onMouseUp(e:MouseEvent){
			
			if(this.hitTestObject(Main.trashRef)){
				remove();
				return;
			}
			
			TweenLite.to(Main.trashRef, 0.5, {y:25, alpha:0, onComplete:onAnimeEnd});
			
			removeEventListener(MouseEvent.MOUSE_UP, onMouseUp)
			
			this.stopDrag();
			Main.listeCollisionGreen.addItem(this);
			Main.listeCollisionYellow.addItem(this);
			Main.listeCollisionRed.addItem(this);
			
			addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown)
			
		}
		
		function onMouseDown(e:MouseEvent){
			Main.trashRef.visible = true;
			TweenLite.to(Main.trashRef, 0.5, {y:50, alpha:1});
			
			this.startDrag();
			Main.listeCollisionGreen.removeItem(this);
			Main.listeCollisionYellow.removeItem(this);
			Main.listeCollisionRed.removeItem(this);
			
			removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown)
			addEventListener(MouseEvent.MOUSE_UP, onMouseUp)
			
		}
		
		function remove(){
			TweenLite.to(Main.trashRef, 0.5, {y:25, alpha:0, onComplete:onAnimeEnd});
			this.parent.removeChild(this)
		}
		
		function onAnimeEnd(){
			Main.trashRef.visible = false;
		}
		
		public function playSound(ms){
			if(canPlay == true){
				canPlay = false
				
				myTimer = new Timer(ms, 1);
				myTimer.addEventListener(TimerEvent.TIMER, onTimerComplete);
				myTimer.start();
				
				myChannel = new SoundChannel();
				myChannel = mySound.play();
				
				var transformation:SoundTransform = myChannel.soundTransform;
				transformation.volume = Main.gameVolume;
				myChannel.soundTransform = transformation;
				
				myChannel.addEventListener(Event.SOUND_COMPLETE, soundEnd);
				
				ring = new Ring(this.x, this.y, "small", Main.tempNodeContainer);
				
			}
		}
		
		function onTimerComplete(e:TimerEvent){
			
			myTimer.removeEventListener(TimerEvent.TIMER, onTimerComplete);
			canPlay = true;
			
		}
		
		function soundEnd(e:Event){
			
			myChannel = null;
			
			
		}
		
	}
	
}
