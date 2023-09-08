var _jsxFileName = "/Users/pjreed/dev/mirador/dist/es/src/components/CompanionWindowFactory.js";

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
import ThumbnailNavigation from '../containers/ThumbnailNavigation';
import WindowSideBarAnnotationsPanel from '../containers/WindowSideBarAnnotationsPanel';
import WindowSideBarInfoPanel from '../containers/WindowSideBarInfoPanel';
import WindowSideBarCanvasPanel from '../containers/WindowSideBarCanvasPanel';
import AttributionPanel from '../containers/AttributionPanel';
import SearchPanel from '../containers/SearchPanel';
import LayersPanel from '../containers/LayersPanel';
/**
 * Render a companion window using the appropriate component for the content
 */

export var CompanionWindowFactory = /*#__PURE__*/function (_Component) {
  _inherits(CompanionWindowFactory, _Component);

  var _super = _createSuper(CompanionWindowFactory);

  function CompanionWindowFactory() {
    _classCallCheck(this, CompanionWindowFactory);

    return _super.apply(this, arguments);
  }

  _createClass(CompanionWindowFactory, [{
    key: "render",

    /** */
    value: function render() {
      var _this$props = this.props,
          content = _this$props.content,
          windowId = _this$props.windowId,
          id = _this$props.id;

      switch (content) {
        case 'info':
          return /*#__PURE__*/React.createElement(WindowSideBarInfoPanel, {
            id: id,
            windowId: windowId,
            __self: this,
            __source: {
              fileName: _jsxFileName,
              lineNumber: 21,
              columnNumber: 17
            }
          });

        case 'canvas':
          return /*#__PURE__*/React.createElement(WindowSideBarCanvasPanel, {
            id: id,
            windowId: windowId,
            __self: this,
            __source: {
              fileName: _jsxFileName,
              lineNumber: 23,
              columnNumber: 17
            }
          });

        case 'annotations':
          return /*#__PURE__*/React.createElement(WindowSideBarAnnotationsPanel, {
            id: id,
            windowId: windowId,
            __self: this,
            __source: {
              fileName: _jsxFileName,
              lineNumber: 25,
              columnNumber: 16
            }
          });

        case 'thumbnailNavigation':
          return /*#__PURE__*/React.createElement(ThumbnailNavigation, {
            id: id,
            windowId: windowId,
            __self: this,
            __source: {
              fileName: _jsxFileName,
              lineNumber: 27,
              columnNumber: 16
            }
          });

        case 'attribution':
          return /*#__PURE__*/React.createElement(AttributionPanel, {
            id: id,
            windowId: windowId,
            __self: this,
            __source: {
              fileName: _jsxFileName,
              lineNumber: 29,
              columnNumber: 16
            }
          });

        case 'search':
          return /*#__PURE__*/React.createElement(SearchPanel, {
            id: id,
            windowId: windowId,
            __self: this,
            __source: {
              fileName: _jsxFileName,
              lineNumber: 31,
              columnNumber: 16
            }
          });

        case 'layers':
          return /*#__PURE__*/React.createElement(LayersPanel, {
            id: id,
            windowId: windowId,
            __self: this,
            __source: {
              fileName: _jsxFileName,
              lineNumber: 33,
              columnNumber: 16
            }
          });

        default:
          return /*#__PURE__*/React.createElement(React.Fragment, null);
      }
    }
  }]);

  return CompanionWindowFactory;
}(Component);
CompanionWindowFactory.defaultProps = {
  content: null
};