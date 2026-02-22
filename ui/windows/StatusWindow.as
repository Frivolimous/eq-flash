package ui.windows{
	import flash.display.Sprite;
	import flash.utils.Dictionary;
	import ui.assets.TextDouble;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import system.actions.ActionBase;
	import flash.text.AntiAliasType;
	import skills.SkillData;
	
	public class StatusWindow extends Sprite{
		public var origin:SpriteModel;
		var displays:Vector.<TextDouble>=new Vector.<TextDouble>(14);
		var talentDisplay:TextField=new TextField;
		
		public function StatusWindow(rows:int=7){
			for (var i:int=0;i<displays.length;i+=1){
				displays[i]=textPair(16+Math.floor(i/rows)*120,50+(i%rows)*15,(i==7?TextDouble.ACTION:TextDouble.STAT));
			}
			displays[0].setTextFromIndex(StatModel.STRENGTH);
			displays[1].setTextFromIndex(StatModel.MPOWER);
			displays[2].setTextFromIndex(StatModel.INITIATIVE);
			displays[3].setTextFromIndex(StatModel.HEALTH);
			displays[4].setTextFromIndex(StatModel.HREGEN);
			displays[5].setTextFromIndex(StatModel.MANA);
			displays[6].setTextFromIndex(StatModel.MREGEN);
			displays[7].setTextFromIndex(ActionBase.HITRATE);
			displays[8].setTextFromIndex(StatModel.BLOCK);
			displays[9].setTextFromIndex(StatModel.DODGE);
			displays[10].setTextFromIndex(StatModel.TURN);
			displays[11].setTextFromIndex(StatModel.RMAGICAL);
			displays[12].setTextFromIndex(StatModel.RCHEMICAL);
			displays[13].setTextFromIndex(StatModel.RSPIRIT);
			talentDisplay.x=displays[0].x;
			talentDisplay.y=displays[13].y+20;
			talentDisplay.width=140;
			talentDisplay.height=100;
			talentDisplay.selectable=false;
			talentDisplay.embedFonts=true;
			talentDisplay.antiAliasType=AntiAliasType.ADVANCED;
			talentDisplay.defaultTextFormat=new TextFormat(StringData.FONT_SYSTEM,12,StringData.U_BROWN);
			talentDisplay.wordWrap=true;
			addChild(talentDisplay);
		}
		
		public function update(model:SpriteModel=null){
			if (model!=null){
				origin=model;
			}
			if (origin==null) return;
			
			var _attack:ActionBase=origin.actionList.getAttack().modify(origin,false);
			
			/*displays[0].setTextFromIndex(StatModel.STRENGTH);
			displays[1].setTextFromIndex(StatModel.MPOWER);
			displays[2].setTextFromIndex(StatModel.INITIATIVE);
			displays[3].setTextFromIndex(StatModel.HEALTH);
			displays[4].setTextFromIndex(StatModel.HREGEN);
			displays[5].setTextFromIndex(StatModel.MANA);
			displays[6].setTextFromIndex(StatModel.MREGEN);
			displays[7].setTextFromIndex(ActionBase.HITRATE);
			displays[8].setTextFromIndex(StatModel.BLOCK);
			displays[9].setTextFromIndex(StatModel.DODGE);
			displays[10].setTextFromIndex(StatModel.TURN);
			displays[11].setTextFromIndex(StatModel.RMAGICAL);
			displays[12].setTextFromIndex(StatModel.RCHEMICAL);
			displays[13].setTextFromIndex(StatModel.RSPIRIT);*/
			
			//displays[0].text2=StringData.reduce(origin.stats.getValue
			for (var i:int=0;i<14;i+=1){ //Stat Values
				if (i==7){
					displays[i].text2=String(Math.round(_attack.getValue(ActionBase.HITRATE)));
					continue;
				}
				switch(displays[i].index){
					case StatModel.DODGE: case StatModel.TURN:
					case StatModel.RMAGICAL: case StatModel.RCHEMICAL: case StatModel.RSPIRIT: case StatModel.HREGEN: case StatModel.MREGEN: 
						displays[i].text2=StringData.reduce(origin.stats.getValue(displays[i].index)*100)+"%";break;
					default: displays[i].text2=StringData.reduce(origin.stats.getValue(displays[i].index));
						break;
				}
			}
			talentDisplay.htmlText="<font size='14'><b>"+SkillData.talentName[origin.skillBlock.getTalentIndex()]+"</b></font>\n"+StringData.talentDesc(origin.skillBlock.getTalentIndex());
			//talentDisplay.htmlText="<font size=15>"+StringData.talentName(origin.talent.index)+"</font>\n"+StringData.talentDesc(origin.talent.index);
		}

		function textPair(_x:Number=0,_y:Number=0,_type:int=0):TextDouble{
			var m:TextDouble=new TextDouble(90,_type);
			m.x=_x;
			m.y=_y;
			addChild(m);
			return m;			
		}
	}
}
