var _jsxFileName = "/Users/pjreed/dev/mirador/dist/es/src/extend/withPlugins.js";

function ownKeys(object, enumerableOnly) { var keys = Object.keys(object); if (Object.getOwnPropertySymbols) { var symbols = Object.getOwnPropertySymbols(object); if (enumerableOnly) symbols = symbols.filter(function (sym) { return Object.getOwnPropertyDescriptor(object, sym).enumerable; }); keys.push.apply(keys, symbols); } return keys; }

function _objectSpread(target) { for (var i = 1; i < arguments.length; i++) { var source = arguments[i] != null ? arguments[i] : {}; if (i % 2) { ownKeys(Object(source), true).forEach(function (key) { _defineProperty(target, key, source[key]); }); } else if (Object.getOwnPropertyDescriptors) { Object.defineProperties(target, Object.getOwnPropertyDescriptors(source)); } else { ownKeys(Object(source)).forEach(function (key) { Object.defineProperty(target, key, Object.getOwnPropertyDescriptor(source, key)); }); } } return target; }

function _defineProperty(obj, key, value) { if (key in obj) { Object.defineProperty(obj, key, { value: value, enumerable: true, configurable: true, writable: true }); } else { obj[key] = value; } return obj; }

import React, { useContext } from 'react';
import curry from 'lodash/curry';
import isEmpty from 'lodash/isEmpty';
import PluginContext from './PluginContext';
/** withPlugins should be the innermost HOC */

function _withPlugins(targetName, TargetComponent) {
  // eslint-disable-line no-underscore-dangle

  /** */
  function PluginHoc(props, ref) {
    var pluginMap = useContext(PluginContext);

    var passDownProps = _objectSpread({}, props);

    if (ref) passDownProps.ref = ref;

    if (isEmpty(pluginMap)) {
      return /*#__PURE__*/React.createElement(TargetComponent, Object.assign({}, passDownProps, {
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 20,
          columnNumber: 14
        }
      }));
    }

    var plugins = pluginMap[targetName];

    if (isEmpty(plugins)) {
      return /*#__PURE__*/React.createElement(TargetComponent, Object.assign({}, passDownProps, {
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 26,
          columnNumber: 14
        }
      }));
    }

    if (!isEmpty(plugins.wrap) && !isEmpty(plugins.add)) {
      var WrapPluginComponent = plugins.wrap[0].component;
      var AddPluginComponents = plugins.add.map(function (plugin) {
        return plugin.component;
      });
      return /*#__PURE__*/React.createElement(WrapPluginComponent, Object.assign({
        targetProps: passDownProps
      }, passDownProps, {
        PluginComponents: AddPluginComponents,
        TargetComponent: TargetComponent,
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 33,
          columnNumber: 9
        }
      }));
    }

    if (!isEmpty(plugins.wrap)) {
      var PluginComponent = plugins.wrap[0].component;
      return /*#__PURE__*/React.createElement(PluginComponent, {
        targetProps: passDownProps,
        TargetComponent: TargetComponent,
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 44,
          columnNumber: 14
        }
      });
    }

    if (!isEmpty(plugins.add)) {
      var PluginComponents = plugins.add.map(function (plugin) {
        return plugin.component;
      });
      return /*#__PURE__*/React.createElement(TargetComponent, Object.assign({}, passDownProps, {
        PluginComponents: PluginComponents,
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 49,
          columnNumber: 14
        }
      }));
    }
  }

  var whatever = React.forwardRef(PluginHoc);
  whatever.displayName = "WithPlugins(".concat(targetName, ")");
  return whatever;
}
/** withPlugins('MyComponent')(MyComponent) */


export var withPlugins = curry(_withPlugins);