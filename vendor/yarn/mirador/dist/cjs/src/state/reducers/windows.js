"use strict";

Object.defineProperty(exports, "__esModule", {
  value: true
});
exports.windowsReducer = void 0;

var _immutable = require("immutable");

var _actionTypes = _interopRequireDefault(require("../actions/action-types"));

var _selectors = require("../selectors");

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

/**
 * windowsReducer
 */
var windowsReducer = function windowsReducer() {
  var state = arguments.length > 0 && arguments[0] !== undefined ? arguments[0] : {};
  var action = arguments.length > 1 ? arguments[1] : undefined;

  switch (action.type) {
    case _actionTypes["default"].ADD_WINDOW:
      return _objectSpread({}, state, _defineProperty({}, action.window.id, action.window));

    case _actionTypes["default"].RECEIVE_MANIFEST:
      return Object.keys(state).reduce(function (object, key) {
        if (state[key].manifestId === action.manifestId) {
          object[key] = _objectSpread({}, state[key], {
            canvasId: state[key].canvasId || (0, _selectors.getManifestStartCanvas)(action.manifestJson, state[key].canvasIndex).id,
            canvasIndex: undefined
          });
        } else {
          object[key] = state[key]; // eslint-disable-line no-param-reassign
        }

        return object;
      }, {});

    case _actionTypes["default"].MAXIMIZE_WINDOW:
      return _objectSpread({}, state, _defineProperty({}, action.windowId, _objectSpread({}, state[action.windowId], {
        maximized: true
      })));

    case _actionTypes["default"].MINIMIZE_WINDOW:
      return _objectSpread({}, state, _defineProperty({}, action.windowId, _objectSpread({}, state[action.windowId], {
        maximized: false
      })));

    case _actionTypes["default"].UPDATE_WINDOW:
      return (0, _immutable.updateIn)(state, [action.id], function (orig) {
        return (0, _immutable.merge)(orig, action.payload);
      });

    case _actionTypes["default"].REMOVE_WINDOW:
      return Object.keys(state).reduce(function (object, key) {
        if (key !== action.windowId) {
          object[key] = state[key]; // eslint-disable-line no-param-reassign
        }

        return object;
      }, {});

    case _actionTypes["default"].TOGGLE_WINDOW_SIDE_BAR:
      return _objectSpread({}, state, _defineProperty({}, action.windowId, _objectSpread({}, state[action.windowId], {
        sideBarOpen: !state[action.windowId].sideBarOpen
      })));

    case _actionTypes["default"].SET_WINDOW_VIEW_TYPE:
      return _objectSpread({}, state, _defineProperty({}, action.windowId, _objectSpread({}, state[action.windowId], {
        view: action.viewType
      })));

    case _actionTypes["default"].SET_WINDOW_SIDE_BAR_PANEL:
      return _objectSpread({}, state, _defineProperty({}, action.windowId, _objectSpread({}, state[action.windowId], {
        sideBarPanel: action.panelType
      })));

    case _actionTypes["default"].UPDATE_WINDOW_POSITION:
      return _objectSpread({}, state, _defineProperty({}, action.payload.windowId, _objectSpread({}, state[action.payload.windowId], {
        x: action.payload.position.x,
        y: action.payload.position.y
      })));

    case _actionTypes["default"].SET_WINDOW_SIZE:
      return _objectSpread({}, state, _defineProperty({}, action.payload.windowId, _objectSpread({}, state[action.payload.windowId], {
        height: action.payload.size.height,
        width: action.payload.size.width,
        x: action.payload.size.x,
        y: action.payload.size.y
      })));

    case _actionTypes["default"].SET_CANVAS:
      return (0, _immutable.updateIn)(state, [action.windowId], function (orig) {
        return (0, _immutable.merge)(orig, {
          canvasId: action.canvasId,
          selectedContentSearchAnnotation: action.selectedContentSearchAnnotation
        });
      });

    case _actionTypes["default"].ADD_COMPANION_WINDOW:
      if (action.payload.position === 'left') {
        var companionWindowIds = state[action.windowId].companionWindowIds;
        var companionWindows = action.companionWindows;
        var newCompanionWindowIds = companionWindowIds.filter(function (id) {
          return companionWindows[id].position !== action.payload.position;
        });
        return _objectSpread({}, state, _defineProperty({}, action.windowId, _objectSpread({}, state[action.windowId], {
          companionAreaOpen: true,
          companionWindowIds: newCompanionWindowIds.concat([action.id]),
          sideBarPanel: action.payload.content
        })));
      }

      return _objectSpread({}, state, _defineProperty({}, action.windowId, _objectSpread({}, state[action.windowId], {
        companionWindowIds: state[action.windowId].companionWindowIds.concat([action.id])
      })));

    case _actionTypes["default"].UPDATE_COMPANION_WINDOW:
      if (action.payload.position !== 'left') return state;
      return _objectSpread({}, state, _defineProperty({}, action.windowId, _objectSpread({}, state[action.windowId], {
        companionAreaOpen: true
      })));

    case _actionTypes["default"].REMOVE_COMPANION_WINDOW:
      return _objectSpread({}, state, _defineProperty({}, action.windowId, _objectSpread({}, state[action.windowId], {
        companionWindowIds: state[action.windowId].companionWindowIds.filter(function (id) {
          return id !== action.id;
        })
      })));

    case _actionTypes["default"].SELECT_CONTENT_SEARCH_ANNOTATION:
      return _objectSpread({}, state, _defineProperty({}, action.windowId, _objectSpread({}, state[action.windowId], {
        canvasId: action.canvasId,
        selectedContentSearchAnnotation: action.annotationId
      })));

    case _actionTypes["default"].SELECT_ANNOTATION:
      return _objectSpread({}, state, _defineProperty({}, action.windowId, _objectSpread({}, state[action.windowId], {
        selectedAnnotations: _objectSpread({}, state[action.windowId].selectedAnnotations, _defineProperty({}, action.targetId, [].concat(_toConsumableArray((state[action.windowId].selectedAnnotations || {})[action.targetId] || []), [action.annotationId])))
      })));

    case _actionTypes["default"].DESELECT_ANNOTATION:
      {
        var selectedAnnotations = updatedSelectedAnnotations(state, action);
        return _objectSpread({}, state, _defineProperty({}, action.windowId, _objectSpread({}, state[action.windowId], {
          selectedAnnotations: selectedAnnotations
        })));
      }

    case _actionTypes["default"].HIGHLIGHT_ANNOTATION:
      return _objectSpread({}, state, _defineProperty({}, action.windowId, _objectSpread({}, state[action.windowId], {
        highlightedAnnotation: action.annotationId
      })));

    case _actionTypes["default"].TOGGLE_ANNOTATION_DISPLAY:
      return _objectSpread({}, state, _defineProperty({}, action.windowId, _objectSpread({}, state[action.windowId], {
        displayAllAnnotations: !state[action.windowId].displayAllAnnotations
      })));

    case _actionTypes["default"].IMPORT_MIRADOR_STATE:
      return action.state.windows;

    case _actionTypes["default"].REQUEST_SEARCH:
      return _objectSpread({}, state, _defineProperty({}, action.windowId, _objectSpread({}, state[action.windowId], {
        suggestedSearches: undefined
      })));

    case _actionTypes["default"].RECEIVE_SEARCH:
      return _objectSpread({}, state, _defineProperty({}, action.windowId, _objectSpread({}, state[action.windowId], {
        canvasId: action.canvasId || state[action.windowId].canvasId,
        selectedContentSearchAnnotation: action.annotationId && [action.annotationId] || state[action.windowId].selectedContentSearchAnnotation
      })));

    default:
      return state;
  }
};
/**
 * Handle removing IDs from selectedAnnotations
 * where empty targetIds are removed from state as well
 */


exports.windowsReducer = windowsReducer;

function updatedSelectedAnnotations(state, action) {
  var filteredIds = state[action.windowId].selectedAnnotations[action.targetId].filter(function (id) {
    return id !== action.annotationId;
  });

  if (filteredIds.length > 0) {
    return _objectSpread({}, state[action.windowId].selectedAnnotations, _defineProperty({}, action.targetId, filteredIds));
  }

  return (0, _immutable.remove)(state[action.windowId].selectedAnnotations, action.targetId);
}