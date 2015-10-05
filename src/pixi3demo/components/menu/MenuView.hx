package pixi3demo.components.menu;

import pixi3demo.core.buttons.TextButton;
import pixi.core.math.shapes.Rectangle;
import pixi.core.graphics.Graphics;
import pixi.core.display.Container;
import pixi3demo.core.components.ComponentView;
import motion.Actuate;

class MenuView extends ComponentView {

	public static inline var STATE_SHOW:String = "STATE_SHOW";
	public static inline var STATE_HIDE:String = "STATE_HIDE";

	var _menuContainer:Container;
	var _state:String;
	var _menu:Menu;
	var _openButton:Graphics;

	var _menuItems:Array<String>;

	public function setup() {
		_menuContainer = new Container();

		_state = MenuView.STATE_HIDE;

		_setupOpenButton();
		_menu = new Menu(stageProperties, loader);
		_menu.x = -202;
		_menuContainer.addChild(_menu);

		_container.addChild(_menuContainer);

		_menuItems = ["Retina", "Bunnymark", "Sprites", "Sprite Sheets", "Typekit", "Audio", "Skeleton Animation", "Video"];

		var menuItem:TextButton;
		for (i in 0 ... _menuItems.length) {
			menuItem = _menu.addItem(_menuItems[i]);
			//menuItem.clicked.add();
		}
	}

	function _setupOpenButton() {
		_openButton = new Graphics();
		_openButton.beginFill(0xFFFFFF);
		_openButton.drawRect(1, 1, 15, 60);
		_openButton.endFill();
		_openButton.interactive = true;
		_openButton.tap = _toggleShow;
		_openButton.click = _toggleShow;
		_menuContainer.addChild(_openButton);
	}

	function _toggleShow(data) {
		if (_state == MenuView.STATE_SHOW) hideMenu();
		else showMenu();
	}

	public function showMenu() {
		_state = MenuView.STATE_SHOW;
		Actuate.tween(_menuContainer, 0.3, { x: 204 }).onComplete(_enableMenuItems);
	}

	public function hideMenu() {
		_state = MenuView.STATE_HIDE;
		Actuate.tween(_menuContainer, 0.3, { x: 0 }).onComplete(_disableMenuItems);
	}

	function _enableMenuItems() {
		_menu.enableMenuItems();
	}

	function _disableMenuItems() {
		_menu.disableMenuItems();
	}
}