import { removeIn, setIn, updateIn, merge } from 'immutable';
import ActionTypes from '../actions/action-types';
/** */

export function companionWindowsReducer() {
  var state = arguments.length > 0 && arguments[0] !== undefined ? arguments[0] : {};
  var action = arguments.length > 1 ? arguments[1] : undefined;

  switch (action.type) {
    case ActionTypes.ADD_COMPANION_WINDOW:
      return setIn(state, [action.id], action.payload);

    case ActionTypes.ADD_WINDOW:
      return action.companionWindows.reduce(function (newState, cw) {
        newState[cw.id] = cw; // eslint-disable-line no-param-reassign

        return newState;
      }, state);

    case ActionTypes.REMOVE_WINDOW:
      return action.companionWindowIds.reduce(function (newState, id) {
        return removeIn(newState, [id]);
      }, state);

    case ActionTypes.UPDATE_COMPANION_WINDOW:
      return updateIn(state, [action.id], function (orig) {
        return merge(orig, action.payload);
      });

    case ActionTypes.REMOVE_COMPANION_WINDOW:
      return removeIn(state, [action.id]);

    case ActionTypes.IMPORT_MIRADOR_STATE:
      return action.state.companionWindows;

    case ActionTypes.TOGGLE_TOC_NODE:
      return updateIn(state, [[action.id], 'tocNodes'], {}, function (orig) {
        return merge(orig, action.payload);
      });

    default:
      return state;
  }
}