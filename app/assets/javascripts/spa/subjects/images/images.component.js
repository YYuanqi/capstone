(function () {
  "use strict";

  angular
    .module("spa.subjects")
    .component("sdImageSelector", {
      templateUrl: imageSelectorTemplateUrl,
      controller: ImageSelectorController,
      bindings: {
        authz: "<"
      }
    })
    .component("sdImageEditor", {
      templateUrl: imageEditorTemplateUrl,
      controller: ImageEditorController,
      bindings: {
        authz: "<"
      }
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
    "$q",
    "$state",
    "$stateParams",
    "spa.subjects.Image",
    "spa.subjects.ImageThing",
    "spa.subjects.ImageLinkableThing"];

  function ImageSelectorController($scope, $stateParams, Image) {
    var vm = this;

    vm.$onInit = function () {
      console.log("ImageSelectorController", $scope);
      if (!$stateParams.id) {
        vm.items = Image.query();
      }
    }
  }

  function ImageEditorController($scope, $q, $state, $stateParams, Image, ImageThing, ImageLinkableThing) {
    var vm = this;
    vm.create = create;
    vm.clear = clear;
    vm.update = update;
    vm.remove = remove;


    vm.$onInit = function () {
      console.log("ImageEditorController", $scope);
      if ($stateParams.id) {
        reload($stateParams.id);
      } else {
        newResource();
      }
    };

    return;

    function newResource() {
      vm.item = new Image();
      return vm.item;
    }

    function reload(imageId) {
      var itemId = imageId ? imageId : vm.item.id;
      console.log("re/loading image", itemId);
      vm.item = Image.get({id: itemId});
      vm.things = ImageThing.query({image_id: itemId});
      vm.linkable_things = ImageLinkableThing.query({image_id: itemId});
      $q.all([vm.item.$promise, vm.things.$promise]).catch(handleError);
    }

    function clear() {
      newResource();
      $state.go(".", {id: null})
    }

    function create() {
      vm.item.errors = null;
      vm.item.$save().then(
        function () {
          console.log("create complete", vm.item);
          $state.go(".", {id: vm.item.id});
        },
        handleError);
    }

    function update() {
      vm.item.errors = null;
      // vm.item.$update().then(
      //   function () {
      //     console.log("update complete", vm.item);
      //     $scope.imageform.$setPristine();
      //     $state.reload();
      //   },
      //   handleError);
      var update = vm.item.$update();
      linkThings(update);
    }

    function linkThings(parentPromise) {
      var promises = [];
      if (parentPromise) promise.push(parentPromise);
      angular.forEach(vm.selected_linkable, function (linkable) {
        var resource = ImageThing.save({image_id: vm.item.id}, {thing_id: linkable});
        promises.push(resource.$promise);
      });

      vm.selected_linkables = [];
      console.log("waiting for promises", promises);
      $q.all(promises).then(
        function (response) {
          console.log("promise.all response", response);
          $scope.imageform.$setPristine();
          reload();
        },
        handleError);
    }

    function remove() {
      vm.item.errors = null;
      vm.item.$delete().then(
        function () {
          console.log("remove complete", vm.item);
          clear();
        },
        handleError);
    }

    function handleError(response) {
      if (response.data) {
        vm.item["errors"] = response.data.errors;
      }
      if (!vm.item.errors) {
        vm.item["errors"] = {};
        vm.item["errors"]["full_message"] = response;
      }
      $scope.imageform.$setPristine();
    }
  }
})();