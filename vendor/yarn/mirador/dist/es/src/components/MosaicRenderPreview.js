var _jsxFileName = "/Users/pjreed/dev/mirador/dist/es/src/components/MosaicRenderPreview.js";
import React from 'react';
import classNames from 'classnames';
/**
 * MosaicRenderPreview is used to for the preview when dragging a mosaic window/tile
*/

export function MosaicRenderPreview(props) {
  var classes = props.classes,
      t = props.t,
      title = props.title;
  return /*#__PURE__*/React.createElement("div", {
    className: classNames('mosaic-window-body', classes.preview),
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