var _jsxFileName = "/Users/pjreed/dev/mirador/dist/es/src/lib/MiradorViewer.js";

function ownKeys(object, enumerableOnly) { var keys = Object.keys(object); if (Object.getOwnPropertySymbols) { var symbols = Object.getOwnPropertySymbols(object); if (enumerableOnly) symbols = symbols.filter(function (sym) { return Object.getOwnPropertyDescriptor(object, sym).enumerable; }); keys.push.apply(keys, symbols); } return keys; }

function _objectSpread(target) { for (var i = 1; i < arguments.length; i++) { var source = arguments[i] != null ? arguments[i] : {}; if (i % 2) { ownKeys(Object(source), true).forEach(function (key) { _defineProperty(target, key, source[key]); }); } else if (Object.getOwnPropertyDescriptors) { Object.defineProperties(target, Object.getOwnPropertyDescriptors(source)); } else { ownKeys(Object(source)).forEach(function (key) { Object.defineProperty(target, key, Object.getOwnPropertyDescriptor(source, key)); }); } } return target; }

function _defineProperty(obj, key, value) { if (key in obj) { Object.defineProperty(obj, key, { value: value, enumerable: true, configurable: true, writable: true }); } else { obj[key] = value; } return obj; }

function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }

function _defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ("value" in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } }

function _createClass(Constructor, protoProps, staticProps) { if (protoProps) _defineProperties(Constructor.prototype, protoProps); if (staticProps) _defineProperties(Constructor, staticProps); return Constructor; }

import React from 'react';
import ReactDOM from 'react-dom';
import { Provider } from 'react-redux';
import deepmerge from 'deepmerge';
import uuid from 'uuid/v4';
import PluginProvider from '../extend/PluginProvider';
import App from '../containers/App';
import createStore from '../state/createStore';
import createRootReducer from '../state/reducers/rootReducer';
import * as actions from '../state/actions';
import settings from '../config/settings';
import { getCompanionWindowIdsForPosition, getManifestSearchService } from '../state/selectors';
/**
 * Default Mirador instantiation
 */

var MiradorViewer = /*#__PURE__*/function () {
  /**
   */
  function MiradorViewer(config, plugins) {
    _classCallCheck(this, MiradorViewer);

    this.store = createStore();
    this.config = config;
    this.processConfig();
    var viewer = {
      actions: actions,
      store: this.store
    };
    ReactDOM.render( /*#__PURE__*/React.createElement(Provider, {
      store: this.store,
      __self: this,
      __source: {
        fileName: _jsxFileName,
        lineNumber: 30,
        columnNumber: 7
      }
    }, /*#__PURE__*/React.createElement(PluginProvider, {
      plugins: plugins,
      createRootReducer: createRootReducer,
      __self: this,
      __source: {
        fileName: _jsxFileName,
        lineNumber: 31,
        columnNumber: 9
      }
    }, /*#__PURE__*/React.createElement(App, {
      __self: this,
      __source: {
        fileName: _jsxFileName,
        lineNumber: 32,
        columnNumber: 11
      }
    }))), document.getElementById(config.id));
    return viewer;
  }
  /**
   * Process config into actions
   */


  _createClass(MiradorViewer, [{
    key: "processConfig",
    value: function processConfig() {
      var _this = this;

      /** merge type for arrays */
      var overwriteMerge = function overwriteMerge(destinationArray, sourceArray, options) {
        return sourceArray;
      };

      var mergedConfig = deepmerge(settings, this.config, {
        arrayMerge: overwriteMerge
      });
      var action = actions.setConfig(mergedConfig);
      this.store.dispatch(action);
      mergedConfig.windows.forEach(function (miradorWindow, layoutOrder) {
        var windowId = "window-".concat(uuid());
        var manifestId = miradorWindow.manifestId || miradorWindow.loadedManifest;

        var manifestAction = _this.store.dispatch(actions.fetchManifest(manifestId));

        var windowAction = _this.store.dispatch(actions.addWindow(_objectSpread({
          // these are default values ...
          id: windowId,
          layoutOrder: layoutOrder,
          manifestId: manifestId,
          thumbnailNavigationPosition: mergedConfig.thumbnailNavigation.defaultPosition
        }, miradorWindow)));

        Promise.all([manifestAction, windowAction]).then(function () {
          if (miradorWindow.defaultSearchQuery) {
            var state = _this.store.getState();

            var companionWindowId = getCompanionWindowIdsForPosition(state, {
              position: 'left',
              windowId: windowId
            })[0];
            var searchService = getManifestSearchService(state, {
              windowId: windowId
            });
            var searchId = searchService && "".concat(searchService.id, "?q=").concat(miradorWindow.defaultSearchQuery);
            companionWindowId && searchId && _this.store.dispatch(actions.fetchSearch(windowId, companionWindowId, searchId, miradorWindow.defaultSearchQuery));
          }
        });
      });
      Object.keys(mergedConfig.manifests || {}).forEach(function (manifestId) {
        _this.store.dispatch(actions.requestManifest(manifestId, mergedConfig.manifests[manifestId]));
      });
    }
  }]);

  return MiradorViewer;
}();

export default MiradorViewer;