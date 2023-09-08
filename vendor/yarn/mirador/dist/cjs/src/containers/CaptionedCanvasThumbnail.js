"use strict";

Object.defineProperty(exports, "__esModule", {
  value: true
});
exports["default"] = void 0;

var _redux = require("redux");

var _reactI18next = require("react-i18next");

var _styles = require("@material-ui/core/styles");

var _withPlugins = require("../extend/withPlugins");

var _CaptionedCanvasThumbnail = require("../components/CaptionedCanvasThumbnail");

/**
 * Styles for withStyles HOC
 */
var styles = function styles(theme) {
  return {
    canvasThumbLabel: {
      background: 'linear-gradient(to top, rgba(0,0,0,0.7) 0%, rgba(0,0,0,0.3) 70%, rgba(0,0,0,0) 100%)',
      bottom: '5px',
      left: '0px',
      overflow: 'hidden',
      position: 'absolute',
      textOverflow: 'ellipsis',
      whiteSpace: 'nowrap',
      width: '100%'
    },
    container: {
      display: 'inline-block',
      height: 'inherit',
      position: 'relative'
    },
    root: {
      background: 'linear-gradient(to top, rgba(0,0,0,0.7) 0%, rgba(0,0,0,0.3) 70%, rgba(0,0,0,0) 100%)'
    },
    title: {
      color: '#ffffff'
    }
  };
};

var enhance = (0, _redux.compose)((0, _styles.withStyles)(styles), (0, _reactI18next.withTranslation)(), (0, _withPlugins.withPlugins)('CaptionedCanvasThumbnail'));

var _default = enhance(_CaptionedCanvasThumbnail.CaptionedCanvasThumbnail);

exports["default"] = _default;