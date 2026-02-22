package items{
	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.AntiAliasType;
	import ui.assets.SuperComboBox;
	import ui.assets.ComboButton;
	import system.actions.ActionBase;
	import system.actions.ActionPriorities;
	import system.actions.conditionals.ConditionalBase;
	import ui.windows.ConfirmWindow;
	import utils.GameData;
	
	public class ItemButton extends MovieClip{
		static const ADD_LISTS:Boolean=false;
		
		var _Name:String;
		var _Desc:String;
		public var label:TextField=new TextField;
		var index:int;
		var model:ItemModel;
		public var disabled:Boolean=false;
		
		var combo:SuperComboBox;
		var combo2:SuperComboBox;
		var combo3:SuperComboBox;
		var currentMain:int=-1;
		
		public function ItemButton(_model:ItemModel=null,_index:int=-1){
			name=MouseControl.ITEM_BUTTON;
			buttonMode=true;
			mouseChildren=false;
			index=_index;
			fill(0xDDDDDD);
			addChild(label);
			label.antiAliasType=AntiAliasType.ADVANCED;
			label.embedFonts=true;
			label.defaultTextFormat=new TextFormat(StringData.FONT_FANCY,14,0xC1A95F,true);
			label.width=35;
			label.height=14.2;
			label.autoSize="center";
			label.y=-3;
			
			if (_model!=null){
				update(_model);
			}
		}
		
		public function update(_model:ItemModel){
			model=_model;
			var i:int=-1;
			if (model==null){
				i=ActionPriorities.NONE;
			}else if (model.action==null){
				i=ActionPriorities.EQUIP;
			}else{
				i=model.action.basePriority.getCurrentName();
			}
			
			fill(ActionPriorities.getColor(i),ActionPriorities.isLightColor(i));
			
			label.text=ActionPriorities.getListName(i);
			setDesc(ActionPriorities.getTooltipName(i),"Click to change the priority, hold the mouse button to see Advanced Options.");
			//setDesc("","");
		}
		
		public function fill(i:uint,darkText:Boolean=false){
			graphics.clear();
			graphics.beginFill(i,1);
			graphics.drawRect(0,0,35,14.2);
			graphics.endFill();
			if (darkText){
				label.defaultTextFormat=new TextFormat(null,null,0x33291B);
			}else{
				label.defaultTextFormat=new TextFormat(null,null,0xC1A95F);
			}
		}
		
		public function get tooltipName():String{
			return _Name;
		}
		
		public function set tooltipName(s:String){
			throw (new Error("property is read-only"));
		}
		
		public function get description():String{
			return _Desc;
		}
		
		public function set description(s:String){
			throw (new Error("property is read-only"));
		}
		
		public function setDesc(_name:String=null,_desc:String=null){
			if (_name!=null){
				_Name=_name;
			}
			if (_desc!=null){
				_Desc=_desc;
			}
		}
		
		public function run(){
			if (model==null || !model.hasAction() || disabled) return;
			if (combo!=null && combo.parent!=null){
				combo.remove();
			}
			
			switchList();
		}
		
		public function onHold(){
			if (model==null || !model.hasAction() || disabled) return;
			if (!utils.GameData.getFlag(GameData.FLAG_TUTORIAL)) return;
			
			if (combo==null || combo.parent==null){
				combo=makeComboBox();
			}else{
				combo.remove();
			}
		}
		
		function switchList(i:int=-1){
			//use for the Basic Priority, switches the basic list.
			model.action.basePriority.goNextList();
			update(model);
			if (Facade.currentUI!=null) Facade.currentUI.updateStats();
		}
		
		function updateList(i:int=-1){
			update(model);
			if (combo!=null) refreshComboBox();
			if (Facade.currentUI!=null) Facade.currentUI.updateStats();
		}
		
		function refreshComboBox(){
			if (combo!=null) combo.remove();
			if (combo2!=null) combo2.remove();
			if (combo3!=null) combo3.remove()
			combo2=null;
			combo3=null;
			combo=makeComboBox();
		}
		
		function makeTierButtons(_action:ActionBase):Array{
			var a:Array=[];
			a.push(new ComboButton("",0x412315,nullFunction,-1,false));
			a.push(new ComboButton("Tier",0x412315,nullFunction,-1,false));
			a.push(new ComboButton("Top",ActionPriorities.getColor(0),changeTier,1,_action.priorityTier==1));
			a.push(new ComboButton("High",ActionPriorities.getColor(1),changeTier,2,_action.priorityTier==2));
			a.push(new ComboButton("Mid",ActionPriorities.getColor(2),changeTier,3,_action.priorityTier==3));
			a.push(new ComboButton("Low",ActionPriorities.getColor(3),changeTier,4,_action.priorityTier==4));
			a[0].buttonMode=false;
			a[1].buttonMode=false;
			a[1].setDesc("Tier List:","Actions are automatically sorted into these tier lists.  Higher tiers are always checked before lower tiers.  Within each tier, last action equipped is checked first.\nIf you just loaded a game, the action equipped on the right happens before the action on the left (Items before Spells).");
			a[2].setDesc("Top Tier:","Healing effects are automatically sorted here.");
			a[3].setDesc("High Tier:","Buffs/Curses are automatically sorted here.");
			a[4].setDesc("Mid Tier:","Standard offensive actions are sorted here.");
			a[5].setDesc("Low Tier:","By default, only the basic attack is sorted here.");
			return a;
		}
		
		function changeTier(i:int){
			model.action.priorityTier=i;
			updateList();
		}
		
		function makeComboBox():SuperComboBox{
			//Primary Priority List.  All good here!
			var a:Array=[model.action.basePriority.makeDistanceComboArray(updateList)];
			a[0].unshift(new ComboButton("Range",0x412315,nullFunction,-1,false));
			a[0][0].buttonMode=false;
			if (ADD_LISTS){
				a[0][0].setDesc("Priorities 2.0 BETA Help:","All rules are subject to change.  \n\nDon't fiddle with this if you don't understand.  \n\nActions are currently sorted in this order: (1) Healing, (2) Buffs/Curses, (3) Everything Else, (4) Attack Last.  Within each section, the last action equipped is checked first.  If you just loaded a game, the action equipped on the right happens before the action on the left (Items before Spells).  This is subject to change in the future.");
			}else{
				a[0][0].setDesc("Priorities 1.5 BETA","All rules are subject to change.  Don't fiddle with this if you don't understand!");
			}
			
			a[0]=a[0].concat(makeTierButtons(model.action));
			
			var _list:Array=model.action.additionalPriorities;
			
			for (var i:int=0;i<_list.length;i+=1){
				var _toAdd:Array=[];
				_toAdd=_list[i].makeComboArray(refreshComboBox,_list[i].selections,_list[i].category,_list[i].sub);
						//list of selections.  Need to (1) SELECT THIS LIST and (2) REFRESH PAGE.
						//Select This List means add to _list[i].selections (or remove from)... toggle, basically.
						//Refresh has to be pushed from here.
				
				if (ADD_LISTS){
					_toAdd.unshift(new ComboButton(ConditionalBase.MASTER_LIST[_list[i].category][1][_list[i].sub][0],0x412315,popRemoveList,i));
					_toAdd[0].setDesc("Remove Priority List: "+ConditionalBase.MASTER_LIST[_list[i].category][0]+" "+ConditionalBase.MASTER_LIST[_list[i].category][1][_list[i].sub][0],"Click to remove this list");
				}else{
					_toAdd.unshift(_list[i].makeSubTitle(nullFunction));
				}
				a.push(_toAdd);
			}
			if (ADD_LISTS && _list.length<4){
				_toAdd=[new ComboButton("+List",ActionPriorities.getColor(-1),popAddMainList,-1,false)];
				_toAdd[0].setDesc("Add Priority List","Adds a new list that can be used to set priorities.  Every list must be 'true' in order to use the action.  If any selected item is found 'true' then the list is confirmed as 'true'. (internally: -OR- statements, externally: -AND- statements).  Selecting no options will always return False (disabling the ability)");
				a.push(_toAdd);
			}
			
			return new SuperComboBox(this,a,Facade.stage);
		}
		
		function popAddMainList(i:int=-1){
			var a:Array=ConditionalBase.makeMainComboArray(popAddSecondaryList);
			if (combo2!=null) combo2.remove();
			combo2=new SuperComboBox(combo,[a],Facade.stage);
		}
		
		function popAddSecondaryList(i:int=-1){
			var a:Array=ConditionalBase.makeSubComboArray(finalAddList,i);
			currentMain=i;
			if (combo3!=null) combo3.remove();
			combo3=new SuperComboBox(combo2,[a],Facade.stage);
		}
		
		function finalAddList(_sub:int){
			model.action.addAdditionalPriority(new ConditionalBase(currentMain,_sub));
			refreshComboBox();
		}
		
		function popRemoveList(i:int=-1){
			new ConfirmWindow("Remove this list from your priorities?",100,100,finishRemoveList,i);
		}
		
		function finishRemoveList(i:int=-1){
			model.action.removeAdditionalPriorityIndex(i);
			refreshComboBox();
		}
		
		function nullFunction(i:int=-1){}
	}
}