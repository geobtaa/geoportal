"use strict";

Object.defineProperty(exports, "__esModule", {
  value: true
});
exports["default"] = _default;

var _MiradorViewer = _interopRequireDefault(require("./lib/MiradorViewer"));

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { "default": obj }; }

/**
 * Default Mirador instantiation
 */
function _default(config, plugins) {
  return new _MiradorViewer["default"](config, plugins);
}