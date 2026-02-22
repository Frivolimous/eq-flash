package tournament{
	import flash.events.MouseEvent;
	import ui.assets.FadeTransition;
	
	public class ExhibitionControl{
		var players:Array=new Array();
		var gameM:GameModel;
		var saveC:SaveControl;
		var effectC:EffectControl;
		var actionC:ActionControl;
		var duelC:DuelControl;
		var record:Boolean=true;
		
		public function init(){
			gameM=Facade.gameM;
			saveC=Facade.saveC;
			duelC=Facade.duelC;
			effectC=Facade.effectC;
			actionC=Facade.actionC;
		}
		
		public function simMode(b:Boolean=true){
			if (b){
				gameM.playerM.view=new FakeSpriteView;
				gameM.enemyM.view=new FakeSpriteView;
				//gameM.projM=new FakeProjectileObject;
				GameModel.SIMULATED=true;
			}else{
				gameM.playerM.view=new SpriteView(gameM.playerM);
				saveC.startLoadChar(gameM.playerM,gameM.playerM.saveSlot,true,saveC.getArray(gameM.playerM));
				gameM.enemyM.view=new SpriteView(gameM.enemyM);
				gameM.enemyM.view.inverted=true;
				gameM.enemyM.view.newPlayer(false);
				//gameM.projM=new ProjectileObject;
				GameModel.SIMULATED=false;
			}
		}
		
		public function fullDuel(_results:DuelResult,_replay:Boolean=false){
			if (_replay && _results.replay==null){
				_replay=false;
			}
			
			if (_replay){
				GameModel.startReplay(_results.replay);
			}
			
			saveC.loadShort(gameM.playerM,_results.left);
			saveC.loadShort(gameM.enemyM,_results.right);
			saveC.saveTemp(0,gameM.playerM);
			saveC.saveTemp(1,gameM.enemyM);
			gameM.duel=true;
			simMode(false);
			Facade.gameC=Facade.duelC;
			Facade.gameUI.transTo=Facade.currentUI;
			new FadeTransition(Facade.currentUI,Facade.gameUI);
		}
		
		var actionPhase:Boolean=true;
		
		public function fastDuel(_results:DuelResult,_record:Boolean=false):DuelResult{
			saveC.loadShort(gameM.playerM,_results.left);
			saveC.loadShort(gameM.enemyM,_results.right);
			gameM.distance=GameModel.FAR;
			gameM.playerM.maxHM();
			gameM.enemyM.maxHM();
			actionPhase=true;
			record=_record;
			if (record){
				GameModel.record=true;
				GameModel.recordA=new Array;
			}else{
				GameModel.record=false;
			}
			GameModel.cReplay=0;
			
			duelC.chooseInit();
			var i:Number=0;
			while (i<GameModel.MAX_ROUNDS){
				if (gameM.turn){
					if (!actionPhase){
						actionC.beginTurn(gameM.playerM,gameM.enemyM);
						actionPhase=true;
					}else{
						actionC.runAct(gameM.playerM,gameM.playerM[gameM.distance]);
						
						while (gameM.playerM.tFunction!=null){
							gameM.playerM.endTimer();
						}
						/*while (gameM.projM.tFunction!=null){
							gameM.projM.endTimer();
							gameM.projM.exists=false;
						}*/
						if (gameM.playerM.tFunction!=null){
							throw(new Error("Shouldn't be UN-NULL"));
						}
						actionPhase=false;
						gameM.turn=!gameM.turn;
						i+=0.5;
					}
				}else{
					if (!actionPhase){
						actionC.beginTurn(gameM.enemyM,gameM.playerM);
						actionPhase=true;
					}else{
						actionC.runAct(gameM.enemyM,gameM.enemyM[gameM.distance]);
						
						while (gameM.enemyM.tFunction!=null){
							gameM.enemyM.endTimer();
						}
						/*while (gameM.projM.tFunction!=null){
							gameM.projM.endTimer();
							gameM.projM.exists=false;
						}*/
						if (gameM.enemyM.tFunction!=null){
							throw(new Error("Shouldn't be UN-NULL"));
						}
						actionPhase=false;
						gameM.turn=!gameM.turn;
						i+=0.5;
					}
				}
				
				checkDeath(gameM.playerM);
				checkDeath(gameM.enemyM);
				
				if (gameM.playerM.dead){
					if (gameM.enemyM.dead){
						_results.finishRound(DuelResult.TIE,gameM.playerM,gameM.enemyM,i);
						if (record) _results.replay=GameModel.recordA;
						return _results;
					}else{
						_results.finishRound(DuelResult.LOSS,gameM.playerM,gameM.enemyM,i);
						if (record) _results.replay=GameModel.recordA;
						return _results;
					}
				}else if (gameM.enemyM.dead){
					_results.finishRound(DuelResult.WIN,gameM.playerM,gameM.enemyM,i);
					if (record) _results.replay=GameModel.recordA;
					return _results;
				}
			}
			_results.finishRound(DuelResult.TIE,gameM.playerM,gameM.enemyM,i);
			if (record) _results.replay=GameModel.recordA;
			return _results;
			//Left = 0; Right = 1; Tie = -1
		}
		
		public function checkDeath(_v:SpriteModel){
			if (_v.exists && !_v.dead){
				if (_v.getHealth()<=0){
					if (!effectC.tryRevive(_v)){
						_v.dead=true;
						gameM.playerM.clearTimer();
						gameM.playerM.view.toIdle();
						gameM.enemyM.clearTimer();
						gameM.enemyM.view.toIdle();
						//gameM.projM.clearTimer();
						Facade.gameUI.clearBuffs(true);
						Facade.gameUI.clearBuffs(false);
						gameM.enemyM.buffList.reset();
						gameM.playerM.buffList.reset();
					}
				}
			}
		}
	}
}