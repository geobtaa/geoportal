"use strict";

Object.defineProperty(exports, "__esModule", {
  value: true
});
exports.BackgroundPluginArea = void 0;

var _react = _interopRequireDefault(require("react"));

var _cssNs = _interopRequireDefault(require("../config/css-ns"));

var _PluginHook = require("./PluginHook");

var _this = void 0,
    _jsxFileName = "/Users/pjreed/dev/mirador/dist/cjs/src/components/BackgroundPluginArea.js";

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { "default": obj }; }

/** invisible area where background plugins can add to */
var BackgroundPluginArea = function BackgroundPluginArea(props) {
  return /*#__PURE__*/_react["default"].createElement("div", {
    className: (0, _cssNs["default"])('background-plugin-area'),
    style: {
      display: 'none'
    },
    __self: _this,
    __source: {
      fileName: _jsxFileName,
      lineNumber: 8,
      columnNumber: 3
    }
  }, /*#__PURE__*/_react["default"].createElement(_PluginHook.PluginHook, Object.assign({}, props, {
    __self: _this,
    __source: {
      fileName: _jsxFileName,
      lineNumber: 9,
      columnNumber: 5
    }
  })));
};

exports.BackgroundPluginArea = BackgroundPluginArea;
BackgroundPluginArea.defaultProps = {
  PluginComponents: []
};