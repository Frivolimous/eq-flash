package ui{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	public class DialogueUI extends Sprite{
		var page:int;
		var objects:Array=new Array();
		var continueB:DialogueContinue;
		var pauseOver:Sprite;
		
		public function DialogueUI(_start:Boolean,_area:int){
			pauseOver=new Sprite();
			pauseOver.graphics.beginFill(0,0.01);
			pauseOver.graphics.drawRect(0,0,GameUI.VIEW_WIDTH,GameUI.VIEW_WIDTH);
			continueB=new DialogueContinue;
			continueB.x=382;
			continueB.y=259;
			objects=new Array();
			if (_area==0){
				if (_start){
					i=500;
				}else{
					i=550;
				}
			}else if (_area<11){
				if (_start){
					i=300;
				}else{
					i=350;
				}
			}else if (_area<26){
				if (_start){
					var i:int=0;
				}else{
					i=50;
				}
			}else if (_area<51){
				if (_start){
					i=100;
				}else{
					i=150;
				}
			}else if (_area<150){
				if (_start){
					i=200;
				}else{
					i=250;
				}
			}else if (_area<300){
				if (_start){
					i=400;
				}else{
					i=450;
				}
			}else if (_area<400){
				if (_start){
					i=600;
				}else{
					i=650;
				}
			}else if (_area<1000){
				if (_start){
					i=700;
				}else{
					i=750;
				}
			}else if (_area<2000){
				if (_start){
					i=800;
				}else{
					i=850;
				}
			}
			
			Facade.stage.removeEventListener(MouseEvent.CLICK,Facade.mouseC.mouseClick);
			Facade.stage.removeEventListener(MouseEvent.MOUSE_DOWN,Facade.mouseC.mouseDown);
			Facade.stage.addEventListener(MouseEvent.CLICK,mouseClick);
			Facade.gameC.pauseGame(true);
			page=i-1;
			nextPage();
			Facade.gameUI.addChildAt(pauseOver,Facade.gameUI.getChildIndex(Facade.gameUI.pauseB)+1);
			Facade.gameUI.addChild(this);
		}
		
		function endDialogue(){
			Facade.stage.addEventListener(MouseEvent.CLICK,Facade.mouseC.mouseClick);
			Facade.stage.addEventListener(MouseEvent.MOUSE_DOWN,Facade.mouseC.mouseDown);
			Facade.stage.removeEventListener(MouseEvent.CLICK,mouseClick);
			Facade.gameUI.removeChild(this);
			Facade.gameUI.removeChild(pauseOver);
			Facade.gameC.pauseGame(false);
		}
		
		function nextPage(){
			while (objects.length>0){
				removeChild(objects.shift());
			}
			page+=1;

			switch(page){
				case 0:
					makeBox("Well well, if it isn't another hapless hero!",2,1);
					addContinue();break;
				case 1:
					makeBox("You may think you're great, but really...",2,1);
					addContinue();break;
				case 2:
					makeBox("YOU'RE NOT!",2,4);
					addContinue();break;
				case 3:
					makeBox("If your fighting is as bad as your insults then this'll be over pretty quick...",0,1);
					addContinue();break;
				case 50:
					makeBox("Argh!\n*Cough* *Splurg*",1,2);
					addContinue();break;
				case 51:
					makeBox("You may have defeated me, but this isn't the end!",1,1);
					addContinue();break;
				case 52:
					makeBox("I serve a master who is greater even than me...",1,1);
					addContinue();break;
				case 53:
					makeBox("Which isn't saying much...",0,2);
					addContinue();break;
				case 54:
					makeBox("Come on man, dying words here!",1,2);
					addContinue();break;
				case 55:
					makeBox("Oh, sorry\n*rolls eyes*",0,2);
					addContinue();break;
				case 56:
					makeBox("*Cough* *Gag*",1,2);
					addContinue();break;
				case 57:
					makeBox("My master will destroy you and turn the whole world to darkness.",1,1);
					addContinue();break;
				case 58:
					makeBox("And then all will be ruled by...",1,2);
					addContinue();break;
				case 59:
					makeBox("THE SHADOW KING!",1,4);
					addContinue();break;
				case 60:
					makeBox("Ok, die now...",0,2);
					addContinue();break;
				case 100:("The power of darkness flows through me",2,1);
					addContinue();break;
				case 101:
					makeBox("All fear the power bestowed by the Shadow King!",2,1);
					addContinue();break;
				case 102:
					makeBox("I say no.",0,3);
					addContinue();break;
				case 103:
					makeBox("The power of the Shadow King is unrivaled in this world!",2,1);
					addContinue();break;
				case 104:
					makeBox("Yeah, that's wrong too.",0,2);
					addContinue();break;
				case 105:
					makeBox("Fool!  You dare challenge my power?",2,2);
					addContinue();break;
				case 106:
					makeBox("I think that's what I said...",0,2);
					addContinue();break;
				case 107:
					makeBox("Then feel the wrath of darkness!",2,2);
					addContinue();break;
				case 150:
					makeBox("*Urk*\nHow could this be!",1,2);
					addContinue();break;
				case 151:
					makeBox("Well, it happens that I'm a hero... and heros vanquish evil.",0,1);
					addContinue();break;
				case 152:
					makeBox("Which, by the way, is you.",0,2);
					addContinue();break;
				case 153:
					makeBox("You may think you've won, but -",1,2);
					addContinue();break;
				case 154:
					makeBox("I have won.  You're vanquished.  That's it.",0,1);
					addContinue();break;
				case 155:
					makeBox("Dude, don't interrupt!",1,2);
					addContinue();break;
				case 156:
					makeBox("Sorry...",0,3);
					addContinue();break;
				case 157:
					makeBox("That's really rude!",1,2);
					addContinue();break;
				case 158:
					makeBox("I said sorry!",0,2);
					addContinue();break;
				case 159:
					makeBox("*Gack* *Splurgle*",1,2);
					addContinue();break;
				case 160:
					makeBox("You may think you've won, but...",1,2);
					addContinue();break;
				case 161:
					makeBox("Your greatest challenge is yet to come.",1,2);
					addContinue();break;
				case 162:
					makeBox("And when you face the Shadow King...",1,2);
					addContinue();break;
				case 163:
					makeBox("YOU WILL LOSE!",1,4);
					addContinue();break;
				case 164:
					makeBox("You done..?",0,2);
					addContinue();break;
				case 200:
					makeBox("MUAHAHAHAHA!",2,2);
					addContinue();break;
				case 201:
					makeBox("So, you're this Shadow King I've been hearing about?",0,1);
					addContinue();break;
				case 202:
					makeBox("Yes, it is I! The Shadow King!",2,2);
					addContinue();break;
				case 203:
					makeBox("Finally... you know, I've been walking for a REALLY long time.",0,1);
					addContinue();break;
				case 204:
					makeBox("And your journey ends...",2,2);
					addContinue();break;
				case 205:
					makeBox("\nHERE!",2,4);
					addContinue();break;
				case 206:
					makeBox("Lets just get this over with...",0,2);
					addContinue();break;
				case 250:
					makeBox("YEAAAAAAAARGH!",1,4);
					addContinue();break;
				case 251:
					makeBox("Ow, my ears!",0,2);
					addContinue();break;
				case 252:
					makeBox("How... how could a mere mortal defeat me?!?!",1,1);
					addContinue();break;
				case 253:
					makeBox("Uh... cus apparently you're mortal too?",0,1);
					addContinue();break;
				case 254:
					makeBox("*Gack* *Rumble*",1,2);
					addContinue();break;
				case 255:
					makeBox("I...",1,3);
					addContinue();break;
				case 256:
					makeBox("I accept defeat...",1,2);
					addContinue();break;
				case 257:
					makeBox("But I die knowing that my scourge still plagues this land,",1,1);
					addContinue();break;
				case 258:
					makeBox("And my evil will never be driven from it!",1,1);
					addContinue();break;
				case 259:
					makeBox("Yeah, but you were!",0,2);
					addContinue();break;
				case 260:
					makeBox("Jerk... you don't have to rub it in!\n*Cough*",1,1);
					addContinue();break;
				case 261:
					makeBox("I don't HAVE to, but I WANT to...\nN00B!",0,1);
					addContinue();break;
				case 262:
					makeBox("Screw you!\n*Ackle* *Freeg*",1,2);
					addContinue();break;
				case 263:
					makeBox("OK I'm done... gimme my treasure and I'm out of here.",0,1);
					addContinue();break;
				case 264:
					makeBox("Congratulation!  You have defeated the Shadow King!\nYou can continue fighting and getting better stuff, but there won't be any more events.",1,5);
					addContinue();break;
				case 265:
					makeBox("Or will there..?",1,5);
					addContinue();break;
				case 266:
					makeBox("Designed, Written and Programmed by: Jeremy Moshe\nArt by: Juliette Cazes\nMusic by: Stephan Wells",1,5);
					addContinue();break;
				case 267:
					makeBox("Ok that's it... go keep playing!",1,5);
					addContinue();break;
				case 300:
					makeBox("Lol noob?  Ha!  U think u can beat me??",2,1);
					addContinue();break;
				case 301:
					makeBox("HAHAHA u dont rage when lose, kk? we play now ^^.",2,1);
					addContinue();break;
				case 302:
					makeBox("\nYEARGH!",2,4);
					addContinue();break;
				case 303:
					makeBox("Was that supposed to scare me? You can do better than that!",0,1);
					addContinue();break;
				case 350:
					makeBox("*Hurg!*\nNoo...I...",1,2);
					addContinue();break;
				case 351:
					makeBox("I r beaten!  u mofo how u do that!",1,1);
					addContinue();break;
				case 352:
					makeBox("I has great power, was gift from greatest evil...",1,1);
					addContinue();break;
				case 353:
					makeBox("He shoulda given you more.",0,2);
					addContinue();break;
				case 354:
					makeBox("Screw you tryhard!  why make jokes!",1,2);
					addContinue();break;
				case 355:
					makeBox("It's nice you think I'm joking",0,2);
					addContinue();break;
				case 356:
					makeBox("*Cough* *Gag*",1,2);
					addContinue();break;
				case 357:
					makeBox("Just wait and see noob, u not get far...",1,1);
					addContinue();break;
				case 358:
					makeBox("And if u do then u will meet...",1,2);
					addContinue();break;
				case 359:
					makeBox("YOUR DOOM!",1,4);
					addContinue();break;
				case 360:
					makeBox("You make no sense...",0,2);
					addContinue();break;
				case 400:
					makeBox("STOP!",2,2);
					addContinue();break;
				case 401:
					makeBox("Geez, I thought I was done with you guys...",0,1);
					addContinue();break;
				case 402:
					makeBox("The hunt is complete!",2,2);
					addContinue();break;
				case 403:
					makeBox("???  I've literally just been walking in a straight line.",0,1);
					addContinue();break;
				case 404:
					makeBox("And now the battle...",2,2);
					addContinue();break;
				case 405:
					makeBox("\nBEGINS!",2,4);
					addContinue();break;
				case 450:
					makeBox("AAAAARGH!",1,4);
					addContinue();break;
				case 451:
					makeBox("My master will be... so dissapointed...",1,1);
					addContinue();break;
				case 452:
					makeBox("You know I defeated the shadow king already, right?",0,1);
					addContinue();break;
				case 453:
					makeBox("Impossible!",1,2);
					addContinue();break;
				case 454:
					makeBox("You REALLY didn't know?  OMG you're the worst henchman ever.",0,1);
					addContinue();break;					
				case 455:
					makeBox("...",1,3);
					addContinue();break;
				case 456:
					makeBox("Are you dead yet?",0,2);
					addContinue();break;
				case 457:
					makeBox("...",1,3);
					addContinue();break;
				case 458:
					makeBox("Yeah, you're dead.",0,2);
					addContinue();break;
				case 500:
					makeBox("None but the strong shall pass into the Epic Realm!",2,1);
					addContinue();break;
				case 501:
					makeBox("None but the mighty shall survive and thrive!",2,1);
					addContinue();break;
				case 502:
					makeBox("The what? I'm new here, I could use an explanation.",0,1);
					addContinue();break;
				case 503:
					makeBox("I am not a tutor, I am a defender!",2,1);
					addContinue();break;
				case 504:
					makeBox("Come on man, nobody told me wtf the Epic Realm is!",0,1);
					addContinue();break;
				case 505:
					makeBox("Very well, if you are found worthy, I will tell!",2,1);
					addContinue();break;
				case 550:
					makeBox("You have been found worthy... I will explain.",1,1);
					addContinue();break;
				case 551:
					makeBox("There is only one realm (progress is shared).",1,1);
					addContinue();break;
				case 552:
					makeBox("And no turning back (progress is permanent).",1,1);
					addContinue();break;
				case 553:
					makeBox("Rewards are few (only loot from bosses).",1,1);
					addContinue();break;
				case 554:
					makeBox("But rewards are great (special loot is earned).",1,1);
					addContinue();break;
				case 555:
					makeBox("Now go... prove your worth!",1,1);
					addContinue();break;
				case 556:
					makeBox("Sweeeet...",0,2);
					addContinue();break;
				case 600:
					makeBox("OMG Another shadow minion? I thougth I got you all!",0,1);
					addContinue();break;
				case 601:
					makeBox("I am no minion!  I am the shadow of the Master Smith!",2,1);
					addContinue();break;
				case 602:
					makeBox("Cool, you know how to smith?  Can you craft things for me?",0,1);
					addContinue();break;
				case 603:
					makeBox("No, I am evil now!  I will kill you instead!",2,2);
					addContinue();break;
				case 604:
					makeBox("Wow, twist!",0,2);
					addContinue();break;
				case 650:
					makeBox("ARGH! You have defeated me and now I turn good!",1,1);
					addContinue();break;
				case 651:
					makeBox("Really? Sweet!",0,2);
					addContinue();break;
				case 652:
					makeBox("I will reopen my shop in town, but...",1,2);
					addContinue();break;
				case 653:
					makeBox("I can't craft the best stuff without my Flex Transister",1,1);
					addContinue();break;
				case 654:
					makeBox("Let me guess, some other bad guy has it?",0,1);
					addContinue();break;
				case 655:
					makeBox("Yup!",1,3);
					addContinue();break;
				case 656:
					makeBox("And if I get it for you, you can craft better things?",0,1);
					addContinue();break;
				case 657:
					makeBox("Yup!",1,3);
					addContinue();break;
				case 658:
					makeBox("K....",0,3);
					addContinue();break;
				case 700:
					makeBox("YOU TREAD WHERE YOU DO NOT BELONG...",2,1);
					addContinue();break;
				case 701:
					makeBox("FOR THIS I WILL DESTROY YOU!",2,2);
					addContinue();break;
				case 702:
					makeBox("And you are..?",0,2);
					addContinue();break;
				case 703:
					makeBox("I AM THE MASTER OF TIME AND SPACE!",2,1);
					addContinue();break;
				case 704:
					makeBox("You have the Flex Transister don't you...",0,1);
					addContinue();break;
				case 750:
					makeBox("Alright I beat you, now give me what I came for.",0,1);
					addContinue();break;
				case 751:
					makeBox("NO!!! With this the Master Smith can open a portal...",1,1);
					addContinue();break;
				case 752:
					makeBox("To the Epic Realm!",1,2);
					addContinue();break;
				case 753:
					makeBox("And then you can gather Essences...",1,1);
					addContinue();break;
				case 754:
					makeBox("So the smith can make your gear stronger!",1,1);
					addContinue();break;
				case 755:
					makeBox("And the Master Smith can also make you Epic Gear now!",1,1);
					addContinue();break;
				case 756:
					makeBox("Oh no!  This is bad for the Shadow Race!",1,1);
					addContinue();break;
				case 757:
					makeBox("Wow, thanks for the exposition.",0,2);
					addContinue();break;
				case 758:
					makeBox("NP",1,3);
					addContinue();break;
				case 759:
					makeBox("Oh, and btw we are a Shadow Race now",1,1);
					addContinue();break;
				case 760:
					makeBox("and the Shadow Beast is our new leader.",1,1);
					addContinue();break;
				case 761:
					makeBox("k thx bb.",0,2);
					addContinue();break;
				case 800:
					makeBox("...",2,3);
					addContinue();break;
				case 801:
					makeBox("Aren't you gonna say something..?",0,2);
					addContinue();break;
				case 802:
					makeBox("Why? You're just gonna skip this anyways...",2,1);
					addContinue();break;
				case 803:
					makeBox("That's true.",0,2);
					addContinue();break;
				case 850:
					makeBox("Wanna talk now?",0,2);
					addContinue();break;
				case 851:
					makeBox("Nah, not really... u?",1,2);
					addContinue();break;
				case 852:
					makeBox("Nope, cya!",0,2);
					addContinue();break;
				case 853:
					makeBox("Bb.",1,3);
					addContinue();break;
				default: endDialogue();
			}
		}
		
		function addContinue(){
			addChild(continueB);
		}
		
		function makeBox(_s:String,_position:int,_type:int):Sprite{
			//Position: 0=Player, 1=Enemy Near, 2=Enemy Far
			//Type: 0 = Large, 1 = Medium, 2 = Small, 3 = Exclamation, 4 = Narration
			var m:DialogueBalloon=new DialogueBalloon;
			m.gotoAndStop(_type);
			m.y=144;
			switch(_position){
				case 0: m.x=67; break;
				case 1: m.x=210; break;
				case 2: m.x=310; break;
			}
			m.label.text=_s;
			
			objects.push(m);
			addChild(m);
			return m;
		}

		public function mouseClick(e:MouseEvent){
			if (contains(continueB)){
				removeChild(continueB);
				nextPage();
			}
		}
	}
}