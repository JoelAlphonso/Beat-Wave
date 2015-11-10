package cem {
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import cem.Main;
	import com.greensock.TweenLite;
	import com.greensock.easing.Circ;
	
	public class WaveNode extends MovieClip {
		
		var main:Main;
		var ring:Ring;
		var container:MovieClip;
		
		public function WaveNode() {
			// constructor code
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage)
		}
		
		function onAddedToStage(e:Event){
			
			addEventListener(MouseEvent.MOUSE_UP, onMouseUp)
			
			//trace(Main.waveContainer)
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
			
			var frame:int = e.currentTarget.currentFrame;
			var vitesse:String;
			
			switch(frame){
				case 1:
					vitesse = "slow";
					container = Main.waveContainerGreen
				break;
				case 2:
					vitesse = "medium";
					container = Main.waveContainerYellow
				break;
				case 3:
					vitesse = "fast";
					container = Main.waveContainerRed
				break;	
			}
			
			ring = new Ring(this.x, this.y, vitesse, container);
			
			addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown)
			
		}
		
		function onMouseDown(e:MouseEvent){
			Main.trashRef.visible = true;
			TweenLite.to(Main.trashRef, 0.5, {y:50, alpha:1});
			
			ring.remove();
			this.startDrag();
			
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
		
	}
	
}
