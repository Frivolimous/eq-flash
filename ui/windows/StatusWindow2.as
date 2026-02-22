package ui.windows{
	import flash.display.Sprite;
	import flash.utils.Dictionary;
	import ui.assets.TextDouble;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import system.actions.ActionBase;
	
	public class StatusWindow2 extends Sprite{
		public var origin:SpriteModel;
		var displays:Vector.<TextDouble>=new Vector.<TextDouble>(31);
		
		public function StatusWindow2(rows:int=16){
			for (var i:int=0;i<displays.length;i+=1){
				if (i<16){
					var _x:Number=17;
				}else{
					_x=111;
				}
				var j:int=i;
				if (j>=rows) j-=rows;
				
				var _y:Number=50-7+j*12;
				if (i<=15){
					if (i>2) _y+=6;
					if (i>6) _y+=6;
					if (i>11) _y+=6;
					if (i>=3 && i<=6){
						displays[i]=textPair(_x,_y,100,TextDouble.ACTION);
					}else{
						displays[i]=textPair(_x,_y,100,TextDouble.STAT);
					}
				}else{
					if (i>19) _y+=6;
					if (i>26) _y+=6;
					if (i>27) _y+=6;
					displays[i]=textPair(_x,_y,130,TextDouble.STAT);
				}
			}
			
			displays[0].setTextFromIndex(StatModel.STRENGTH);
			displays[1].setTextFromIndex(StatModel.MPOWER);
			displays[2].setTextFromIndex(StatModel.INITIATIVE);
			
			displays[3].setTextFromIndex(ActionBase.HITRATE);
			displays[4].setTextFromIndex(ActionBase.CRITRATE);
			displays[5].setTextFromIndex(ActionBase.CRITMULT);
			displays[6].setTextFromIndex(ActionBase.DAMAGE);
			
			displays[7].setTextFromIndex(StatModel.ITEMEFF);
			displays[8].setTextFromIndex(StatModel.POTEFF);
			displays[9].setTextFromIndex(StatModel.THROWEFF);
			displays[10].setTextFromIndex(StatModel.HOLYEFF);
			displays[11].setTextFromIndex(StatModel.CHEMEFF);
			
			displays[12].setTextFromIndex(StatModel.MRATE);
			displays[13].setTextFromIndex(StatModel.IRATE);
			displays[14].setTextFromIndex(StatModel.PRATE);
			displays[15].setTextFromIndex(StatModel.TRATE);
			
			displays[16].setTextFromIndex(StatModel.HEALTH);
			displays[17].setTextFromIndex(StatModel.HREGEN);
			displays[18].setTextFromIndex(StatModel.MANA);
			displays[19].setTextFromIndex(StatModel.MREGEN);
			
			displays[20].setTextFromIndex(StatModel.BLOCK);
			displays[21].setTextFromIndex(StatModel.DODGE);
			displays[22].setTextFromIndex(StatModel.TURN);
			displays[23].setTextFromIndex(StatModel.RMAGICAL);
			displays[24].setTextFromIndex(StatModel.RCHEMICAL);
			displays[25].setTextFromIndex(StatModel.RSPIRIT);
			displays[26].setTextFromIndex(StatModel.RCRIT);
			
			displays[27].setTextFromIndex(StatModel.CRAFT_BELT);
			
			displays[28].setTextFromIndex(StatModel.ILOOT);
			displays[29].setTextFromIndex(StatModel.SLOTS);
			displays[30].setTextFromIndex(StatModel.DRANGE);
		}
		
		public function update(model:SpriteModel){
			origin=model;
			var _attack:ActionBase=origin.actionList.getAttack().modify(origin,false);
			for (var i:int=0;i<displays.length;i+=1){ //Stat Values
				if (displays[i].type==TextDouble.STAT){
					switch(displays[i].index){
						case StatModel.DODGE: case StatModel.TURN:
						case StatModel.RMAGICAL: case StatModel.RCHEMICAL: case StatModel.RSPIRIT: case StatModel.RCRIT:
						case StatModel.ITEMEFF: case StatModel.POTEFF: case StatModel.THROWEFF: case StatModel.HOLYEFF: case StatModel.CHEMEFF:
						case StatModel.MRATE: case StatModel.IRATE: case StatModel.PRATE: case StatModel.TRATE: case StatModel.ILOOT: case StatModel.DRANGE:
						case StatModel.HREGEN: case StatModel.MREGEN: 
							displays[i].text2=StringData.reduce(origin.stats.getValue(displays[i].index)*100)+"%";break;
						default: displays[i].text2=StringData.reduce(origin.stats.getValue(displays[i].index));
							break;
					}
				}else if (displays[i].type==TextDouble.ACTION){
					switch(displays[i].index){
						case ActionBase.HITRATE: displays[i].text2=String(Math.floor(_attack.getValue(ActionBase.HITRATE))); break;
						case ActionBase.CRITRATE: displays[i].text2=StringData.reduce(_attack.critrate*100)+"%"; break;
						case ActionBase.CRITMULT: displays[i].text2=StringData.reduce(_attack.critmult*100)+"%"; break;
						case ActionBase.DAMAGE: displays[i].text2=String(Math.floor(_attack.damage)); break;
					}
				}
			}
		}

		function textPair(_x:Number=0,_y:Number=0,_width:Number=130,_type:int=0):TextDouble{
			var m:TextDouble=new TextDouble(_width,_type);
			m.x=_x;
			m.y=_y;
			m.scaleX=m.scaleY=.9
			addChild(m);
			return m;			
		}
	}
}
