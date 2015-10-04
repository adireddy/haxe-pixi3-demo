package pixi3demo.model;

import msignal.Signal.Signal0;
import msignal.Signal.Signal1;

class Model {

	public var addAssets:Signal0;
	public var updateFps:Signal1<Int>;

	public var preloaderReady(default, set):Bool;
	public var fps(default, set):Int;

	public function new() {
		addAssets = new Signal0();
		updateFps = new Signal1(Int);
	}

	public function init() {}

	public function reset() {}

	function set_preloaderReady(val:Bool):Bool {
		if (val) addAssets.dispatch();
		return preloaderReady = val;
	}

	function set_fps(val:Int):Int {
		updateFps.dispatch(val);
		return fps = val;
	}
}