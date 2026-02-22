package ui.main.assets {
	import flash.display.Sprite;
	import artifacts.SepiaArtifactUI;
	import items.StatusInventoryUI;
	
	public class SepiaDisplay extends Sprite{
		
		var charView:SpriteModel=new SpriteModel();
		var inventory:StatusInventoryUI=new StatusInventoryUI;
		var artifact:SepiaArtifactUI=new SepiaArtifactUI;

		public function SepiaDisplay() {
			charView.view.x=130;
			charView.view.y=250;
			secondary.text="";
			addChild(charView.view);
			addChild(inventory);
			addChild(artifact);
		}
		
		public function update(_v:SpriteModel){
			Facade.saveC.loadShort(charView,Facade.saveC.getShortArray(_v),-1);
			charView.view.makeSepia(1.5);
			
			nameTitle.htmlText=_v.label+" "+_v.title+"\n<font size='18'>"+StringData.level(_v.level)+"</font>";
			
			inventory.update(_v);
			artifact.update(_v);
			for (var i:int=0;i<_v.arts.length;i+=1){
				if (_v.arts[i]==false){
					this["art"+i].alpha=0.5;
				}else{
					this["art"+i].alpha=1;
				}
			}
		}
		
		public function clear(){
			nameTitle.text="";
			secondary.text="";
			inventory.update();
			artifact.update();
			
		}
		
		public function secondaryText(s:String){
			if (contains(artifact)) removeChild(artifact);
			for (var i:int=0;i<5;i+=1){
				if (contains(this["art"+i])) removeChild(this["art"+i]);
			}
			
			secondary.htmlText=s;
		}

	}
	
}
