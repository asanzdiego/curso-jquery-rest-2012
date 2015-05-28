define([ 'module-a' ], function( ModuleA ) {

  var initialize = function() {

    console.log( "App Initialize");

    ModuleA.initialize();
  };

  return {
    initialize : initialize
  };

});
