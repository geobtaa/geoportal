function ownKeys(object, enumerableOnly) { var keys = Object.keys(object); if (Object.getOwnPropertySymbols) { var symbols = Object.getOwnPropertySymbols(object); if (enumerableOnly) symbols = symbols.filter(function (sym) { return Object.getOwnPropertyDescriptor(object, sym).enumerable; }); keys.push.apply(keys, symbols); } return keys; }

function _objectSpread(target) { for (var i = 1; i < arguments.length; i++) { var source = arguments[i] != null ? arguments[i] : {}; if (i % 2) { ownKeys(Object(source), true).forEach(function (key) { _defineProperty(target, key, source[key]); }); } else if (Object.getOwnPropertyDescriptors) { Object.defineProperties(target, Object.getOwnPropertyDescriptors(source)); } else { ownKeys(Object(source)).forEach(function (key) { Object.defineProperty(target, key, Object.getOwnPropertyDescriptor(source, key)); }); } } return target; }

function _defineProperty(obj, key, value) { if (key in obj) { Object.defineProperty(obj, key, { value: value, enumerable: true, configurable: true, writable: true }); } else { obj[key] = value; } return obj; }

import { updateIn, merge } from 'immutable';
import ActionTypes from '../actions/action-types';
/**
 * elasticLayoutReducer
 */

export var elasticLayoutReducer = function elasticLayoutReducer() {
  var state = arguments.length > 0 && arguments[0] !== undefined ? arguments[0] : {};
  var action = arguments.length > 1 ? arguments[1] : undefined;

  switch (action.type) {
    case ActionTypes.ADD_WINDOW:
      return _objectSpread({}, state, _defineProperty({}, action.window.id, _objectSpread({
        windowId: action.window.id
      }, action.elasticLayout)));

    case ActionTypes.UPDATE_ELASTIC_WINDOW_LAYOUT:
      return updateIn(state, [action.windowId], function (orig) {
        return merge(orig, action.payload);
      });

    case ActionTypes.REMOVE_WINDOW:
      return Object.keys(state).reduce(function (object, key) {
        if (key !== action.windowId) {
          object[key] = state[key]; // eslint-disable-line no-param-reassign
        }

        return object;
      }, {});

    case ActionTypes.IMPORT_MIRADOR_STATE:
      return action.state.elasticLayout;

    default:
      return state;
  }
};