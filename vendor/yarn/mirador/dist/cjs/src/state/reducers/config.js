"use strict";

Object.defineProperty(exports, "__esModule", {
  value: true
});
exports.configReducer = void 0;

var _deepmerge = _interopRequireDefault(require("deepmerge"));

var _actionTypes = _interopRequireDefault(require("../actions/action-types"));

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { "default": obj }; }

/**
 * configReducer - does a deep merge of the config
 */
var configReducer = function configReducer() {
  var state = arguments.length > 0 && arguments[0] !== undefined ? arguments[0] : {};
  var action = arguments.length > 1 ? arguments[1] : undefined;

  switch (action.type) {
    case _actionTypes["default"].UPDATE_CONFIG:
    case _actionTypes["default"].IMPORT_CONFIG:
      return (0, _deepmerge["default"])(state, action.config);

    case _actionTypes["default"].SET_CONFIG:
      return action.config;

    case _actionTypes["default"].IMPORT_MIRADOR_STATE:
      return action.state.config;

    default:
      return state;
  }
};

exports.configReducer = configReducer;