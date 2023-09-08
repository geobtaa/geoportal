"use strict";

Object.defineProperty(exports, "__esModule", {
  value: true
});
exports.accessTokensReducer = accessTokensReducer;

var _normalizeUrl = _interopRequireDefault(require("normalize-url"));

var _Utils = require("manifesto.js/dist-esmodule/Utils");

var _actionTypes = _interopRequireDefault(require("../actions/action-types"));

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { "default": obj }; }

function ownKeys(object, enumerableOnly) { var keys = Object.keys(object); if (Object.getOwnPropertySymbols) { var symbols = Object.getOwnPropertySymbols(object); if (enumerableOnly) symbols = symbols.filter(function (sym) { return Object.getOwnPropertyDescriptor(object, sym).enumerable; }); keys.push.apply(keys, symbols); } return keys; }

function _objectSpread(target) { for (var i = 1; i < arguments.length; i++) { var source = arguments[i] != null ? arguments[i] : {}; if (i % 2) { ownKeys(Object(source), true).forEach(function (key) { _defineProperty(target, key, source[key]); }); } else if (Object.getOwnPropertyDescriptors) { Object.defineProperties(target, Object.getOwnPropertyDescriptors(source)); } else { ownKeys(Object(source)).forEach(function (key) { Object.defineProperty(target, key, Object.getOwnPropertyDescriptor(source, key)); }); } } return target; }

function _defineProperty(obj, key, value) { if (key in obj) { Object.defineProperty(obj, key, { value: value, enumerable: true, configurable: true, writable: true }); } else { obj[key] = value; } return obj; }

/** */
function accessTokensReducer() {
  var state = arguments.length > 0 && arguments[0] !== undefined ? arguments[0] : {};
  var action = arguments.length > 1 ? arguments[1] : undefined;
  var authService;
  var tokenService;

  switch (action.type) {
    case _actionTypes["default"].RECEIVE_INFO_RESPONSE:
      if (action.ok && (0, _normalizeUrl["default"])(action.infoId, {
        stripAuthentication: false
      }) === (0, _normalizeUrl["default"])(action.infoJson['@id'], {
        stripAuthentication: false
      })) return state;
      authService = _Utils.Utils.getService(_objectSpread({}, action.infoJson, {
        options: {}
      }), 'http://iiif.io/api/auth/1/external');
      if (!authService) return state;
      tokenService = _Utils.Utils.getService(authService, 'http://iiif.io/api/auth/1/token');
      if (!tokenService || state[tokenService.id]) return state;
      return _objectSpread({}, state, _defineProperty({}, tokenService.id, {
        authId: authService.id,
        id: tokenService.id,
        infoIds: [].concat(state[tokenService.id] && state[tokenService.id].infoIds || [], action.infoId),
        isFetching: true
      }));

    case _actionTypes["default"].REQUEST_ACCESS_TOKEN:
      return _objectSpread({}, state, _defineProperty({}, action.serviceId, {
        authId: action.authId,
        id: action.serviceId,
        infoIds: action.infoIds,
        isFetching: true
      }));

    case _actionTypes["default"].RECEIVE_ACCESS_TOKEN:
      return _objectSpread({}, state, _defineProperty({}, action.serviceId, _objectSpread({}, state[action.serviceId], {
        infoIds: [],
        isFetching: false,
        json: action.json
      })));

    case _actionTypes["default"].RECEIVE_ACCESS_TOKEN_FAILURE:
      return _objectSpread({}, state, _defineProperty({}, action.serviceId, _objectSpread({}, state[action.serviceId], {
        error: action.error,
        isFetching: false
      })));

    default:
      return state;
  }
}