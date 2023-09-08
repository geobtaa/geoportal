"use strict";

Object.defineProperty(exports, "__esModule", {
  value: true
});
exports.getWindowTitles = getWindowTitles;
exports.getWindowManifests = getWindowManifests;
exports.getWindows = getWindows;
exports.getWindow = getWindow;
exports.getWindowDraggability = exports.getViewer = exports.getWindowViewType = exports.getCanvasIndex = exports.getMaximizedWindowsIds = exports.getWindowIds = void 0;

var _reselect = require("reselect");

var _manifests = require("./manifests");

var _config = require("./config");

var _workspace = require("./workspace");

/**
 * Return the manifest titles for all open windows
 * @param {object} state
 * @return {object}
 */
function getWindowTitles(state) {
  var result = {};
  Object.keys(getWindows(state)).forEach(function (windowId) {
    result[windowId] = (0, _manifests.getManifestTitle)(state, {
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


function getWindowManifests(state) {
  return Object.values(state.windows).map(function (window) {
    return window.manifestId;
  });
}
/** */


function getWindows(state) {
  return state.windows || {};
}
/** */


var getWindowIds = (0, _reselect.createSelector)([getWindows], function (windows) {
  return Object.keys(windows);
});
/** */

exports.getWindowIds = getWindowIds;
var getMaximizedWindowsIds = (0, _reselect.createSelector)([getWindows], function (windows) {
  return Object.values(windows).filter(function (window) {
    return window.maximized === true;
  }).map(function (window) {
    return window.id;
  });
});
/** */

exports.getMaximizedWindowsIds = getMaximizedWindowsIds;

function getWindow(state, _ref) {
  var windowId = _ref.windowId;
  return getWindows(state)[windowId];
}
/** Return the canvas index for a certain window.
* @param {object} state
* @param {String} windowId
* @param {Number}
*/


var getCanvasIndex = (0, _reselect.createSelector)([getWindow, _manifests.getManifestoInstance], function (window, manifest) {
  return (manifest && window && window.canvasId && manifest.getSequences()[0].getCanvasById(window.canvasId) || {}).index || 0;
});
/** Return type of view in a certain window.
* @param {object} state
* @param {object} props
* @param {string} props.manifestId
* @param {string} props.windowId
* @param {String}
*/

exports.getCanvasIndex = getCanvasIndex;
var getWindowViewType = (0, _reselect.createSelector)([getWindow, _manifests.getManifestViewingHint, _config.getDefaultView], function (window, manifestViewingHint, defaultView) {
  var lookup = {
    individuals: 'single',
    paged: 'book'
  };
  return window && window.view || lookup[manifestViewingHint] || defaultView;
});
exports.getWindowViewType = getWindowViewType;
var getViewer = (0, _reselect.createSelector)([function (state) {
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

exports.getViewer = getViewer;
var getWindowDraggability = (0, _reselect.createSelector)([_workspace.getWorkspaceType, getWindow, function (state) {
  return Object.keys(state.windows).length > 1;
}], function (workspaceType, window, manyWindows) {
  if (workspaceType === 'elastic') return true;
  return manyWindows && window && window.maximized === false;
});
exports.getWindowDraggability = getWindowDraggability;