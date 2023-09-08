"use strict";

Object.defineProperty(exports, "__esModule", {
  value: true
});
exports.authReducer = void 0;

var _normalizeUrl = _interopRequireDefault(require("normalize-url"));

var _actionTypes = _interopRequireDefault(require("../actions/action-types"));

var _canvases = require("../selectors/canvases");

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { "default": obj }; }

function ownKeys(object, enumerableOnly) { var keys = Object.keys(object); if (Object.getOwnPropertySymbols) { var symbols = Object.getOwnPropertySymbols(object); if (enumerableOnly) symbols = symbols.filter(function (sym) { return Object.getOwnPropertyDescriptor(object, sym).enumerable; }); keys.push.apply(keys, symbols); } return keys; }

function _objectSpread(target) { for (var i = 1; i < arguments.length; i++) { var source = arguments[i] != null ? arguments[i] : {}; if (i % 2) { ownKeys(Object(source), true).forEach(function (key) { _defineProperty(target, key, source[key]); }); } else if (Object.getOwnPropertyDescriptors) { Object.defineProperties(target, Object.getOwnPropertyDescriptors(source)); } else { ownKeys(Object(source)).forEach(function (key) { Object.defineProperty(target, key, Object.getOwnPropertyDescriptor(source, key)); }); } } return target; }

function _defineProperty(obj, key, value) { if (key in obj) { Object.defineProperty(obj, key, { value: value, enumerable: true, configurable: true, writable: true }); } else { obj[key] = value; } return obj; }

/**
 * authReducer
 */
var authReducer = function authReducer() {
  var state = arguments.length > 0 && arguments[0] !== undefined ? arguments[0] : {};
  var action = arguments.length > 1 ? arguments[1] : undefined;
  var service;

  switch (action.type) {
    case _actionTypes["default"].RECEIVE_INFO_RESPONSE:
      if (action.ok && (0, _normalizeUrl["default"])(action.infoId, {
        stripAuthentication: false
      }) === (0, _normalizeUrl["default"])(action.infoJson['@id'], {
        stripAuthentication: false
      })) return state;
      service = (0, _canvases.selectNextAuthService)({
        auth: state
      }, action.infoJson, {
        external: true,
        kiosk: true
      });
      if (!service || state[service.id]) return state;
      return _objectSpread({}, state, _defineProperty({}, service.id, {
        id: service.id,
        infoId: [].concat(state[service.id] && state[service.id].infoId || [], action.infoId),
        isFetching: true,
        profile: service.getProfile()
      }));

    case _actionTypes["default"].ADD_AUTHENTICATION_REQUEST:
      return _objectSpread({}, state, _defineProperty({}, action.id, {
        id: action.id,
        infoId: [].concat(state[action.id] && state[action.id].infoId || [], action.infoId),
        isFetching: true
      }));

    case _actionTypes["default"].RESOLVE_AUTHENTICATION_REQUEST:
      return _objectSpread({}, state, _defineProperty({}, action.id, {
        id: action.id,
        isFetching: false,
        ok: action.ok
      }));

    default:
      return state;
  }
};

exports.authReducer = authReducer;