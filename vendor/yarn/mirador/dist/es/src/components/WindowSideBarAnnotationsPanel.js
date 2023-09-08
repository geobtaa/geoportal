var _jsxFileName = "/Users/pjreed/dev/mirador/dist/es/src/components/WindowSideBarAnnotationsPanel.js";

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
import Typography from '@material-ui/core/Typography';
import AnnotationSettings from '../containers/AnnotationSettings';
import CanvasAnnotations from '../containers/CanvasAnnotations';
import CompanionWindow from '../containers/CompanionWindow';
import ns from '../config/css-ns';
/**
 * WindowSideBarAnnotationsPanel ~
*/

export var WindowSideBarAnnotationsPanel = /*#__PURE__*/function (_Component) {
  _inherits(WindowSideBarAnnotationsPanel, _Component);

  var _super = _createSuper(WindowSideBarAnnotationsPanel);

  function WindowSideBarAnnotationsPanel() {
    _classCallCheck(this, WindowSideBarAnnotationsPanel);

    return _super.apply(this, arguments);
  }

  _createClass(WindowSideBarAnnotationsPanel, [{
    key: "render",

    /**
     * Returns the rendered component
    */
    value: function render() {
      var _this = this;

      var _this$props = this.props,
          annotationCount = _this$props.annotationCount,
          classes = _this$props.classes,
          selectedCanvases = _this$props.selectedCanvases,
          t = _this$props.t,
          windowId = _this$props.windowId,
          id = _this$props.id;
      return /*#__PURE__*/React.createElement(CompanionWindow, {
        title: t('annotations'),
        paperClassName: ns('window-sidebar-annotation-panel'),
        windowId: windowId,
        id: id,
        titleControls: /*#__PURE__*/React.createElement(AnnotationSettings, {
          windowId: windowId,
          __self: this,
          __source: {
            fileName: _jsxFileName,
            lineNumber: 26,
            columnNumber: 24
          }
        }),
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 21,
          columnNumber: 7
        }
      }, /*#__PURE__*/React.createElement("div", {
        className: classes.section,
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 28,
          columnNumber: 9
        }
      }, /*#__PURE__*/React.createElement(Typography, {
        component: "p",
        variant: "subtitle2",
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 29,
          columnNumber: 11
        }
      }, t('showingNumAnnotations', {
        number: annotationCount
      }))), selectedCanvases.map(function (canvas, index) {
        return /*#__PURE__*/React.createElement(CanvasAnnotations, {
          canvasId: canvas.id,
          key: canvas.id,
          index: index,
          totalSize: selectedCanvases.length,
          windowId: windowId,
          __self: _this,
          __source: {
            fileName: _jsxFileName,
            lineNumber: 33,
            columnNumber: 11
          }
        });
      }));
    }
  }]);

  return WindowSideBarAnnotationsPanel;
}(Component);
WindowSideBarAnnotationsPanel.defaultProps = {
  selectedCanvases: [],
  t: function t(key) {
    return key;
  }
};