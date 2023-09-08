"use strict";

Object.defineProperty(exports, "__esModule", {
  value: true
});
exports["default"] = void 0;

var _redux = require("redux");

var _styles = require("@material-ui/core/styles");

var _withPlugins = require("../extend/withPlugins");

var _PrimaryWindow = require("../components/PrimaryWindow");

var styles = {
  primaryWindow: {
    display: 'flex',
    flex: 1,
    position: 'relative'
  }
};
var enhance = (0, _redux.compose)((0, _styles.withStyles)(styles), (0, _withPlugins.withPlugins)('PrimaryWindow'));

var _default = enhance(_PrimaryWindow.PrimaryWindow);

exports["default"] = _default;