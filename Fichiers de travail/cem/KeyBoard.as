package cem {

	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.KeyboardEvent;


	public class KeyBoard extends MovieClip {

		var keySoundArray: Array;

		public function KeyBoard(KeySoundArray: Array) {
			// constructor code
			keySoundArray = KeySoundArray
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);

		}

		private function onAddedToStage(e: Event) {

			for (var i: int = 0; i < this.numChildren; i++) {
				var key = this.getChildByName("key" + i)
				key.gotoAndStop(i + 1);
				key.sound(keySoundArray[i]);
			}

			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyPress)
			stage.addEventListener(KeyboardEvent.KEY_UP, onKeyRelease)

		}

		private function onKeyPress(e: KeyboardEvent) {

			var noteToPlay;

			switch (e.keyCode) {
				case 65: // a
					noteToPlay = this.getChildByName("key0")
					break;
				case 87: // w
					noteToPlay = this.getChildByName("key1")
					break;
				case 83: // s
					noteToPlay = this.getChildByName("key2")
					break;
				case 69: // e
					noteToPlay = this.getChildByName("key3")
					break;
				case 68: // d
					noteToPlay = this.getChildByName("key4")
					break;
				case 70: // f
					noteToPlay = this.getChildByName("key5")
					break;
				case 84: // t
					noteToPlay = this.getChildByName("key6")
					break;
				case 71: // g
					noteToPlay = this.getChildByName("key7")
					break;
				case 89: // y
					noteToPlay = this.getChildByName("key8")
					break;
				case 72: // h
					noteToPlay = this.getChildByName("key9")
					break;
				case 85: // u
					noteToPlay = this.getChildByName("key10")
					break;
				case 74: // j
					noteToPlay = this.getChildByName("key11")
					break;
			}
			if (noteToPlay is Key) {
				if (!noteToPlay.isDown) {
					noteToPlay.playNote(null)
					noteToPlay.isDown = true;
				}
			}
		}

		private function onKeyRelease(e: KeyboardEvent) {

			var noteToPlay;

			switch (e.keyCode) {
				case 65: // a
					noteToPlay = this.getChildByName("key0")
					break;
				case 87: // w
					noteToPlay = this.getChildByName("key1")
					break;
				case 83: // s
					noteToPlay = this.getChildByName("key2")
					break;
				case 69: // e
					noteToPlay = this.getChildByName("key3")
					break;
				case 68: // d
					noteToPlay = this.getChildByName("key4")
					break;
				case 70: // f
					noteToPlay = this.getChildByName("key5")
					break;
				case 84: // t
					noteToPlay = this.getChildByName("key6")
					break;
				case 71: // g
					noteToPlay = this.getChildByName("key7")
					break;
				case 89: // y
					noteToPlay = this.getChildByName("key8")
					break;
				case 72: // h
					noteToPlay = this.getChildByName("key9")
					break;
				case 85: // u
					noteToPlay = this.getChildByName("key10")
					break;
				case 74: // j
					noteToPlay = this.getChildByName("key11")
					break;
			}

			if (noteToPlay is Key) {
				noteToPlay.isDown = false
			}
			


		}

	}

}