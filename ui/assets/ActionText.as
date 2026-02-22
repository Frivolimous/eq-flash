package ui.assets{
	import flash.display.Sprite;
	import ui.assets.PullButton;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import utils.GameData;
	
	public class ActionText extends Sprite{
		var lines:Array=new Array(10);
		var tDmg:int=0;
		var buffs:Array=new Array();
		var origin:String;
		//var subtitle:TextField;
		var updateSubtitle:Boolean=true;
		var pending:Boolean=false;
		
		public function ActionText(){
			for (var i:int=0;i<lines.length;i+=1){
				lines[i]=new TextField();
				
				lines[i].embedFonts=true;
				lines[i].defaultTextFormat=new TextFormat(StringData.FONT_FANCY);
				lines[i].width=150;
				lines[i].height=20;
				lines[i].selectable=false;
				lines[i].x=5;
				lines[i].y=170-i*14;
				if (i<8){
					addChild(lines[i]);
				}
			}
			subtitleCheck.update(null,toggleSubtitles,true);
			
			updateSubtitle=!GameData._Save.data.pause[GameData.OPTION_SUBTITLE];
			
			
			//subtitle=Facade.gameUI.subtitle;
			/*subtitle=new TextField;
			subtitle.embedFonts=true;
			subtitle.defaultTextFormat=new TextFormat("Kingthing Normal",15);
			subtitle.width=400;
			subtitle.height=30;
			subtitle.selectable=false;
			subtitle.x=5;
			subtitle.y=260;
			Facade.gameUI.addChildAt(subtitle,Facade.gameUI.getChildIndex(Facade.gameUI.);*/
		}
		
		public function updateStreak(i:int,j:int){
			streakT.text=String(i);
			streakST.text=String(j);
		}
		
		public function addAction(_o:String,_action:String){
			if (pending){
				addDmg(0);
			}
			_action=StringData.verb(_action);
			if (_action!=null){
				addText(_o+" "+_action);
			}
			pending=true;
		}
		
		public function addBuff(_t:String,_buff:String){
			if (pending){
				buffs.push(_buff);
				origin=_t;
			}else{
				addText(_t+" is "+_buff);
			}
		}
		
		public function addTDmg(i:int){
			tDmg+=i;
		}
		
		public function addDmg(i:int){
			i+=tDmg;
			tDmg=0;
			if (i>0) appendText(" for "+i+" dmg");
			if (buffs.length>0){
				addText(origin+" is ");
				appendText(buffs.shift());
				while (buffs.length>1){
					appendText(", "+buffs.shift());
				}
				if (buffs.length>0){
					appendText(" and "+buffs.shift());
				}
				appendText("!");
			}
			pending=false;
		}
		
		public function addHeal(i:int){
			if (i>0) appendText(" for "+i);
		}
		
		public function addDefend(s:String){
			if (tDmg>0){
				addDmg(0);
			}else{
				switch(s){
					case SpriteView.BLOCK: appendText(" but is Blocked"); break;
					case SpriteView.DODGE: appendText(" but Misses"); break;
					case SpriteView.TURN: appendText(" but gets Nullified"); break;
				}
			}
		}
		
		public function addKill(s:String){
			addText(s+" is defeated");
		}
		
		public function addFind(s:String){
			addText("Treasure found: "+s);
		}

		public function addText(s:String){
			Facade.addLine(s); /****/
			for (var i:int=(lines.length-1);i>0;i-=1){
				lines[i].text=lines[i-1].text;
			}
			lines[0].text=s;
			if (updateSubtitle){
				Facade.gameUI.subtitle4.text=lines[3].text;
				Facade.gameUI.subtitle3.text=lines[2].text;
				Facade.gameUI.subtitle2.text=lines[1].text;
				Facade.gameUI.subtitle1.text=lines[0].text;
			}
		}
		
		public function appendText(s:String){
			Facade.addLine(s); /****/
			lines[0].appendText(s);
			if (updateSubtitle){
				Facade.gameUI.subtitle1.appendText(s);
			}
		}
		
		public function toggleSubtitles(_i:int=-1){
			if (_i==1){
				updateSubtitle=true;
			}else{
				updateSubtitle=!updateSubtitle;
				GameData._Save.data.pause[GameData.OPTION_SUBTITLE]=!updateSubtitle;
				Facade.gameUI.subtitle1.text=lines[0].text;
				Facade.gameUI.subtitle2.text=lines[1].text;
				Facade.gameUI.subtitle3.text=lines[2].text;
				Facade.gameUI.subtitle4.text=lines[3].text;
				
			}
			subtitleCheck.setToggle(updateSubtitle);
			if (!updateSubtitle){
				Facade.gameUI.subtitle1.text="";
				Facade.gameUI.subtitle2.text="";
				Facade.gameUI.subtitle3.text="";
				Facade.gameUI.subtitle4.text="";
			}
		}
	}
}