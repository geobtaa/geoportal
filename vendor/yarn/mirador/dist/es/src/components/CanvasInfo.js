var _jsxFileName = "/Users/pjreed/dev/mirador/dist/es/src/components/CanvasInfo.js";

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
import CollapsibleSection from '../containers/CollapsibleSection';
import SanitizedHtml from '../containers/SanitizedHtml';
import { LabelValueMetadata } from './LabelValueMetadata';
/**
 * CanvasInfo
 */

export var CanvasInfo = /*#__PURE__*/function (_Component) {
  _inherits(CanvasInfo, _Component);

  var _super = _createSuper(CanvasInfo);

  function CanvasInfo() {
    _classCallCheck(this, CanvasInfo);

    return _super.apply(this, arguments);
  }

  _createClass(CanvasInfo, [{
    key: "render",

    /**
     * render
     * @return
     */
    value: function render() {
      var _this$props = this.props,
          canvasDescription = _this$props.canvasDescription,
          canvasLabel = _this$props.canvasLabel,
          canvasMetadata = _this$props.canvasMetadata,
          id = _this$props.id,
          index = _this$props.index,
          t = _this$props.t,
          totalSize = _this$props.totalSize;
      return /*#__PURE__*/React.createElement(CollapsibleSection, {
        id: "".concat(id, "-currentItem-").concat(index),
        label: t('currentItem', {
          context: "".concat(index + 1, "/").concat(totalSize)
        }),
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 29,
          columnNumber: 7
        }
      }, /*#__PURE__*/React.createElement(React.Fragment, null, canvasLabel && /*#__PURE__*/React.createElement(Typography, {
        "aria-labelledby": "".concat(id, "-currentItem-").concat(index, " ").concat(id, "-currentItem-").concat(index, "-heading"),
        id: "".concat(id, "-currentItem-").concat(index, "-heading"),
        variant: "h4",
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 35,
          columnNumber: 13
        }
      }, canvasLabel), canvasDescription && /*#__PURE__*/React.createElement(Typography, {
        variant: "body1",
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 47,
          columnNumber: 13
        }
      }, /*#__PURE__*/React.createElement(SanitizedHtml, {
        htmlString: canvasDescription,
        ruleSet: "iiif",
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 48,
          columnNumber: 15
        }
      })), canvasMetadata.length > 0 && /*#__PURE__*/React.createElement(LabelValueMetadata, {
        labelValuePairs: canvasMetadata,
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 53,
          columnNumber: 13
        }
      })));
    }
  }]);

  return CanvasInfo;
}(Component);
CanvasInfo.defaultProps = {
  canvasDescription: null,
  canvasLabel: null,
  canvasMetadata: [],
  index: 1,
  t: function t(key) {
    return key;
  },
  totalSize: 1
};