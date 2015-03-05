package  {
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	import ValveLib.Events.ShopEvent;
	
	
	public class lbRes extends MovieClip {
		
		//hold the gameAPI
    	var gameAPI:Object;
		var globals:Object;
    
		public function lbRes() {
			this.shpOver.btnSpl.addEventListener(MouseEvent.CLICK, btnSplClick);
			this.wndSpl.visible = false;
    	}
    	
		// sets the shop visible / invisible
		public function btnSplClick(e:MouseEvent) {
			if( this.wndSpl.visible == false ) {
				this.wndSpl.openShop(new Object);
			} else {
				this.wndSpl.closeShop(new Object);
			}
		}
		
    	//set initialise this instance's gameAPI
    	public function setup(api:Object, globals:Object) {
        	this.gameAPI = api;
    		this.globals = globals;
    	}
		
		public function screenResize(stageW:int, stageH:int, xScale:Number, yScale:Number){
    		//we set the position of this movieclip to the center of the stage
    		//remember, the black cross in the center is our center. You control the alignment with this code, you can align it however you like.
    		//this.x = stageW/2;
    		//this.y = stageH/2;
    		//A small example of aligning to the right bottom corner would be:
    		/* this.x = StageW - this.width/2;
     		* this.y = StageH - this.height/2; */
			//this.shpOver.y = this.shpOver.y * yScale;
     		
     		//Now we just set the scale of this element, because these parameters are already the inverse ratios
    		//this.scaleX = xScale;
    		//this.scaleY = yScale;
		}
    }
}
