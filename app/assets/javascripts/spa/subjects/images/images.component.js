(function () {
  "use strict";

  angular
    .module("spa.subjects")
    .component("sdImageSelector", {
      templateUrl: imageSelectorTemplateUrl,
      controller: ImageSelectorController,
      bindings: {}
    })
    .component("sdImageEditor", {
      templateUrl: imageEditorTemplateUrl,
      controller: ImageEditorController,
      binding: {}
    });

  imageSelectorTemplateUrl.$inject = ["spa.config.APP_CONFIG"];

  function imageSelectorTemplateUrl(APP_CONFIG) {
    return APP_CONFIG.image_selector_html;
  }

  imageEditorTemplateUrl.$inject = ["spa.config.APP_CONFIG"];

  function imageEditorTemplateUrl(APP_CONFIG) {
    return APP_CONFIG.image_editor_html;
  }

  ImageSelectorController.$inject = ["$scope",
    "$stateParams",
    "spa.subjects.Image"];

  ImageEditorController.$inject = ["$scope",
    "$stateParams",
    "spa.subjects.Image"];

  function ImageSelectorController($scope, $stateParams, Image) {
    var vm = this;

    vm.$onInit = function () {
      console.log("ImageSelectorController", $scope);
      if (!$stateParams.id) {
        vm.items = Image.query();
      }
    }
  }

  function ImageEditorController($scope, $stateParams, Image) {
    var vm = this;

    vm.$onInit = function () {
      console.log("ImageEditorController", $scope);
      if ($stateParams.id) {
        vm.item = Image.get({id: $stateParams.id});
        console.log(new Image());
      } else {
        newResource();
      }
    };

    function newResource() {
      vm.item = new Image();
    }
  }
})();
