"use strict";

Object.defineProperty(exports, "__esModule", {
  value: true
});
exports.MosaicRenderPreview = MosaicRenderPreview;

var _react = _interopRequireDefault(require("react"));

var _classnames = _interopRequireDefault(require("classnames"));

var _jsxFileName = "/Users/pjreed/dev/mirador/dist/cjs/src/components/MosaicRenderPreview.js";

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { "default": obj }; }

/**
 * MosaicRenderPreview is used to for the preview when dragging a mosaic window/tile
*/
function MosaicRenderPreview(props) {
  var classes = props.classes,
      t = props.t,
      title = props.title;
  return /*#__PURE__*/_react["default"].createElement("div", {
    className: (0, _classnames["default"])('mosaic-window-body', classes.preview),
    __self: this,
    __source: {
      fileName: _jsxFileName,
      lineNumber: 14,
      columnNumber: 5
    }
  }, t('previewWindowTitle', {
    title: title
  }));
}

MosaicRenderPreview.defaultProps = {
  classes: {},
  t: function t(k) {
    return k;
  },
  title: ''
};