package ui.main{
	import flash.display.Sprite;
	import ui.assets.CosmeticSelect;
	import sprites.BallHead;
	import utils.GameData;
	
	public class CosmeticsTab extends Sprite{
		public static const SKIN:String="Skin",
							EYES:String="Eyes",
							MOUTH:String="Mouth",
							AURA:String="Aura",
							FEET:String="Feet",
							EXTRA1:String="Extra TOP",
							EXTRA2:String="Extra MIDDLE",
							EXTRA3:String="Extra BOTTOM";
				
				
		public var origin:SpriteModel;
		var buttons:Vector.<CosmeticSelect>;
		var view:SpriteView;
		
		public function CosmeticsTab(){
			buttons=new <CosmeticSelect>[skinC,eyeC,mouthC,extra3C,extra2C,auraC,feetC,extra1C];
			buttons[0].update(SKIN,BallHead.COSMETICS_SKIN.concat(GameData.getCosmetics(0)),selectCosmetic);
			buttons[1].update(EYES,BallHead.COSMETICS_EYES.concat(GameData.getCosmetics(1)),selectCosmetic);
			buttons[2].update(MOUTH,BallHead.COSMETICS_MOUTH.concat(GameData.getCosmetics(2)),selectCosmetic);
			buttons[6].update(FEET,BallHead.COSMETICS_FEET.concat(GameData.getCosmetics(3)),selectCosmetic);
			buttons[7].update(EXTRA1,BallHead.COSMETICS_EXTRA.concat(GameData.getCosmetics(4)),selectCosmetic);
			buttons[4].update(EXTRA2,BallHead.COSMETICS_EXTRA.concat(GameData.getCosmetics(4)),selectCosmetic);
			buttons[3].update(EXTRA3,BallHead.COSMETICS_EXTRA.concat(GameData.getCosmetics(4)),selectCosmetic);
			buttons[5].update(AURA,BallHead.COSMETICS_AURA.concat(GameData.getCosmetics(5)),selectCosmetic);
			
			view=new SpriteView();
			view.x=140;
			view.y=180;
			addChildAt(view,getChildIndex(skinC));
			for (var i:int=0;i<buttons.length;i+=1){
				
			}
		}
		
		public function update(_origin:SpriteModel){
			origin=_origin;
			view.setPlayerDisplay(_origin);
			for (var i:int=0;i<buttons.length;i+=1){
				buttons[i].selectCosmetic(_origin.cosmetics[i]);
			}
		}
		
		public function selectCosmetic(_type:String,i:int){
			switch(_type){
				case SKIN: origin.cosmetics[0]=i; break;
				case EYES: origin.cosmetics[1]=i; break;
				case MOUTH: origin.cosmetics[2]=i; break;
				case EXTRA1: origin.cosmetics[7]=i; break;
				case EXTRA2: origin.cosmetics[4]=i; break;
				case AURA: origin.cosmetics[5]=i; break;
				case FEET: origin.cosmetics[6]=i; break;
				case EXTRA3: origin.cosmetics[3]=i; break;
			}
			origin.view.updateCosmetics(origin.cosmetics,origin.skillBlock.getTalentIndex());
			view.updateCosmetics(origin.cosmetics,origin.skillBlock.getTalentIndex());
		}
		
	}
}