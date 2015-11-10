package cem {
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	
	public class SoundNodeCreator extends MovieClip {
		
		var soundUrl:String;
		
		public function SoundNodeCreator(pSoundUrl:String) {
			// constructor code
			
			soundUrl = pSoundUrl;
			
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
		}
		
		function onAddedToStage(pEvt:Event){
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			this.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown)
			//trace("frame =" + this.currentFrame)
		}
		
		function onMouseDown(e:MouseEvent){
			
			var soundNode:SoundNode = new SoundNode(soundUrl);
			
			var frame:int = e.currentTarget.currentFrame;
			//trace(e.currentTarget.currentFrame);
			
			Main.nodeContainer.addChild(soundNode);
			soundNode.gotoAndStop(frame);
			soundNode.x = stage.mouseX;
			soundNode.y = stage.mouseY;
			soundNode.startDrag();
			//waveNode.addEventListener(MouseEvent.MOUSE_UP, onMouseUp)
		}
		
	}
	
}
