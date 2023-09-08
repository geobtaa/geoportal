var _jsxFileName = "/Users/pjreed/dev/mirador/dist/es/src/components/SidebarIndexThumbnail.js";

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
import classNames from 'classnames';
import ManifestoCanvas from '../lib/ManifestoCanvas';
import { CanvasThumbnail } from './CanvasThumbnail';
/** */

export var SidebarIndexThumbnail = /*#__PURE__*/function (_Component) {
  _inherits(SidebarIndexThumbnail, _Component);

  var _super = _createSuper(SidebarIndexThumbnail);

  function SidebarIndexThumbnail() {
    _classCallCheck(this, SidebarIndexThumbnail);

    return _super.apply(this, arguments);
  }

  _createClass(SidebarIndexThumbnail, [{
    key: "render",

    /** */
    value: function render() {
      var _this$props = this.props,
          classes = _this$props.classes,
          config = _this$props.config,
          otherCanvas = _this$props.otherCanvas,
          canvas = _this$props.canvas;
      var _config$canvasNavigat = config.canvasNavigation,
          width = _config$canvasNavigat.width,
          height = _config$canvasNavigat.height;
      var manifestoCanvas = new ManifestoCanvas(otherCanvas);
      return /*#__PURE__*/React.createElement(React.Fragment, null, /*#__PURE__*/React.createElement("div", {
        style: {
          minWidth: 50
        },
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 21,
          columnNumber: 9
        }
      }, /*#__PURE__*/React.createElement(CanvasThumbnail, {
        className: classNames(classes.clickable),
        isValid: manifestoCanvas.hasValidDimensions,
        imageUrl: manifestoCanvas.thumbnail(width, height),
        maxHeight: config.canvasNavigation.height,
        maxWidth: config.canvasNavigation.width,
        aspectRatio: manifestoCanvas.aspectRatio,
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 22,
          columnNumber: 11
        }
      })), /*#__PURE__*/React.createElement(Typography, {
        className: classNames(classes.label),
        variant: "body1",
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 31,
          columnNumber: 9
        }
      }, canvas.label));
    }
  }]);

  return SidebarIndexThumbnail;
}(Component);