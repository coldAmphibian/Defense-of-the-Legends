package  {
	
	//import the events
	import flash.events.MouseEvent;
	import flash.events.EventDispatcher;
	import flash.events.Event;
		
	
	//import display thingies so we can customize our button
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.SimpleButton;
	import flash.text.TextField;
	import flash.display.Graphics;
	
	//import the custom event class
	import ev_Invoke;
	
	import flash.geom.Point;
	import flash.text.TextFormat;
	import flash.display.Shape;
	import flash.text.AntiAliasType;
	
	
	public class tmpTest extends MovieClip {
		var _ID:String;
		var _nameLUA:String;
		var _texture:String;
		var _upState:Sprite = new Sprite;
		var _overState:Sprite = new Sprite;
		var _downState:Sprite = new Sprite;
		var _disabledState:Sprite = new Sprite;
		var _ownedState:Sprite = new Sprite;
		var _upgState:Sprite = new Sprite;
		var _isOwned:Boolean = false;
		var _isSellable:Boolean = true;
		var _isEnabled:Boolean = true;
		var _cost:int;
		var _size:Number;
		var _txtCost:TextField;
		var _txtPnt:TextField;
		var _sellFactor:Number;
		var _upgFactor:Number;
		var _curLvl:int;
		var _maxLvl:int;
		var _isUpg:Boolean;
		var _pntCost:int;
		var _pntSellFac:Number;
		var _pntIncrement:int;
		var _pntIncLvl:int;
		var _useRes:Boolean;
		var _useGold:Boolean;
		
		
		//hold the gameAPI
    	var gameAPI:Object;
		var globals:Object;
		
		public function tmpTest() {
		}
		
		public function remListeners() {
			this.removeEventListener(MouseEvent.CLICK, onBtnClick); 
			this.removeEventListener(MouseEvent.MOUSE_DOWN, mouse_down);
			this.removeEventListener(MouseEvent.MOUSE_UP, mouse_up);
		}
		
		public function addListeners() {
			this.addEventListener(MouseEvent.CLICK, onBtnClick); 
			this.addEventListener(MouseEvent.MOUSE_DOWN, mouse_down);
			this.addEventListener(MouseEvent.MOUSE_UP, mouse_up);
		}
		
		public function show_owned ( arg:Boolean ) {
			if( arg ) {
				_ownedState.visible = true;
				set_enabled(false, true);
			} else {
				_ownedState.visible = false;
				set_enabled(true, true);
			}
		}
		
		public function set_enabled( arg:Boolean, arg2:Boolean ) {
			if( arg ) {
				_isEnabled = true;
				_disabledState.visible = false;
				addListeners();
			} else {
				_isEnabled = false;
				// if we're calling from show_owned, dont change the _disabledState
				if( !arg2 ) _disabledState.visible = true;
				remListeners();
			}
		}
		
		public function mouse_out( e:MouseEvent ) {
			//trace("mouse out");
			if( _isEnabled ) set_visibility(true, false, false);
			this.globals.Loader_rad_mode_panel.gameAPI.OnHideAbilityTooltip();
		}
		
		public function mouse_over( e:MouseEvent ) {
			//trace("mouse over");
			if( _isEnabled ) {
				//change visibility of the ability button
				set_visibility(false, true, false);
			}
			//trace('[mouse_over] ' + this._nameLUA);
			//set the object
			var ob:Object = e.target;
            // set the point because fuck
        	var lp:Point = ob.localToGlobal(new Point(0, 0));
			this.globals.Loader_rad_mode_panel.gameAPI.OnShowAbilityTooltip(lp.x+_size, lp.y+(_size/5), ob._nameLUA);
		}
		
		public function mouse_down( e:MouseEvent ) {
			//trace("mouse down");
			if( _isEnabled ) set_visibility(false, false, true);
		}
		
		public function mouse_up( e:MouseEvent ) {
			//trace("mouse up");
			if( _isEnabled ) set_visibility(false, true, false);
		}
		
		
		// sets different visibilities for different states (hover, click, default..)
		public function set_visibility(v1:Boolean, v2:Boolean, v3:Boolean) {
			_upState.visible = v1;
			_overState.visible = v2;
			_downState.visible = v3;
		}
		
		public function set_text( amount : Number) {
			var txFormat:TextFormat = new TextFormat();
			amount = Math.floor(amount);
			
			txFormat.color = 0xFFFFFF;
			txFormat.size = this._size/4;
			txFormat.font = "$TextFont";
			txFormat.align = "center";
			txFormat.rightMargin = 2;
			
			_txtCost.multiline = false;
			_txtCost.wordWrap = false;
			_txtCost.background = false;
			_txtCost.autoSize = "left";
			_txtPnt.antiAliasType = AntiAliasType.ADVANCED;
			//_txtCost.border = true;
			//_txtCost.borderColor = 0xFFFFFF;
			_txtCost.background = true;
			_txtCost.backgroundColor = 0x000000;
			
			_txtCost.text = amount.toString();
			
			_txtCost.setTextFormat(txFormat);
			_txtCost.selectable = false;
			
			_txtCost.x = _size-_txtCost.width;
			_txtCost.y = _size-_txtCost.height;
		}
		
		public function set_pnt( amount : Number) {
			var txFormat:TextFormat = new TextFormat();
			amount = Math.floor(amount);
			
			txFormat.color = 0xFFFFFF;
			txFormat.size = this._size/4;
			txFormat.font = "$TextFont";
			txFormat.align = "center";
			txFormat.leftMargin = 2;
			
			_txtPnt.multiline = false;
			_txtPnt.wordWrap = false;
			_txtPnt.background = false;
			_txtPnt.autoSize = "left";
			_txtPnt.antiAliasType = AntiAliasType.ADVANCED;
			//_txtPnt.border = true;
			//_txtPnt.borderColor = 0xFFFFFF;
			_txtPnt.background = true;
			_txtPnt.backgroundColor = 0x000000;
			_txtPnt.text = amount.toString();
			
			_txtPnt.setTextFormat(txFormat);
			_txtPnt.selectable = false;
			
			_txtPnt.x = 0;
			_txtPnt.y = _size-_txtPnt.height;
		}
		
		public function setup_btn(args:Object, api:Object, globals:Object, size:int, useRes:Boolean, useGold:Boolean ) {
				this.gameAPI = api;
    			this.globals = globals;
				this._useRes = useRes;
				this._useGold = useGold;
				
				// set up base spell info
				this._ID = args._ID;
				this._nameLUA = args._name;
				this._texture = args._texture;
				this._size = size;
				if( args._isSellable == "true" ) this._isSellable = true; else this._isSellable = false;
				if( args._isOwned == "true" ) this._isOwned = true; else this._isOwned = false;
				this._cost = args._cost;
				this._sellFactor = args._sellFactor;
				this._upgFactor = args._upgFactor;
				this._curLvl = args._curLvl;
				this._maxLvl = args._maxLvl;
				if( args._isUpg == "true" ) this._isUpg = true; else this._isUpg = false;
				this._pntCost = args._pntCost;
				this._pntSellFac = args._pntSellFac;
				this._pntIncrement = args._pntIncrement;
				this._pntIncLvl = args._pntIncLvl;
			
				// set the clip to act as a button, also set the children not to interact with the mouse as it screws the click
				this.buttonMode = true;
				this.mouseChildren = false;
				
				//set our icon used passed to us by LUA
				//var texture_icon:Class = getDefinitionByName(this._texture) as Class;
				
				
				//set the bitmaps for different states.. there's probably a better way to do this
				var bmpBuffUp:MovieClip = new MovieClip;
				var bmpBuffOver:MovieClip = new MovieClip;
				var bmpBuffDown:MovieClip = new MovieClip;
				var bmpBuffDisabled:MovieClip = new MovieClip;
				var bmpBuffOwned:MovieClip = new MovieClip;
				var bmpBuffUpg:MovieClip = new MovieClip;
				
				// load the images
				this.globals.LoadImage("images/spellicons/" + this._texture + ".png", bmpBuffUp, false);
				this.globals.LoadImage("images/spellicons/" + this._texture + ".png", bmpBuffOver, false);
				this.globals.LoadImage("images/spellicons/" + this._texture + ".png", bmpBuffDown, false);
				this.globals.LoadImage("images/spellicons/" + this._texture + ".png", bmpBuffDisabled, false);
				this.globals.LoadImage("images/spellicons/" + this._texture + ".png", bmpBuffOwned, false);
				this.globals.LoadImage("images/spellicons/" + this._texture + ".png", bmpBuffUpg, false);
				//trace("[LoadAbilityImage] "+this._texture + " visibility:" + bmpBuffUp.visible);
				//trace("[LoadAbilityImage] "+this._texture + " height:" + bmpBuffUp.height);
				//trace("[LoadAbilityImage] "+this._texture + " width:" + bmpBuffUp.width);
				
				//set the bitmap widths.. gonna make this scaleable later
				/*bmpBuffUp.width = bmpBuffUp.height = _size;
				bmpBuffOver.width = bmpBuffOver.height = _size;
				bmpBuffDown.width = bmpBuffDown.height = _size;
				bmpBuffDisabled.width = bmpBuffDisabled.height = _size;
				bmpBuffOwned.width = bmpBuffOwned.height = _size;*/
				
				//prepare the states
				_upState.addChild(bmpBuffUp);
				_upState.addChild(new btnTemp_up);
				_overState.addChild(bmpBuffOver);
				_overState.addChild(new btnTemp_over);
				_downState.addChild(bmpBuffDown);
				_downState.addChild(new btnTemp_down);
				_disabledState.addChild(bmpBuffDisabled);
				_disabledState.addChild(new btnTemp_disabled);
				_ownedState.addChild(bmpBuffOwned);
				_ownedState.addChild(new btnTemp_owned);
				//_upgState.addChild(bmpBuffUpg);
				_upgState.addChild(new btnTemp_upg);
				
				_upState.width = _upState.height = _size;
				_overState.width = _overState.height = _size;
				_downState.width = _downState.height = _size;
				_disabledState.width = _disabledState.height = _size;
				_ownedState.width = _ownedState.height = _size;
				_upgState.width = _upgState.height = _size;
				
				_ownedState.visible = false;
				_upgState.visible = false;
				
				// --------------------------------------
				// set the textfield for showing goldcost
				// --------------------------------------
				_txtCost = new TextField;
				var txFormat:TextFormat = new TextFormat();
			
				txFormat.color = 0xFFFFFF;
				txFormat.size = this._size/4;
				txFormat.font = "$TextFont";
				txFormat.align = "center";
				txFormat.rightMargin = 2;
				
				_txtCost.multiline = false;
				_txtCost.wordWrap = false;
				_txtCost.background = false;
				_txtCost.autoSize = "left";
				_txtCost.antiAliasType = AntiAliasType.ADVANCED;
				//_txtCost.border = true;
				//_txtCost.borderColor = 0xFFFFFF;
				_txtCost.background = true;
				_txtCost.backgroundColor = 0x000000;
				_txtCost.text = this._cost.toString();
				
				_txtCost.setTextFormat(txFormat);
				_txtCost.selectable = false;
				//_txtCost.alpha = 1;
				
				/*var txtShape:Shape = new Shape;
				txtShape.graphics.beginFill(0xFFCC00, 0.6);
				txtShape.graphics.drawRect(0,0,_txtCost.textWidth,_txtCost.textHeight);
				txtShape.graphics.endFill();*/
				
				// -------------------------------------
				// set the textfield for showing pntcost
				// -------------------------------------
				_txtPnt = new TextField;
				var txPntFormat:TextFormat = new TextFormat();
			
				txPntFormat.color = 0xFFFFFF;
				txPntFormat.size = this._size/4;
				txPntFormat.font = "$TextFont";
				txPntFormat.align = "center";
				txPntFormat.leftMargin = 2;
				
				_txtPnt.multiline = false;
				_txtPnt.wordWrap = false;
				_txtPnt.background = false;
				_txtPnt.autoSize = "left";
				_txtPnt.antiAliasType = AntiAliasType.ADVANCED;
				//_txtPnt.border = true;
				//_txtPnt.borderColor = 0xFFFFFF;
				_txtPnt.background = true;
				_txtPnt.backgroundColor = 0x000000;
				_txtPnt.text = this._pntCost.toString();
				
				_txtPnt.setTextFormat(txPntFormat);
				_txtPnt.selectable = false;
				//_txtPnt.alpha = 1;
				
				/*var pntShape:Shape = new Shape;
				pntShape.graphics.beginFill(0xFFCC00, 0.6);
				pntShape.graphics.drawRect(0,0,_txtPnt.textWidth,_txtPnt.textHeight);
				pntShape.graphics.endFill();*/
				
				
				//add the states to the button
				this.addChild(this._upState);
				this.addChild(this._overState);
				this.addChild(this._downState);
				this.addChild(this._disabledState);
				this.addChild(this._ownedState);
				this.addChild(this._upgState);
				//this.addChild(txtShape);
				this.addChild(_txtCost);
				//this.addChild(pntShape);
				this.addChild(_txtPnt);
				
				_txtCost.x = _size-_txtCost.width;
				_txtCost.y = _size-_txtCost.height;
				//txtShape.x = _txtCost.x;
				//txtShape.y = _txtCost.y;
				
				_txtPnt.x = 0;
				_txtPnt.y = _size-_txtPnt.height;
				//pntShape.x = _txtPnt.x;
				//pntShape.y = _txtPnt.y;
				
				if( this._ID == "0000" || !_useRes ) {
					_txtPnt.visible = false;
					//pntShape.visible = false;
				}
				if( this._ID != "0000" && !_useGold ) {
					_txtCost.visible = false;
				}
				
				//move the downstate a bit so it looks pressed
				this._downState.x+=1;
				this._downState.y+=1;
				bmpBuffDown.x+=1;
				bmpBuffDown.y+=1;
				
				// at last, set the visibility to the default state
				set_visibility(true, false, false);
				
				this.addEventListener(MouseEvent.ROLL_OVER, mouse_over);
				this.addEventListener(MouseEvent.ROLL_OUT, mouse_out);
		}
		
		public function onBtnClick( e:MouseEvent ) {
			if( _isEnabled ) {
				// initialize custom event
				var evt:ev_Invoke = new ev_Invoke(ev_Invoke.INVOKE);
			
				// add the spell ID to the event so it gets passed
				evt._spell_ID = this._ID;
			
				// check if it is owned
				if( _isOwned ) evt._owned = true; else evt._owned = false;
			
				// hide the tooltip
				this.globals.Loader_rad_mode_panel.gameAPI.OnHideAbilityTooltip();
				
				set_visibility(true,false,false);
				
				// send the event that the parent class is listening to
				dispatchEvent(evt);
			}
		}
	}
	
}
