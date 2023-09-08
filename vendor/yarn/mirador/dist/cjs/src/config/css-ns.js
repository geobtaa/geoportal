"use strict";

Object.defineProperty(exports, "__esModule", {
  value: true
});
exports["default"] = void 0;

var _cssNs = require("css-ns");

/**
 * export ns - sets up css namespacing for everything to be `mirador-`
 */
var ns = function ns(className) {
  return (0, _cssNs.createCssNs)({
    namespace: 'mirador'
  })(className);
};

var _default = ns;
exports["default"] = _default;