"use strict";

Object.defineProperty(exports, "__esModule", {
  value: true
});
exports.requestSearch = requestSearch;
exports.receiveSearch = receiveSearch;
exports.receiveSearchFailure = receiveSearchFailure;
exports.removeSearch = removeSearch;
exports.fetchSearch = fetchSearch;
exports.selectContentSearchAnnotation = selectContentSearchAnnotation;

var _isomorphicUnfetch = _interopRequireDefault(require("isomorphic-unfetch"));

var _selectors = require("../selectors");

var _actionTypes = _interopRequireDefault(require("./action-types"));

var _AnnotationList = _interopRequireDefault(require("../../lib/AnnotationList"));

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { "default": obj }; }

/**
 * requestSearch - action creator
 *
 * @param  {String} windowId
 * @param  {String} searchId
 * @param  {String} query
 * @memberof ActionCreators
 */
function requestSearch(windowId, companionWindowId, searchId, query) {
  return {
    companionWindowId: companionWindowId,
    query: query,
    searchId: searchId,
    type: _actionTypes["default"].REQUEST_SEARCH,
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


function receiveSearch(windowId, companionWindowId, searchId, searchJson) {
  return function (dispatch, getState) {
    var state = getState();
    var selectedIds = (0, _selectors.getSelectedContentSearchAnnotationIds)(state, {
      companionWindowId: companionWindowId,
      windowId: windowId
    });
    var annotation;
    var canvas;

    if (selectedIds.length === 0) {
      var canvases = (0, _selectors.getCanvases)(state, {
        windowId: windowId
      });
      annotation = (0, _selectors.sortSearchAnnotationsByCanvasOrder)( // eslint-disable-line prefer-destructuring
      new _AnnotationList["default"](searchJson), canvases)[0];
      canvas = annotation && (0, _selectors.getCanvas)(state, {
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
      type: _actionTypes["default"].RECEIVE_SEARCH,
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


function receiveSearchFailure(windowId, companionWindowId, searchId, error) {
  return {
    companionWindowId: companionWindowId,
    error: error,
    searchId: searchId,
    type: _actionTypes["default"].RECEIVE_SEARCH_FAILURE,
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


function removeSearch(windowId, companionWindowId) {
  return {
    companionWindowId: companionWindowId,
    type: _actionTypes["default"].REMOVE_SEARCH,
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


function fetchSearch(windowId, companionWindowId, searchId, query) {
  return function (dispatch) {
    dispatch(requestSearch(windowId, companionWindowId, searchId, query));
    return (0, _isomorphicUnfetch["default"])(searchId).then(function (response) {
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


function selectContentSearchAnnotation(windowId, companionWindowId, annotationIds) {
  return function (dispatch, getState) {
    var state = getState();
    var canvas = (0, _selectors.getCanvasForAnnotation)(state, {
      annotationId: annotationIds[0],
      companionWindowId: companionWindowId,
      windowId: windowId
    });
    dispatch({
      annotationId: annotationIds,
      canvasId: canvas && canvas.id,
      companionWindowId: companionWindowId,
      type: _actionTypes["default"].SELECT_CONTENT_SEARCH_ANNOTATION,
      windowId: windowId
    });
  };
}