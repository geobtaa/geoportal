var _jsxFileName = "/Users/pjreed/dev/mirador/dist/es/src/components/Window.js";

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

import React, { Component } from 'react';
import cn from 'classnames';
import Paper from '@material-ui/core/Paper';
import { MosaicWindowContext } from 'react-mosaic-component/lib/contextTypes';
import ns from '../config/css-ns';
import WindowTopBar from '../containers/WindowTopBar';
import PrimaryWindow from '../containers/PrimaryWindow';
import CompanionArea from '../containers/CompanionArea';
import WindowAuthenticationControl from '../containers/WindowAuthenticationControl';
import { PluginHook } from './PluginHook';
/**
 * Represents a Window in the mirador workspace
 * @param {object} window
 */

export var Window = /*#__PURE__*/function (_Component) {
  _inherits(Window, _Component);

  var _super = _createSuper(Window);

  /** */
  function Window(props) {
    var _this;

    _classCallCheck(this, Window);

    _this = _super.call(this, props);
    _this.state = {};
    return _this;
  }
  /** */


  _createClass(Window, [{
    key: "componentDidMount",

    /** */
    value: function componentDidMount(prevProps) {
      var _this$props = this.props,
          fetchManifest = _this$props.fetchManifest,
          manifest = _this$props.manifest,
          manifestId = _this$props.manifestId;

      if (manifestId && (!manifest || !manifest.isFetching)) {
        fetchManifest(manifestId);
      }
    }
    /**
     * wrappedTopBar - will conditionally wrap a WindowTopBar for needed
     * additional functionality based on workspace type
     */

  }, {
    key: "wrappedTopBar",
    value: function wrappedTopBar() {
      var _this$props2 = this.props,
          manifest = _this$props2.manifest,
          windowId = _this$props2.windowId,
          workspaceType = _this$props2.workspaceType,
          windowDraggable = _this$props2.windowDraggable;
      var topBar = /*#__PURE__*/React.createElement("div", {
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 49,
          columnNumber: 7
        }
      }, /*#__PURE__*/React.createElement(WindowTopBar, {
        windowId: windowId,
        manifest: manifest,
        windowDraggable: windowDraggable,
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 50,
          columnNumber: 9
        }
      }), /*#__PURE__*/React.createElement(WindowAuthenticationControl, {
        key: "auth",
        windowId: windowId,
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 55,
          columnNumber: 9
        }
      }));

      if (workspaceType === 'mosaic' && windowDraggable) {
        var mosaicWindowActions = this.context.mosaicWindowActions;
        return mosaicWindowActions.connectDragSource(topBar);
      }

      return topBar;
    }
    /**
     * Renders things
     */

  }, {
    key: "render",
    value: function render() {
      var _this$props3 = this.props,
          focusWindow = _this$props3.focusWindow,
          label = _this$props3.label,
          manifest = _this$props3.manifest,
          maximized = _this$props3.maximized,
          sideBarOpen = _this$props3.sideBarOpen,
          view = _this$props3.view,
          windowId = _this$props3.windowId,
          classes = _this$props3.classes,
          t = _this$props3.t;
      var hasError = this.state.hasError;

      if (hasError) {
        return /*#__PURE__*/React.createElement(React.Fragment, null);
      }

      return /*#__PURE__*/React.createElement(Paper, {
        onFocus: focusWindow,
        component: "section",
        elevation: 1,
        id: windowId,
        className: cn(classes.window, ns('window'), maximized ? classes.maximized : null),
        "aria-label": t('window', {
          label: label
        }),
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 82,
          columnNumber: 7
        }
      }, this.wrappedTopBar(), /*#__PURE__*/React.createElement("div", {
        className: classes.middle,
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 93,
          columnNumber: 9
        }
      }, /*#__PURE__*/React.createElement("div", {
        className: classes.middleLeft,
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 94,
          columnNumber: 11
        }
      }, /*#__PURE__*/React.createElement("div", {
        className: classes.primaryWindow,
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 95,
          columnNumber: 13
        }
      }, /*#__PURE__*/React.createElement(PrimaryWindow, {
        view: view,
        windowId: windowId,
        manifest: manifest,
        sideBarOpen: sideBarOpen,
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 96,
          columnNumber: 15
        }
      })), /*#__PURE__*/React.createElement("div", {
        className: classes.companionAreaBottom,
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 103,
          columnNumber: 13
        }
      }, /*#__PURE__*/React.createElement(CompanionArea, {
        windowId: windowId,
        position: "bottom",
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 104,
          columnNumber: 15
        }
      }))), /*#__PURE__*/React.createElement("div", {
        className: classes.companionAreaRight,
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 107,
          columnNumber: 11
        }
      }, /*#__PURE__*/React.createElement(CompanionArea, {
        windowId: windowId,
        position: "right",
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 108,
          columnNumber: 13
        }
      }), /*#__PURE__*/React.createElement(CompanionArea, {
        windowId: windowId,
        position: "far-right",
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 109,
          columnNumber: 13
        }
      }))), /*#__PURE__*/React.createElement(CompanionArea, {
        windowId: windowId,
        position: "far-bottom",
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 112,
          columnNumber: 9
        }
      }), /*#__PURE__*/React.createElement(PluginHook, Object.assign({}, this.props, {
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 113,
          columnNumber: 9
        }
      })));
    }
  }], [{
    key: "getDerivedStateFromError",
    value: function getDerivedStateFromError(error) {
      // Update state so the next render will show the fallback UI.
      return {
        hasError: true
      };
    }
  }]);

  return Window;
}(Component);
Window.contextType = MosaicWindowContext;
Window.defaultProps = {
  classes: {},
  focusWindow: function focusWindow() {},
  label: null,
  manifest: null,
  manifestId: undefined,
  maximized: false,
  sideBarOpen: false,
  view: undefined,
  windowDraggable: null,
  workspaceType: null
};