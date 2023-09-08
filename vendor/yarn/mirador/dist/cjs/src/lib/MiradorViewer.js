"use strict";

Object.defineProperty(exports, "__esModule", {
  value: true
});
exports["default"] = void 0;

var _react = _interopRequireDefault(require("react"));

var _reactDom = _interopRequireDefault(require("react-dom"));

var _reactRedux = require("react-redux");

var _deepmerge = _interopRequireDefault(require("deepmerge"));

var _v = _interopRequireDefault(require("uuid/v4"));

var _PluginProvider = _interopRequireDefault(require("../extend/PluginProvider"));

var _App = _interopRequireDefault(require("../containers/App"));

var _createStore = _interopRequireDefault(require("../state/createStore"));

var _rootReducer = _interopRequireDefault(require("../state/reducers/rootReducer"));

var actions = _interopRequireWildcard(require("../state/actions"));

var _settings = _interopRequireDefault(require("../config/settings"));

var _selectors = require("../state/selectors");

var _jsxFileName = "/Users/pjreed/dev/mirador/dist/cjs/src/lib/MiradorViewer.js";

function _getRequireWildcardCache() { if (typeof WeakMap !== "function") return null; var cache = new WeakMap(); _getRequireWildcardCache = function _getRequireWildcardCache() { return cache; }; return cache; }

function _interopRequireWildcard(obj) { if (obj && obj.__esModule) { return obj; } if (obj === null || typeof obj !== "object" && typeof obj !== "function") { return { "default": obj }; } var cache = _getRequireWildcardCache(); if (cache && cache.has(obj)) { return cache.get(obj); } var newObj = {}; var hasPropertyDescriptor = Object.defineProperty && Object.getOwnPropertyDescriptor; for (var key in obj) { if (Object.prototype.hasOwnProperty.call(obj, key)) { var desc = hasPropertyDescriptor ? Object.getOwnPropertyDescriptor(obj, key) : null; if (desc && (desc.get || desc.set)) { Object.defineProperty(newObj, key, desc); } else { newObj[key] = obj[key]; } } } newObj["default"] = obj; if (cache) { cache.set(obj, newObj); } return newObj; }

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { "default": obj }; }

function ownKeys(object, enumerableOnly) { var keys = Object.keys(object); if (Object.getOwnPropertySymbols) { var symbols = Object.getOwnPropertySymbols(object); if (enumerableOnly) symbols = symbols.filter(function (sym) { return Object.getOwnPropertyDescriptor(object, sym).enumerable; }); keys.push.apply(keys, symbols); } return keys; }

function _objectSpread(target) { for (var i = 1; i < arguments.length; i++) { var source = arguments[i] != null ? arguments[i] : {}; if (i % 2) { ownKeys(Object(source), true).forEach(function (key) { _defineProperty(target, key, source[key]); }); } else if (Object.getOwnPropertyDescriptors) { Object.defineProperties(target, Object.getOwnPropertyDescriptors(source)); } else { ownKeys(Object(source)).forEach(function (key) { Object.defineProperty(target, key, Object.getOwnPropertyDescriptor(source, key)); }); } } return target; }

function _defineProperty(obj, key, value) { if (key in obj) { Object.defineProperty(obj, key, { value: value, enumerable: true, configurable: true, writable: true }); } else { obj[key] = value; } return obj; }

function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }

function _defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ("value" in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } }

function _createClass(Constructor, protoProps, staticProps) { if (protoProps) _defineProperties(Constructor.prototype, protoProps); if (staticProps) _defineProperties(Constructor, staticProps); return Constructor; }

/**
 * Default Mirador instantiation
 */
var MiradorViewer = /*#__PURE__*/function () {
  /**
   */
  function MiradorViewer(config, plugins) {
    _classCallCheck(this, MiradorViewer);

    this.store = (0, _createStore["default"])();
    this.config = config;
    this.processConfig();
    var viewer = {
      actions: actions,
      store: this.store
    };

    _reactDom["default"].render( /*#__PURE__*/_react["default"].createElement(_reactRedux.Provider, {
      store: this.store,
      __self: this,
      __source: {
        fileName: _jsxFileName,
        lineNumber: 30,
        columnNumber: 7
      }
    }, /*#__PURE__*/_react["default"].createElement(_PluginProvider["default"], {
      plugins: plugins,
      createRootReducer: _rootReducer["default"],
      __self: this,
      __source: {
        fileName: _jsxFileName,
        lineNumber: 31,
        columnNumber: 9
      }
    }, /*#__PURE__*/_react["default"].createElement(_App["default"], {
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

      var mergedConfig = (0, _deepmerge["default"])(_settings["default"], this.config, {
        arrayMerge: overwriteMerge
      });
      var action = actions.setConfig(mergedConfig);
      this.store.dispatch(action);
      mergedConfig.windows.forEach(function (miradorWindow, layoutOrder) {
        var windowId = "window-".concat((0, _v["default"])());
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

            var companionWindowId = (0, _selectors.getCompanionWindowIdsForPosition)(state, {
              position: 'left',
              windowId: windowId
            })[0];
            var searchService = (0, _selectors.getManifestSearchService)(state, {
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

var _default = MiradorViewer;
exports["default"] = _default;