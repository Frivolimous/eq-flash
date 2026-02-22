package ui.windows{
	import flash.display.Sprite;
	import ui.assets.GraphicButton;
	import ui.assets.TextDouble;
	import ui.assets.TextContainer;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.AntiAliasType;
	import system.actions.ActionBase;

	public class ActionWindow extends Sprite{
		const SPACING:int=15;
		const TEXT_X:int=114;
		const TEXT_Y:int=90;
		var origin:SpriteModel;
		var action:ActionBase;
		var actionI:int=-1;
				
		var effectTitle:TextField=new TextField;
		var critTitle:TextField=new TextField;
		var cAList:String=GameModel.NEAR;
		var actionList:Array=new Array();
		var actionText:Array=new Array();
		
		var twoRows:Boolean;
		
		public function ActionWindow(){
			leftB.update(null,nextAList);
			rightB.update(null,prevAList);
			effectTitle.antiAliasType=AntiAliasType.ADVANCED;
			effectTitle.embedFonts=true;
			effectTitle.defaultTextFormat=new TextFormat(StringData.FONT_FANCY,16,StringData.U_BROWN);
			effectTitle.width=mainTitle.width;
			effectTitle.height=25;
			effectTitle.text="Effects:";
			effectTitle.selectable=false;
			critTitle.antiAliasType=AntiAliasType.ADVANCED;
			critTitle.embedFonts=true;
			critTitle.defaultTextFormat=new TextFormat(StringData.FONT_FANCY,16,StringData.U_BROWN);
			critTitle.width=mainTitle.width;
			critTitle.height=25;
			critTitle.text="C.Effects:";
			critTitle.selectable=false;
			
			effectTitle.x=critTitle.x=TEXT_X;
		}

		
		public function update(model:SpriteModel){
			if (model==null) return;
			
			if (model!=origin){
				origin=model;
				actionI=-1;
				resetAList();
				refreshAList();
			}else{
				refreshAList();
			}
		}
		
		function resetAList(){
			cAList=GameModel.NEAR;
			actionListT.text=StringData.NEAR_AW;
			actionI=-1;
			clearAction();
			refreshAList();
		}
		
		function nextAList(){
			switch (cAList){
				case GameModel.BETWEEN:cAList=GameModel.NEAR;actionListT.text=StringData.NEAR_AW;break;
				case GameModel.NEAR:cAList=GameModel.FAR;actionListT.text=StringData.FAR_AW;break;
				case GameModel.FAR:cAList=GameModel.VERY;actionListT.text=StringData.VERY_AW;break;
				case GameModel.VERY:cAList=GameModel.BETWEEN;actionListT.text=StringData.SAFE_AW;break;
				default:break;
			}
			actionI=-1;
			clearAction();
			refreshAList();
		}
		
		function prevAList(){
			switch (cAList){
				case GameModel.BETWEEN:cAList=GameModel.VERY;actionListT.text=StringData.VERY_AW;break;
				case GameModel.NEAR:cAList=GameModel.BETWEEN;actionListT.text=StringData.SAFE_AW;break;
				case GameModel.FAR:cAList=GameModel.NEAR;actionListT.text=StringData.NEAR_AW;break;
				case GameModel.VERY:cAList=GameModel.FAR;actionListT.text=StringData.FAR_AW;break;
				default:break;
			}
			actionI=-1;
			clearAction();
			refreshAList();
		}

		function refreshAList(){
			for (var i:int=0;i<actionList.length;i+=1){
				removeChild(actionList[i]);
			}
			var _list:Vector.<ActionBase>=origin.actionList.getList(cAList);
			
			actionList=new Array();
			for (i=0;i<_list.length;i+=1){
				actionList.push(new ActionListButton);
				actionList[i].update(_list[i].label,popAction,true);
				actionList[i].index=i;
				actionList[i].setDesc("");
								
				actionList[i].x=16;
				actionList[i].y=75+25*i;
				addChild(actionList[i]);
			}
			
			if (actionI>=0) popAction(actionI);
		}
				
		public function popAction(v:int){
			actionI=v;
			clearAction();
			action=origin.actionList.getList(cAList)[actionI].modify(origin,false);
			action.userate=action.fullUse(origin);
			mainTitle.text=action.label;
			if (v>actionList.length-1) v=actionList.length-1;
			
			for (i=0;i<actionList.length;i+=1){
				actionList[i].toggled=false;
			}
			actionList[v].toggled=true;
			
			var i:int=1;
			
			if (action.userate<1){
				actionText.push(textPair(ActionBase.USERATE,String(int(action.userate*100))+"%",TEXT_X,TEXT_Y+i*SPACING));
				i+=1;
			}
			if (action.mana>0 && !isNaN(action.mana)){
				actionText.push(textPair(ActionBase.MANA,String(action.mana),TEXT_X,TEXT_Y+i*SPACING));
				i+=1;
			}
			if ((action.hitrate>0)&&(action.hitrate<1000)){
				actionText.push(textPair(ActionBase.HITRATE,String(action.getValue(ActionBase.HITRATE)),TEXT_X,TEXT_Y+i*SPACING));
				i+=1;
				/*if (origin==Facade.gameM.playerM){
					if (Facade.gameM.enemyM.exists){
						actionText.push(textPair("",String(int(100*action.toHit(Facade.gameM.enemyM.stats.block)))+"%",TEXT_X,TEXT_Y+i*SPACING));
						i+=1;
					}
				}else{
					actionText.push(textPair("",String(int(50*action.hitrate/Facade.gameM.playerM.stats.block))+"%",TEXT_X,TEXT_Y+i*SPACING));
					i+=1;
				}*/
			}
			if (action.damage!=0 && !isNaN(action.damage)){
				actionText.push(textPair((action.target==ActionBase.ENEMY?ActionBase.DAMAGE:ActionBase.HEAL),String(int(action.damage))+"/"+ActionBase.statNames[action.type].substr(0,1),TEXT_X,TEXT_Y+i*SPACING));
				i+=1;
			}
			if (action.critrate!=0 && !isNaN(action.critrate)){
				actionText.push(textPair(ActionBase.CRITRATE,String(int(action.critrate*100))+"%",TEXT_X,TEXT_Y+i*SPACING));
				i+=1;
				actionText.push(textPair(ActionBase.CRITMULT,"x"+String(Math.round(action.critmult*10)/10),TEXT_X,TEXT_Y+i*SPACING));
				i+=1;
			}
			if (action.leech!=0 && !isNaN(action.leech)){
				actionText.push(textPair(ActionBase.LEECH,String(int(action.leech*100))+"%",TEXT_X,TEXT_Y+i*SPACING));
				i+=1;
			}
			if (action.dodgeReduce!=0 && !isNaN(action.dodgeReduce)){
				var _temp:int;
				if (action.isMagic()){
					_temp=StatModel.TURN_REDUCE;
				}else{
					_temp=ActionBase.DODGE_REDUCE;
				}
				actionText.push(textPair(_temp,String(int(action.dodgeReduce*100))+"%",TEXT_X,TEXT_Y+i*SPACING));
				i+=1;
			}
			if (action.effects.length>0){
				effectTitle.y=TEXT_Y+i*SPACING;
				addChild(effectTitle);
				i+=1;
				for (var j:int=0;j<action.effects.length;j+=1){
					actionText.push(textObject(action.effects[j].name,TEXT_X+5,TEXT_Y+i*SPACING,action.effects[j]));
					i+=1;
				}
			}
			if (action.cEffects.length>0){
				critTitle.y=TEXT_Y+i*SPACING;
				addChild(critTitle);
				i+=1;
				for (j=0;j<action.cEffects.length;j+=1){
					actionText.push(textObject(action.cEffects[j].name,TEXT_X+5,TEXT_Y+i*SPACING,action.cEffects[j]));
					i+=1;
				}
			}
		}
		
		public function clearAction(){
			for (var i:int=0;i<actionText.length;i+=1){
				removeChild(actionText[i]);
			}
			actionText=new Array();
			if (actionI>=origin.actionList.getList(cAList).length){
				actionI=origin.actionList.getList(cAList).length-1;
			}
			mainTitle.text="";
			if (contains(effectTitle)) removeChild(effectTitle);
			if (contains(critTitle)) removeChild(critTitle);
		}
		
		function textObject(s:String,_x:int,_y:int,v:*):TextContainer{
			var m:TextContainer=new TextContainer(s);
			m.value=v;
			m.name=MouseControl.EFFECT_TEXT;
			m.x=_x;
			m.y=_y;
			addChild(m);
			return m;
		}
		
		function textPair(i:int,t2:String="",_x:Number=0,_y:Number=0):TextDouble{
			var m:TextDouble=new TextDouble(115,TextDouble.ACTION);
			m.setTextFromIndex(i);
			m.text2=t2;
			m.x=_x;
			m.y=_y;
			addChild(m);
			return m;
		}
	}
}
