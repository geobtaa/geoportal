import { createSelector } from 'reselect';
import deepmerge from 'deepmerge';
/** */

function getConfig(state) {
  return state.config || {};
}
/**
* Return languages from config (in state) and indicate which is currently set
* @param {object} state
* @return {Array} [ {locale: 'de', label: 'Deutsch', current: true}, ... ]
*/


export var getLanguagesFromConfigWithCurrent = createSelector([getConfig], function (_ref) {
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
export var getShowZoomControlsConfig = createSelector([function (state) {
  return state.workspace;
}, getConfig], function (workspace, config) {
  return workspace.showZoomControls === undefined ? config.workspace.showZoomControls : workspace.showZoomControls;
});
export var getTheme = createSelector([getConfig], function (_ref2) {
  var theme = _ref2.theme,
      themes = _ref2.themes,
      selectedTheme = _ref2.selectedTheme;
  return deepmerge(theme, themes[selectedTheme] || {});
});
export var getThemeIds = createSelector([getConfig], function (_ref3) {
  var themes = _ref3.themes;
  return Object.keys(themes);
});
export var getContainerId = createSelector([getConfig], function (_ref4) {
  var id = _ref4.id;
  return id;
});
export var getDefaultView = createSelector([getConfig], function (_ref5) {
  var window = _ref5.window;
  return window && window.defaultView;
});
export var getThemeDirection = createSelector([getConfig], function (_ref6) {
  var theme = _ref6.theme;
  return theme.direction || 'ltr';
});