(function () {
  "use strict";

  angular
    .module('spa.authn')
    .factory("spa.authn.whoAmI", whoAmIFactory);

  whoAmIFactory.$inject = ["$resource", "spa.config.APP_CONFIG"];

  function whoAmIFactory($resource, APP_CONFIG) {
    return $resource(APP_CONFIG.server_url + "/authn/whoami");
  }
})();
