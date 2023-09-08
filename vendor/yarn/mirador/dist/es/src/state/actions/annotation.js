import fetch from 'isomorphic-unfetch';
import ActionTypes from './action-types';
/**
 * requestAnnotation - action creator
 *
 * @param  {String} targetId
 * @param  {String} annotationId
 * @memberof ActionCreators
 */

export function requestAnnotation(targetId, annotationId) {
  return {
    annotationId: annotationId,
    targetId: targetId,
    type: ActionTypes.REQUEST_ANNOTATION
  };
}
/**
 * receiveAnnotation - action creator
 *
 * @param  {String} targetId
 * @param  {String} annotationId
 * @param  {Object} annotationJson
 * @memberof ActionCreators
 */

export function receiveAnnotation(targetId, annotationId, annotationJson) {
  return {
    annotationId: annotationId,
    annotationJson: annotationJson,
    targetId: targetId,
    type: ActionTypes.RECEIVE_ANNOTATION
  };
}
/**
 * receiveAnnotationFailure - action creator
 *
 * @param  {String} targetId
 * @param  {String} annotationId
 * @param  {String} error
 * @memberof ActionCreators
 */

export function receiveAnnotationFailure(targetId, annotationId, error) {
  return {
    annotationId: annotationId,
    error: error,
    targetId: targetId,
    type: ActionTypes.RECEIVE_ANNOTATION_FAILURE
  };
}
/**
 * fetchAnnotation - action creator
 *
 * @param  {String} annotationId
 * @memberof ActionCreators
 */

export function fetchAnnotation(targetId, annotationId) {
  return function (dispatch) {
    dispatch(requestAnnotation(targetId, annotationId));
    return fetch(annotationId).then(function (response) {
      return response.json();
    }).then(function (json) {
      return dispatch(receiveAnnotation(targetId, annotationId, json));
    })["catch"](function (error) {
      return dispatch(receiveAnnotationFailure(targetId, annotationId, error));
    });
  };
}
/**
 * selectAnnotation - action creator
 *
 * @param  {String} windowId
 * @param  {String} targetId
 * @param  {String} annotationId
 * @memberof ActionCreators
 */

export function selectAnnotation(windowId, targetId, annotationId) {
  return {
    annotationId: annotationId,
    targetId: targetId,
    type: ActionTypes.SELECT_ANNOTATION,
    windowId: windowId
  };
}
/**
 * deselectAnnotation - action creator
 *
 * @param  {String} windowId
 * @param  {String} targetId
 * @param  {String} annotationId
 * @memberof ActionCreators
 */

export function deselectAnnotation(windowId, targetId, annotationId) {
  return {
    annotationId: annotationId,
    targetId: targetId,
    type: ActionTypes.DESELECT_ANNOTATION,
    windowId: windowId
  };
}
/**
 * toggleAnnotationDisplay - action creator
 *
 * @param  {String} windowId
 * @memberof ActionCreators
 */

export function toggleAnnotationDisplay(windowId) {
  return {
    type: ActionTypes.TOGGLE_ANNOTATION_DISPLAY,
    windowId: windowId
  };
}
/**
 * toggleAnnotationDisplay - action creator
 *
 * @param  {String} windowId
 * @memberof ActionCreators
 */

export function highlightAnnotation(windowId, annotationId) {
  return {
    annotationId: annotationId,
    type: ActionTypes.HIGHLIGHT_ANNOTATION,
    windowId: windowId
  };
}