package system.buffs {
	import ui.effects.PopEffect;
	
	public class BuffList {
		private var buffs:Vector.<BuffBase>=new Vector.<BuffBase>;
		var origin:SpriteModel;
		
		public function BuffList(_origin:SpriteModel) {
			origin=_origin;
		}
		
		public function reset(){
			buffs=new Vector.<BuffBase>;
		}
		
		public function addBuff(_buff:BuffBase){
			var _existing:BuffBase;
			for (var i:int=0;i<buffs.length;i+=1){
				if (buffs[i].name==_buff.name){
					_existing=buffs[i];
					buffs.splice(i,1);
					break;
				}
			}
			
			buffs.push(_buff);
			
			if (_existing==null) origin.view.buffAdded(buffs.length-1);
			
			_buff.wasAddedTo(origin,_existing);
							 
			if (Facade.currentUI!=null){
				Facade.currentUI.updateStats();
				graphicAddBuff(_buff);
			}
		}
		
		public function removeBuff(i:int):BuffBase{
			var m:BuffBase=buffs[i];
			buffs.splice(i,1);
			
			origin.view.buffRemoved(i,m.name);
			m.wasRemovedFrom(origin);
			
			if (Facade.currentUI!=null) Facade.currentUI.updateStats();
			graphicRemoveBuff(m);
			return m;
		}
		
		public function removeBuffCalled(s:String):BuffBase{
			for (var i:int=0;i<buffs.length;i+=1){
				if (buffs[i].name==s) {
					return removeBuff(i);
				}
			}
			return null;
		}
		
		public function hasBuff(s:String):Boolean{
			for (var i:int=0;i<buffs.length;i+=1){
				if (buffs[i].name==s) return true;
			}
			return false;
		}
		
		public function getBuff(i:int):BuffBase{
			return buffs[i];
		}
		
		public function getBuffCalled(s:String):BuffBase{
			for (var i:int=0;i<buffs.length;i+=1){
				if (buffs[i].name==s) return buffs[i];
			}
			return null;
		}
		
		public function numBuffs():int{
			return buffs.length;
		}
		
		public function countBuffs(_type:int,_includeStacks:Boolean=true):int{
			var m:int=0;
			for (var i:int=0;i<buffs.length;i+=1){
				if (buffs[i].index>-1 && buffs[i].type==_type){
					if (_includeStacks){
						m+=buffs[i].stacks;
					}else{
						m+=1;
					}
				}
			}
			return m;
		}
		
		public function graphicAddBuff(_buff:BuffBase){
			if (GameModel.SIMULATED) return;
			if (Facade.currentUI!=Facade.gameUI) return;
			Facade.gameUI.addBuff(origin==Facade.gameM.playerM,_buff);
		}
		
		public function graphicRemoveBuff(_buff:BuffBase){
			if (GameModel.SIMULATED) return;
			if (Facade.currentUI!=Facade.gameUI) return;
			
			if (_buff.name==BuffData.BOMB){
				new PopEffect(origin,PopEffect.BOMB);
			}
			
			Facade.gameUI.removeBuff(origin==Facade.gameM.playerM,_buff.name);
		}
		
		public function updateBuff(){
			if (buffs.length==0) return;
			var buffDmg:DamageModel=new DamageModel();
			
			var i:int=0;
			while (i<buffs.length){
				buffs[i].update(origin,buffDmg);
				if (buffs[i].charges==0){
					removeBuff(i);
				}else{
					i+=1;
				}
			}
			
			buffDmg.applyDamage(origin,origin,false);
		}
		
		public function actionStop():String{
			for (var i:int=0;i<buffs.length;i+=1){
				//var _buff:BuffBase=_v.buffList.getBuff(i);
				if (buffs[i] is BuffAction){
					if ((buffs[i] as BuffAction).checkRate()){
						return buffs[i].name;
					}
				}
			}
			return null;
		}
		
		public function clearEndFight(){
			//removeBuffCalled(BuffData.CRIT_ACCUM);
			removeBuffCalled(BuffData.REVIVED);
			removeBuffCalled(BuffData.ATTACK_IGNORED);
			
			var _buff:BuffBase=removeBuffCalled(BuffData.SUPER_SAYAN);
			if (_buff==null) _buff=removeBuffCalled(BuffData.SUPER_SAYAN2);
			if (_buff==null) _buff=removeBuffCalled(BuffData.SUPER_SAYAN3);
			if (_buff!=null){
				addBuff(BuffData.makeBuff(BuffData.SAYAN,_buff.level));
			}
		}
	}
}
