"use strict";

Object.defineProperty(exports, "__esModule", {
  value: true
});
exports.getThemeDirection = exports.getDefaultView = exports.getContainerId = exports.getThemeIds = exports.getTheme = exports.getShowZoomControlsConfig = exports.getLanguagesFromConfigWithCurrent = void 0;

var _reselect = require("reselect");

var _deepmerge = _interopRequireDefault(require("deepmerge"));

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { "default": obj }; }

/** */
function getConfig(state) {
  return state.config || {};
}
/**
* Return languages from config (in state) and indicate which is currently set
* @param {object} state
* @return {Array} [ {locale: 'de', label: 'Deutsch', current: true}, ... ]
*/


var getLanguagesFromConfigWithCurrent = (0, _reselect.createSelector)([getConfig], function (_ref) {
  var availableLanguages = _ref.availableLanguages,
      language = _ref.language;
  return Object.keys(availableLanguages).map(function (key) {
    return {
      current: key === language,
      label: availableLanguages[key],
      locale: key
    };
  });
});
exports.getLanguagesFromConfigWithCurrent = getLanguagesFromConfigWithCurrent;
var getShowZoomControlsConfig = (0, _reselect.createSelector)([function (state) {
  return state.workspace;
}, getConfig], function (workspace, config) {
  return workspace.showZoomControls === undefined ? config.workspace.showZoomControls : workspace.showZoomControls;
});
exports.getShowZoomControlsConfig = getShowZoomControlsConfig;
var getTheme = (0, _reselect.createSelector)([getConfig], function (_ref2) {
  var theme = _ref2.theme,
      themes = _ref2.themes,
      selectedTheme = _ref2.selectedTheme;
  return (0, _deepmerge["default"])(theme, themes[selectedTheme] || {});
});
exports.getTheme = getTheme;
var getThemeIds = (0, _reselect.createSelector)([getConfig], function (_ref3) {
  var themes = _ref3.themes;
  return Object.keys(themes);
});
exports.getThemeIds = getThemeIds;
var getContainerId = (0, _reselect.createSelector)([getConfig], function (_ref4) {
  var id = _ref4.id;
  return id;
});
exports.getContainerId = getContainerId;
var getDefaultView = (0, _reselect.createSelector)([getConfig], function (_ref5) {
  var window = _ref5.window;
  return window && window.defaultView;
});
exports.getDefaultView = getDefaultView;
var getThemeDirection = (0, _reselect.createSelector)([getConfig], function (_ref6) {
  var theme = _ref6.theme;
  return theme.direction || 'ltr';
});
exports.getThemeDirection = getThemeDirection;