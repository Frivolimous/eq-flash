package ui.game{
	import flash.display.Sprite;
	import flash.utils.Dictionary;
	import ui.assets.PullButton;
	import ui.assets.SymbolPair;
	import ui.assets.TextDouble;
	import system.actions.ActionBase;
	import ui.assets.GraphicButton;
	
	public class StatsWindow extends Sprite{
		public static const BASIC:int=0,
							ATTACK:int=1,
							MAGIC:int=2,
							ITEM:int=3,
							DEFENSE:int=4,
							SPECIAL:int=5,
							
							SPACE:int=-1;
							
		public var origin:SpriteModel;
		var page2:Sprite=new Sprite;
		var displays:Vector.<TextDouble>=new Vector.<TextDouble>;
		var buttons:Vector.<GraphicButton>=new Vector.<GraphicButton>(6);
		var lists:Array=[[],[StatModel.STRENGTH,StatModel.INITIATIVE,StatModel.PHYSEFF,SPACE,100+ActionBase.DAMAGE,100+ActionBase.TYPE,SPACE,100+ActionBase.HITRATE,100+ActionBase.CRITRATE,100+ActionBase.CRITMULT,SPACE,100+ActionBase.LEECH,100+ActionBase.DODGE_REDUCE],
						 [StatModel.MPOWER,StatModel.MAGICEFF,StatModel.HOLYEFF,StatModel.DARKEFF,SPACE,StatModel.MANA,StatModel.MREGEN,StatModel.MRATE,SPACE,StatModel.SLOTS,SPACE,StatModel.SPELLSTEAL,StatModel.TURN_REDUCE],
						 [StatModel.ITEMEFF,StatModel.POTEFF,StatModel.THROWEFF,StatModel.CHEMEFF,SPACE,StatModel.IRATE,StatModel.PRATE,StatModel.TRATE,SPACE,StatModel.CRAFT_BELT],
						 [StatModel.HEALTH,StatModel.HREGEN,SPACE,StatModel.RMAGICAL,StatModel.RCHEMICAL,StatModel.RSPIRIT,StatModel.RPHYS,StatModel.RCRIT,SPACE,StatModel.BLOCK,StatModel.DODGE,StatModel.TURN,SPACE,StatModel.TENACITY],
						 [StatModel.ILOOT,SPACE,StatModel.BUFFMULT,StatModel.CURSEMULT,StatModel.DOTEFF,StatModel.PROCEFF,StatModel.HEALMULT,SPACE,StatModel.FAR,StatModel.NEAR,SPACE,StatModel.DMGMULT,StatModel.DRANGE]];
						 
		//basicB, attackB, magicB, itemB, defenseB, specialB
		const tooltipDesc:String="B: Basic\nA: Attack\nM: Magic\nI: Item\nD: Defenses\nS:Special";
		
		public function StatsWindow(){
			page1.strength.symbol=SymbolPair.STRENGTH;
			page1.mpow.symbol=SymbolPair.MPOW;
			page1.init.symbol=SymbolPair.INIT;
			page1.hit.symbol=SymbolPair.HIT;
			page1.hit.type=SymbolPair.ACTION;
			page1.crit.symbol=SymbolPair.CRIT;
			page1.crit.type=SymbolPair.ACTION;
			page1.block.symbol=SymbolPair.BLOCK;
			page1.dodge.symbol=SymbolPair.DODGE;
			page1.rmag.symbol=SymbolPair.RMAG;
			page1.rchem.symbol=SymbolPair.RCHEM;
			page1.rspirit.symbol=SymbolPair.RSPIRIT;
			page2.x=16;
			page2.y=70;
			addChild(page2);
			basicB.autosize=false;
			basicB.update("B",changePage,true);
			basicB.index=BASIC;
			basicB.setDesc("Basic",tooltipDesc);
			buttons[BASIC]=basicB;
			attackB.autosize=false;
			attackB.update("A",changePage,true);
			attackB.index=ATTACK;
			attackB.setDesc("Attack",tooltipDesc);
			buttons[ATTACK]=attackB;
			magicB.autosize=false;
			magicB.update("M",changePage,true);
			magicB.index=MAGIC;
			magicB.setDesc("Magic",tooltipDesc);
			buttons[MAGIC]=magicB;
			itemB.autosize=false;
			itemB.update("I",changePage,true);
			itemB.index=ITEM;
			itemB.setDesc("Item",tooltipDesc);
			buttons[ITEM]=itemB;
			defenseB.autosize=false;
			defenseB.update("D",changePage,true);
			defenseB.index=DEFENSE;
			defenseB.setDesc("Defense",tooltipDesc);
			buttons[DEFENSE]=defenseB;
			specialB.autosize=false;
			specialB.update("S",changePage,true);
			specialB.index=SPECIAL;
			specialB.setDesc("Special",tooltipDesc);
			buttons[SPECIAL]=specialB;
			
			switchB.update(null,changeTarget);
			changePage(0);
		}
		
		public function update(model:SpriteModel=null){
			if (model!=null) origin=model;
			if (origin==null) return;
			var _attack:ActionBase=origin.actionList.getAttack().modify(origin,false);
			if (contains(page1)){
				page1.strength.text=String(Math.round(origin.stats.getValue(StatModel.STRENGTH)));
				page1.hit.text=String(Math.round(_attack.getValue(ActionBase.HITRATE)));
				page1.crit.text=String(Math.round(_attack.critrate*100*10)/10)+"%";
				page1.mpow.text=String(Math.round(origin.stats.getValue(StatModel.MPOWER)));
				page1.init.text=String(Math.round(origin.stats.getValue(StatModel.INITIATIVE)));
				
				page1.block.text=String(Math.round(origin.stats.getValue(StatModel.BLOCK)));
				var _avoid=origin.stats.getValue(StatModel.DODGE);
				if (origin.eDistance!=GameModel.NEAR) _avoid=StatModel.addMult(_avoid,origin.stats.getValue(StatModel.FAR_AVOID));
				page1.dodge.text=String(Math.round(_avoid*100))+"%";
				page1.rmag.text=String(Math.round(origin.stats.getValue(StatModel.RMAGICAL)*100))+"%";
				page1.rchem.text=String(Math.round(origin.stats.getValue(StatModel.RCHEMICAL)*100))+"%";
				page1.rspirit.text=String(Math.round(origin.stats.getValue(StatModel.RSPIRIT)*100))+"%";
			}else{
				for (var i:int=0;i<displays.length;i+=1){
					if (displays[i].type==TextDouble.ACTION){
						switch(displays[i].index){
							case ActionBase.HITRATE: displays[i].text2=String(Math.round(_attack.getValue(ActionBase.HITRATE))); break;
							case ActionBase.CRITRATE: displays[i].text2=String(Math.round(_attack.critrate*100))+"%"; break;
							case ActionBase.CRITMULT: displays[i].text2=String(Math.round(_attack.critmult*100))+"%"; break;
							case ActionBase.DAMAGE: displays[i].text2=String(Math.round(_attack.damage)); break;
							case ActionBase.TYPE: displays[i].text2=ActionBase.statNames[_attack.type]; break;
							case ActionBase.LEECH: displays[i].text2=String(Math.round(_attack.leech*100))+"%"; break;
							case ActionBase.DODGE_REDUCE: displays[i].text2=String(Math.round(_attack.dodgeReduce*100))+"%"; break;
						}
					}else{
						switch(displays[i].index){
							/*case StatModel.DODGE: case StatModel.TURN: case StatModel.TENACITY:
							case StatModel.TURN_REDUCE:
							case StatModel.RMAGICAL: case StatModel.RCHEMICAL: case StatModel.RSPIRIT: case StatModel.RCRIT: case StatModel.RPHYS:
							case StatModel.ITEMEFF: case StatModel.POTEFF: case StatModel.THROWEFF: case StatModel.HOLYEFF: case StatModel.CHEMEFF: case StatModel.HEALMULT: case StatModel.DMGMULT:
							case StatModel.PHYSEFF: case StatModel.MAGICEFF:
							case StatModel.MRATE: case StatModel.IRATE: case StatModel.PRATE: case StatModel.TRATE: case StatModel.ILOOT: case StatModel.DRANGE:
							case StatModel.HREGEN: case StatModel.MREGEN: case StatModel.SPELLSTEAL:
							case StatModel.DOTEFF: case StatModel.PROCEFF: case StatModel.BUFFMULT: case StatModel.CURSEMULT:
							case StatModel.FAR: case StatModel.NEAR:*/
							case StatModel.DODGE: case StatModel.TURN:
								_avoid=origin.stats.getValue(displays[i].index);
								if (origin.eDistance!=GameModel.NEAR) _avoid=StatModel.addMult(_avoid,origin.stats.getValue(StatModel.FAR_AVOID));
								displays[i].text2=String(Math.round(_avoid*100))+"%";break;
							case StatModel.STRENGTH: case StatModel.INITIATIVE: case StatModel.MPOWER:
							case StatModel.HEALTH: case StatModel.MANA: case StatModel.BLOCK:
							case StatModel.SLOTS: case StatModel.CRAFT_BELT:
								displays[i].text2=String(Math.round(origin.stats.getValue(displays[i].index)));
								break;
							default: 
								displays[i].text2=String(Math.round(origin.stats.getValue(displays[i].index)*100))+"%";break;
						}
					}
				}
			}
			
			if (origin==Facade.gameM.playerM){
				title.text="Stats";
			}else{
				title.text=origin.label;
			}
		}
		
		public function changePage(i:int){
			for (var j:int=1;j<buttons.length;j+=1){
				if (j==i){
					buttons[j].toggled=true;
				}else{
					buttons[j].toggled=false;
				}
			}
			
			if (i==0){
				if (contains(page2)) removeChild(page2);
				addChild(page1);
			}else{
				if (contains(page1)) removeChild(page1);
				addChild(page2);
				populatePage2(lists[i]);
			}
			update();
		}
		
		public function populatePage2(a:Array){
			var _y:Number=0;
			var GAP:Number=6;
			while(displays.length>0){
				page2.removeChild(displays.shift());
			}
			
			for (var i:int=0;i<a.length;i+=1){
				if (a[i]==SPACE){
					_y+=GAP;
				}else{
					if (a[i]>=100){
						var _pair:TextDouble=textPair(0,_y,160,TextDouble.ACTION);
						_pair.setTextFromIndex(a[i]-100);
					}else{
						_pair=textPair(0,_y,160,TextDouble.STAT);
						_pair.setTextFromIndex(a[i]);
					}
					displays.push(_pair);
					_y+=12;
				}
			}
		}
		
		function textPair(_x:Number=0,_y:Number=0,_width:Number=160,_type:int=0):TextDouble{
			var m:TextDouble=new TextDouble(_width,_type);
			m.x=_x;
			m.y=_y;
			m.scaleX=m.scaleY=.9
			page2.addChild(m);
			return m;			
		}
		
		function changeTarget(){
			Facade.gameUI.switchTarget();
		}
	}
}
