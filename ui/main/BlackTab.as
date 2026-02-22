package ui.main{
	import flash.display.Sprite;
	import flash.display.Bitmap;
	import skills.SkillData;
	import items.*
	import ui.windows.ConfirmWindow;
	import ui.assets.FadeTransition;
	import utils.GameData;
	
	public class BlackTab extends Sprite{
																						
		public var inventory:StoreInventoryUI;
		var restockAll:Function;
		
		public function BlackTab(){
			gambleB.update(StringData.GAMBLE,openGamble,true);
			upgradeB.update(StringData.UPGRADE,openUpgrade,true);
			refreshBlock.refreshB.update(StringData.REFRESH,tryRestock);
			closeMarkets();
		}
		
		public function update(_player:*){
			gambleUI.update(_player);
			refreshBlock.remainText.text=String(GameData.refreshes);
		}
		
		public function lockInventory(b:Boolean){
			gambleUI.locked=b;
			upgradeUI.locked=b;
		}
		
		public function init(_inventory:StoreInventoryUI,_refresh:Function){
			inventory=_inventory;
			upgradeUI.init(SingleInventoryUI.UPGRADE,_inventory);
			restockAll=_refresh;
		}
		
		public function openGamble(){
			if (Facade.gameM.playerM.skillBlock.getTalentIndex()==SkillData.HOLY){
				new ConfirmWindow(StringData.CONF_MORAL);
			}else{
				closeMarkets();
				display.text=StringData.TEXT_GAMBLE;
				addChild(gambleUI);
				addChild(refreshBlock);
				gambleB.toggled=true;
			}
		}
		
		public function openUpgrade(){
			closeMarkets();
			display.text=StringData.TEXT_UPGRADE;
			addChild(upgradeUI);
			upgradeB.toggled=true;
		}
		
		/*public function openRestack(){
			closeMarkets();
			display.text=StringData.TEXT_STACK;
			addChild(restackUI);
			restackB.toggled=true;
		}*/
		
		public function closeMarkets(){
			try{ removeChild(gambleUI); removeChild(refreshBlock); }catch(e:Error){}
			try{ removeChild(upgradeUI) }catch(e:Error){}
			//try{ removeChild(restackUI) }catch(e:Error){}
			upgradeUI.removeValues();
			//restackUI.removeValues();
			display.text=StringData.TEXT_BLACK;
			gambleB.toggled=false;
			upgradeB.toggled=false;
			//restackB.toggled=false;
		}
				
		function tryRestock(){
			if (GameData.refreshes>=1){
				GameData.refreshes-=1;
				restockAll();
			}else if (Facade.gameM.kreds>0){
				new ConfirmWindow("Use 1 Power Token to refresh the store slots?",50,50,restockPT);
			}else{
				new ConfirmWindow("Not enough Refreshes or Power Tokens to refresh.")
			}
		}
		
		function restockPT(i:int=0){
			Facade.gameM.kreds-=1;
			restockAll();
		}
		
		public function restock(){
			refreshBlock.remainText.text=String(GameData.refreshes);
			var _level:int=Math.ceil(Facade.gameM.area/10);
			if (_level>15) _level=15;
			
			gambleUI.clear();
			for (var i:int=0;i<3;i+=1){
				gambleUI.addItemAt(new ItemView(ItemData.spawnGamble(_level)),i);
			}
		}
				
		public function getItemArray():Array{
			var m:Array=new Array(3);		
			for (var i:int=0;i<3;i+=1){
				if (gambleUI.itemA[i].stored!=null){
					m[i]=gambleUI.itemA[i].stored.model.index;
				}else{
					m[i]=-1;
				}
				
			}
			return m;
		}
		
		public function setItemsFromArray(_a:Array){
			var _level:int=Math.ceil(Facade.gameM.area/10);
			if (_level>15) _level=15;
			
			gambleUI.clear();
			for (var i:int=0;i<3;i+=1){
				if (_a[i]!=-1){
					gambleUI.addItemAt(new ItemView(ItemData.spawnItem(-1,_a[i])),i);
					gambleUI.itemA[i].stored.model.cost=ItemData.gambleCost(gambleUI.itemA[i].stored.model.cost,_level,gambleUI.itemA[i].stored.model.primary==ItemData.PROJECTILE);
				}
			}
		}
	}
}