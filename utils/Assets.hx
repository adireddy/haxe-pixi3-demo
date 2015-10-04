import sys.io.FileOutput;
import sys.FileSystem;
import sys.io.File;

class Assets {

	var folders:Array<String> = [];
	var files:Array<String> = [];

	var _assetsFile:FileOutput;
	var _fileNames:Map<String, String>;
	var _fileIDs:Map<String, String>;

	public function new() {
		_fileNames = new Map();
		_fileIDs = new Map();
		_assetsFile = File.write("utils/AssetsList.hx", false);
		_assetsFile.writeString("class AssetsList {\n\n");

		_assetsFile.writeString("\tstatic var LIST:Array<String> = [");

		_listFiles("resources");

		_assetsFile.writeString("\"\"];\n\n");

		for (file in _fileNames.keys()) _assetsFile.writeString("\tpublic static inline var " + file + ":String = \"" + _fileNames.get(file) + "\";\n");

		for (id in _fileIDs.keys()) _assetsFile.writeString("\tpublic static inline var " + id + ":String = \"" + _fileIDs.get(id) + "\";\n");

		_assetsFile.writeString("\n\tpublic static function exists(val:String):Bool {\n");
		_assetsFile.writeString("\t\treturn (AssetsList.LIST.indexOf(val) > -1);\n");
		_assetsFile.writeString("\t}");

		_assetsFile.writeString("\n}");

		_assetsFile.close();
	}

	function _listFiles(name:String) {
		var files = FileSystem.readDirectory(name);
		for (f in files) {
			if (FileSystem.isDirectory(name + "/" + f)) folders.push(name + "/" + f);
			else {
				_assetsFile.writeString("\"" + name + "/" + f + "\",\n\t\t\t");
				_setFilesMap(name + "/" + f);
			}
		}

		if(folders.length > 0) {
			_listFiles(folders.shift());
		}
	}

	function _setFilesMap(name:String) {
		var filePath:String = "";
		var fileName:String = "";

		if (name.indexOf(".DS_Store") == -1) {
			if (name.indexOf("@1x") > 0) filePath = name.substring(name.indexOf("@1x") + 4, name.length);
			else if (name.indexOf("sounds") > 0) filePath = name.substring(name.indexOf("sounds"), name.length);

			if (filePath != "") {
				fileName = filePath.split("/").join("_");
				fileName = fileName.split("-").join("_");
				//fileName = fileName.split("x").join("_");
				fileName = fileName.split(".").join("_");
				_fileNames.set(fileName.toUpperCase(), filePath);

				fileName = fileName.substring(0, fileName.lastIndexOf("_"));
				_fileIDs.set(fileName.toUpperCase(), fileName);
			}
		}
	}

	static function main() {
		new Assets();
	}
}