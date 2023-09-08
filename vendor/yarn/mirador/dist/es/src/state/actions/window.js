function ownKeys(object, enumerableOnly) { var keys = Object.keys(object); if (Object.getOwnPropertySymbols) { var symbols = Object.getOwnPropertySymbols(object); if (enumerableOnly) symbols = symbols.filter(function (sym) { return Object.getOwnPropertyDescriptor(object, sym).enumerable; }); keys.push.apply(keys, symbols); } return keys; }

function _objectSpread(target) { for (var i = 1; i < arguments.length; i++) { var source = arguments[i] != null ? arguments[i] : {}; if (i % 2) { ownKeys(Object(source), true).forEach(function (key) { _defineProperty(target, key, source[key]); }); } else if (Object.getOwnPropertyDescriptors) { Object.defineProperties(target, Object.getOwnPropertyDescriptors(source)); } else { ownKeys(Object(source)).forEach(function (key) { Object.defineProperty(target, key, Object.getOwnPropertyDescriptor(source, key)); }); } } return target; }

function _defineProperty(obj, key, value) { if (key in obj) { Object.defineProperty(obj, key, { value: value, enumerable: true, configurable: true, writable: true }); } else { obj[key] = value; } return obj; }

function _toConsumableArray(arr) { return _arrayWithoutHoles(arr) || _iterableToArray(arr) || _unsupportedIterableToArray(arr) || _nonIterableSpread(); }

function _nonIterableSpread() { throw new TypeError("Invalid attempt to spread non-iterable instance.\nIn order to be iterable, non-array objects must have a [Symbol.iterator]() method."); }

function _unsupportedIterableToArray(o, minLen) { if (!o) return; if (typeof o === "string") return _arrayLikeToArray(o, minLen); var n = Object.prototype.toString.call(o).slice(8, -1); if (n === "Object" && o.constructor) n = o.constructor.name; if (n === "Map" || n === "Set") return Array.from(n); if (n === "Arguments" || /^(?:Ui|I)nt(?:8|16|32)(?:Clamped)?Array$/.test(n)) return _arrayLikeToArray(o, minLen); }

function _iterableToArray(iter) { if (typeof Symbol !== "undefined" && Symbol.iterator in Object(iter)) return Array.from(iter); }

function _arrayWithoutHoles(arr) { if (Array.isArray(arr)) return _arrayLikeToArray(arr); }

function _arrayLikeToArray(arr, len) { if (len == null || len > arr.length) len = arr.length; for (var i = 0, arr2 = new Array(len); i < len; i++) { arr2[i] = arr[i]; } return arr2; }

function _objectWithoutProperties(source, excluded) { if (source == null) return {}; var target = _objectWithoutPropertiesLoose(source, excluded); var key, i; if (Object.getOwnPropertySymbols) { var sourceSymbolKeys = Object.getOwnPropertySymbols(source); for (i = 0; i < sourceSymbolKeys.length; i++) { key = sourceSymbolKeys[i]; if (excluded.indexOf(key) >= 0) continue; if (!Object.prototype.propertyIsEnumerable.call(source, key)) continue; target[key] = source[key]; } } return target; }

function _objectWithoutPropertiesLoose(source, excluded) { if (source == null) return {}; var target = {}; var sourceKeys = Object.keys(source); var key, i; for (i = 0; i < sourceKeys.length; i++) { key = sourceKeys[i]; if (excluded.indexOf(key) >= 0) continue; target[key] = source[key]; } return target; }

import uuid from 'uuid/v4';
import ActionTypes from './action-types';
/**
 * focusWindow - action creator
 *
 * @param  {String} windowId
 * @memberof ActionCreators
 */

export function focusWindow(windowId) {
  var pan = arguments.length > 1 && arguments[1] !== undefined ? arguments[1] : false;
  return function (dispatch, getState) {
    var _getState = getState(),
        elasticLayout = _getState.elasticLayout,
        workspace = _getState.workspace;

    var position;

    if (pan) {
      var _elasticLayout$window = elasticLayout[windowId],
          x = _elasticLayout$window.x,
          y = _elasticLayout$window.y,
          width = _elasticLayout$window.width,
          height = _elasticLayout$window.height;
      var _workspace$viewportPo = workspace.viewportPosition,
          viewWidth = _workspace$viewportPo.width,
          viewHeight = _workspace$viewportPo.height;
      position = {
        x: x + width / 2 - viewWidth / 2,
        y: y + height / 2 - viewHeight / 2
      };
    } else {
      position = {};
    }

    dispatch({
      position: position,
      type: ActionTypes.FOCUS_WINDOW,
      windowId: windowId
    });
  };
}
/**
 * addWindow - action creator
 *
 * @param  {Object} options
 * @memberof ActionCreators
 */

export function addWindow(_ref) {
  var companionWindows = _ref.companionWindows,
      options = _objectWithoutProperties(_ref, ["companionWindows"]);

  return function (dispatch, getState) {
    var _getState2 = getState(),
        config = _getState2.config,
        windows = _getState2.windows;

    var numWindows = Object.keys(windows).length;
    var cwDefault = "cw-".concat(uuid());
    var cwThumbs = "cw-".concat(uuid());
    var additionalCompanionWindowIds = (companionWindows || []).map(function (e) {
      return "cw-".concat(uuid());
    });
    var defaultOptions = {
      canvasId: undefined,
      collectionIndex: 0,
      companionAreaOpen: true,
      companionWindowIds: [cwDefault, cwThumbs].concat(_toConsumableArray(additionalCompanionWindowIds)),
      displayAllAnnotations: config.displayAllAnnotations || false,
      draggingEnabled: true,
      id: "window-".concat(uuid()),
      layoutOrder: numWindows + 1,
      manifestId: null,
      maximized: false,
      rangeId: null,
      rotation: null,
      selectedAnnotations: {},
      sideBarOpen: config.window.sideBarOpenByDefault,
      sideBarPanel: config.window.defaultSideBarPanel,
      thumbnailNavigationId: cwThumbs
    };
    var elasticLayout = {
      height: 400,
      width: 400,
      x: 200 + (Math.floor(numWindows / 10) * 50 + numWindows * 30 % 300),
      y: 200 + numWindows * 50 % 300
    };
    dispatch({
      companionWindows: [{
        content: config.window.defaultSideBarPanel,
        "default": true,
        id: cwDefault,
        position: 'left'
      }, {
        content: 'thumbnailNavigation',
        "default": true,
        id: cwThumbs,
        position: options.thumbnailNavigationPosition || config.thumbnailNavigation.defaultPosition
      }].concat(_toConsumableArray((companionWindows || []).map(function (cw, i) {
        return _objectSpread({}, cw, {
          id: additionalCompanionWindowIds[i]
        });
      }))),
      elasticLayout: elasticLayout,
      type: ActionTypes.ADD_WINDOW,
      window: _objectSpread({}, defaultOptions, {}, options)
    });
  };
}
/**
 * maximizeWindow
 * @param  {String} windowId
 * @memberof ActionCreators
 */

export function maximizeWindow(windowId, layout) {
  return {
    type: ActionTypes.MAXIMIZE_WINDOW,
    windowId: windowId
  };
}
/**
 * minimizeWindow
 * @param  {String} windowId
 * @memberof ActionCreators
 */

export function minimizeWindow(windowId) {
  return {
    type: ActionTypes.MINIMIZE_WINDOW,
    windowId: windowId
  };
}
/** */

export function updateWindow(id, payload) {
  return {
    id: id,
    payload: payload,
    type: ActionTypes.UPDATE_WINDOW
  };
}
/** */

export function setCompanionAreaOpen(id, companionAreaOpen) {
  return {
    id: id,
    payload: {
      companionAreaOpen: companionAreaOpen
    },
    type: ActionTypes.UPDATE_WINDOW
  };
}
/**
 * removeWindow - action creator
 *
 * @param  {String} windowId
 * @memberof ActionCreators
 */

export function removeWindow(windowId) {
  return function (dispatch, getState) {
    var _getState3 = getState(),
        windows = _getState3.windows;

    var companionWindowIds = windows[windowId].companionWindowIds;
    dispatch({
      companionWindowIds: companionWindowIds,
      type: ActionTypes.REMOVE_WINDOW,
      windowId: windowId,
      windows: windows
    });
  };
}
/**
 * toggleWindowSideBar - action creator
 *
 * @param  {String} windowId
 * @memberof ActionCreators
 */

export function toggleWindowSideBar(windowId) {
  return {
    type: ActionTypes.TOGGLE_WINDOW_SIDE_BAR,
    windowId: windowId
  };
}
/**
 * setWindowThumbnailPosition - action creator
 *
 * @param  {String} windowId
 * @param  {String} position
 * @memberof ActionCreators
 */

export function setWindowThumbnailPosition(windowId, position) {
  return function (dispatch, getState) {
    var _getState4 = getState(),
        windows = _getState4.windows;

    var thumbnailNavigationId = windows[windowId].thumbnailNavigationId;
    dispatch({
      id: thumbnailNavigationId,
      payload: {
        position: position
      },
      type: ActionTypes.UPDATE_COMPANION_WINDOW
    });
  };
}
/**
 * setWindowViewType - action creator
 *
 * @param  {String} windowId
 * @param  {String} viewType
 * @memberof ActionCreators
 */

export function setWindowViewType(windowId, viewType) {
  return {
    type: ActionTypes.SET_WINDOW_VIEW_TYPE,
    viewType: viewType,
    windowId: windowId
  };
}