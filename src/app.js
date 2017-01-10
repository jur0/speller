require('./normalize.css');
require('./style.css');

(function() {
    'use strict';

    var Elm = require('./Main');
    Elm.Main.embed(document.body);
})();
