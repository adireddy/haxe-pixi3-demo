class Console {

	public static function log(msg:Dynamic) {
		#if debug untyped __js__("console").log(msg); #end
	}

	public static function info(msg:Dynamic) {
		#if debug untyped __js__("console").info(msg); #end
	}

	public static function warn(msg:Dynamic) {
		#if debug untyped __js__("console").warn(msg); #end
	}

	public static function error(msg:Dynamic) {
		#if debug untyped __js__("console").error(msg); #end
	}
}