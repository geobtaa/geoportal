import fetch from 'isomorphic-unfetch';
import { getCanvasForAnnotation, getCanvas, getCanvases, sortSearchAnnotationsByCanvasOrder, getSelectedContentSearchAnnotationIds } from '../selectors';
import ActionTypes from './action-types';
import AnnotationList from '../../lib/AnnotationList';
/**
 * requestSearch - action creator
 *
 * @param  {String} windowId
 * @param  {String} searchId
 * @param  {String} query
 * @memberof ActionCreators
 */

export function requestSearch(windowId, companionWindowId, searchId, query) {
  return {
    companionWindowId: companionWindowId,
    query: query,
    searchId: searchId,
    type: ActionTypes.REQUEST_SEARCH,
    windowId: windowId
  };
}
/**
 * receiveSearch - action creator
 *
 * @param  {String} windowId
 * @param  {String} searchId
 * @param  {Object} searchJson
 * @memberof ActionCreators
 */

export function receiveSearch(windowId, companionWindowId, searchId, searchJson) {
  return function (dispatch, getState) {
    var state = getState();
    var selectedIds = getSelectedContentSearchAnnotationIds(state, {
      companionWindowId: companionWindowId,
      windowId: windowId
    });
    var annotation;
    var canvas;

    if (selectedIds.length === 0) {
      var canvases = getCanvases(state, {
        windowId: windowId
      });
      annotation = sortSearchAnnotationsByCanvasOrder( // eslint-disable-line prefer-destructuring
      new AnnotationList(searchJson), canvases)[0];
      canvas = annotation && getCanvas(state, {
        canvasId: annotation.targetId,
        windowId: windowId
      });
    }

    dispatch({
      annotationId: annotation && annotation.id,
      canvasId: canvas && canvas.id,
      companionWindowId: companionWindowId,
      searchId: searchId,
      searchJson: searchJson,
      type: ActionTypes.RECEIVE_SEARCH,
      windowId: windowId
    });
  };
}
/**
 * receiveSearchFailure - action creator
 *
 * @param  {String} windowId
 * @param  {String} searchId
 * @param  {String} error
 * @memberof ActionCreators
 */

export function receiveSearchFailure(windowId, companionWindowId, searchId, error) {
  return {
    companionWindowId: companionWindowId,
    error: error,
    searchId: searchId,
    type: ActionTypes.RECEIVE_SEARCH_FAILURE,
    windowId: windowId
  };
}
/**
 * removeSearch - action creator
 *
 * @param  {String} windowId
 * @param  {String} companionWindowId
 * @memberof ActionCreators
 */

export function removeSearch(windowId, companionWindowId) {
  return {
    companionWindowId: companionWindowId,
    type: ActionTypes.REMOVE_SEARCH,
    windowId: windowId
  };
}
/**
 * fetchSearch - action creator
 *
 * @param  {String} searchId
 * @param  {String} query
 * @memberof ActionCreators
 */

export function fetchSearch(windowId, companionWindowId, searchId, query) {
  return function (dispatch) {
    dispatch(requestSearch(windowId, companionWindowId, searchId, query));
    return fetch(searchId).then(function (response) {
      return response.json();
    }).then(function (json) {
      return dispatch(receiveSearch(windowId, companionWindowId, searchId, json));
    })["catch"](function (error) {
      return dispatch(receiveSearchFailure(windowId, companionWindowId, searchId, error));
    });
  };
}
/**
 * selectedContentSearchAnnotation - action creator
 *
 * @param  {String} windowId
 * @param  {String} annotationId
 * @memberof ActionCreators
 */

export function selectContentSearchAnnotation(windowId, companionWindowId, annotationIds) {
  return function (dispatch, getState) {
    var state = getState();
    var canvas = getCanvasForAnnotation(state, {
      annotationId: annotationIds[0],
      companionWindowId: companionWindowId,
      windowId: windowId
    });
    dispatch({
      annotationId: annotationIds,
      canvasId: canvas && canvas.id,
      companionWindowId: companionWindowId,
      type: ActionTypes.SELECT_CONTENT_SEARCH_ANNOTATION,
      windowId: windowId
    });
  };
}