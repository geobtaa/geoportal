import deepmerge from 'deepmerge';
import ActionTypes from '../actions/action-types';
/**
 * configReducer - does a deep merge of the config
 */

export var configReducer = function configReducer() {
  var state = arguments.length > 0 && arguments[0] !== undefined ? arguments[0] : {};
  var action = arguments.length > 1 ? arguments[1] : undefined;

  switch (action.type) {
    case ActionTypes.UPDATE_CONFIG:
    case ActionTypes.IMPORT_CONFIG:
      return deepmerge(state, action.config);

    case ActionTypes.SET_CONFIG:
      return action.config;

    case ActionTypes.IMPORT_MIRADOR_STATE:
      return action.state.config;

    default:
      return state;
  }
};