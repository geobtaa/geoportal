var _this = this,
    _jsxFileName = "/Users/pjreed/dev/mirador/dist/es/src/components/PluginHook.js";

function _objectWithoutProperties(source, excluded) { if (source == null) return {}; var target = _objectWithoutPropertiesLoose(source, excluded); var key, i; if (Object.getOwnPropertySymbols) { var sourceSymbolKeys = Object.getOwnPropertySymbols(source); for (i = 0; i < sourceSymbolKeys.length; i++) { key = sourceSymbolKeys[i]; if (excluded.indexOf(key) >= 0) continue; if (!Object.prototype.propertyIsEnumerable.call(source, key)) continue; target[key] = source[key]; } } return target; }

function _objectWithoutPropertiesLoose(source, excluded) { if (source == null) return {}; var target = {}; var sourceKeys = Object.keys(source); var key, i; for (i = 0; i < sourceKeys.length; i++) { key = sourceKeys[i]; if (excluded.indexOf(key) >= 0) continue; target[key] = source[key]; } return target; }

import React from 'react';
/** Renders plugins */

export var PluginHook = function PluginHook(props) {
  var PluginComponents = props.PluginComponents; // eslint-disable-line react/prop-types

  var classes = props.classes,
      otherProps = _objectWithoutProperties(props, ["classes"]);

  return PluginComponents ? PluginComponents.map(function (PluginComponent, index) {
    return /*#__PURE__*/React.createElement(PluginComponent, Object.assign({}, otherProps, {
      key: index // eslint-disable-line react/no-array-index-key
      ,
      __self: _this,
      __source: {
        fileName: _jsxFileName,
        lineNumber: 9,
        columnNumber: 7
      }
    }));
  }) : null;
};