define([ 'module-b' ], function( ModuleB ) {

  var initialize = function() {

    console.log( "Module A Initialize");

    ModuleB.initialize();
  };

  return {
    initialize : initialize
  };

});
