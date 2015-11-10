package cem {

	import flash.display.MovieClip;
	import cem.Ring;
	import com.coreyoneil.*;
	import flash.utils.setInterval;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import com.coreyoneil.collision.CollisionList;
	import flash.events.Event;
	import flash.display.Sprite;
	import flash.filesystem.File;
	import com.coreyoneil.collision.CollisionGroup;
	import flash.media.SoundTransform;
	import flash.events.MouseEvent;
	import flash.display.MorphShape;
	import flash.system.ApplicationDomain;
	import flash.desktop.NativeApplication;
	import flash.media.Sound;
	import flash.net.URLRequest;
	import flash.media.SoundChannel;
	import flash.display.DisplayObjectContainer;
	import flash.display.SimpleButton;
	import flash.net.URLLoader;
	import flash.display.StageDisplayState;
	import flash.geom.Matrix;

	public class Main extends MovieClip {

		//Static variables
		static var gameVolume: Number = 0.5;
		static var gameSpeed: Number = 0.5;
		static var speed: Number = 0.5;
		static var listeCollisionGreen: CollisionList;
		static var listeCollisionYellow: CollisionList;
		static var listeCollisionRed: CollisionList;

		//Static Containers
		static var waveContainerGreen: MovieClip;
		static var waveContainerYellow: MovieClip;
		static var waveContainerRed: MovieClip;
		static var tempNodeContainer: MovieClip;
		static var nodeContainer: MovieClip;
		static var trashRef: MovieClip;

		//Containers Variables
		var layoutContainer: MovieClip;
		var menuContainer: MovieClip;
		var helpContainer: MovieClip;
		var animeContainer: MovieClip;
		var maskContainer: MovieClip;
		var jeuContainer: MovieClip;

		private var mainThemePlaying: Boolean = false;
		var gamePaused: Boolean = false;
		var gameMuted: Boolean = false;

		var jeu: Jeu;
		var intro: AnimeIntro;
		var menu: Menu;
		var helpMenu: HelpMenu = new HelpMenu();

		var tempSpeed: Number;
		var circleTimer: Timer;
		public var aSoundNodeCreator: MovieClip;

		var menuSound: Sound;
		var menuSoundUrl: URLRequest;
		var menuSoundChannel: SoundChannel = new SoundChannel();

		var rollOverSoundUrl: URLRequest = new URLRequest("sons-bouton/bump.mp3");
		var rollOverSound: Sound = new Sound(rollOverSoundUrl);

		var mouseDownSoundUrl: URLRequest = new URLRequest("sons-bouton/bip.mp3");
		var mouseDownSound: Sound = new Sound(mouseDownSoundUrl);

		public var listeMp3: Array = new Array();
		public var listeMp3Keyboard: Array;
		public var musicDirectory: File = File.applicationDirectory;
		public var keySoundDirectory: File = File.applicationDirectory;
		var lagTimer: Timer;

		//var cachedStar:Star = new Star();


		public function Main(): void {
			// constructor code

			stage.displayState = StageDisplayState.FULL_SCREEN_INTERACTIVE; // Full Screen
			//cachedStar.cacheAsBitmapMatrix = cachedStar.transform.concatenatedMatrix
			//cachedStar.cacheAsBitmap = true
			//cachedStar.cacheAsBitmapMatrix = new Matrix();

			lagTimer = new Timer(100, 0);
			lagTimer.addEventListener(TimerEvent.TIMER, delayForLag);
			lagTimer.start();


		}

		private function delayForLag(e: TimerEvent): void {
			lagTimer.stop()
			lagTimer.removeEventListener(TimerEvent.TIMER, delayForLag);
			createContainers(); // Fonction pour créer tous les conteneurs
			createSoundTheme(); // Associe la musique thème à la variable menuSound
			createMask();
			startAnimeIntro(); // Pour commencer l'animation d'intro
		}

		private function createSoundTheme(): void { // Associe la musique du menu à la var menuSound
			menuSoundUrl = new URLRequest("musique/Pamgaea.mp3")
			menuSound = new Sound(menuSoundUrl);
		}

		private function startAnimeIntro(): void { // Pour commencer l'animation d'intro

			intro = new AnimeIntro();
			animeContainer.addChild(intro)

			intro.addEventListener("finAnime", finIntroEvent); // Execute la fonction finIntroEvent() quand l'intro est fini

			intro.btnSkip.addEventListener(MouseEvent.CLICK, finIntroMouseEvent) // Execute la fonction finIntroEvent() quand l'utilisateur pèse sur le bouton "passer"

			playMenuMusique();
			mainThemePlaying = true;
		}

		private function finIntroEvent(e: Event): void {
			finIntro(); // call finIntro à partir d'un Event de type Event
		}

		private function finIntroMouseEvent(e: MouseEvent): void {
			finIntro(); // call finIntro à partir d'un Event de type MouseEvent
		}

		private function finIntro(): void { // Fin Intro + créer les composantes du jeu
			intro.stop();
			animeContainer.removeChild(intro);
			createMenu();
			createHelpMenu();
			createGameComponent();
		}

		private function createContainers(): void {
			//Containers
			waveContainerGreen = new MovieClip();
			waveContainerYellow = new MovieClip();
			waveContainerRed = new MovieClip();
			tempNodeContainer = new MovieClip();
			nodeContainer = new MovieClip();
			layoutContainer = new MovieClip();
			menuContainer = new MovieClip();
			helpContainer = new MovieClip();
			animeContainer = new MovieClip();
			maskContainer = new MovieClip();
			jeuContainer = new MovieClip();

			addChild(jeuContainer);
			addChild(tempNodeContainer);
			addChild(nodeContainer);
			addChild(waveContainerGreen);
			addChild(waveContainerYellow);
			addChild(waveContainerRed);
			addChild(layoutContainer);
			addChild(menuContainer);
			addChild(helpContainer);
			addChild(animeContainer);
			addChild(maskContainer);


			//Nommer les instances pour facilité la détection de collisions
			waveContainerGreen.name = "wcGreen";
			waveContainerYellow.name = "wcYellow";
			waveContainerRed.name = "wcRed";
		}

		private function createMask(): void { // met un mask par dessus tout pour ne pas voir le vide lorsque visionné sur différentes résolutions
			var myMask: MyMask = new MyMask();
			maskContainer.addChild(myMask);

		}

		private function createMenu(): void {

			menu = new Menu();
			menuContainer.addChild(menu)

			//Boutons du menu
			menu.btnPlayAnime.addEventListener(MouseEvent.CLICK, nouvellePartie)
			menu.btnHelpAnime.addEventListener(MouseEvent.CLICK, fromMainToHelp)
			menu.btnSoundAnime.addEventListener(MouseEvent.CLICK, chooseFolder)
			menu.btnQuit.addEventListener(MouseEvent.CLICK, exitGame)

			//Timer pour animation de fond généré dynamiquement
			circleTimer = new Timer(250);
			circleTimer.addEventListener(TimerEvent.TIMER, createMenuBackAnime);
			circleTimer.start();

			if (!mainThemePlaying) { // Faire jouer la musique si elle ne joue pas déjà
				playMenuMusique();
				mainThemePlaying = true;
			}
		}

		private function playMenuMusique(): void { // Pour jouer de la musique au menu
			var transformation: SoundTransform = menuSoundChannel.soundTransform;
			transformation.volume = 0.3;
			menuSoundChannel = menuSound.play(0, 9999, transformation)
		}

		private function createMenuBackAnime(e: TimerEvent): void { // Pour générer un animation d'arriere plan pour le menu

			var posX: Number = Math.random() * stage.stageWidth;
			var posY: Number = Math.random() * stage.stageHeight;
			var backCircle = new Ring(posX, posY, "random", menu.menuBackCircleContainer)

		}

		private function chooseFolder(e: MouseEvent): void {
			musicDirectory.browseForDirectory("Ouvrir dossier de son mp3")
			musicDirectory.addEventListener(Event.SELECT, folderSelected)
		}

		private function folderSelected(e: Event): void { //Fonction lancé quand le joueur à choisi un dossier

			listeMp3 = []; //Reset l'array liste Mp3

			loadSoundFromListing();
		}

		private function createHelpMenu(): void { //Crée le menu d'aide
			helpContainer.addChild(helpMenu);
			helpMenu.visible = false;
			helpMenu.gotoAndStop("info")
			var i: int;
			for (i = 0; i < 6; i++) {
				//var btn = helpMenu. + "btnInfo" + i
				helpMenu["btnInfo" + i].addEventListener(MouseEvent.ROLL_OVER, changeInfo)
				helpMenu["btnInfo" + i].addEventListener(MouseEvent.ROLL_OUT, unChangeInfo)
			}

		}

		private function changeInfo(e: MouseEvent): void {
			switch (e.currentTarget.name) {
				case "btnInfo0":
					helpMenu.gotoAndStop("infoNav");
					break;
				case "btnInfo1":
					helpMenu.gotoAndStop("infoTrash");
					break;
				case "btnInfo2":
					helpMenu.gotoAndStop("infoWave");
					break;
				case "btnInfo3":
					helpMenu.gotoAndStop("infoControl");
					break;
				case "btnInfo4":
					helpMenu.gotoAndStop("infoNode");
					break;
				case "btnInfo5":
					helpMenu.gotoAndStop("infoKeyboard");
					break;
			}
		}

		private function unChangeInfo(e: MouseEvent): void {
			helpMenu.gotoAndStop("info")
		}

		private function resetMenuBtn(): void {
			menu.btnPlayAnime.gotoAndPlay(0)
			menu.btnHelpAnime.gotoAndPlay(0)
			menu.btnSoundAnime.gotoAndPlay(0)
		}

		// ---------------------- FONCTIONS de NAVIGATION --------------------------------

		private function fromMainToHelp(e: MouseEvent): void {
			helpMenu.visible = true;
			helpMenu.btnHome.addEventListener(MouseEvent.CLICK, fromHelpToMain)
		}

		private function fromHelpToMain(e: MouseEvent): void {
			helpMenu.visible = false;
			helpMenu.btnHome.removeEventListener(MouseEvent.CLICK, fromHelpToMain)
			resetMenuBtn();
		}

		private function fromGameToMain(e: MouseEvent): void {
			resetGame();
			menu.visible = true;
			circleTimer.start();

			if (!mainThemePlaying) {
				playMenuMusique();
				mainThemePlaying = true;
			}

			resetMenuBtn();
		}

		private function fromGameToHelp(e: MouseEvent): void {

			pauseGame();
			helpMenu.visible = true;
			helpMenu.btnHome.addEventListener(MouseEvent.CLICK, fromHelpToGame)
		}

		private function fromHelpToGame(e: MouseEvent): void {

			unpauseGame();
			helpMenu.visible = false;
			helpMenu.btnHome.removeEventListener(MouseEvent.CLICK, fromHelpToGame)
		}

		// --------------------------- FIN FONCTIONS DE NAVIGATION ------------------------------

		private function createGameComponent(): void { // Créer les partie du jeu qui n'ont pas besoin d'etre enlevé et remis à chaque partie

			jeu = new Jeu();
			jeuContainer.addChild(jeu);

			//Crée la liste de collision constitué de trois conteneurs qui recevront les pastilles d'ondes
			listeCollisionGreen = new CollisionList(waveContainerGreen);
			listeCollisionYellow = new CollisionList(waveContainerYellow);
			listeCollisionRed = new CollisionList(waveContainerRed);

			trashRef = this.jeu.trash; // Relie la poubelle de son, qui est déjà sur la scène, à la var trashRef
			trashRef.visible = false; // Cache la poubelle

			loadDefaultSound();
			loadDefaultKeyboardSound();

			//Event listener pour les boutons du jeu
			jeu.btnHome.addEventListener(MouseEvent.CLICK, fromGameToMain)
			jeu.btnHelp.addEventListener(MouseEvent.CLICK, fromGameToHelp)
			jeu.btnQuit.addEventListener(MouseEvent.CLICK, exitGame)
			jeu.btnPause.addEventListener(MouseEvent.CLICK, togglePause)
			jeu.btnPause.gotoAndStop(1)
			jeu.btnMute.addEventListener(MouseEvent.CLICK, toggleMute)
			jeu.btnMute.gotoAndStop(1)

			searchButton(this);

		}

		private function searchButton(e: DisplayObjectContainer) { // Fonction qui recherche tous les boutons sur le stage
			//trace( DisplayObjectContainer.numChildren)

			for (var i: int = 0; i < e.numChildren; i++) {

				var child = e.getChildAt(i);

				if (child is SimpleButton) { // vérifie si l'enfant est un bouton

					child.addEventListener(MouseEvent.ROLL_OVER, addRollOver);
					child.addEventListener(MouseEvent.MOUSE_DOWN, addMouseDown);

				} else if (child is DisplayObjectContainer && child.numChildren > 0) { // Vérifie si l'enfant est un container d'autres enfants et qu'il en contient plus d'un

					searchButton(child);

				}
			}
		}

		private function addRollOver(e: MouseEvent): void { // rajoute le son rollOver sur tout les boutons
			rollOverSound.play();
		}

		private function addMouseDown(e: MouseEvent): void { // rajoute le son mouseDown sur tout les boutons
			mouseDownSound.play();
		}

		private function nouvellePartie(e: MouseEvent): void { // Commencer la partie

			//Cacher le menu et arrèter l'instanciation des cercles
			menu.visible = false;
			circleTimer.stop();

			//Arrêter la musique
			menuSoundChannel.stop();
			mainThemePlaying = false;

			createLayout(); //fonction pour creer l'environnement du jeu

			this.addEventListener(Event.ENTER_FRAME, verifierCollision); // Vérifie les collisions de la liste de collision sur Enter_Frame
		}

		private function createLayout(): void { //fonction pour creer l'environnement du jeu

			createSliders(); // Cré les sliders de son et de vitesse

			createDefaultWaveNodeCreator();

			createDefaultSoundNodeCreator();

			createKeyboard();

		}

		private function createSliders(): void {
			var sliderVolume = new Slider(150)
			layoutContainer.addChild(sliderVolume)
			sliderVolume.x = stage.stageWidth - 185
			sliderVolume.y = 35
			sliderVolume.addEventListener(Event.ENTER_FRAME, ajustVolume)

			var sliderSpeed = new Slider(150)
			layoutContainer.addChild(sliderSpeed)
			sliderSpeed.x = stage.stageWidth - 185
			sliderSpeed.y = 70
			sliderSpeed.addEventListener(Event.ENTER_FRAME, ajustSpeed)
		}

		private function ajustSpeed(e: Event): void { // recoit une donnée du sliderSpeed et l'update dans la variable gameSpeed
			if (!gamePaused) { //Vérifie si le jeu est sur pause
				gameSpeed = e.currentTarget.dataToChange
			}
		}

		private function ajustVolume(e: Event): void { // recoit une donnée du sliderVolume et l'update dans la variable gameVolume
			if (!gameMuted) { // Vérifie si le jeu est sur Mute
				gameVolume = e.currentTarget.dataToChange
			}
		}

		private function loadDefaultKeyboardSound(): void { // Précharge les urls des sons de clavier par default et les pousse dans un tableau
			listeMp3Keyboard = new Array()
			keySoundDirectory = keySoundDirectory.resolvePath("sons-dubstep");
			var files: Array = keySoundDirectory.getDirectoryListing();
			for (var j: int; j < files.length; j++) {
				listeMp3Keyboard.push(files[j].url);
			}
		}

		private function loadDefaultSound(): void { // Précharge les urls des sons par default et les pousse dans un tableau
			listeMp3 = []; //Reset l'array liste Mp3
			musicDirectory = musicDirectory.resolvePath("sons");
			loadSoundFromListing();
		}

		private function loadSoundFromListing() { // pousse le contenu du dossier choisi ou de defaut dans un array
			var files: Array = musicDirectory.getDirectoryListing();
			for (var j: int; j < files.length; j++) {
				listeMp3.push(files[j].url);
			}
		}

		private function createKeyboard(): void { // Crée une instance du clavier musical
			var keyBoard: KeyBoard = new KeyBoard(listeMp3Keyboard)
			keyBoard.x = stage.stageWidth / 2
			keyBoard.y = stage.stageHeight - 125
			layoutContainer.addChild(keyBoard);
		}

		private function createDefaultWaveNodeCreator(): void { // Pour créer les instances d'items WaveNode dans l'interface
			for (var i: int = 3; i > 0; i--) {
				var waveNodeCreator: WaveNodeCreator = new WaveNodeCreator();
				waveNodeCreator.gotoAndStop(i);
				waveNodeCreator.x = 315 + i * 100;
				waveNodeCreator.y = 50;
				waveNodeCreator.buttonMode = true;
				layoutContainer.addChild(waveNodeCreator)
			}
		}

		private function createDefaultSoundNodeCreator(): void { // Pour créer les instances d'items SoundNode dans l'interface
			for (var j: int = 0; j < listeMp3.length; j++) {
				aSoundNodeCreator = new SoundNodeCreator(listeMp3[j])
				aSoundNodeCreator.y = 190 + (aSoundNodeCreator.height + 18) * j
				aSoundNodeCreator.x = stage.stageWidth - 50
				aSoundNodeCreator.gotoAndStop(j + 1)
				aSoundNodeCreator.buttonMode = true;
				layoutContainer.addChild(aSoundNodeCreator);
			}
		}

		private function verifierCollision(e: Event): void { // Pour vérifier les collisions et jouer les sons lorsque nécéssaire

			//trace("volume = " + gameVolume)
			var lesCollisionsGreen: Array = listeCollisionGreen.checkCollisions()
			var obj1: MovieClip;
			var obj2: MovieClip;
			var ms1: Number;
			var ms2: Number
			if (lesCollisionsGreen.length > 0) { // Seulement tester les collisions lorsqu'il y a des collision dans notre Array

				//trace("collision")

				for (var i: int; i < lesCollisionsGreen.length; i++) {

					obj1 = lesCollisionsGreen[i].object1
					obj2 = lesCollisionsGreen[i].object2
					//trace(obj1.name);
					//trace(obj2.name);

					if (obj1.name == "soundNode") {
						ms1 = 650 / (gameSpeed + 0.5);
						obj1.playSound(ms1); // Fait jouer le son enregistré dans l'objet SoundNode en passant le paramètre de delai
					} else if (obj2.name == "soundNode") {
						ms2 = 650 / (gameSpeed + 0.5);

						obj2.playSound(ms2); // Fait jouer le son enregistré dans l'objet SoundNode en passant le paramètre de delai
					}
				}
			}

			var lesCollisionsYellow: Array = listeCollisionYellow.checkCollisions()
			if (lesCollisionsYellow.length > 0) { // Seulement tester les collisions lorsqu'il y a des collision dans notre Array
				//trace("collision")

				for (var j: int; j < lesCollisionsYellow.length; j++) {

					obj1 = lesCollisionsYellow[j].object1
					obj2 = lesCollisionsYellow[j].object2
					//trace(obj1.name);
					//trace(obj2.name);

					if (obj1.name == "soundNode") {
						ms1 = 400 / (gameSpeed + 0.5);
						obj1.playSound(ms1); // Fait jouer le son enregistré dans l'objet SoundNode en passant le paramètre de delai
					} else if (obj2.name == "soundNode") {
						ms2 = 400 / (gameSpeed + 0.5);

						obj2.playSound(ms2); // Fait jouer le son enregistré dans l'objet SoundNode en passant le paramètre de delai
					}
				}
			}

			var lesCollisionsRed: Array = listeCollisionRed.checkCollisions()
			if (lesCollisionsRed.length > 0) { // Seulement tester les collisions lorsqu'il y a des collision dans notre Array
				//trace("collision")

				for (var h: int; h < lesCollisionsRed.length; h++) {

					obj1 = lesCollisionsRed[h].object1
					obj2 = lesCollisionsRed[h].object2
					//trace(obj1.name);
					//trace(obj2.name);

					if (obj1.name == "soundNode") {
						ms1 = 250 / (gameSpeed + 0.5);
						obj1.playSound(ms1); // Fait jouer le son enregistré dans l'objet SoundNode en passant le paramètre de delai
					} else if (obj2.name == "soundNode") {
						ms2 = 250 / (gameSpeed + 0.5);

						obj2.playSound(ms2); // Fait jouer le son enregistré dans l'objet SoundNode en passant le paramètre de delai
					}
				}

			}



		} // Fin verifierCollision()

		private function resetGame(): void { // enleve les composante nécessaire pour recommencer le jeu si nécéssaire

			this.removeEventListener(Event.ENTER_FRAME, verifierCollision);

			//Vider les différents conteneurs
			while (layoutContainer.numChildren > 0) {
				layoutContainer.removeChildAt(0);
			}

			while (waveContainerGreen.numChildren > 0) {
				waveContainerGreen.removeChildAt(0);
			}

			while (waveContainerYellow.numChildren > 0) {
				waveContainerYellow.removeChildAt(0);
			}

			while (waveContainerRed.numChildren > 0) {
				waveContainerRed.removeChildAt(0);
			}

			while (nodeContainer.numChildren > 0) {
				var node = nodeContainer.getChildAt(0);
				node.remove() //Accède à la méthode remove() des WaveNode et des SoundNode pour les retirer adéquatement
			}
			
			
			//Réinitialise les boutons pause et mute
			gameMuted = false;
			gamePaused = false;
			jeu.btnMute.gotoAndStop(1)
			jeu.btnPause.gotoAndStop(1)

		}

		private function toggleMute(e: MouseEvent): void { // Switch le jeu de mute a unmute et vice versa
			if (gameMuted) { // Si le jeu est sur mute, le enleve le mute
				gameMuted = false;
				e.currentTarget.gotoAndStop(1) // change le visuel du bouton
			} else { // sinon, mettre sur mute
				gameMuted = true;
				gameVolume = 0; // met le volume du jeu à 0
				e.currentTarget.gotoAndStop(2) // change le visuel du bouton
			}
		}

		private function togglePause(e: MouseEvent): void { // Switch le jeu de pause a unpause et vice versa
			if (gamePaused) {
				unpauseGame();
				jeu.btnPause.gotoAndStop(1) // change le visuel du bouton
			} else {
				pauseGame();
				jeu.btnPause.gotoAndStop(2) // change le visuel du bouton
			}
		}

		private function pauseGame(): void { // Met le jeu en pause
			this.removeEventListener(Event.ENTER_FRAME, verifierCollision); // Pour arrêter de vérifier les collisions pour éviter des erreurs de calcule
			gamePaused = true;
			gameSpeed = -0.5; //Remets la vitesse des animations à 0
		}

		private function unpauseGame(): void { // dépause le jeu
			this.addEventListener(Event.ENTER_FRAME, verifierCollision); // Pour recommencer la vérification des collisions
			gamePaused = false;
		}

		private function exitGame(e: MouseEvent): void { // Ferme le jeu
			NativeApplication.nativeApplication.exit();
		}

	}

}