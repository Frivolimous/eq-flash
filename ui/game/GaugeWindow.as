package ui.game {
	import flash.display.MovieClip;
	
	public class GaugeWindow extends MovieClip {
		
		public function GaugeWindow() {
			healthBar.setTooltipName("Health:");
			manaBar.setTooltipName("Mana:");
			if (xpBar!=null) xpBar.setTooltipName("Experience:");
		}
		
		public function init(origin:SpriteModel){
			nameTitle.text=origin.label;
			update(origin);
		}
		
		public function update(origin:SpriteModel){
			if (origin.stats.getValue(StatModel.FURY)>0){
				if (currentFrame==1){
					gotoAndStop(2);
					furyBar.setTooltipName("Fury:");
					init(origin);
					return;
				}else{
					furyBar.count(origin.fury,origin.stats.getValue(StatModel.FURY));
				}
			}else{
				if (currentFrame==2){
					gotoAndStop(1);
					init(origin);
					return;
				}
			}
			healthBar.count(origin.getHealth(),origin.stats.getValue(StatModel.HEALTH));
			manaBar.count(origin.mana,origin.stats.getValue(StatModel.MANA));
			if (xpBar!=null){
				if (origin.level<origin.getMaxLevel()){
					xpBar.count(origin.xp,origin.maxXP);
				}else{
					xpBar.setMaxed(true);
				}
			}
			levelTitle.text=String(origin.level);
		}

	}
	
}
