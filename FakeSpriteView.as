package{
	import flash.display.BitmapData;
	import flash.display.Bitmap;
	import items.ItemModel;
	import flash.display.MovieClip;
	import flash.filters.ColorMatrixFilter;
	import system.actions.ActionBase;
	

	public class FakeSpriteView extends SpriteView{
		
		public function SpriteView(m:SpriteModel=null){
			model=m;
		}
		
		override public function toIdle(){
			if (tweenA==DOUBLE_ATTACK){
				action(IDLE);
			}
		}
		
		override public function fromAction(_action:ActionBase,_extra:int=0){
			if (_action.isDouble()){ 
				action(DOUBLE_ATTACK,_extra);
			}
		}
		
		override public function action(_a:String,_extra:int=0){
			tweenA=_a;
		}
		
		override public function tick(){
			
		}
		
		
		override function updateBuffs(){
			
		}
		
		override public function buffAdded(i:int){
			
		}
		
		override public function buffRemoved(i:int,_name:String){
			
		}
		
		override public function isFootBuff(i:int):Boolean{
			
			return false;
		}
		
		override public function tryFootBuff(i:int):Boolean{
			
			return false;
		}
		
		override public function isDisplayBuff(i:int):Boolean{
			
			return false;
		}
		
		override public function tryDisplayBuff(i:int):Boolean{
			
			return false;
		}

		override public function isIdle():Boolean{
			return false;
		}

		override public function newPlayer(_updateUI:Boolean){
			
		}
		
		override public function newFromCode(_code:int,_boss:Boolean=false){
			
		}
		
		override public function newMonster(_type:String){
			
		}
		
		override public function set inverted(b:Boolean){
			
		}
		
		override public function get inverted():Boolean{
			return false;
		}
		
		override public function displayBars(b:Boolean=true){
			
		}
		
		override public function updateWeapon(_weapon:ItemModel=null){
			
		}
		
		override public function updateHelmet(_helmet:ItemModel=null){			
			
		}
		
		override public function updateAura(_aura:int=-1){
			
		}
		
		override public function getBitmap():Bitmap{
			return new Bitmap
		}
		
		override public function sepia():BitmapData{
			return new BitmapData(0,0);
		}
		
		override public function buffEffect(s:String,b:Boolean){
			
		}
		
		override function weaponFilters(_v:MovieClip,_glowColor:uint=0x00ffff){
			
		}
		
		override function helmetFilters(_v:MovieClip){
			
		}
		
		override function eFilter(_a:Number,_b:Number,_c:Number):ColorMatrixFilter{
			return new ColorMatrixFilter();
		}
		
		override public function recolor(a:Array,_shadow:Boolean=false){
			
		}
		
		override function invertFilter(a:Array){
		}
		
		override public function makeSepia(_scale:Number=1){
			
		}
		
		override public function backTwo(){
			
		}
	}
}