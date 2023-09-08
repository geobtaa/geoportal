function ownKeys(object, enumerableOnly) { var keys = Object.keys(object); if (Object.getOwnPropertySymbols) { var symbols = Object.getOwnPropertySymbols(object); if (enumerableOnly) symbols = symbols.filter(function (sym) { return Object.getOwnPropertyDescriptor(object, sym).enumerable; }); keys.push.apply(keys, symbols); } return keys; }

function _objectSpread(target) { for (var i = 1; i < arguments.length; i++) { var source = arguments[i] != null ? arguments[i] : {}; if (i % 2) { ownKeys(Object(source), true).forEach(function (key) { _defineProperty(target, key, source[key]); }); } else if (Object.getOwnPropertyDescriptors) { Object.defineProperties(target, Object.getOwnPropertyDescriptors(source)); } else { ownKeys(Object(source)).forEach(function (key) { Object.defineProperty(target, key, Object.getOwnPropertyDescriptor(source, key)); }); } } return target; }

function _defineProperty(obj, key, value) { if (key in obj) { Object.defineProperty(obj, key, { value: value, enumerable: true, configurable: true, writable: true }); } else { obj[key] = value; } return obj; }

import normalizeUrl from 'normalize-url';
import ActionTypes from '../actions/action-types';
import { selectNextAuthService } from '../selectors/canvases';
/**
 * authReducer
 */

export var authReducer = function authReducer() {
  var state = arguments.length > 0 && arguments[0] !== undefined ? arguments[0] : {};
  var action = arguments.length > 1 ? arguments[1] : undefined;
  var service;

  switch (action.type) {
    case ActionTypes.RECEIVE_INFO_RESPONSE:
      if (action.ok && normalizeUrl(action.infoId, {
        stripAuthentication: false
      }) === normalizeUrl(action.infoJson['@id'], {
        stripAuthentication: false
      })) return state;
      service = selectNextAuthService({
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

    case ActionTypes.ADD_AUTHENTICATION_REQUEST:
      return _objectSpread({}, state, _defineProperty({}, action.id, {
        id: action.id,
        infoId: [].concat(state[action.id] && state[action.id].infoId || [], action.infoId),
        isFetching: true
      }));

    case ActionTypes.RESOLVE_AUTHENTICATION_REQUEST:
      return _objectSpread({}, state, _defineProperty({}, action.id, {
        id: action.id,
        isFetching: false,
        ok: action.ok
      }));

    default:
      return state;
  }
};