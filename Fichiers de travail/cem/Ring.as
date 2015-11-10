package cem {

	import flash.display.Sprite;
	import com.greensock.*;
	import com.greensock.easing.*;
	import flash.display.Stage;
	import cem.Main
	import flash.display.MovieClip;
	import com.coreyoneil.collision.CollisionList;
	import flash.events.Event;
	import flash.events.EventDispatcher;

	public class Ring extends EventDispatcher {

		var myAnime: TweenMax;
		var circle: Sprite;
		var container: MovieClip;
		var speed: Number;
		var endSize: Number;
		var xPos: Number;
		var yPos: Number;
		var startSize: Number;
		var color: int;
		var ringScale: int = 15;
		var repeatValue: Number = -1; //Pour boucler l'animation à l'infinie
		var canLoop: Boolean = true;


		public function Ring(posX, posY, kind, Container) {
			// constructor code

			xPos = posX;
			yPos = posY;
			container = Container;

			switch (kind) {
				case "fast":
					speed = 0.5;
					color = 0xFF6354;
					ringScale = 10;
					break;
				case "medium":
					speed = 1;
					color = 0xFFE77D
					ringScale = 12.5;
					break;
				case "slow":
					speed = 2;
					color = 0x70FF99;
					ringScale = 15;
					break;
				case "small":
					speed = 0.5;
					color = Math.random() * 0xFFFFFF;
					ringScale = 5;
					repeatValue = 0;
					break;
				case "random":
					speed = Math.random() * 2.5 + 0.5;
					color = Math.random() * 0xFFFFFF;
					ringScale = Math.random() * 25 + 5;
					repeatValue = 0;
					break;
			}

			createCircle();
		}

		function createCircle() {

			circle = new Sprite;

			circle.graphics.beginFill(color);
			circle.graphics.drawCircle(0, 0, 10);
			circle.graphics.drawCircle(0, 0, 9);
			circle.graphics.endFill();

			circle.x = xPos
			circle.y = yPos
			container.addChild(circle);

			tween();

		}

		function tween() {
			myAnime = TweenMax.to(circle, speed, {
				scaleX: ringScale,
				scaleY: ringScale,
				alpha: 0,
				ease: Linear.easeNone,
				onUpdate: updateSpeed,
				onUpdateParams: ["{self}"], // se renvoie lui-même en paramêtre
				repeat: repeatValue,
				onComplete: remove
			});
		}

		function updateSpeed(twee) { // Fonction pour updater la modifier la vitesse de l'animation a chaque frames de l'animation

			twee.timeScale(Main.gameSpeed + 0.5)
		}


		public function remove() {
			myAnime.kill()
			container.removeChild(circle);
		}



	}

}