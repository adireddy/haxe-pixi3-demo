package pixi3demo.components.menu;

import pixi3demo.core.components.ComponentController;

class MenuController extends ComponentController {

	@inject public var view:MenuView;

	override public function setup() {
		view.setup();
	}
}