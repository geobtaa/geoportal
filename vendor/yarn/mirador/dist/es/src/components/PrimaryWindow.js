var _jsxFileName = "/Users/pjreed/dev/mirador/dist/es/src/components/PrimaryWindow.js";

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
import classNames from 'classnames';
import WindowSideBar from '../containers/WindowSideBar';
import WindowViewer from '../containers/WindowViewer';
import GalleryView from '../containers/GalleryView';
import CompanionArea from '../containers/CompanionArea';
import ns from '../config/css-ns';
/**
 * WindowMiddleContent - component that renders the "middle" area of the
 * Mirador Window
 */

export var PrimaryWindow = /*#__PURE__*/function (_Component) {
  _inherits(PrimaryWindow, _Component);

  var _super = _createSuper(PrimaryWindow);

  function PrimaryWindow() {
    _classCallCheck(this, PrimaryWindow);

    return _super.apply(this, arguments);
  }

  _createClass(PrimaryWindow, [{
    key: "renderViewer",

    /**
     * renderViewer
     *
     * @return {(String|null)}
     */
    value: function renderViewer() {
      var _this$props = this.props,
          manifest = _this$props.manifest,
          view = _this$props.view,
          windowId = _this$props.windowId;

      if (manifest && manifest.isFetching === false) {
        if (view === 'gallery') {
          return /*#__PURE__*/React.createElement(GalleryView, {
            windowId: windowId,
            __self: this,
            __source: {
              fileName: _jsxFileName,
              lineNumber: 25,
              columnNumber: 11
            }
          });
        }

        return /*#__PURE__*/React.createElement(WindowViewer, {
          windowId: windowId,
          __self: this,
          __source: {
            fileName: _jsxFileName,
            lineNumber: 31,
            columnNumber: 9
          }
        });
      }

      return null;
    }
    /**
     * Render the component
     */

  }, {
    key: "render",
    value: function render() {
      var _this$props2 = this.props,
          windowId = _this$props2.windowId,
          classes = _this$props2.classes;
      return /*#__PURE__*/React.createElement("div", {
        className: classNames(ns('primary-window'), classes.primaryWindow),
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 45,
          columnNumber: 7
        }
      }, /*#__PURE__*/React.createElement(WindowSideBar, {
        windowId: windowId,
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 46,
          columnNumber: 9
        }
      }), /*#__PURE__*/React.createElement(CompanionArea, {
        windowId: windowId,
        position: "left",
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 47,
          columnNumber: 9
        }
      }), this.renderViewer());
    }
  }]);

  return PrimaryWindow;
}(Component);
PrimaryWindow.defaultProps = {
  manifest: null,
  view: undefined
};