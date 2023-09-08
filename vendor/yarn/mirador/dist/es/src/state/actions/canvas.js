import ActionTypes from './action-types';
import { getCanvasGrouping, getNextCanvasGrouping, getPreviousCanvasGrouping, getSearchAnnotationsForCompanionWindow, getSearchForWindow } from '../selectors';
/**
 * setCanvas - action creator
 *
 * @param  {String} windowId
 * @param  {String} canvasId
 * @memberof ActionCreators
 */

export function setCanvas(windowId, canvasId) {
  return function (dispatch, getState) {
    var state = getState();
    var canvasIds = getCanvasGrouping(state, {
      canvasId: canvasId,
      windowId: windowId
    }).map(function (c) {
      return c.id;
    });
    var searches = getSearchForWindow(state, {
      windowId: windowId
    }) || {};
    var annotationBySearch = Object.keys(searches).reduce(function (accumulator, companionWindowId) {
      var annotations = getSearchAnnotationsForCompanionWindow(state, {
        companionWindowId: companionWindowId,
        windowId: windowId
      });
      var resourceAnnotations = annotations.resources;
      var hitAnnotation = resourceAnnotations.find(function (r) {
        return canvasIds.includes(r.targetId);
      });
      if (hitAnnotation) accumulator[companionWindowId] = [hitAnnotation.id];
      return accumulator;
    }, {});
    var annotationIds = Object.values(annotationBySearch);
    var action = {
      canvasId: canvasIds && canvasIds[0],
      searches: annotationBySearch,
      type: ActionTypes.SET_CANVAS,
      windowId: windowId
    };

    if (annotationIds.length > 0) {
      action.selectedContentSearchAnnotation = // eslint-disable-line prefer-destructuring
      annotationIds[0];
    }

    dispatch(action);
  };
}
/** Set the window's canvas to the next canvas grouping */

export function setNextCanvas(windowId) {
  return function (dispatch, getState) {
    var state = getState();
    var newGroup = getNextCanvasGrouping(state, {
      windowId: windowId
    });
    newGroup && dispatch(setCanvas(windowId, newGroup[0] && newGroup[0].id));
  };
}
/** Set the window's canvas to the previous canvas grouping */

export function setPreviousCanvas(windowId) {
  return function (dispatch, getState) {
    var state = getState();
    var newGroup = getPreviousCanvasGrouping(state, {
      windowId: windowId
    });
    newGroup && dispatch(setCanvas(windowId, newGroup[0] && newGroup[0].id));
  };
}
/**
 *
 * @param windowId
 * @param payload
 * @returns {{payload: *, type: string, windowId: *}}
 */

export function updateViewport(windowId, payload) {
  return {
    payload: payload,
    type: ActionTypes.UPDATE_VIEWPORT,
    windowId: windowId
  };
}