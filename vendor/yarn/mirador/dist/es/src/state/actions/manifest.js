function ownKeys(object, enumerableOnly) { var keys = Object.keys(object); if (Object.getOwnPropertySymbols) { var symbols = Object.getOwnPropertySymbols(object); if (enumerableOnly) symbols = symbols.filter(function (sym) { return Object.getOwnPropertyDescriptor(object, sym).enumerable; }); keys.push.apply(keys, symbols); } return keys; }

function _objectSpread(target) { for (var i = 1; i < arguments.length; i++) { var source = arguments[i] != null ? arguments[i] : {}; if (i % 2) { ownKeys(Object(source), true).forEach(function (key) { _defineProperty(target, key, source[key]); }); } else if (Object.getOwnPropertyDescriptors) { Object.defineProperties(target, Object.getOwnPropertyDescriptors(source)); } else { ownKeys(Object(source)).forEach(function (key) { Object.defineProperty(target, key, Object.getOwnPropertyDescriptor(source, key)); }); } } return target; }

function _defineProperty(obj, key, value) { if (key in obj) { Object.defineProperty(obj, key, { value: value, enumerable: true, configurable: true, writable: true }); } else { obj[key] = value; } return obj; }

import fetch from 'isomorphic-unfetch';
import ActionTypes from './action-types';
/**
 * requestManifest - action creator
 *
 * @param  {String} manifestId
 * @memberof ActionCreators
 */

export function requestManifest(manifestId, properties) {
  return {
    manifestId: manifestId,
    properties: properties,
    type: ActionTypes.REQUEST_MANIFEST
  };
}
/**
 * receiveManifest - action creator
 *
 * @param  {String} manifestId
 * @param  {Object} manifestJson
 * @memberof ActionCreators
 */

export function receiveManifest(manifestId, manifestJson) {
  return {
    manifestId: manifestId,
    manifestJson: manifestJson,
    type: ActionTypes.RECEIVE_MANIFEST
  };
}
/**
 * receiveManifestFailure - action creator
 *
 * @param  {String} windowId
 * @param  {String} error
 * @memberof ActionCreators
 */

export function receiveManifestFailure(manifestId, error) {
  return {
    error: error,
    manifestId: manifestId,
    type: ActionTypes.RECEIVE_MANIFEST_FAILURE
  };
}
/**
 * fetchManifest - action creator
 *
 * @param  {String} manifestId
 * @memberof ActionCreators
 */

export function fetchManifest(manifestId, properties) {
  return function (dispatch, getState) {
    dispatch(requestManifest(manifestId, _objectSpread({}, properties, {
      isFetching: true
    })));

    var _getState = getState(),
        _getState$config = _getState.config,
        config = _getState$config === void 0 ? {} : _getState$config;

    return fetch(manifestId, {
      headers: config.resourceHeaders
    }).then(function (response) {
      return response.json();
    }).then(function (json) {
      return dispatch(receiveManifest(manifestId, json));
    })["catch"](function (error) {
      if (typeof error === 'object') {
        // Returned by JSON parse failure
        dispatch(receiveManifestFailure(manifestId, String(error)));
      } else {
        dispatch(receiveManifestFailure(manifestId, error));
      }
    });
  };
}
/**
 * removeManifest - action creator
 *
 * @param  {String} manifestId
 * @memberof ActionCreators
 */

export function removeManifest(manifestId) {
  return {
    manifestId: manifestId,
    type: ActionTypes.REMOVE_MANIFEST
  };
}