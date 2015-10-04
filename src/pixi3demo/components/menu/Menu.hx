package pixi3demo.components.menu;

import pixi3demo.core.buttons.TextButton;
import pixi3demo.core.loader.AssetLoader;
import pixi.interaction.EventTarget;
import pixi3demo.core.utils.StageProperties;
import pixi.core.display.Container;
import haxe.Timer;

class Menu extends Container {

	var _menuItems:Array<TextButton>;
	var _lastPosition:Float;
	var _dragging:Bool;
	var _height:Float;

	var _stageProperties:StageProperties;
	var _loader:AssetLoader;

	public function new(stageProperties:StageProperties, loader:AssetLoader) {
		super();

		_stageProperties = stageProperties;
		_loader = loader;

		_menuItems = [];
		interactive = true;
	}

	public function addItem(label:String, ?data:Dynamic):TextButton {
		var menuItem:TextButton = new TextButton([_loader.getTexture(AssetsList.COMMON_BUTTON)]);
		menuItem.text = label;
		menuItem.y = 50 * _menuItems.length;
		addChild(menuItem);
		_menuItems.push(menuItem);
		_height = 50 * _menuItems.length;

		if (_height > _stageProperties.screenHeight) {
			on("touchstart", _onTouchStart);
			on("touchend", _onTouchEnd);

			on("mousedown", _onMouseDown);
			on("mouseup", _onMouseUp);
		}
		return menuItem;
	}

	function _onTouchStart(evt:EventTarget) {
		_lastPosition = evt.data.getLocalPosition(parent).y;
		on("touchmove", _onTouchMove);
	}

	function _onTouchMove(evt:EventTarget) {
		var point = evt.data.getLocalPosition(parent);
		var distance = this._lastPosition - point.y;

		if (_dragging || (distance < -5 || distance > 5)) {
			disableMenuItems();
			_move(_lastPosition - point.y);
			_dragging = true;
			_lastPosition = point.y;
		}
	}

	function _onTouchEnd(evt:EventTarget) {
		off("touchmove", _onTouchMove);
		_dragging = false;
		Timer.delay(enableMenuItems, 100);
	}

	function _onMouseDown(evt:EventTarget) {
		_lastPosition = evt.data.getLocalPosition(parent).y;
		on("mousemove", _onMouseMove);
	}

	function _onMouseUp(evt:EventTarget) {
		off("mousemove", _onMouseMove);
		_dragging = false;
		enableMenuItems();
	}

	function _onMouseMove(evt:EventTarget) {
		var point = evt.data.getLocalPosition(parent);
		var distance = _lastPosition - point.y;

		if (_dragging || (distance < -5 || distance > 5)) {
			disableMenuItems();
			_move(_lastPosition - point.y);
			_dragging = true;
			_lastPosition = point.y;
		}
	}

	public function disableMenuItems() {
		for (i in 0 ... _menuItems.length) _menuItems[i].disable();
	}

	public function enableMenuItems() {
		for (i in 0 ... _menuItems.length) _menuItems[i].enable();
	}

	function _move(distance:Float) {
		y -= distance;

		if (y > 0) y = 0;
		else if (y < -(_height - _stageProperties.screenHeight)) {
			y = -(_height - _stageProperties.screenHeight);
		}

		x = Math.round(x);
		y = Math.round(y);
	}

	public function getItems():Array<TextButton> {
		return _menuItems;
	}
}