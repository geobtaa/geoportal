"use strict";

Object.defineProperty(exports, "__esModule", {
  value: true
});
exports.setCanvas = setCanvas;
exports.setNextCanvas = setNextCanvas;
exports.setPreviousCanvas = setPreviousCanvas;
exports.updateViewport = updateViewport;

var _actionTypes = _interopRequireDefault(require("./action-types"));

var _selectors = require("../selectors");

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { "default": obj }; }

/**
 * setCanvas - action creator
 *
 * @param  {String} windowId
 * @param  {String} canvasId
 * @memberof ActionCreators
 */
function setCanvas(windowId, canvasId) {
  return function (dispatch, getState) {
    var state = getState();
    var canvasIds = (0, _selectors.getCanvasGrouping)(state, {
      canvasId: canvasId,
      windowId: windowId
    }).map(function (c) {
      return c.id;
    });
    var searches = (0, _selectors.getSearchForWindow)(state, {
      windowId: windowId
    }) || {};
    var annotationBySearch = Object.keys(searches).reduce(function (accumulator, companionWindowId) {
      var annotations = (0, _selectors.getSearchAnnotationsForCompanionWindow)(state, {
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
      type: _actionTypes["default"].SET_CANVAS,
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


function setNextCanvas(windowId) {
  return function (dispatch, getState) {
    var state = getState();
    var newGroup = (0, _selectors.getNextCanvasGrouping)(state, {
      windowId: windowId
    });
    newGroup && dispatch(setCanvas(windowId, newGroup[0] && newGroup[0].id));
  };
}
/** Set the window's canvas to the previous canvas grouping */


function setPreviousCanvas(windowId) {
  return function (dispatch, getState) {
    var state = getState();
    var newGroup = (0, _selectors.getPreviousCanvasGrouping)(state, {
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


function updateViewport(windowId, payload) {
  return {
    payload: payload,
    type: _actionTypes["default"].UPDATE_VIEWPORT,
    windowId: windowId
  };
}