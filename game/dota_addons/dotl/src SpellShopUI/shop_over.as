package  {
	
	import flash.display.MovieClip;
	
	public class shop_over extends MovieClip {
		
		var baseW:Number;
		var baseH:Number;
		var overW:Number;
		
		public function shop_over() {
			// constructor code
			baseH = this.height;
			baseW = this.width;
			overW = 305;
		}
		
		public function screenResize(_w:int, _h:int, xScale:Number, yScale:Number){
			this.width = this.baseW*yScale;
			this.height = this.baseH*yScale;
			this.x = 0;
			this.y = _h-this.overW*yScale;
			if( _w == 1280 ) {
				switch ( _h ) {
					case 1024:
						// this works
						this.y = this.y+15;
						break;
					case 768:
						// this works
						this.y = this.y-10;
						break;
					case 600:
						// this works
						this.y = this.y-33;
						break;
				}
			}
		}
	}
	
}
