(function () {
  "use strict";

  angular
    .module("spa.authn")
    .component("sdSignup", {
      templateUrl: templateUrl,
      controller: SignupController,
    });

  templateUrl.$inject = ["spa.config.APP_CONFIG"];
  function templateUrl(APP_CONFIG) {
    return APP_CONFIG.authn_signup_html;
  }

  SignupController.$inject = ["$scope", "$state", "spa.authn.Authn"];

  function SignupController($scope, $state, Authn) {
    var vm = this;
    vm.signupForm = {};
    vm.signup = signup;

    vm.$onInit = function () {
      console.log("SignupController", $scope);
    };
    return;

    function signup() {
      console.log("signup...");
      Authn.signup(vm.signupForm).then(
        function (response) {
          vm.id = response.data.data.id;
          console.log("sign up complete", response.data, vm);
          $state.go("home");
        },
        function (response) {
          console.log("signup failure", response, vm);
        }
      )
    }
  }

})();
