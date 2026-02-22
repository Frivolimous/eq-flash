package artifacts {
	import flash.display.Sprite;
	import utils.GameData;

	public class StashArtifactUI extends ArtifactInventoryBase{
		//UI of stash.  5x3;
		
		public var _Source:Array;
		var over:ArtifactInventoryBase;
		var _back:Sprite=new Sprite;
		
		public function StashArtifactUI() {
			_back.graphics.beginFill(0,0.01);
			_back.graphics.drawRect(-12,33,533,194);
			_back.name=MouseControl.ARTIFACT_BACK;
			addChild(_back);
			itemA=new Array(50);
			for (var i:int=0;i<50;i+=1){
				itemA[i]=makeBox(i,Math.floor(i/5)*53.15,41.05+(i%5)*37.3,ArtifactBox.NONE);
			}
			makeHeader(1,ArtifactData.PHOENIX,column0.x,column0.y);
			makeHeader(2,ArtifactData.ARCHANGEL,column1.x,column1.y);
			makeHeader(3,ArtifactData.SPIRIT,column2.x,column2.y);
			makeHeader(4,ArtifactData.VALKYRIE,column3.x,column3.y);
			makeHeader(5,ArtifactData.GAIA,column4.x,column4.y);
			makeHeader(6,ArtifactData.DRAGON,column5.x,column5.y);
			makeHeader(7,ArtifactData.BLOOD,column6.x,column6.y);
			makeHeader(8,ArtifactData.MATRIX,column7.x,column7.y);
		}
		
		function makeHeader(i:int,_name:String,_x:Number,_y:Number){
			var _header:ArtifactHeaders=new ArtifactHeaders;
			_header.mouseChildren=false;
			_header.name=MouseControl.ARTIFACT_HEADER;
			
			_header.gotoAndStop(i);
			_header.tooltipName=_name;
			_header.x=_x;
			_header.y=_y;
			
			addChild(_header);
		}
		
		public function init (_over:ArtifactInventoryBase){
			over=_over;
		}
		
		public function maxStash(_origin:SpriteModel=null,_level:int=0){
			clear();
			_Source=new Array;
			
			main:for (var i:int=0;i<itemA.length;i+=1){
				if (ArtifactData.spawnArtifact(i,0)==null){
					this["column"+Math.floor(i/5)]["row"+(i%5)].gotoAndStop(2);
					_Source[i]=-1;
				}else{
					itemA[i].showBlank(true);
					for (var j:int=0;j<origin.arts.length;j+=1){
						if (origin.arts[j] is ArtifactModel && origin.arts[j].index==i){
							_Source[i]=_level;
							continue main;
						}
					}
					_Source[i]=_level;
					itemA[i].addItem(new ArtifactView(ArtifactData.spawnArtifact(i,_level)));
				}
			}
		}
		
		public function updateStash(a:Array=null,_origin:SpriteModel=null){
			clear();
			
			_Source=a;
			origin=_origin;
			
			if (a==null) return;
			
			main:for (var i:int=0;i<itemA.length;i+=1){
				if (i>=_Source.length || ArtifactData.spawnArtifact(i,0)==null){
					this["column"+Math.floor(i/5)]["row"+(i%5)].gotoAndStop(2);
				}else if (_Source[i]==-1){
					itemA[i].showBlank(false);
				}else{
					itemA[i].showBlank(true);
					for (var j:int=0;j<origin.arts.length;j+=1){
						if (origin.arts[j] is ArtifactModel && origin.arts[j].index==i){
							continue main;
						}
					}
					itemA[i].addItem(new ArtifactView(ArtifactData.spawnArtifact(i,_Source[i])));
				}
			}
		}
		
		/*override public function yesSell(i:int){
			if (_Source!=null) _Source[i]=null;
			super.yesSell(i);
		}*/
		
		override public function addItem(_item:ArtifactView):Boolean{
			return forceAddTo(_item);
		}
		
		override public function addItemAt(_item:ArtifactView,i:int):Boolean{
			return forceAddTo(_item);
		}
		
		public function forceAddTo(_item:ArtifactView):Boolean{
			var i:int=_item.model.index;
			itemA[i].addItem(_item);
			return true;
		}
		
		public function unlockSlot(_slot:int,_level:int=0){
			if (_level>-1){
				GameData.artifacts[_slot]=_level;
				itemA[_slot].showBlank(true);
			}
		}
	}
}
