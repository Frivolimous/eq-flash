package ui.windows{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.Bitmap;
	import artifacts.ArtifactData;
	import utils.GameData;
	import flash.events.Event;
	
	public class AscendZoneWindow extends MovieClip{
		var _Function:Function;
		var blackout:Sprite=new Sprite;
		var zone:int;
		var cost:int;
		var level:int;
		
		public function AscendZoneWindow(_f:Function){
			x=100;
			y=100;
			
			_Function=_f;
			
			blackout.graphics.beginFill(0,0.6);
			blackout.graphics.drawRect(0,0,Facade.WIDTH,Facade.HEIGHT);
			blackout.graphics.endFill();

			Facade.stage.addChild(blackout);
			Facade.stage.addChild(this);
			
			button0.update("0",selectButton,true);
			button0.index=0;
			button0.setDesc("Zone 0","Return to Zone 1 at Level 1 for 0 Souls.  You may only travel to a zone you have already reached.");
			button1.update("101",selectButton,true);
			button1.index=1;
			button1.setDesc("Zone 101","Return to Zone 101 at Level 45 for 250 Souls.  You may only travel to a zone you have already reached.");
			button2.update("201",selectButton,true);
			button2.index=2;
			button2.setDesc("Zone 201","Return to Zone 201 at Level 50 for 4000 Souls.\n\nYou will not earn Souls for the areas you skipped and you may only travel to a zone you have already reached.");
			button3.update("301",selectButton,true);
			button3.index=3;
			button3.setDesc("Zone 301","Return to Zone 301 at Level 60 for 30000 Souls.\n\nYou will not earn Souls for the areas you skipped and you may only travel to a zone you have already reached.");
			button4.update("401",selectButton,true);
			button4.index=4;
			button4.setDesc("Zone 401","Return to Zone 401 at Level 60 for 75000 Souls.\n\nYou will not earn Souls for the areas you skipped and you may only travel to a zone you have already reached.");
			button5.update("601",selectButton,true);
			button5.index=5;
			button5.setDesc("Zone 601","Return to Zone 601 at Level 60 for 150000 Souls.\n\nYou will not earn Souls for the areas you skipped and you may only travel to a zone you have already reached.");
			button6.update("1001",selectButton,true);
			button6.index=6;
			button6.setDesc("Zone 1001","Return to Zone 1001 at Level 60 for 300000 Souls.\n\nYou will not earn Souls for the areas you skipped and you may only travel to a zone you have already reached.");
			button7.update("2001",selectButton,true);
			button7.index=7;
			button7.setDesc("Zone 2001","Return to Zone 2001 at Level 60 for 600000 Souls.\n\nYou will not earn Souls for the areas you skipped and you may only travel to a zone you have already reached.");
			button8.update("3001",selectButton,true);
			button8.index=8;
			button8.setDesc("Zone 3001","Return to Zone 3001 at Level 60 for 900000 Souls.\n\nYou will not earn Souls for the areas you skipped and you may only travel to a zone you have already reached.");
			
			var _furthest:int=GameData.getScore(GameData.SCORE_FURTHEST);
			if (_furthest<201){
				button2.disabled=true;
			}
			if (_furthest<301){
				button3.disabled=true;
			}
			if (_furthest<401){
				button4.disabled=true;
			}
			if (_furthest<601){
				button5.disabled=true;
			}
			if (_furthest<1001){
				button6.disabled=true;
			}
			if (_furthest<2001){
				button7.disabled=true;
			}
			if (_furthest<3001){
				button8.disabled=true;
			}
			
			soulB.update(StringData.REVIVE,confirmSouls);
			cancelB.update(StringData.CANCEL,closeWindow);
			selectButton(0);
			/*removeChild(button6);
			removeChild(button7);
			removeChild(button8);*/
		}
				
		function confirmSouls(){
			GameData.souls-=cost;
			_Function(zone,level);
			closeWindow();
		}
				
		public function closeWindow(){
			parent.removeChild(this);
			blackout.parent.removeChild(blackout);
		}
		
		public function selectButton(i:int){
			if (!button0.disabled) button0.toggled=false;
			if (!button1.disabled) button1.toggled=false;
			if (!button2.disabled) button2.toggled=false;
			if (!button3.disabled) button3.toggled=false;
			if (!button4.disabled) button4.toggled=false;
			if (!button5.disabled) button5.toggled=false;
			if (!button6.disabled) button6.toggled=false;
			if (!button7.disabled) button7.toggled=false;
			if (!button8.disabled) button8.toggled=false;
			
			switch(i){
				case 0: zone=1; cost=0; level=1; button0.toggled=true; break;
				case 1: zone=101; cost=250; level=45; button1.toggled=true; break;
				case 2: zone=201; cost=4000; level=50; button2.toggled=true; break;
				case 3: zone=301; cost=30000; level=60; button3.toggled=true; break;
				case 4: zone=401; cost=75000; level=60; button4.toggled=true; break;
				case 5: zone=601; cost=150000; level=60; button5.toggled=true; break;
				case 6: zone=1001; cost=300000; level=60; button6.toggled=true; break;
				case 7: zone=2001; cost=600000; level=60; button7.toggled=true; break;
				case 8: zone=3001; cost=900000; level=60; button8.toggled=true; break;
			}

			soulT.gold.text=String(cost);
			
			if (GameData.souls<cost){
				soulB.disabled=true;
			}else{
				soulB.disabled=false;
			}
		}
		
		
	}
}