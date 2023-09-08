function _objectWithoutProperties(source, excluded) { if (source == null) return {}; var target = _objectWithoutPropertiesLoose(source, excluded); var key, i; if (Object.getOwnPropertySymbols) { var sourceSymbolKeys = Object.getOwnPropertySymbols(source); for (i = 0; i < sourceSymbolKeys.length; i++) { key = sourceSymbolKeys[i]; if (excluded.indexOf(key) >= 0) continue; if (!Object.prototype.propertyIsEnumerable.call(source, key)) continue; target[key] = source[key]; } } return target; }

function _objectWithoutPropertiesLoose(source, excluded) { if (source == null) return {}; var target = {}; var sourceKeys = Object.keys(source); var key, i; for (i = 0; i < sourceKeys.length; i++) { key = sourceKeys[i]; if (excluded.indexOf(key) >= 0) continue; target[key] = source[key]; } return target; }

import { Utils } from 'manifesto.js/dist-esmodule/Utils';
import ActionTypes from './action-types';
import { fetchInfoResponse } from './infoResponse';
/**
 * addAuthenticationRequest - action creator
 *
 * @param  {String} windowId
 * @param  {String} infoId
 * @param  {String} id
 * @memberof ActionCreators
 */

export function addAuthenticationRequest(windowId, infoId, id) {
  return {
    id: id,
    infoId: infoId,
    type: ActionTypes.ADD_AUTHENTICATION_REQUEST,
    windowId: windowId
  };
}
/**
 * resolveAuthenticationRequest - action creator
 *
 * @param {String} id
 * @memberof ActionCreators
 */

export function resolveAuthenticationRequest(id) {
  return function (dispatch, getState) {
    var _getState = getState(),
        auth = _getState.auth;

    dispatch(fetchAccessTokenRequest(id, auth[id].infoId));
  };
}
/**
 * requestAccessToken - action creator
 * @private
 *
 * @param  {String} serviceId
 * @param  {String} authId
 * @param  {String} infoIds
 * @memberof ActionCreators
 */

export function requestAccessToken(serviceId, authId, infoIds) {
  return {
    authId: authId,
    infoIds: infoIds,
    serviceId: serviceId,
    type: ActionTypes.REQUEST_ACCESS_TOKEN
  };
}
/**
 * receiveAccessToken - action creator
 * @private
 *
 * @param  {String} serviceId
 * @param  {Object} json
 * @memberof ActionCreators
 */

export function receiveAccessToken(serviceId, json) {
  return {
    json: json,
    serviceId: serviceId,
    type: ActionTypes.RECEIVE_ACCESS_TOKEN
  };
}
/**
 * receiveAccessTokenFailure - action creator
 * @private
 *
 * @param  {String} serviceId
 * @param  {Object} error
 * @memberof ActionCreators
 */

export function receiveAccessTokenFailure(serviceId, error) {
  return {
    error: error,
    serviceId: serviceId,
    type: ActionTypes.RECEIVE_ACCESS_TOKEN_FAILURE
  };
}
/** @private */

export function fetchAccessTokenRequest(id, infoIds) {
  var providedServices = arguments.length > 2 && arguments[2] !== undefined ? arguments[2] : undefined;
  return function (dispatch, getState) {
    var _getState2 = getState(),
        infoResponses = _getState2.infoResponses;

    var infoResponse = infoResponses[infoIds[0]].json;
    var services = providedServices || Utils.getServices(infoResponse);
    var authService = services.find(function (e) {
      return e.id === id;
    });
    if (!authService) return null;
    var accessTokenService = Utils.getService(authService, 'http://iiif.io/api/auth/1/token');
    dispatch(requestAccessToken(accessTokenService.id, authService.id, infoIds));
    return null;
  };
}
/**
 * resolveAccessTokenRequest - action creator
 *
 * @param {Object} message
 * @memberof ActionCreators
 */

export function resolveAccessTokenRequest(_ref) {
  var messageId = _ref.messageId,
      json = _objectWithoutProperties(_ref, ["messageId"]);

  return function (dispatch, getState) {
    var _getState$accessToken = getState().accessTokens[messageId],
        authId = _getState$accessToken.authId,
        infoIds = _getState$accessToken.infoIds;
    dispatch({
      id: authId,
      ok: !!json.accessToken,
      type: ActionTypes.RESOLVE_AUTHENTICATION_REQUEST
    });

    if (json.accessToken) {
      dispatch(receiveAccessToken(messageId, json));
      infoIds.forEach(function (imageId) {
        return dispatch(fetchInfoResponse({
          imageId: imageId
        }));
      });
    } else {
      dispatch(receiveAccessTokenFailure(messageId, json));
    }
  };
}