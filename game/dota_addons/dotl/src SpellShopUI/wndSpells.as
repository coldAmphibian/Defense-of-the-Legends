package  {
	
	import flash.display.MovieClip;
	
	//sprite imports
	import flash.display.Sprite;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	
	//import pnt for anchor
	import flash.geom.Point;
	import ValveLib.Globals;
	
	// event import
	import ev_Invoke;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import infoTextField;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	
	
	public class wndSpells extends MovieClip {
		
		// dota2 objects
		var gameAPI:Object;
		var globals:Object;
		
		var _defaults:Object = new Object; // holding default spell info;
		var _spells:Object = new Object; //its holding our spells
		var _arr_key:Array = new Array; //its holding our keys for spells in a particular order "0000", "0001", "0002" etc
		var _info_key:Array = new Array; //its holding our keys for _texts, see above
		var _nm:int = 0; // the number of spells we have in the shop
		var _currentBuyIndex:int = 0; // our starting iterator for scroll function of the Buy tab
		var _currentSellIndex:int = 0; // our starting iterator for scroll function of the Sell tab
		var _max_row:int = 4; // maximum rows
		var _max_column:int = 5; // maximum columns
		var _size:int = 64; // spell icon size
		var _dist:int = 8; // distance between spell icons
		var _shopState:int = 0; // our shop tab state. 0 = buy, 1 = sell, 2 = info
		var _owned:int = 0; // number of spells the hero owns
		var _removal:Boolean = false; // discontinued, don't mess with this
		var _limit:int = 4; // limit of # of spells we can buy
		var _baseW:Number = 342; // hacky scaling variable
		var _baseH:Number = 391; // hacky scaling variable
		var _texts:Object = new Object; // its holding our texts for the info tab
		var _nm_texts:int = 0; // number of textfields we have
		var _curRes:int = 4; // the amount of skill points we have
		var _useRes:Boolean = true; // if we are using skill points
		var _curGold:Number = 500; // the amount of gold we have
		var _useGold:Boolean = true; // if we are using gold
		var _goldTimer:Timer = new Timer(500); // the timer that checks for the amount of gold we have every half a second
		var _canOpen:Boolean = true; // if we can open the shop
		var _opened:Boolean = false; // if the shop is opened
		var _showRes:Object; // holds our resource shown text
		
		// our anchor for spell placement
		var anchor:Point = new Point;
		
		public function wndSpells() {
			// the event listener for spellCLICK
			this.addEventListener(ev_Invoke.INVOKE, ev_invoke);
			
			// the event listeners for shop tabs
			this.btnBuy.addEventListener(MouseEvent.CLICK, buyTab);
			this.btnSell.addEventListener(MouseEvent.CLICK, sellTab);
			this.btnInfo.addEventListener(MouseEvent.CLICK, infoTab);
			
			// add the listener for shop scroll function, + the buttons (arrows on the side)
			this.addEventListener(MouseEvent.MOUSE_WHEEL, scrollWhl);
			this.scrlUp_hl.addEventListener(MouseEvent.CLICK, scrollUp);
			this.scrlDw_hl.addEventListener(MouseEvent.CLICK, scrollDw);
			
			anchor.x = 15;
			anchor.y = 25.5;
			
			scrlUp_hl.visible = false;
			scrlDw_hl.visible = false;
			
			resetState();
		}
		
		public function resetState(){
			_shopState = 0;
			changeBuyDisplay(0);
			changeTab( 3, 2, 1)
		}
		
		public function scrollUp( e:MouseEvent ) {
			if( _shopState == 0 && _currentBuyIndex > 0 ) changeBuyDisplay(-_max_row);
			if( _shopState == 1 && _currentSellIndex > 0 ) changeSellDisplay(-_max_row);
			if( _shopState == 2 && scrlUp_hl.visible == true ) changeInfoDisplay(20);
		}
		
		public function scrollDw( e:MouseEvent ) {
			if( _shopState == 0 &&  (_currentBuyIndex+(_max_row*_max_column))<_nm  ) changeBuyDisplay(_max_row);
			if( _shopState == 1 &&  (_currentSellIndex+(_max_row*_max_column))<_owned  ) changeSellDisplay(_max_row);
			if( _shopState == 2 && scrlDw_hl.visible == true ) changeInfoDisplay(-20);
		}
		
		public function scrollWhl( e:MouseEvent ) {
			if( e.delta < 0 ) {
				//trace("[MouseWheel] Scroll Down!");
				if( _shopState == 0 &&  (_currentBuyIndex+(_max_row*_max_column))<_nm  ) changeBuyDisplay(_max_row);
				if( _shopState == 1 &&  (_currentSellIndex+(_max_row*_max_column))<_owned  ) changeSellDisplay(_max_row);
				if( _shopState == 2 && scrlDw_hl.visible == true ) changeInfoDisplay(-20);
			} else {
				//trace("[MouseWheel] Scroll Up!");
				if( _shopState == 0 && _currentBuyIndex > 0 ) changeBuyDisplay(-_max_row);
				if( _shopState == 1 && _currentSellIndex > 0 ) changeSellDisplay(-_max_row)
				if( _shopState == 2 && scrlUp_hl.visible == true ) changeInfoDisplay(20);
			}
		}
		
		public function buyTab( e:MouseEvent ) {
			_shopState = 0;
			changeBuyDisplay(0);
			changeTab( 3, 2, 1);
		}
		
		public function sellTab( e:MouseEvent ) {
			_shopState = 1;
			changeSellDisplay(0);
			changeTab( 1, 3, 2);
		}
		
		public function infoTab( e:MouseEvent ) {
			changeTab( 1, 2, 3);
			_shopState = 2;
			changeInfoDisplay(0);
		}
		
		public function loadSpell( args:Object ) {
			var pID:int = this.globals.Players.GetLocalPlayer();
			
			if (args.player_ID == pID) {
				//trace( "_nm = " + _nm );
				//trace("[loadSpell] " + args._name + " using texture " + args._texture + " with ID: " + args._ID );
				_spells[args._ID] = new tmpTest;
				_spells[args._ID].setup_btn(args, this.gameAPI, this.globals, _size, _useRes, _useGold );
				_arr_key.push(args._ID);
				
				_shopState = 0;
				changeBuyDisplay(0);
				changeTab( 3, 2, 1)
				
				_nm++;
			}
		}
		
		public function changeTab( d1:int, d2:int, d3:int ) {
			if( d1 == 3 ) btnBuy.enabled = false; else btnBuy.enabled = true;
			if( d2 == 3 ) btnSell.enabled = false; else btnSell.enabled = true;
			if( d3 == 3 ) btnInfo.enabled = false; else btnInfo.enabled = true;
			this.setChildIndex(tabBuy, d1);
			this.setChildIndex(tabSell, d2);
			this.setChildIndex(tabInfo, d3);
		}
		
		// take care of dota2 api commands
		public function setup( api:Object, globals:Object, showRes:Object ) {
			this.gameAPI = api;
    		this.globals = globals;
			
			
			// subscribe to events we want to listen for
			this.gameAPI.SubscribeToGameEvent("spell_shop_ui_spell_add", this.loadSpell);
			this.gameAPI.SubscribeToGameEvent("spell_shop_ui_spell_buy", this.buySpell);
			this.gameAPI.SubscribeToGameEvent("spell_shop_ui_spell_sell", this.sellSpell);
			this.gameAPI.SubscribeToGameEvent("spell_shop_ui_spell_upgrade", this.upgradeSpell);
			this.gameAPI.SubscribeToGameEvent("spell_shop_ui_spell_change", this.changeSpell);
			this.gameAPI.SubscribeToGameEvent("spell_shop_ui_change_limit", this.changeSettings);
			this.gameAPI.SubscribeToGameEvent("spell_shop_ui_shop_open", this.openShop);
			this.gameAPI.SubscribeToGameEvent("spell_shop_ui_shop_close", this.closeShop);
			this.gameAPI.SubscribeToGameEvent("spell_shop_ui_shop_toggle", this.toggleState);
			this.gameAPI.SubscribeToGameEvent("spell_shop_ui_update_res", this.updateRes);
			
			//trace("[PrintTable] _settings");
			//load the settings from the KV
			var _settings = Globals.instance.GameInterface.LoadKVFile('scripts/spell_shop_ui/settings.txt');
			//set the settings
			shopInit( _settings );
			
			//load the info tab from the KV
			//trace("[PrintTable] _infoSettings");
			var _infoSettings = Globals.instance.GameInterface.LoadKVFile('scripts/spell_shop_ui/info_tab.txt');
			infoTabInit( _infoSettings );
			sortInfoTab( 1, _nm_texts );
			setInfoTab();
			textCont.visible = false;
			
			// load the spell defaults
			var _defaultSpellKV = Globals.instance.GameInterface.LoadKVFile('scripts/spell_shop_ui/spells_default.txt');
			loadDefaultsKV( _defaultSpellKV );
			
			//load the spells from the KV
			var _spellsKV = Globals.instance.GameInterface.LoadKVFile('scripts/spell_shop_ui/spells.txt');
			loadSpellsKV( _spellsKV );
			//if( _useRes ) sortSpellsKV( 0, _nm ); else sortSpellsKV( 1, _nm );
			_arr_key.sort();
			
			resetState();
			
			
			_goldTimer.addEventListener(TimerEvent.TIMER, this.updateGold);
			
			// not implemented
			if( !_useRes ) showRes.visible = false;
				else {
					showRes.border = true;
					showRes.borderColor = 0xFFFFFF;
					showRes.backgroundColor = 0x000000;
					_showRes = showRes;
			}
			
		}
		
		public function loadDefaultsKV( args:Object ) {
			_defaults._nameLUA = args._name;
			_defaults._texture = args._texture;
			_defaults._cost = args._cost;
			_defaults._sellFactor = args._sellFactor;
			_defaults._upgFactor = args._upgFactor;
			_defaults._curLvl = args._curLvl;
			_defaults._maxLvl = args._maxLvl;
			_defaults._pntCost = args._pntCost;
			_defaults._pntSellFac = args._pntSellFac;
			_defaults._pntIncrement = args._pntIncrement;
			_defaults._pntIncLvl = args._pntIncLvl;
				
			if( args._isSellable == "true" ) _defaults._isSellable = true; else _defaults._isSellable = false;
			if( args._isOwned == "true" ) _defaults._isOwned = true; else _defaults._isOwned = false;
			if( args._isUpg == "true" ) _defaults._isUpg = true; else _defaults._isUpg = false;

		}
		
		public function updateRes( args:Object ) {
			var pID:int = this.globals.Players.GetLocalPlayer();
			if( _useRes ) {
				if( pID == args.player_ID ) {
					_curRes = args._res;
				}
				_showRes.text = _curRes.toString();
				if( _shopState == 0 && _opened ) changeBuyDisplay(0);
				if( _shopState == 1 && _opened ) changeSellDisplay(0);
			}
		}
		
		public function openShop( args:Object ) {
			var pID:int = this.globals.Players.GetLocalPlayer();
			
			if( pID == args.player_ID || args.playerID == null ) {
				if( !_opened && _canOpen ) {
					_goldTimer.start();
					_opened = true;
					this.visible = true;
				}
			}
		}
		
		
		public function closeShop( args:Object ) {
			var pID:int = this.globals.Players.GetLocalPlayer();
			
			if( pID == args.player_ID || args.playerID == null ) {
				if( _opened ) {
					_goldTimer.stop();
					_opened = false;
					this.visible = false;
					this.globals.Loader_rad_mode_panel.gameAPI.OnHideAbilityTooltip();
				}
			}
		}
		
		public function toggleState( args:Object ) {
			var pID:int = this.globals.Players.GetLocalPlayer();
			
			if( pID == args.player_ID ) {
				if( _canOpen ) {
					_canOpen = false;
					if( _opened ) closeShop( args );
				} else {
					_canOpen = true;
				}
			}
		}
		
		public function changeSpell( args:Object ) {
			var pID:int = this.globals.Players.GetLocalPlayer();
			if( _spells[args._ID] != null && pID == args.player_ID ) {
				_spells[args._ID]._nameLUA = args._name;
				_spells[args._ID]._cost = args._cost;
				_spells[args._ID]._sellFactor = args._sellFactor;
				_spells[args._ID]._upgFactor = args._upgFactor;
				_spells[args._ID]._curLvl = args._curLvl;
				_spells[args._ID]._maxLvl = args._maxLvl;
				_spells[args._ID]._pntCost = args._pntCost;
				_spells[args._ID]._pntSellFac = args._pntSellFac;
				_spells[args._ID]._pntIncrement = args._pntIncrement;
				_spells[args._ID]._pntIncLvl = args._pntIncLvl;
				
				if( args._isSellable == "true" ) _spells[args._ID]._isSellable = true; else _spells[args._ID]._isSellable = false;
				if( args._isOwned == "true" ) _spells[args._ID]._isOwned = true; else _spells[args._ID]._isOwned = false;
				if( args._isUpg == "true" ) _spells[args._ID]._isUpg = true; else _spells[args._ID]._isUpg = false;
			}
		}
		
		public function updateGold( e:TimerEvent ) {
			var pID:int = this.globals.Players.GetLocalPlayer();
			var buffer:Number = this.globals.Players.GetGold(pID);
			if( _curGold != buffer ) {
				_curGold = buffer;
				if( _shopState == 0 && _opened ) changeBuyDisplay(0);
				if( _shopState == 1 && _opened ) changeSellDisplay(0);
			}
			
		}
		
		public function loadSpellsKV( args:Object ) {
			for(var key in args) {
                var v = args[key];
				
                if(typeof(v) == "object") {
					if( v._name == null ) v._name = _defaults._nameLUA;
					if( v._texture == null ) v._texture = v._name;
					if( v._cost == null ) v._cost = _defaults._cost;
					if( v._sellFactor == null ) v._sellFactor = _defaults._sellFactor;
					if( v._upgFactor == null ) v._upgFactor = _defaults._upgFactor;
					if( v._curLvl == null ) v._curLvl = _defaults._curLvl;
					if( v._maxLvl == null ) v._maxLvl = _defaults._maxLvl;
					if( v._pntCost == null ) v._pntCost = _defaults._pntCost;
					if( v._pntSellFac == null ) v._pntSellFac = _defaults._pntSellFac;
					if( v._pntIncrement == null ) v._pntIncrement = _defaults._pntIncrement;
					if( v._pntIncLvl == null ) v._pntIncLvl = _defaults._pntIncLvl;
					if( v._isOwned == null ) if( !_defaults._isOwned ) v._isOwned = "false"; else v._isOwned = "true";
					if( v._isSellable == null ) if( !_defaults._isSellable ) v._isSellable = "false"; else v._isSellable = "true";
					if( v._isUpg == null ) if( !_defaults._isUpg  ) v._isUpg = "false"; else v._isUpg = "true";
					
					
					v._ID = leadingZero(v._ID);
					_arr_key.push(v._ID);
					_spells[v._ID] = new tmpTest;
					//trace('[loadSpellsKV] ' + leadingZero(v._ID) + ' ' + v._texture);
					_spells[v._ID].setup_btn(v, this.gameAPI, this.globals, _size, _useRes, _useGold );
					if( _spells[v._ID]._isOwned ) _owned++;
					_nm++;
                }
            }
		}
		/*
		public function sortSpellsKV( index:int, max:int ) {
			for(var key in _spells) {
				//trace('[sortSpellsKV]' + key );
				//trace('_spells[key]._ID ' + _spells[key]._ID);
				if( _spells[key]._ID == leadingZero(index) ) {
					_arr_key.push(key);
					//trace('[sortSpellsKV]' + key );
					if( index+1 <= max ) sortSpellsKV( index+1, max );
					break;
				}
			}
		}*/
		
		function leadingZero(num : Number) : String {
   			if(num < 10) {
       			return "000" + num;
    		} else if( num < 100 ) {
				return "00" + num;
			} else if( num < 1000 ) {
				return "0" + num;
			}
    		return num.toString();
 		}
		
		public function infoTabInit( args:Object ) {
			for(var key in args) {
                var v = args[key];
				
                if(typeof(v) == "object") {
					_texts[key] = new infoTextField;
					_nm_texts++;
                    _texts[key]._pos = v._pos;
					_texts[key]._color = v._color;
					_texts[key]._fontSize = v._fontSize;
					_texts[key]._font = v._font;
					_texts[key]._bg = v._bg;
					_texts[key]._bgColor = v._bgColor;
					_texts[key]._align = v._align;
					_texts[key]._text = v._text;
                }
            }
		}
		
		public function sortInfoTab( index:int, max:int ) {
			for(var key in _texts) {
				if( _texts[key]._pos == index ) {
					_info_key.push(key);
					if( index+1 <= max ) sortInfoTab( index+1, max );
					break;
				}
			}
		}
		
		public function setInfoTab() {
			var _parent_y:Number = 0;
			var _parent_h:Number = 0;
			for each(var key in _info_key) {
				_texts[key].setup(textCont, _parent_y, _parent_h);
				textCont.addChild(_texts[key]);
				_texts[key].x = 0;
				if( _parent_h != 0 ) _parent_h += 10;
				_texts[key].y = _parent_y + _parent_h;
				_parent_y = _texts[key].y;
				_parent_h = _texts[key].height;
				//trace('[setInfoTab] ' + textCont.x + ';;' + _texts[key].x);
			}
		}
		
		public function shopInit( args:Object ) {
			_dist = args._dist;
			_limit = args._limit;
			_size = args._size;
			if( args._canOpen == "true" ) _canOpen = true; else _canOpen = false;
			if( args._useRes == "true" ) _useRes = true; else _useRes = false;
			if( args._useGold == "true" ) _useGold = true; else _useGold = false;
			
			// flipped because i'm retarded
			_max_column = args._max_row;
			_max_row = args._max_column;
		}
		
		public function changeSettings( args:Object ){
			var pID:int = this.globals.Players.GetLocalPlayer();
			if( args.player_ID == pID ) {
				_limit = args._limit;
				if( _shopState == 0 ) changeBuyDisplay(0);
				if( _shopState == 1 ) changeSellDisplay(0);
			}
		}
		
		// invoke LUA function, the event passes the evt._spell_ID and evt._owned ( representing spell and player possession status, respectively)
		public function ev_invoke(evt:ev_Invoke):void {
			//trace("event received, evt._spell_ID is: " + evt._spell_ID );
			if( !_useGold && evt._spell_ID!= "0000" ) {
				this._spells[evt._spell_ID].set_text(0);
			} else if( !_useRes ) {
				this._spells[evt._spell_ID].set_pnt(0);
			}
			// send server command with the spell name, spell ID and spell cost depending on OWNAGE
			if( evt._spell_ID == "0000" ) {
				if( _shopState == 0 ) this.gameAPI.SendServerCommand( "buySkillpoint " + _spells[evt._spell_ID]._txtCost.text );
				if( _shopState == 1 && _curRes > 0 ) this.gameAPI.SendServerCommand( "sellSkillpoint " + _spells[evt._spell_ID]._txtCost.text );
			} else if( !evt._owned ) this.gameAPI.SendServerCommand( "buySpell " + evt._spell_ID + " " + _spells[evt._spell_ID]._nameLUA + " " + _spells[evt._spell_ID]._txtCost.text + " " + _spells[evt._spell_ID]._txtPnt.text );
				else {
				if( _shopState == 0 ) this.gameAPI.SendServerCommand( "upgradeSpell " + evt._spell_ID + " " + _spells[evt._spell_ID]._nameLUA + " " + _spells[evt._spell_ID]._txtCost.text + " " + _spells[evt._spell_ID]._txtPnt.text );
				else this.gameAPI.SendServerCommand( "sellSpell " + evt._spell_ID + " " + _spells[evt._spell_ID]._nameLUA + " " + _spells[evt._spell_ID]._txtCost.text + " " + _spells[evt._spell_ID]._txtPnt.text );
			}
		}
		
		public function buySpell( args:Object ) {
			var pID:int = this.globals.Players.GetLocalPlayer();
			
			//trace("[buySpell] fired & received");
			
			if (args.player_ID == pID) {
        		if( args._success ) {
					_spells[args._ID]._isOwned = true;
					_spells[args._ID]._curLvl = 1;
					_owned++;
					changeBuyDisplay(0);
				}
			}
		}
		
		public function sellSpell( args:Object ) {
			var pID:int = this.globals.Players.GetLocalPlayer();
			
			//trace("[sellSpell] fired & received");
			
			if (args.player_ID == pID) {
        		if( args._success ) {
					_spells[args._ID]._isOwned = false;
					_spells[args._ID]._curLvl = 0;
					_owned--;
					changeSellDisplay(0);
					_spells[args._ID].set_visibility(true, false, false);
				}
			}
		}
		
		public function upgradeSpell( args:Object ) {
			var pID:int = this.globals.Players.GetLocalPlayer();
			
			//trace("[upgradeSpell] fired & received");
			
			if (args.player_ID == pID) {
        		if( args._success ) {
					_spells[args._ID]._curLvl++;
					changeBuyDisplay(0);
				}
			}
		}
		
		public function changeInfoDisplay( _mod:int ) {
			
			var checker:Boolean = false;
			var checkerUp:Boolean = false;
			
			for each(var key in _arr_key) {
				if( this._spells[key].parent == this ) {
					this._spells[key].set_visibility(true,false,false);
					this.removeChild(this._spells[key]);				
				}
			}
			
			for each(key in _info_key) {
				_texts[key].y += _mod;
				if( (_texts[key].y+_texts[key].height) > 340 ) checker = true;
				if( _texts[key].y<0 ) checkerUp = true;
				//trace('[changeInfoDisplay] ' + textCont.height + ';; ' + (_texts[key].y+_texts[key].height) + _texts[key].y);
			}
			
			textCont.visible = true;
			
			if( checkerUp ) { scrlUp_hl.visible = true; scrlUp_bw.visible = false; }
				else { scrlUp_hl.visible = false; scrlUp_bw.visible = true; }
			if( checker ) { scrlDw_hl.visible = true; scrlDw_bw.visible = false; }
				else { scrlDw_hl.visible = false; scrlDw_bw.visible = true; }
		}
		
		public function changeSellDisplay( _mod:int ) {
			textCont.visible = false;
			// our iterator
			var _index:int = 0;
			
			//our counter for owned spells
			var _counter:int = 0;
			
			_currentSellIndex += _mod;
			
			for each(var key in _arr_key) {
				if( _currentSellIndex <= _index && _counter < (_max_row*_max_column) ) {
					if( key == "0000" ) {
						if( this._spells[key].parent != this ) this.addChild(this._spells[key]);
						this._spells[key].set_text( (this._spells[key]._cost * this._spells[key]._sellFactor) );
						this._spells[key].x = this.anchor.x + ( ((_counter - _currentSellIndex) % _max_row ) * (_size+_dist) );
						this._spells[key].y = this.anchor.y + ( Math.floor((_counter - _currentSellIndex) / _max_row) * (_size+_dist) );
						if( _curRes > 0 ) this._spells[key].set_enabled(true, false); else { this._spells[key].set_enabled(false, false); this._spells[key].set_visibility(true, false, false); }
						_counter++;
					} else {
						if( this._spells[key].parent != this && this._spells[key]._isOwned ) {
							this.addChild(this._spells[key]);
						} else if( this._spells[key].parent == this && !this._spells[key]._isOwned ) this.removeChild(this._spells[key]);
						
						this._spells[key]._upgState.visible = false;
						if( _useGold ) this._spells[key].set_text( (this._spells[key]._cost * this._spells[key]._curLvl * this._spells[key]._sellFactor) );
						if( _useRes ) this._spells[key].set_pnt( calculatePointCost( key ) );
						this._spells[key].x = this.anchor.x + ( ((_counter - _currentSellIndex) % _max_row ) * (_size+_dist) );
						this._spells[key].y = this.anchor.y + ( Math.floor((_counter - _currentSellIndex) / _max_row) * (_size+_dist) );
						
						if( this._spells[key]._isOwned ) {
							_counter++;
							this._spells[key].show_owned( false );
						}
						if( !this._spells[key]._isSellable ) this._spells[key].set_enabled(false, false); else this._spells[key].set_enabled(true, false);
					}
				} else if( this._spells[key].parent == this ) { this._spells[key].set_visibility(true,false,false); this.removeChild(this._spells[key]); }
				_index++;
			}
			
			if( _currentSellIndex > 0 ) { scrlUp_hl.visible = true; scrlUp_bw.visible = false; }
				else { scrlUp_hl.visible = false; scrlUp_bw.visible = true; }
			if( _counter < _owned ) { scrlDw_hl.visible = true; scrlDw_bw.visible = false; }
				else { scrlDw_hl.visible = false; scrlDw_bw.visible = true; }
		}
		
		public function changeBuyDisplay( _mod:int ) {
			textCont.visible = false;
			// our iterator
			var _index:int = 0;
			
			// change the index of the top left spell
			_currentBuyIndex += _mod;
			
			for each(var key in _arr_key) {
				if( _currentBuyIndex <= _index && _index < ((_max_row*_max_column)+_currentBuyIndex) ) {
					// handle adding / removing considering the set parameters (_isOwned, _removal)
					if( key == "0000" ) {
						if( this._spells[key].parent != this ) this.addChild(this._spells[key]);
						this._spells[key].set_text(this._spells[key]._cost);
						if( _curGold >= this._spells[key]._txtCost.text ) this._spells[key].set_enabled(true, false);
							else { this._spells[key].set_enabled(false, false); this._spells[key].set_visibility(true, false, false); }
						this._spells[key].x = this.anchor.x + ( ((_index - _currentBuyIndex) % _max_row ) * (_size+_dist) );
						this._spells[key].y = this.anchor.y + ( Math.floor((_index - _currentBuyIndex) / _max_row) * (_size+_dist) );
					} else {
						if( this._spells[key].parent != this && !( this._spells[key]._isOwned && this._removal ) ) this.addChild(this._spells[key]);
						if( this._spells[key].parent == this && this._spells[key]._isOwned && this._removal ) this.removeChild(this._spells[key]);
					
						// if we're not removing the element, change it so it is shown as owned and cant be interacted with
						if( this._spells[key]._isOwned && !this._removal ) {
							if( this._spells[key]._isUpg ) {
								this._spells[key]._upgState.visible = true;
								if( _useGold ) this._spells[key].set_text( (this._spells[key]._cost * this._spells[key]._upgFactor) );
								if( _useRes ) this._spells[key].set_pnt( this._spells[key]._pntCost + Math.floor((this._spells[key]._curLvl)/this._spells[key]._pntIncLvl)*this._spells[key]._pntIncrement );
								if( _useGold && this._spells[key]._txtCost.text <= _curGold ) {
									if( (_useRes && this._spells[key]._txtPnt.text <= _curRes) || !_useRes ) this._spells[key].set_enabled(true, false);
										else this._spells[key].set_enabled(false, false);
								} else if( _useRes && this._spells[key]._txtPnt.text <= _curRes ) this._spells[key].set_enabled(true, false);
									else this._spells[key].set_enabled(false, false);
							} else {
								if( _useGold ) this._spells[key].set_text( this._spells[key]._cost );
								if( _useRes ) this._spells[key].set_pnt( this._spells[key]._pntCost );
								this._spells[key].show_owned(true);
								this._spells[key]._upgState.visible = false;
							}
							if( this._spells[key]._isUpg && this._spells[key]._curLvl >= this._spells[key]._maxLvl ) {
								this._spells[key].show_owned(true);
								this._spells[key]._upgState.visible = false;
							}
						} else {
							if( _useGold ) this._spells[key].set_text( this._spells[key]._cost );
							if( _useRes ) this._spells[key].set_pnt( this._spells[key]._pntCost );
							this._spells[key].show_owned(false);
							this._spells[key]._upgState.visible = false;
						}
										
						// disable the buttons if we're at our ability # limit
						if( (_owned >= _limit && !this._spells[key]._isOwned) || ( _useGold && this._spells[key]._txtCost.text > _curGold ) || ( _useRes && this._spells[key]._txtPnt.text > _curRes) ) this._spells[key].set_enabled(false, false);
							else if( !this._spells[key]._isOwned &&	this._spells[key]._curLvl <= this._spells[key]._maxLvl )this._spells[key].set_enabled(true, false);
					
						//trace('[spellLEVEL] ' + _spells[key]._nameLUA + ' '+ _spells[key]._curLvl);
					
						// positioning
						this._spells[key].x = this.anchor.x + ( ((_index - _currentBuyIndex) % _max_row ) * (_size+_dist) );
						this._spells[key].y = this.anchor.y + ( Math.floor((_index - _currentBuyIndex) / _max_row) * (_size+_dist) );
					
						// remove the excess spells and correct visibility so the hover state 
						// doesnt stick when you scroll while hovering over the top/bottom spell
					}
				} else if( this._spells[key].parent == this ) { this._spells[key].set_visibility(true,false,false); this.removeChild(this._spells[key]); }
				_index++;
			}
			
			
			// set the scrolling bar states
			if( _currentBuyIndex > 0 ) { scrlUp_hl.visible = true; scrlUp_bw.visible = false; }
				else { scrlUp_hl.visible = false; scrlUp_bw.visible = true; }
			if( _currentBuyIndex+(_max_row*_max_column) < _nm ) { scrlDw_hl.visible = true; scrlDw_bw.visible = false; }
				else { scrlDw_hl.visible = false; scrlDw_bw.visible = true; }
		}
		
		public function calculatePointCost( _ID:String ):int {
			var total:int = 0;
			var cur:int = _spells[_ID]._pntCost;
			for (var i:int = 1; i < _spells[_ID]._curLvl+1; i++) {
    			if( (i-1) % _spells[_ID]._pntIncLvl == 0 && i>1 ) {
					cur += _spells[_ID]._pntIncrement;
					//trace(cur);
				}
				total += cur;
			}
			
			total = Math.floor(total * _spells[_ID]._pntSellFac);
			if( total == 0 ) total = 1;
			
			return total;
		}
		
		//resize the module
		public function screenResize(_w:int, _h:int, xScale:Number, yScale:Number, anch:Object){
			this.scaleX = yScale;//this._baseW*yScale;
			this.scaleY = yScale;//this._baseH*yScale;
			this.x = 0;
			this.y = anch.y - (this._baseH*yScale);
			//trace('[POSITIONING] ' + anch.y);
			//trace('[POSITIONING] ' + this.y);
			//trace('[POSITIONING] ' + (this._baseH*yScale));
		}
	}
	
}
