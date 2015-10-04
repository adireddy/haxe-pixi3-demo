package pixi3demo.controller;

import pixi3demo.model.Model;
import pixi3demo.view.View;
import pixi3demo.core.components.ComponentModel;
import pixi3demo.core.components.ComponentView;
import pixi3demo.core.components.ComponentController;
import pixi3demo.core.loader.AssetLoader;
import pixi3demo.core.utils.StageProperties;

import bindx.Bind;
import minject.Injector;

class Controller {

	@inject public var model:Model;
	@inject public var view:View;
	@inject public var stageProperties:StageProperties;

	public var componentControllers:Array<ComponentController>;

	var _loader:AssetLoader;
	var _componentViews:Array<ComponentView>;

	public function new() {
		CompileTime.importPackage("pixi3demo.components");
		componentControllers = [];
		_componentViews = [];
	}

	public function init() {
		model.init();
		view.init();

		model.addAssets.addOnce(_onAddAssets);

		_setupLoader();
		_setupComponents();
	}

	inline function _setupLoader() {
		_loader = new AssetLoader();
		_loader.baseUrl = "resources/";
		_loader.pixelRatio = stageProperties.pixelRatio;
		//_loader.resolution = stageProperties.bucketWidth + "x" + stageProperties.bucketHeight;
	}

	function _onAddAssets() {
		view.addAssetsToLoad();
		for (controller in componentControllers) controller.addAssetsToLoad();
		_loader.start(_onPreloadingComplete);
	}

	function _onPreloadingComplete() {
		for (controller in componentControllers) controller.setup();
	}

	function _setupComponents() {
		var models:List<Class<ComponentModel>> = CompileTime.getAllClasses(ComponentModel);
		var views:List<Class<ComponentView>> = CompileTime.getAllClasses(ComponentView);
		var controllers:List<Class<ComponentController>> = CompileTime.getAllClasses(ComponentController);

		var viewInjector = new Injector();
		viewInjector.mapValue(AssetLoader, _loader);
		viewInjector.injectInto(view);

		var modelMap:Map<String, Class<ComponentModel>> = new Map();
		for (modelClass in models) modelMap.set(Type.getClassName(modelClass).split(".").pop(), modelClass);

		var viewMap:Map<String, Class<ComponentView>> = new Map();
		for (viewClass in views) viewMap.set(Type.getClassName(viewClass).split(".").pop(), viewClass);

		for (controllerClass in controllers) {
			var controllerName = Type.getClassName(controllerClass).split(".").pop();
			controllerName = controllerName.substring(0, controllerName.indexOf("Controller"));
			var modelClass = modelMap.get(controllerName + "Model");
			var viewClass = viewMap.get(controllerName + "View");
			_setupComponent(modelClass, viewClass, controllerClass);
		}

		_componentViews.sort(function(comp1:ComponentView, comp2:ComponentView):Int {
			return Reflect.compare(comp1.index, comp2.index);
		});

		for (view in _componentViews) view.applyIndex();
		_componentViews = null;
	}

	function _setupComponent(modelClass:Class<ComponentModel>, viewClass:Class<ComponentView>, controllerClass:Class<ComponentController>) {
		var componentInjector = new Injector();
		componentInjector.mapValue(Model, model);

		var componentModel:ComponentModel = null;
		var componentView:ComponentView = null;

		if (modelClass != null) {
			componentModel = Type.createInstance(modelClass, []);
			componentInjector.mapValue(modelClass, componentModel);

			var modelInjector = new Injector();
			modelInjector.mapValue(Model, model);
			modelInjector.injectInto(componentModel);

			componentModel.init();
		}

		if (viewClass != null) {
			var viewName = Type.getClassName(viewClass).split(".").pop();
			componentView = Type.createInstance(viewClass, [view, viewName]);
			componentInjector.mapValue(viewClass, componentView);

			var viewInjector = new Injector();
			viewInjector.mapValue(AssetLoader, _loader);
			viewInjector.mapValue(StageProperties, stageProperties);
			viewInjector.injectInto(componentView);

			componentView.init();
			_componentViews.push(cast(componentView, ComponentView));
		}

		var componentController:ComponentController = Type.createInstance(controllerClass, []);
		componentInjector.injectInto(componentController);
		componentController.init();
		componentControllers.push(componentController);
	}

	public function reset() {
		model.reset();
		view.reset();
	}
}