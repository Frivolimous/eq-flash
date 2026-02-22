package artifacts{	
	
	public class ArtifactView extends DefaultIcon{
		public var model:ArtifactModel;
		public var location:ArtifactInventoryBase;
		var shortDesc:Boolean=false;
		
		public function ArtifactView(_model:ArtifactModel){
			index=-1;
			mouseChildren=false;
			name=MouseControl.ARTIFACT;
			buttonMode=true;
			
			vectorIcon=new ArtifactIcons;
			
			finishView(_model);
		}
		
		function finishView(_model:ArtifactModel){
			model=_model;
			model.view=this;
			
			vectorIcon.gotoAndStop(_model.index+1);
			makeBitmap(vectorIcon,3.2,2.8,40);
			//vectorIcon.label.text=String(_model.index);
		}
		
		public function update(_model:ArtifactModel){
			model.view=null;
			_Desc=null;
			
			finishView(_model);
		}
		
		override public function get tooltipName():String{
			return model.name;
		}
				
		override public function get tooltipDesc():String{
			if (_Desc==null){
				_Desc=StringData.getArtifactDesc(model,shortDesc);
			}
			return _Desc;
		}
		
		override public function dispose(){
			if (parent!=null){
				parent.removeChild(this);
			}
		}
	}
}