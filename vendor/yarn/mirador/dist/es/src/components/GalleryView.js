var _jsxFileName = "/Users/pjreed/dev/mirador/dist/es/src/components/GalleryView.js";

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
import Paper from '@material-ui/core/Paper';
import GalleryViewThumbnail from '../containers/GalleryViewThumbnail';
/**
 * Renders a GalleryView overview of the manifest.
 */

export var GalleryView = /*#__PURE__*/function (_Component) {
  _inherits(GalleryView, _Component);

  var _super = _createSuper(GalleryView);

  function GalleryView() {
    _classCallCheck(this, GalleryView);

    return _super.apply(this, arguments);
  }

  _createClass(GalleryView, [{
    key: "render",

    /**
     * Renders things
     */
    value: function render() {
      var _this = this;

      var _this$props = this.props,
          canvases = _this$props.canvases,
          classes = _this$props.classes,
          viewingDirection = _this$props.viewingDirection,
          windowId = _this$props.windowId;
      var htmlDir = viewingDirection === 'right-to-left' ? 'rtl' : 'ltr';
      return /*#__PURE__*/React.createElement(Paper, {
        component: "section",
        dir: htmlDir,
        square: true,
        elevation: 0,
        className: classes.galleryContainer,
        id: "".concat(windowId, "-gallery"),
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 19,
          columnNumber: 7
        }
      }, canvases.map(function (canvas) {
        return /*#__PURE__*/React.createElement(GalleryViewThumbnail, {
          key: canvas.id,
          windowId: windowId,
          canvas: canvas,
          __self: _this,
          __source: {
            fileName: _jsxFileName,
            lineNumber: 29,
            columnNumber: 13
          }
        });
      }));
    }
  }]);

  return GalleryView;
}(Component);
GalleryView.defaultProps = {
  classes: {},
  viewingDirection: ''
};