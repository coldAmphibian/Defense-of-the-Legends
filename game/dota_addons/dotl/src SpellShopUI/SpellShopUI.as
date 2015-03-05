package {
	import flash.display.MovieClip;
	//sprite imports
	import flash.display.Sprite;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.SimpleButton;
	import btnTemp;
	import tmpTest;


	//import some stuff from the valve lib
	import ValveLib.Globals;
	import ValveLib.ResizeManager;
	import flash.sampler.NewObjectSample;
	
	public class SpellShopUI extends MovieClip{
		
		//these three variables are required by the engine
		public var gameAPI:Object;
		public var globals:Object;
		public var elementName:String;
		
		public var curWs:int = 3;
				
		//constructor, you usually will use onLoaded() instead
		public function SpellShopUI() : void {
		}
		
		//this function is called when the UI is loaded
		public function onLoaded() : void {			
			//make this UI visible
			visible = true;
			
			//let the client rescale the UI
			Globals.instance.resizeManager.AddListener(this);
			
			//trace("Test");
			
			//pass the gameAPI on to the modules
			this.lbTest.setup(this.gameAPI, this.globals);
			this.lbTest.wndSpl.setup(this.gameAPI, this.globals, this.lbTest.shpOver.txtRes);
			
		}
		
		//calculate the scaling ratio in the X and Y direction and apply it to the state
		public function onResize(re:ResizeManager) : * {
			//pass the resize event to our module, we pass the width and height of the screen, as well as the INVERSE of the stage scaling ratios.
			var scaleRatioX:Number = re.ScreenWidth/1600;
    		var scaleRatioY:Number = re.ScreenHeight/900;
			
			this.lbTest.shpOver.screenResize(re.ScreenWidth, re.ScreenHeight, scaleRatioX, scaleRatioY);
			this.lbTest.wndSpl.screenResize(re.ScreenWidth, re.ScreenHeight, scaleRatioX, scaleRatioY, this.lbTest.shpOver);
		}
	}
}