import { createSelector } from 'reselect';
import { getManifestTitle, getManifestViewingHint, getManifestoInstance } from './manifests';
import { getDefaultView } from './config';
import { getWorkspaceType } from './workspace';
/**
 * Return the manifest titles for all open windows
 * @param {object} state
 * @return {object}
 */

export function getWindowTitles(state) {
  var result = {};
  Object.keys(getWindows(state)).forEach(function (windowId) {
    result[windowId] = getManifestTitle(state, {
      windowId: windowId
    });
  });
  return result;
}
/**
 * Return the manifest titles for all open windows
 * @param {object} state
 * @return {object}
 */

export function getWindowManifests(state) {
  return Object.values(state.windows).map(function (window) {
    return window.manifestId;
  });
}
/** */

export function getWindows(state) {
  return state.windows || {};
}
/** */

export var getWindowIds = createSelector([getWindows], function (windows) {
  return Object.keys(windows);
});
/** */

export var getMaximizedWindowsIds = createSelector([getWindows], function (windows) {
  return Object.values(windows).filter(function (window) {
    return window.maximized === true;
  }).map(function (window) {
    return window.id;
  });
});
/** */

export function getWindow(state, _ref) {
  var windowId = _ref.windowId;
  return getWindows(state)[windowId];
}
/** Return the canvas index for a certain window.
* @param {object} state
* @param {String} windowId
* @param {Number}
*/

export var getCanvasIndex = createSelector([getWindow, getManifestoInstance], function (window, manifest) {
  return (manifest && window && window.canvasId && manifest.getSequences()[0].getCanvasById(window.canvasId) || {}).index || 0;
});
/** Return type of view in a certain window.
* @param {object} state
* @param {object} props
* @param {string} props.manifestId
* @param {string} props.windowId
* @param {String}
*/

export var getWindowViewType = createSelector([getWindow, getManifestViewingHint, getDefaultView], function (window, manifestViewingHint, defaultView) {
  var lookup = {
    individuals: 'single',
    paged: 'book'
  };
  return window && window.view || lookup[manifestViewingHint] || defaultView;
});
export var getViewer = createSelector([function (state) {
  return state.viewers;
}, function (state, _ref2) {
  var windowId = _ref2.windowId;
  return windowId;
}], function (viewers, windowId) {
  return viewers[windowId];
});
/**
 * Returns the draggability of a window
 * @param {object} state
 * @param {object} props
 * @return {Boolean}
 */

export var getWindowDraggability = createSelector([getWorkspaceType, getWindow, function (state) {
  return Object.keys(state.windows).length > 1;
}], function (workspaceType, window, manyWindows) {
  if (workspaceType === 'elastic') return true;
  return manyWindows && window && window.maximized === false;
});