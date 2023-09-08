"use strict";

Object.defineProperty(exports, "__esModule", {
  value: true
});
exports.WorkspaceMosaic = void 0;

var _react = _interopRequireDefault(require("react"));

var _reactMosaicComponent = require("react-mosaic-component");

require("react-mosaic-component/react-mosaic-component.css");

var _difference = _interopRequireDefault(require("lodash/difference"));

var _toPairs = _interopRequireDefault(require("lodash/toPairs"));

var _classnames = _interopRequireDefault(require("classnames"));

var _MosaicRenderPreview = _interopRequireDefault(require("../containers/MosaicRenderPreview"));

var _Window = _interopRequireDefault(require("../containers/Window"));

var _MosaicLayout = _interopRequireDefault(require("../lib/MosaicLayout"));

var _jsxFileName = "/Users/pjreed/dev/mirador/dist/cjs/src/components/WorkspaceMosaic.js";

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { "default": obj }; }

function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }

function _defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ("value" in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } }

function _createClass(Constructor, protoProps, staticProps) { if (protoProps) _defineProperties(Constructor.prototype, protoProps); if (staticProps) _defineProperties(Constructor, staticProps); return Constructor; }

function _inherits(subClass, superClass) { if (typeof superClass !== "function" && superClass !== null) { throw new TypeError("Super expression must either be null or a function"); } subClass.prototype = Object.create(superClass && superClass.prototype, { constructor: { value: subClass, writable: true, configurable: true } }); if (superClass) _setPrototypeOf(subClass, superClass); }

function _setPrototypeOf(o, p) { _setPrototypeOf = Object.setPrototypeOf || function _setPrototypeOf(o, p) { o.__proto__ = p; return o; }; return _setPrototypeOf(o, p); }

function _createSuper(Derived) { return function () { var Super = _getPrototypeOf(Derived), result; if (_isNativeReflectConstruct()) { var NewTarget = _getPrototypeOf(this).constructor; result = Reflect.construct(Super, arguments, NewTarget); } else { result = Super.apply(this, arguments); } return _possibleConstructorReturn(this, result); }; }

function _possibleConstructorReturn(self, call) { if (call && (typeof call === "object" || typeof call === "function")) { return call; } return _assertThisInitialized(self); }

function _assertThisInitialized(self) { if (self === void 0) { throw new ReferenceError("this hasn't been initialised - super() hasn't been called"); } return self; }

function _isNativeReflectConstruct() { if (typeof Reflect === "undefined" || !Reflect.construct) return false; if (Reflect.construct.sham) return false; if (typeof Proxy === "function") return true; try { Date.prototype.toString.call(Reflect.construct(Date, [], function () {})); return true; } catch (e) { return false; } }

function _getPrototypeOf(o) { _getPrototypeOf = Object.setPrototypeOf ? Object.getPrototypeOf : function _getPrototypeOf(o) { return o.__proto__ || Object.getPrototypeOf(o); }; return _getPrototypeOf(o); }

/**
 * Represents a work area that contains any number of windows
 * @memberof Workspace
 * @private
 */
var WorkspaceMosaic = /*#__PURE__*/function (_React$Component) {
  _inherits(WorkspaceMosaic, _React$Component);

  var _super = _createSuper(WorkspaceMosaic);

  /**
   */
  function WorkspaceMosaic(props) {
    var _this;

    _classCallCheck(this, WorkspaceMosaic);

    _this = _super.call(this, props);
    _this.tileRenderer = _this.tileRenderer.bind(_assertThisInitialized(_this));
    _this.mosaicChange = _this.mosaicChange.bind(_assertThisInitialized(_this));
    _this.determineWorkspaceLayout = _this.determineWorkspaceLayout.bind(_assertThisInitialized(_this));
    _this.zeroStateView = /*#__PURE__*/_react["default"].createElement("div", {
      __self: _assertThisInitialized(_this),
      __source: {
        fileName: _jsxFileName,
        lineNumber: 28,
        columnNumber: 26
      }
    });
    _this.windowPaths = {};
    _this.toolbarControls = [];
    _this.additionalControls = [];
    return _this;
  }
  /** */


  _createClass(WorkspaceMosaic, [{
    key: "componentDidMount",
    value: function componentDidMount() {
      var updateWorkspaceMosaicLayout = this.props.updateWorkspaceMosaicLayout;
      var newLayout = this.determineWorkspaceLayout();
      if (newLayout) updateWorkspaceMosaicLayout(newLayout);
    }
    /** */

  }, {
    key: "componentDidUpdate",
    value: function componentDidUpdate(prevProps) {
      var _this$props = this.props,
          windows = _this$props.windows,
          layout = _this$props.layout,
          updateWorkspaceMosaicLayout = _this$props.updateWorkspaceMosaicLayout;
      var prevWindows = Object.keys(prevProps.windows);
      var currentWindows = Object.keys(windows); // Handles when Windows are removed from the state

      if (!prevWindows.every(function (e) {
        return currentWindows.includes(e);
      })) {
        // There are no more remaining Windows, just return an empty layout
        if (currentWindows.length === 0) {
          updateWorkspaceMosaicLayout(null);
          return;
        }

        var removedWindows = (0, _difference["default"])(prevWindows, currentWindows);
        var newLayout = new _MosaicLayout["default"](layout);
        newLayout.removeWindows(removedWindows, this.windowPaths);
        updateWorkspaceMosaicLayout(newLayout.layout);
      } // Handles when Windows are added (not via Add Resource UI)
      // TODO: If a window is added, add it in a better way #2380


      if (!currentWindows.every(function (e) {
        return prevWindows.includes(e);
      })) {
        var _newLayout = this.determineWorkspaceLayout();

        if (_newLayout !== layout) updateWorkspaceMosaicLayout(_newLayout);
      }
    }
    /**
     * bookkeepPath - used to book keep Window's path's
     * @param  {String} windowId   [description]
     * @param  {Array} path [description]
     */

  }, {
    key: "bookkeepPath",
    value: function bookkeepPath(windowId, path) {
      this.windowPaths[windowId] = path;
    }
    /**
     * Used to determine whether or not a "new" layout should be autogenerated.
     */

  }, {
    key: "determineWorkspaceLayout",
    value: function determineWorkspaceLayout() {
      var _this$props2 = this.props,
          windows = _this$props2.windows,
          layout = _this$props2.layout;
      var sortedWindows = (0, _toPairs["default"])(windows).sort(function (a, b) {
        return a.layoutOrder - b.layoutOrder;
      }).map(function (val) {
        return val[0];
      });
      var leaveKeys = (0, _reactMosaicComponent.getLeaves)(layout); // Windows were added

      if (!sortedWindows.every(function (e) {
        return leaveKeys.includes(e);
      })) {
        // No current layout, so just generate a new one
        if (leaveKeys.length < 2) {
          return (0, _reactMosaicComponent.createBalancedTreeFromLeaves)(sortedWindows);
        } // Add new windows to layout


        var addedWindows = (0, _difference["default"])(sortedWindows, leaveKeys);
        var newLayout = new _MosaicLayout["default"](layout);
        newLayout.addWindows(addedWindows);
        return newLayout.layout;
      } // Windows were removed (perhaps in a different Workspace). We don't have a
      // way to reconfigure.. so we have to random generate


      if (!leaveKeys.every(function (e) {
        return sortedWindows.includes(e);
      })) {
        return (0, _reactMosaicComponent.createBalancedTreeFromLeaves)(sortedWindows);
      }

      return layout;
    }
    /** */

  }, {
    key: "tileRenderer",

    /**
     * Render a tile (Window) in the Mosaic.
     */
    value: function tileRenderer(id, path) {
      var _this$props3 = this.props,
          windows = _this$props3.windows,
          workspaceId = _this$props3.workspaceId;
      var window = windows[id];
      if (!window) return null;
      this.bookkeepPath(window.id, path);
      return /*#__PURE__*/_react["default"].createElement(_reactMosaicComponent.MosaicWindow, {
        toolbarControls: this.toolbarControls,
        additionalControls: this.additionalControls,
        path: path,
        windowId: window.id,
        renderPreview: WorkspaceMosaic.renderPreview,
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 123,
          columnNumber: 7
        }
      }, /*#__PURE__*/_react["default"].createElement(_Window["default"], {
        key: "".concat(window.id, "-").concat(workspaceId),
        windowId: window.id,
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 130,
          columnNumber: 9
        }
      }));
    }
    /**
     * Update the redux store when the Mosaic is changed.
     */

  }, {
    key: "mosaicChange",
    value: function mosaicChange(newLayout) {
      var updateWorkspaceMosaicLayout = this.props.updateWorkspaceMosaicLayout;
      updateWorkspaceMosaicLayout(newLayout);
    }
    /**
     */

  }, {
    key: "render",
    value: function render() {
      var _this$props4 = this.props,
          layout = _this$props4.layout,
          classes = _this$props4.classes;
      return /*#__PURE__*/_react["default"].createElement(_reactMosaicComponent.Mosaic, {
        renderTile: this.tileRenderer,
        initialValue: layout || this.determineWorkspaceLayout(),
        onChange: this.mosaicChange,
        className: (0, _classnames["default"])('mirador-mosaic', classes.root),
        zeroStateView: this.zeroStateView,
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 151,
          columnNumber: 7
        }
      });
    }
  }], [{
    key: "renderPreview",
    value: function renderPreview(mosaicProps) {
      return /*#__PURE__*/_react["default"].createElement("div", {
        className: "mosaic-preview",
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 108,
          columnNumber: 7
        }
      }, /*#__PURE__*/_react["default"].createElement(_MosaicRenderPreview["default"], {
        windowId: mosaicProps.windowId,
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 109,
          columnNumber: 9
        }
      }));
    }
  }]);

  return WorkspaceMosaic;
}(_react["default"].Component);

exports.WorkspaceMosaic = WorkspaceMosaic;
WorkspaceMosaic.defaultProps = {
  layout: undefined
};