package ui.main{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import ui.main.assets.LoadObject;
	import items.StatusInventoryUI;
	import ui.windows.ConfirmWindow;
	import ui.assets.FadeTransition;
	import utils.GameData;
	
	public class LoadCharacterUI extends BaseUI{
		public static const LOAD:String="Load Object",
							OVER:String="Over",
							DELETE:String="Delete";
		
		var gameM:GameModel=Facade.gameM;
		var homeUI:BaseUI;
		
		var cSelected:int;
		var loadList:Array=new Array();
		var loadTo:int=0;
		
		var BUSY:Boolean=false;
		
		public function LoadCharacterUI(_home:BaseUI){
			homeUI=_home;
			doneB.update(StringData.DONE,navOut);
			soundB.update(null,muteSound,true);
		}
		
		function selectDelete(i:int){
			if (BUSY || GameData.BUSY) return;
			
			if (loadList.length>1){
				new ConfirmWindow(StringData.CONF_DELETE,50,50,deleteSave,i);
			}else{
				new ConfirmWindow(StringData.CONF_LAST_DELETE);
			}
		}
		
		function deleteSave(i:int){
			BUSY=true;
			GameData.deleteCharacter(i,finishDelete);
			_deleting=i;
		}
		
		var _deleting:int;
		function finishDelete(){
			if ((gameM.playerM.saveSlot>=_deleting)&&(gameM.playerM.saveSlot<5)) gameM.playerM.saveSlot-=1;
			if (gameM.playerM.saveSlot<0) gameM.playerM.saveSlot=0;
			if ((gameM.enemyM.player)&&(gameM.enemyM.saveSlot>=_deleting)&&(gameM.enemyM.saveSlot<5)) gameM.enemyM.saveSlot-=1;
			refresh();
		}
		
		function select(i:int){
			if (cSelected!=-1 && (BUSY || GameData.BUSY)) return;
			if(cSelected>=0 && cSelected<loadList.length){
				loadList[cSelected].unselect();
			}
			cSelected=i;
			if (cSelected>=loadList.length) cSelected=0;
			if (i<0) return;
			
			loadList[cSelected].select();
			if (loadTo==0){
				Facade.saveC.startLoadChar(gameM.playerM,cSelected,true,null,finishSelected);
			}
		}
		
		function finishSelected(){
			BUSY=false;
			display.update(gameM.playerM);
		}
		
		function refresh(){
			cSelected=-1;
			for (var i:int=0;i<loadList.length;i+=1){
				removeChild(loadList[i]);
			}
			GameData.getCharacterArray(refresh2);
		}
		
		function refresh2(a:Array){
			loadList=new Array();
			for (var i:int=0;i<a.length;i+=1){
				loadList.push(new LoadObject(a[i],i));
				loadList[i].update(null,select,true);
				loadList[i].updateDelete(selectDelete);
				loadList[i].x=82.5;
				loadList[i].y=114.5+40*i;
				addChild(loadList[i]);
			}
			BUSY=false;
			if (loadTo==0){
				select(gameM.playerM.saveSlot);
			}else{
				if ((gameM.enemyM.saveSlot<5)&&(gameM.enemyM.saveSlot>=0)){
					select(gameM.enemyM.saveSlot);
				}else{
					select(0);
				}
			}
		}
		
		override public function openWindow(){
			soundB.toggled=Facade.soundC.mute;
			BUSY=true;
			refresh();
		}
		
		public function navOut(){
			if (BUSY || GameData.BUSY) return;
			new FadeTransition(this,homeUI);
		}
		
		override public function closeWindow(){
			for (var i:int=0;i<loadList.length;i+=1){
				removeChild(loadList[i]);
			}
			loadList=new Array();
		}
		
		public function muteSound(){
			Facade.soundC.mute=!Facade.soundC.mute;
			soundB.toggled=Facade.soundC.mute;
		}
	}
}