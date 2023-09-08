"use strict";

Object.defineProperty(exports, "__esModule", {
  value: true
});
exports.getCompanionWindows = getCompanionWindows;
exports.selectCompanionWindowDimensions = exports.getCompanionAreaVisibility = exports.getCompanionWindowIdsForPosition = exports.getCompanionWindowsForPosition = exports.getCompanionWindow = exports.getThumbnailNavigationPosition = void 0;

var _reselect = require("reselect");

var _groupBy = _interopRequireDefault(require("lodash/groupBy"));

var _windows = require("./windows");

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { "default": obj }; }

function _toConsumableArray(arr) { return _arrayWithoutHoles(arr) || _iterableToArray(arr) || _unsupportedIterableToArray(arr) || _nonIterableSpread(); }

function _nonIterableSpread() { throw new TypeError("Invalid attempt to spread non-iterable instance.\nIn order to be iterable, non-array objects must have a [Symbol.iterator]() method."); }

function _unsupportedIterableToArray(o, minLen) { if (!o) return; if (typeof o === "string") return _arrayLikeToArray(o, minLen); var n = Object.prototype.toString.call(o).slice(8, -1); if (n === "Object" && o.constructor) n = o.constructor.name; if (n === "Map" || n === "Set") return Array.from(n); if (n === "Arguments" || /^(?:Ui|I)nt(?:8|16|32)(?:Clamped)?Array$/.test(n)) return _arrayLikeToArray(o, minLen); }

function _iterableToArray(iter) { if (typeof Symbol !== "undefined" && Symbol.iterator in Object(iter)) return Array.from(iter); }

function _arrayWithoutHoles(arr) { if (Array.isArray(arr)) return _arrayLikeToArray(arr); }

function _arrayLikeToArray(arr, len) { if (len == null || len > arr.length) len = arr.length; for (var i = 0, arr2 = new Array(len); i < len; i++) { arr2[i] = arr[i]; } return arr2; }

function ownKeys(object, enumerableOnly) { var keys = Object.keys(object); if (Object.getOwnPropertySymbols) { var symbols = Object.getOwnPropertySymbols(object); if (enumerableOnly) symbols = symbols.filter(function (sym) { return Object.getOwnPropertyDescriptor(object, sym).enumerable; }); keys.push.apply(keys, symbols); } return keys; }

function _objectSpread(target) { for (var i = 1; i < arguments.length; i++) { var source = arguments[i] != null ? arguments[i] : {}; if (i % 2) { ownKeys(Object(source), true).forEach(function (key) { _defineProperty(target, key, source[key]); }); } else if (Object.getOwnPropertyDescriptors) { Object.defineProperties(target, Object.getOwnPropertyDescriptors(source)); } else { ownKeys(Object(source)).forEach(function (key) { Object.defineProperty(target, key, Object.getOwnPropertyDescriptor(source, key)); }); } } return target; }

function _defineProperty(obj, key, value) { if (key in obj) { Object.defineProperty(obj, key, { value: value, enumerable: true, configurable: true, writable: true }); } else { obj[key] = value; } return obj; }

/** */
function getCompanionWindows(state) {
  return state.companionWindows;
}
/** Return position of thumbnail navigation in a certain window.
* @param {object} state
* @param {String} windowId
* @param {String}
*/


var getThumbnailNavigationPosition = (0, _reselect.createSelector)([_windows.getWindow, function (state) {
  return state.companionWindows;
}], function (window, companionWindows) {
  return window && companionWindows[window.thumbnailNavigationId] && companionWindows[window.thumbnailNavigationId].position;
});
/**
* Return compantion window ids from a window
* @param {String} windowId
* @return {Array}
*/

exports.getThumbnailNavigationPosition = getThumbnailNavigationPosition;
var getCompanionWindowIndexByWindowAndPosition = (0, _reselect.createSelector)([_windows.getWindows, getCompanionWindows], function (windows, companionWindows) {
  return (Object.keys(windows) || []).reduce(function (obj, id) {
    return _objectSpread({}, obj, _defineProperty({}, id, (0, _groupBy["default"])(windows[id].companionWindowIds, function (cwid) {
      return companionWindows[cwid] && companionWindows[cwid].position;
    })));
  }, {});
});
/**
* Return compantion window ids from a window
* @param {String} windowId
* @return {Array}
*/

var getCompanionWindowsByWindowAndPosition = (0, _reselect.createSelector)([_windows.getWindows, getCompanionWindows], function (windows, companionWindows) {
  return (Object.keys(windows) || []).reduce(function (obj, id) {
    return _objectSpread({}, obj, _defineProperty({}, id, (0, _groupBy["default"])(windows[id].companionWindowIds.map(function (cwid) {
      return companionWindows[cwid];
    }), function (cw) {
      return cw.position;
    })));
  }, {});
});
var getCompanionWindow = (0, _reselect.createSelector)([getCompanionWindows, function (state, _ref) {
  var companionWindowId = _ref.companionWindowId;
  return companionWindowId;
}], function (companionWindows, companionWindowId) {
  return companionWindows[companionWindowId];
});
/**
 * Return companion windows of a window
 * @param {String} windowId
 * @return {Array}
 */

exports.getCompanionWindow = getCompanionWindow;
var getCompanionWindowsOfWindow = (0, _reselect.createSelector)([function (state, _ref2) {
  var windowId = _ref2.windowId;
  return windowId;
}, getCompanionWindowsByWindowAndPosition], function (windowId, companionWindows) {
  return companionWindows[windowId] || {};
});
/**
 * Return companion windows of a window
 * @param {String} windowId
 * @return {Array}
 */

var getCompanionWindowIdsOfWindow = (0, _reselect.createSelector)([function (state, _ref3) {
  var windowId = _ref3.windowId;
  return windowId;
}, getCompanionWindowIndexByWindowAndPosition], function (windowId, companionWindowIds) {
  return companionWindowIds[windowId] || {};
});
/**
* Return the companion window string from state in a given windowId and position
* @param {object} state
* @param {String} windowId
* @param {String} position
* @return {String}
*/

var getCompanionWindowsForPosition = (0, _reselect.createSelector)([getCompanionWindowsOfWindow, function (state, _ref4) {
  var position = _ref4.position;
  return {
    position: position
  };
}], function (companionWindows, _ref5) {
  var position = _ref5.position;
  return companionWindows[position] || EMPTY_ARRAY;
});
exports.getCompanionWindowsForPosition = getCompanionWindowsForPosition;
var EMPTY_ARRAY = [];
/** */

var getCompanionWindowIdsForPosition = (0, _reselect.createSelector)([getCompanionWindowIdsOfWindow, function (state, _ref6) {
  var position = _ref6.position;
  return {
    position: position
  };
}], function (companionWindowIds, _ref7) {
  var position = _ref7.position;
  return companionWindowIds[position] || EMPTY_ARRAY;
});
/**
 * Returns the visibility of the companion area
 * @param {object} state
 * @param {object} props
 * @return {Boolean}
 */

exports.getCompanionWindowIdsForPosition = getCompanionWindowIdsForPosition;
var getCompanionAreaVisibility = (0, _reselect.createSelector)([function (state, _ref8) {
  var position = _ref8.position;
  return position;
}, _windows.getWindow], function (position, window) {
  if (!window) return false;
  var companionAreaOpen = window.companionAreaOpen,
      sideBarOpen = window.sideBarOpen;
  if (position !== 'left') return true;
  return !!(companionAreaOpen && sideBarOpen);
});
exports.getCompanionAreaVisibility = getCompanionAreaVisibility;
var selectCompanionWindowDimensions = (0, _reselect.createSelector)([getCompanionWindowsOfWindow], function (companionWindows) {
  var _ref9;

  var width = 0;
  var height = 0;

  (_ref9 = []).concat.apply(_ref9, _toConsumableArray(Object.values(companionWindows))).forEach(function (cw) {
    if (cw.position.match(/right/)) {
      width += 235;
    }

    if (cw.position.match(/bottom/)) {
      height += 201;
    }
  });

  return {
    height: height,
    width: width
  };
});
exports.selectCompanionWindowDimensions = selectCompanionWindowDimensions;