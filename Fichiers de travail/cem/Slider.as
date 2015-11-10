package cem {
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.events.Event;
	import flash.ui.Mouse;
	import flash.media.SoundTransform;
	
	
	public class Slider extends MovieClip {
		
		var isDragging:Boolean = false;
		var mySliderLength:Number;
		var dataToChange:Number = 0.5;
		
		public function Slider(len:Number) {
			// constructor code
			
			mySliderLength = len;
			
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
		}
		
		private function onAddedToStage(e:Event){
			
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage)
			
			this.handle.addEventListener(MouseEvent.MOUSE_DOWN, onmouseDown)
			
			this.handle.buttonMode = true;
		}
		
		private function adjustData(e:Event){
			
			this.bar.width = this.handle.x
			
			dataToChange = handle.x/mySliderLength;
			
		}
		
		private function onmouseDown(e:MouseEvent){
			
			isDragging = true;
			
			var boundingBox:Rectangle=new Rectangle(0,0,mySliderLength, 0)
			
			handle.startDrag(false, boundingBox)
			
			stage.addEventListener(MouseEvent.MOUSE_UP, onmouseUp)
			
			addEventListener(Event.ENTER_FRAME, adjustData)
			
		}
		
		private function onmouseUp(e:MouseEvent){
			
			if(isDragging){
				
				removeEventListener(Event.ENTER_FRAME, adjustData)
			
				handle.stopDrag()
				
				isDragging = false;
			}
			
			
			
		}
		
	}
	
}
