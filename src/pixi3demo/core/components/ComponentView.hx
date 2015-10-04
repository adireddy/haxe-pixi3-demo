package pixi3demo.core.components;

import pixi3demo.view.View;
import pixi3demo.core.utils.StageProperties;
import pixi3demo.core.loader.AssetLoader;
import pixi.core.display.Container;

@SuppressWarnings("checkstyle:Dynamic")
@:keepSub class ComponentView {

	@inject public var loader:AssetLoader;
	@inject public var stageProperties:StageProperties;

	var _container:Container;

	public var componentName:String;

	public var view(default, null):View;

	public var index(default, default):Int;

	public function new(viewIn:View, viewName:String) {
		view = viewIn;

		_container = new Container();
		_container.name = viewName + "Container";

		componentName = viewName.substring(0, viewName.indexOf("View")).toLowerCase();

		if (Pixi3Demo.resize != null) Pixi3Demo.resize.add(resize);
		if (Pixi3Demo.update != null) Pixi3Demo.update.add(update);
	}

	public inline function show() {
		_container.visible = true;
	}

	public inline function hide() {
		_container.visible = false;
	}

	public function init() {
		view.stage.addChild(_container);
	}

	public function resize() {}

	public function destroy() {
		_container.destroy(true);
		view.stage.removeChild(_container);
		_container = null;
	}

	public function update(t:Float) {}

	public function applyIndex() {
		if (index != null && index <= view.stage.children.length - 1) view.stage.setChildIndex(_container, index);
		else {
			index = view.stage.children.length - 1;
			view.stage.setChildIndex(_container, index);
		}
	}
}