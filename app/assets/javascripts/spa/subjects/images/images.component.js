(function () {
  "use strict";

  angular
    .module("spa.subjects")
    .component("sdImageSelector", {
      templateUrl: imageSelectorTemplateUrl,
      controller: ImageSelectorController,
      // bindings: {}
    });

  imageSelectorTemplateUrl.$inject = ["spa.config.APP_CONFIG"];

  function imageSelectorTemplateUrl(APP_CONFIG) {
    return APP_CONFIG.image_selector_html;
  }

  ImageSelectorController.$inject = ["$scope",
    "$stateParams",
    "spa.subjects.Image"];

  function ImageSelectorController($scope, $stateParams, Image) {
    var vm = this;

    vm.$onInit = function() {
      console.log("ImageSelectorController", $scope);
      if (!$stateParams.id) {
        vm.items = Image.query();
      }
    }
  }
})();
