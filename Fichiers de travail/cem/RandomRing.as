package cem {

	import flash.display.Sprite;
	import com.greensock.*;
	import com.greensock.easing.*;
	import flash.display.Stage;
	import cem.Main
	import flash.display.MovieClip;
	import com.coreyoneil.collision.CollisionList;

	public class RandomRing {

		var circle: Sprite;
		var container:MovieClip;
		var main:Main;
		var speed: Number;
		var endSize: Number;
		var xPos: Number;
		var yPos: Number;
		var startSize: Number

		public function RandomRing(ref, Container) {
			// constructor code
			main = ref;
			container = Container;
			createCircle()
		}
		
		function createCircle() {

			speed = Math.random() + 1;
			endSize = Math.random() * 3 + 2;
			xPos = Math.random() * main.stage.stageWidth;
			yPos = Math.random() * main.stage.stageHeight;
			startSize = Math.random() * 80 + 20;
			circle = new Sprite;

			circle.graphics.beginFill(Math.random() * 0xFFFFFF, Math.random());
			circle.graphics.drawCircle(0, 0, startSize);
			circle.graphics.drawCircle(0, 0, startSize - 10);
			circle.graphics.endFill();

			circle.x = xPos
			circle.y = yPos
			container.addChild(circle);
			//main.listeCollision.addItem(circle)

			TweenLite.to(circle, speed, {
				scaleX: endSize,
				scaleY: endSize,
				alpha: 0,
				ease: Circ.easeOut,
				onComplete: rebirth
			});

		}

		function rebirth() {
			container.removeChild(circle);
			//main.listeCollision.removeItem(circle)
			createCircle();
		}
	}

}