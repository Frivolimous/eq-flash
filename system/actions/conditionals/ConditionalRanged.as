package system.actions.conditionals {
	import ui.assets.ComboButton;
	import system.buffs.BuffBase;
	
	public class ConditionalRanged {
		public static const GLOBAL_PROPERTY:String="Global",
								DISTANCE:String="Range",
									NEAR:String="Near",
									FAR:String="Far",
									VERY:String="Long",
									BETWEEN:String="Safe";
									
		public static const DISTANCE_LIST:Array=[BETWEEN,VERY,FAR,NEAR];
		
		//POSITION: 3,1
					   
		/*public var category:int,
					sub:int,
					selections:Array;*/
		
		public function ConditionalRanged(){
			super(3,1);
		}
		
		override public function testThis(_o:SpriteModel,_t:SpriteModel,_action:ActionBase):Boolean{
			
			return true;
		}
		
		override public function getSubs(_category:int=-1):Array{
			return [1];
		}
		
		override public function getSelections(_category:int=-1,_sub:int=-1,_filtered:Boolean=false):Array{
			if (_filtered){
				var m:Array=new Array;
				for (var i:int=0;i<selections.length;i+=1){
					m.push(DISTANCE_LIST[selections[i]]);
				}
				return m;
			}else{
				return DISTANCE_LIST;
			}
		}
		
		public function makeComboArray(_function:Function,_selecteds:Array=null,_category:int=-1,_sub:int=-1):Array{
			if (_selecteds==null) _selecteds=[];
			if (_category==-1){
				m=new Array;
				for (i=0;i<MASTER_LIST.length;i+=1){
					_selected=false;
					for (j=0;j<_selecteds.length;j+=1){
						if (_selecteds[j]==i){
							_selected=true;
							break;
						}
					}
					m.push(makeComboButton(_function,_selected,i));
				}
				return m;
			}else if (_sub==-1){
				var m:Array=new Array;
				for (var i:int=0;i<MASTER_LIST[_category][1].length;i+=1){
					var _selected:Boolean=false;
					for (var j:int=0;j<_selecteds.length;j+=1){
						if (_selecteds[j]==i){
							_selected=true;
							break;
						}
					}
					
					m.push(makeComboButton(_function,_selected,_category,i));
				}
				return m;
			}else{
				m=new Array;
				for (i=0;i<MASTER_LIST[_category][1][_sub][1].length;i+=1){
					_selected=false;
					for (j=0;j<_selecteds.length;j+=1){
						if (_selecteds[j]==i){
							_selected=true;
							break;
						}
					}
					m.push(makeComboButton(_function,_selected,_category,_sub,i));
				}
				
				return m;
			}
		}
		
		var _Refresh:Function;
		
		public function makeComboButton(_function:Function,_selected:Boolean,_category:int=-1,_sub:int=-1,_selection:int=-1,_color:uint=0):ComboButton{
			if (_sub==-1){
				if (_color==0) _color=getColor(_category);
				var m:ComboButton=new ComboButton(MASTER_LIST[_category][0],_color,_function,_category,_selected);
				makeTooltipDesc(m.setDesc,_category);
				return m;
			}else if (_selection==-1){
				if (_color==0) _color=getColor(_sub);
				//m=new ComboButton(MASTER_LIST[_category][0]+" "+MASTER_LIST[_category][1][_sub][0],_color,_function,_sub,_selected);
				m=new ComboButton(MASTER_LIST[_category][1][_sub][0],_color,_function,_sub,_selected);
				
				makeTooltipDesc(m.setDesc,_category,_sub);
				//m.setDesc("remove "+MASTER_LIST[_category][0]+" "+MASTER_LIST[_category][1][_sub][0],"Click here to remove this column.");
				return m;
			}else{
				_Refresh=_function;
				if (_color==0) _color=getColor(_selection);
				m=new ComboButton(MASTER_LIST[_category][1][_sub][1][_selection],_color,toggleSelection,_selection,_selected);
				makeTooltipDesc(m.setDesc,_category,_sub,_selection);
				return m;
			}
		}
		
		public function makeSubTitle(_function:Function):ComboButton{			
			var m:ComboButton=new ComboButton(MASTER_LIST[category][1][sub][0],0x412315,_function);
			m.buttonMode=false;
			makeTooltipDesc(m.setDesc,category,sub);
			return m;
		}
		
		public function toggleSelection(i:int){
			if (!removeSelection(i)){
				addSelection(i);
			}
			
			if (_Refresh!=null) _Refresh();
		}
		
		public function toArray():Array{
			return [category,sub,selections];
		}
	}
}
