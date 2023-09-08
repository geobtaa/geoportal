import { createSelector } from 'reselect';
/** */

function getWorkspace(state) {
  return state.workspace;
}

export var getFullScreenEnabled = createSelector([getWorkspace], function (workspace) {
  return workspace.isFullscreenEnabled;
});
/** Returns the latest error from the state
 * @param {object} state
 */

export function getLatestError(state) {
  return state.errors.items[0] && state.errors[state.errors.items[0]];
}
export var getWorkspaceType = createSelector([getWorkspace], function (_ref) {
  var type = _ref.type;
  return type;
});