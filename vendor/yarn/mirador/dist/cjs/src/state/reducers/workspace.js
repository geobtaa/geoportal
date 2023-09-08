"use strict";

Object.defineProperty(exports, "__esModule", {
  value: true
});
exports.workspaceReducer = void 0;

var _v = _interopRequireDefault(require("uuid/v4"));

var _actionTypes = _interopRequireDefault(require("../actions/action-types"));

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { "default": obj }; }

function ownKeys(object, enumerableOnly) { var keys = Object.keys(object); if (Object.getOwnPropertySymbols) { var symbols = Object.getOwnPropertySymbols(object); if (enumerableOnly) symbols = symbols.filter(function (sym) { return Object.getOwnPropertyDescriptor(object, sym).enumerable; }); keys.push.apply(keys, symbols); } return keys; }

function _objectSpread(target) { for (var i = 1; i < arguments.length; i++) { var source = arguments[i] != null ? arguments[i] : {}; if (i % 2) { ownKeys(Object(source), true).forEach(function (key) { _defineProperty(target, key, source[key]); }); } else if (Object.getOwnPropertyDescriptors) { Object.defineProperties(target, Object.getOwnPropertyDescriptors(source)); } else { ownKeys(Object(source)).forEach(function (key) { Object.defineProperty(target, key, Object.getOwnPropertyDescriptor(source, key)); }); } } return target; }

function _defineProperty(obj, key, value) { if (key in obj) { Object.defineProperty(obj, key, { value: value, enumerable: true, configurable: true, writable: true }); } else { obj[key] = value; } return obj; }

/** Check if the viewport dimensions are fully specified */
function hasViewportPosition(viewportPosition) {
  return viewportPosition.x !== undefined && viewportPosition.y !== undefined && viewportPosition.width !== undefined && viewportPosition.height !== undefined;
}
/** Check if the containee is fully within the bounds on the container */


function contains(container, containee) {
  return containee.x - containee.width / 2 > container.x - container.width / 2 && containee.y - containee.height / 2 > container.y - container.height / 2 && containee.x + containee.width / 2 < container.x + container.width / 2 && containee.y + containee.height / 2 < container.y + container.height / 2;
}
/**
 * workspaceReducer
 */


var workspaceReducer = function workspaceReducer() {
  var state = arguments.length > 0 && arguments[0] !== undefined ? arguments[0] : {
    // we'll need to abstract this more, methinks.
    draggingEnabled: true,
    id: (0, _v["default"])()
  };
  var action = arguments.length > 1 ? arguments[1] : undefined;
  var newWorkspaceDimensions;
  var viewportPosition;

  switch (action.type) {
    case _actionTypes["default"].UPDATE_WORKSPACE:
      return _objectSpread({}, state, {}, action.config);

    case _actionTypes["default"].FOCUS_WINDOW:
      return _objectSpread({}, state, {
        focusedWindowId: action.windowId,
        viewportPosition: _objectSpread({}, state.viewportPosition, {}, action.position)
      });

    case _actionTypes["default"].ADD_WINDOW:
      return _objectSpread({}, state, {
        focusedWindowId: action.window.id
      });

    case _actionTypes["default"].REMOVE_WINDOW:
      if (Object.keys(action.windows).length > 2) return state;
      return _objectSpread({}, state, {
        focusedWindowId: Object.keys(action.windows).find(function (e) {
          return e !== action.windowId;
        })
      });

    case _actionTypes["default"].SET_WORKSPACE_FULLSCREEN:
      return _objectSpread({}, state, {
        isFullscreenEnabled: action.isFullscreenEnabled
      });

    case _actionTypes["default"].TOGGLE_ZOOM_CONTROLS:
      return _objectSpread({}, state, {
        showZoomControls: action.showZoomControls
      });

    case _actionTypes["default"].UPDATE_WORKSPACE_MOSAIC_LAYOUT:
      return _objectSpread({}, state, {
        layout: action.layout
      });

    case _actionTypes["default"].SET_WORKSPACE_ADD_VISIBILITY:
      return _objectSpread({}, state, {
        isWorkspaceAddVisible: action.isWorkspaceAddVisible
      });

    case _actionTypes["default"].SET_WORKSPACE_VIEWPORT_POSITION:
      newWorkspaceDimensions = {};
      viewportPosition = _objectSpread({}, state.viewportPosition, {}, action.payload.position);

      if (hasViewportPosition(viewportPosition) && !contains({
        height: state.height,
        width: state.width,
        x: 0,
        y: 0
      }, viewportPosition)) {
        newWorkspaceDimensions = {
          height: state.height * 2,
          width: state.width * 2
        };
      }

      return _objectSpread({}, state, {}, newWorkspaceDimensions, {
        viewportPosition: viewportPosition
      });

    case _actionTypes["default"].TOGGLE_WORKSPACE_EXPOSE_MODE:
      return _objectSpread({}, state, {
        exposeModeOn: !state.exposeModeOn
      });

    case _actionTypes["default"].SET_CONFIG:
      return _objectSpread({}, state, {}, action.config.workspace);

    case _actionTypes["default"].IMPORT_MIRADOR_STATE:
      return action.state.workspace;

    case _actionTypes["default"].TOGGLE_DRAGGING:
      return _objectSpread({}, state, {
        draggingEnabled: !state.draggingEnabled
      });

    default:
      return state;
  }
};

exports.workspaceReducer = workspaceReducer;