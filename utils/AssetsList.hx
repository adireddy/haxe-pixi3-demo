class AssetsList {

	static var LIST:Array<String> = ["resources/.DS_Store",
			"resources/@1x/common/button.png",
			"resources/@1x/preloader/logo.png",
			""];

	public static inline var COMMON_BUTTON_PNG:String = "common/button.png";
	public static inline var PRELOADER_LOGO_PNG:String = "preloader/logo.png";
	public static inline var COMMON_BUTTON:String = "common_button";
	public static inline var PRELOADER_LOGO:String = "preloader_logo";

	public static function exists(val:String):Bool {
		return (AssetsList.LIST.indexOf(val) > -1);
	}
}