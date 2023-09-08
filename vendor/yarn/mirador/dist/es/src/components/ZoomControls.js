var _jsxFileName = "/Users/pjreed/dev/mirador/dist/es/src/components/ZoomControls.js";

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
import AddCircleIcon from '@material-ui/icons/AddCircleOutlineSharp';
import RemoveCircleIcon from '@material-ui/icons/RemoveCircleOutlineSharp';
import RestoreZoomIcon from './icons/RestoreZoomIcon';
import MiradorMenuButton from '../containers/MiradorMenuButton';
/**
 */

export var ZoomControls = /*#__PURE__*/function (_Component) {
  _inherits(ZoomControls, _Component);

  var _super = _createSuper(ZoomControls);

  /**
   * constructor -
   */
  function ZoomControls(props) {
    var _this;

    _classCallCheck(this, ZoomControls);

    _this = _super.call(this, props);
    _this.handleZoomInClick = _this.handleZoomInClick.bind(_assertThisInitialized(_this));
    _this.handleZoomOutClick = _this.handleZoomOutClick.bind(_assertThisInitialized(_this));
    return _this;
  }
  /**
   * @private
   */


  _createClass(ZoomControls, [{
    key: "handleZoomInClick",
    value: function handleZoomInClick() {
      var _this$props = this.props,
          windowId = _this$props.windowId,
          updateViewport = _this$props.updateViewport,
          viewer = _this$props.viewer;
      updateViewport(windowId, {
        x: viewer.x,
        y: viewer.y,
        zoom: viewer.zoom * 2
      });
    }
    /**
     * @private
     */

  }, {
    key: "handleZoomOutClick",
    value: function handleZoomOutClick() {
      var _this$props2 = this.props,
          windowId = _this$props2.windowId,
          updateViewport = _this$props2.updateViewport,
          viewer = _this$props2.viewer;
      updateViewport(windowId, {
        x: viewer.x,
        y: viewer.y,
        zoom: viewer.zoom / 2
      });
    }
    /**
     * render
     * @return
     */

  }, {
    key: "render",
    value: function render() {
      var _this$props3 = this.props,
          displayDivider = _this$props3.displayDivider,
          showZoomControls = _this$props3.showZoomControls,
          classes = _this$props3.classes,
          t = _this$props3.t,
          zoomToWorld = _this$props3.zoomToWorld;

      if (!showZoomControls) {
        return /*#__PURE__*/React.createElement(React.Fragment, null);
      }

      return /*#__PURE__*/React.createElement("div", {
        className: classes.zoom_controls,
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 63,
          columnNumber: 7
        }
      }, /*#__PURE__*/React.createElement(MiradorMenuButton, {
        "aria-label": t('zoomIn'),
        onClick: this.handleZoomInClick,
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 64,
          columnNumber: 9
        }
      }, /*#__PURE__*/React.createElement(AddCircleIcon, {
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 65,
          columnNumber: 11
        }
      })), /*#__PURE__*/React.createElement(MiradorMenuButton, {
        "aria-label": t('zoomOut'),
        onClick: this.handleZoomOutClick,
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 67,
          columnNumber: 9
        }
      }, /*#__PURE__*/React.createElement(RemoveCircleIcon, {
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 68,
          columnNumber: 11
        }
      })), /*#__PURE__*/React.createElement(MiradorMenuButton, {
        "aria-label": t('zoomReset'),
        onClick: function onClick() {
          return zoomToWorld(false);
        },
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 70,
          columnNumber: 9
        }
      }, /*#__PURE__*/React.createElement(RestoreZoomIcon, {
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 71,
          columnNumber: 11
        }
      })), displayDivider && /*#__PURE__*/React.createElement("span", {
        className: classes.divider,
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 73,
          columnNumber: 28
        }
      }));
    }
  }]);

  return ZoomControls;
}(Component);
ZoomControls.defaultProps = {
  displayDivider: true,
  showZoomControls: false,
  t: function t(key) {
    return key;
  },
  updateViewport: function updateViewport() {},
  viewer: {},
  windowId: ''
};