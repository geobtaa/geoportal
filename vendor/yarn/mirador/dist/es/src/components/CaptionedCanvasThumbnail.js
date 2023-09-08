var _jsxFileName = "/Users/pjreed/dev/mirador/dist/es/src/components/CaptionedCanvasThumbnail.js";

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
import ns from '../config/css-ns';
/** */

export var CaptionedCanvasThumbnail = /*#__PURE__*/function (_Component) {
  _inherits(CaptionedCanvasThumbnail, _Component);

  var _super = _createSuper(CaptionedCanvasThumbnail);

  function CaptionedCanvasThumbnail() {
    _classCallCheck(this, CaptionedCanvasThumbnail);

    return _super.apply(this, arguments);
  }

  _createClass(CaptionedCanvasThumbnail, [{
    key: "render",

    /** */
    value: function render() {
      var _this$props = this.props,
          canvas = _this$props.canvas,
          classes = _this$props.classes,
          height = _this$props.height;
      var manifestoCanvas = new ManifestoCanvas(canvas);
      return /*#__PURE__*/React.createElement("div", {
        key: canvas.id,
        className: classes.container,
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 16,
          columnNumber: 7
        }
      }, /*#__PURE__*/React.createElement(CanvasThumbnail, {
        imageUrl: manifestoCanvas.thumbnail(null, 200) // TODO: When we make these areas resizable, we should probably not hard code this
        ,
        isValid: manifestoCanvas.hasValidDimensions,
        maxHeight: height,
        style: {
          maxWidth: "".concat(Math.ceil(height * manifestoCanvas.aspectRatio), "px")
        },
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 20,
          columnNumber: 9
        }
      }), /*#__PURE__*/React.createElement("div", {
        className: classNames(ns('canvas-thumb-label'), classes.canvasThumbLabel),
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 31,
          columnNumber: 9
        }
      }, /*#__PURE__*/React.createElement("div", {
        style: {
          margin: '4px'
        },
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 34,
          columnNumber: 11
        }
      }, /*#__PURE__*/React.createElement(Typography, {
        classes: {
          root: classes.title
        },
        variant: "caption",
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 39,
          columnNumber: 13
        }
      }, manifestoCanvas.getLabel()))));
    }
  }]);

  return CaptionedCanvasThumbnail;
}(Component);