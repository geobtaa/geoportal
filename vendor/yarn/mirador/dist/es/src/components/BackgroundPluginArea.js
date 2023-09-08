var _this = this,
    _jsxFileName = "/Users/pjreed/dev/mirador/dist/es/src/components/BackgroundPluginArea.js";

import React from 'react';
import ns from '../config/css-ns';
import { PluginHook } from './PluginHook';
/** invisible area where background plugins can add to */

export var BackgroundPluginArea = function BackgroundPluginArea(props) {
  return /*#__PURE__*/React.createElement("div", {
    className: ns('background-plugin-area'),
    style: {
      display: 'none'
    },
    __self: _this,
    __source: {
      fileName: _jsxFileName,
      lineNumber: 8,
      columnNumber: 3
    }
  }, /*#__PURE__*/React.createElement(PluginHook, Object.assign({}, props, {
    __self: _this,
    __source: {
      fileName: _jsxFileName,
      lineNumber: 9,
      columnNumber: 5
    }
  })));
};
BackgroundPluginArea.defaultProps = {
  PluginComponents: []
};