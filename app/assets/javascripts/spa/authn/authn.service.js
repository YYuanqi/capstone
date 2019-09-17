(function () {
  "use strict";

  angular
    .module("spa.authn")
    .service("spa.authn.Authn", Authn);

  Authn.$inject = ["$auth"];

  function Authn($auth) {
    var service = this;
    service.signup = signup;

    return;

    function signup(registration) {
      return $auth.submitRegistration(registration, '/auth');
    }
  }
})();
