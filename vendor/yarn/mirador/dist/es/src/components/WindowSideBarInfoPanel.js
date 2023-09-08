var _jsxFileName = "/Users/pjreed/dev/mirador/dist/es/src/components/WindowSideBarInfoPanel.js";

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
import CompanionWindow from '../containers/CompanionWindow';
import CanvasInfo from '../containers/CanvasInfo';
import LocalePicker from '../containers/LocalePicker';
import ManifestInfo from '../containers/ManifestInfo';
import ManifestRelatedLinks from '../containers/ManifestRelatedLinks';
import ns from '../config/css-ns';
/**
 * WindowSideBarInfoPanel
 */

export var WindowSideBarInfoPanel = /*#__PURE__*/function (_Component) {
  _inherits(WindowSideBarInfoPanel, _Component);

  var _super = _createSuper(WindowSideBarInfoPanel);

  function WindowSideBarInfoPanel() {
    _classCallCheck(this, WindowSideBarInfoPanel);

    return _super.apply(this, arguments);
  }

  _createClass(WindowSideBarInfoPanel, [{
    key: "render",

    /**
     * render
     * @return
     */
    value: function render() {
      var _this = this;

      var _this$props = this.props,
          windowId = _this$props.windowId,
          id = _this$props.id,
          classes = _this$props.classes,
          t = _this$props.t,
          locale = _this$props.locale,
          selectedCanvases = _this$props.selectedCanvases,
          setLocale = _this$props.setLocale,
          availableLocales = _this$props.availableLocales,
          showLocalePicker = _this$props.showLocalePicker;
      return /*#__PURE__*/React.createElement(CompanionWindow, {
        title: t('aboutThisItem'),
        paperClassName: ns('window-sidebar-info-panel'),
        windowId: windowId,
        id: id,
        titleControls: showLocalePicker && /*#__PURE__*/React.createElement(LocalePicker, {
          locale: locale,
          setLocale: setLocale,
          availableLocales: availableLocales,
          __self: this,
          __source: {
            fileName: _jsxFileName,
            lineNumber: 41,
            columnNumber: 13
          }
        }),
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 33,
          columnNumber: 7
        }
      }, selectedCanvases.map(function (canvas, index) {
        return /*#__PURE__*/React.createElement("div", {
          key: canvas.id,
          className: classes.section,
          __self: _this,
          __source: {
            fileName: _jsxFileName,
            lineNumber: 51,
            columnNumber: 13
          }
        }, /*#__PURE__*/React.createElement(CanvasInfo, {
          id: id,
          canvasId: canvas.id,
          index: index,
          totalSize: selectedCanvases.length,
          windowId: windowId,
          __self: _this,
          __source: {
            fileName: _jsxFileName,
            lineNumber: 52,
            columnNumber: 15
          }
        }));
      }), /*#__PURE__*/React.createElement("div", {
        className: classes.section,
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 63,
          columnNumber: 9
        }
      }, /*#__PURE__*/React.createElement(ManifestInfo, {
        id: id,
        windowId: windowId,
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 64,
          columnNumber: 11
        }
      })), /*#__PURE__*/React.createElement("div", {
        className: classes.section,
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 67,
          columnNumber: 9
        }
      }, /*#__PURE__*/React.createElement(ManifestRelatedLinks, {
        id: id,
        windowId: windowId,
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 68,
          columnNumber: 11
        }
      })));
    }
  }]);

  return WindowSideBarInfoPanel;
}(Component);
WindowSideBarInfoPanel.defaultProps = {
  availableLocales: [],
  classes: {},
  locale: '',
  selectedCanvases: [],
  setLocale: undefined,
  showLocalePicker: false,
  t: function t(key) {
    return key;
  }
};