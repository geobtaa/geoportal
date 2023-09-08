"use strict";

Object.defineProperty(exports, "__esModule", {
  value: true
});
exports.requestAnnotation = requestAnnotation;
exports.receiveAnnotation = receiveAnnotation;
exports.receiveAnnotationFailure = receiveAnnotationFailure;
exports.fetchAnnotation = fetchAnnotation;
exports.selectAnnotation = selectAnnotation;
exports.deselectAnnotation = deselectAnnotation;
exports.toggleAnnotationDisplay = toggleAnnotationDisplay;
exports.highlightAnnotation = highlightAnnotation;

var _isomorphicUnfetch = _interopRequireDefault(require("isomorphic-unfetch"));

var _actionTypes = _interopRequireDefault(require("./action-types"));

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { "default": obj }; }

/**
 * requestAnnotation - action creator
 *
 * @param  {String} targetId
 * @param  {String} annotationId
 * @memberof ActionCreators
 */
function requestAnnotation(targetId, annotationId) {
  return {
    annotationId: annotationId,
    targetId: targetId,
    type: _actionTypes["default"].REQUEST_ANNOTATION
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


function receiveAnnotation(targetId, annotationId, annotationJson) {
  return {
    annotationId: annotationId,
    annotationJson: annotationJson,
    targetId: targetId,
    type: _actionTypes["default"].RECEIVE_ANNOTATION
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


function receiveAnnotationFailure(targetId, annotationId, error) {
  return {
    annotationId: annotationId,
    error: error,
    targetId: targetId,
    type: _actionTypes["default"].RECEIVE_ANNOTATION_FAILURE
  };
}
/**
 * fetchAnnotation - action creator
 *
 * @param  {String} annotationId
 * @memberof ActionCreators
 */


function fetchAnnotation(targetId, annotationId) {
  return function (dispatch) {
    dispatch(requestAnnotation(targetId, annotationId));
    return (0, _isomorphicUnfetch["default"])(annotationId).then(function (response) {
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


function selectAnnotation(windowId, targetId, annotationId) {
  return {
    annotationId: annotationId,
    targetId: targetId,
    type: _actionTypes["default"].SELECT_ANNOTATION,
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


function deselectAnnotation(windowId, targetId, annotationId) {
  return {
    annotationId: annotationId,
    targetId: targetId,
    type: _actionTypes["default"].DESELECT_ANNOTATION,
    windowId: windowId
  };
}
/**
 * toggleAnnotationDisplay - action creator
 *
 * @param  {String} windowId
 * @memberof ActionCreators
 */


function toggleAnnotationDisplay(windowId) {
  return {
    type: _actionTypes["default"].TOGGLE_ANNOTATION_DISPLAY,
    windowId: windowId
  };
}
/**
 * toggleAnnotationDisplay - action creator
 *
 * @param  {String} windowId
 * @memberof ActionCreators
 */


function highlightAnnotation(windowId, annotationId) {
  return {
    annotationId: annotationId,
    type: _actionTypes["default"].HIGHLIGHT_ANNOTATION,
    windowId: windowId
  };
}