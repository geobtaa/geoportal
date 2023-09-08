"use strict";

Object.defineProperty(exports, "__esModule", {
  value: true
});
exports.companionWindowsReducer = companionWindowsReducer;

var _immutable = require("immutable");

var _actionTypes = _interopRequireDefault(require("../actions/action-types"));

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { "default": obj }; }

/** */
function companionWindowsReducer() {
  var state = arguments.length > 0 && arguments[0] !== undefined ? arguments[0] : {};
  var action = arguments.length > 1 ? arguments[1] : undefined;

  switch (action.type) {
    case _actionTypes["default"].ADD_COMPANION_WINDOW:
      return (0, _immutable.setIn)(state, [action.id], action.payload);

    case _actionTypes["default"].ADD_WINDOW:
      return action.companionWindows.reduce(function (newState, cw) {
        newState[cw.id] = cw; // eslint-disable-line no-param-reassign

        return newState;
      }, state);

    case _actionTypes["default"].REMOVE_WINDOW:
      return action.companionWindowIds.reduce(function (newState, id) {
        return (0, _immutable.removeIn)(newState, [id]);
      }, state);

    case _actionTypes["default"].UPDATE_COMPANION_WINDOW:
      return (0, _immutable.updateIn)(state, [action.id], function (orig) {
        return (0, _immutable.merge)(orig, action.payload);
      });

    case _actionTypes["default"].REMOVE_COMPANION_WINDOW:
      return (0, _immutable.removeIn)(state, [action.id]);

    case _actionTypes["default"].IMPORT_MIRADOR_STATE:
      return action.state.companionWindows;

    case _actionTypes["default"].TOGGLE_TOC_NODE:
      return (0, _immutable.updateIn)(state, [[action.id], 'tocNodes'], {}, function (orig) {
        return (0, _immutable.merge)(orig, action.payload);
      });

    default:
      return state;
  }
}