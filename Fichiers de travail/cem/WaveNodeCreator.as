package cem {
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import cem.WaveNode;
	import cem.Main;
	import flash.display.DisplayObject;
	import flash.events.Event;
	
	
	public class WaveNodeCreator extends MovieClip {
		
		public function WaveNodeCreator() {
			// constructor code
			
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
		}
		
		function onAddedToStage(pEvt:Event){
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			this.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown)
		}
		
		function onMouseDown(e:MouseEvent){
			
			var waveNode:WaveNode = new WaveNode();
			
			var frame:int = e.currentTarget.currentFrame;
			//trace(e.currentTarget.currentFrame);
			
			Main.nodeContainer.addChild(waveNode);
			waveNode.gotoAndStop(frame);
			waveNode.x = stage.mouseX;
			waveNode.y = stage.mouseY;
			waveNode.startDrag();
			//waveNode.addEventListener(MouseEvent.MOUSE_UP, onMouseUp)
		}
		

		
	}
	
}
