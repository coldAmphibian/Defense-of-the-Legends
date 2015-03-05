package  {
	import flash.text.TextField;
	import flash.text.Font;
	import flash.text.TextFormat;
	
	public class infoTextField extends TextField {
		
		var _pos:int;
		
		var _color:uint;
		var _fontSize:int;
		var _font:String;
		var _bg:String;
		var _bgColor:uint;
		var _text:String;
		var _align:String;
		
		var _parent_y:Number;
		var _parent_h:Number;
		
		public function infoTextField() {
		}
		
		public function setup( obj:Object, nm:Number, nm2:Number ) {
			var txFormat:TextFormat = new TextFormat();
			
			txFormat.color = _color;
			txFormat.size = _fontSize;
			txFormat.font = _font;
			txFormat.align = _align;
			
			this.autoSize = "left";
			this.width = 270;
			this.multiline = true;
			this.wordWrap = true;
			this.text = "";
			splitter( _text );
			if( _bg == "false" ) this.background = false; else this.background = true;
			this.backgroundColor = _bgColor;
			
			this.selectable = false;
			
			this.setTextFormat(txFormat);
			
			this._parent_y = nm;
			this._parent_h = nm2;
		}
		
		public function splitter( s:String ) {
			var buffArr:Array = s.split("\\n");
			for (var i = 0; i<buffArr.length; i++) {
				if( i == 0 ) this.text = buffArr[i]; else this.text = this.text+"\n"+buffArr[i];
			}
		}

	}
	
}