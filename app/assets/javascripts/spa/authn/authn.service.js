(function () {
  "use strict";

  angular
    .module("spa.authn")
    .service("spa.authn.Authn", Authn);

  Authn.$inject = ["$auth", "$q"];

  function Authn($auth, $q) {
    var service = this;
    service.user = null;
    service.signup = signup;
    service.isAuthenticated = isAuthenticated;
    service.getCurrentUserName = getCurrentUserName;
    service.getCurrentUser = getCurrentUser;
    service.getCurrentUserId = getCurrentuserId;
    service.login = login;
    service.logout = logout;

    activate();
    return;

    function activate() {
      $auth.validateUser().then(
        function (response) {
          service.user = response;
          console.log("validated user", response);
        }
      )
    }

    function signup(registration) {
      return $auth.submitRegistration(registration, '/auth');
    }

    function isAuthenticated() {
      return service.user != null && service.user["uid"] != null;
    }

    function getCurrentUserName() {
      return service.user != null ? service.user.name : null;
    }

    function getCurrentUser() {
      return service.user;
    }

    function getCurrentUserId() {
      return service.user!=null ? service.user.id :null
    }

    function login(credentials) {
      console.log("login", credentials.email);
      var result = $auth.submitLogin({
        email: credentials["email"],
        password: credentials["password"]
      });

      var defferd = $q.defer();

      result.then(
        function (response) {
          console.log("login complete", response);
          service.user = response;
          defferd.resolve(response);
        },
        function (response) {
          var formmated_errors = {
            errors: {
              full_messages: response.errors
            }
          };
          console.log("login failure", response);
          defferd.reject(formmated_errors);
        });

      return defferd.promise;
    }

    function logout() {
      console.log("Authn", "logout");
      var result = $auth.signOut();

      result.then(
        function (response) {
          console.log("logout complete", response)
          service.user = null;
        },
        function (response) {
          console.log("logout failure", response);
          service.user = null;
          alert(response.status + ":" + response.statusText);
        });

      return result;
    }
  }
})();
