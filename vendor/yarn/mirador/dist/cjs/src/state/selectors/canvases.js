"use strict";

Object.defineProperty(exports, "__esModule", {
  value: true
});
exports.getVisibleCanvases = getVisibleCanvases;
exports.selectNextAuthService = selectNextAuthService;
exports.selectActiveAuthService = selectActiveAuthService;
exports.selectAuthStatus = selectAuthStatus;
exports.selectCanvasAuthService = exports.selectInfoResponse = exports.getVisibleCanvasNonTiledResources = exports.selectInfoResponses = exports.getCanvasDescription = exports.getCanvasLabel = exports.getPreviousCanvasGrouping = exports.getNextCanvasGrouping = exports.getCanvasGrouping = exports.getCurrentCanvas = exports.getCanvas = exports.getCanvases = void 0;

var _reselect = require("reselect");

var _Utils = require("manifesto.js/dist-esmodule/Utils");

var _flatten = _interopRequireDefault(require("lodash/flatten"));

var _CanvasGroupings = _interopRequireDefault(require("../../lib/CanvasGroupings"));

var _ManifestoCanvas = _interopRequireDefault(require("../../lib/ManifestoCanvas"));

var _manifests = require("./manifests");

var _windows = require("./windows");

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { "default": obj }; }

function _createForOfIteratorHelper(o) { if (typeof Symbol === "undefined" || o[Symbol.iterator] == null) { if (Array.isArray(o) || (o = _unsupportedIterableToArray(o))) { var i = 0; var F = function F() {}; return { s: F, n: function n() { if (i >= o.length) return { done: true }; return { done: false, value: o[i++] }; }, e: function e(_e) { throw _e; }, f: F }; } throw new TypeError("Invalid attempt to iterate non-iterable instance.\nIn order to be iterable, non-array objects must have a [Symbol.iterator]() method."); } var it, normalCompletion = true, didErr = false, err; return { s: function s() { it = o[Symbol.iterator](); }, n: function n() { var step = it.next(); normalCompletion = step.done; return step; }, e: function e(_e2) { didErr = true; err = _e2; }, f: function f() { try { if (!normalCompletion && it["return"] != null) it["return"](); } finally { if (didErr) throw err; } } }; }

function _unsupportedIterableToArray(o, minLen) { if (!o) return; if (typeof o === "string") return _arrayLikeToArray(o, minLen); var n = Object.prototype.toString.call(o).slice(8, -1); if (n === "Object" && o.constructor) n = o.constructor.name; if (n === "Map" || n === "Set") return Array.from(n); if (n === "Arguments" || /^(?:Ui|I)nt(?:8|16|32)(?:Clamped)?Array$/.test(n)) return _arrayLikeToArray(o, minLen); }

function _arrayLikeToArray(arr, len) { if (len == null || len > arr.length) len = arr.length; for (var i = 0, arr2 = new Array(len); i < len; i++) { arr2[i] = arr[i]; } return arr2; }

function ownKeys(object, enumerableOnly) { var keys = Object.keys(object); if (Object.getOwnPropertySymbols) { var symbols = Object.getOwnPropertySymbols(object); if (enumerableOnly) symbols = symbols.filter(function (sym) { return Object.getOwnPropertyDescriptor(object, sym).enumerable; }); keys.push.apply(keys, symbols); } return keys; }

function _objectSpread(target) { for (var i = 1; i < arguments.length; i++) { var source = arguments[i] != null ? arguments[i] : {}; if (i % 2) { ownKeys(Object(source), true).forEach(function (key) { _defineProperty(target, key, source[key]); }); } else if (Object.getOwnPropertyDescriptors) { Object.defineProperties(target, Object.getOwnPropertyDescriptors(source)); } else { ownKeys(Object(source)).forEach(function (key) { Object.defineProperty(target, key, Object.getOwnPropertyDescriptor(source, key)); }); } } return target; }

function _defineProperty(obj, key, value) { if (key in obj) { Object.defineProperty(obj, key, { value: value, enumerable: true, configurable: true, writable: true }); } else { obj[key] = value; } return obj; }

var getCanvases = (0, _reselect.createSelector)([_manifests.getManifestoInstance], function (manifest) {
  return manifest && manifest.getSequences()[0].getCanvases();
});
/**
* Return the canvas selected by an index
* @param {object} state
* @param {object} props
* @param {string} props.manifestId
* @param {string} props.windowId
* @return {Object}
*/

exports.getCanvases = getCanvases;
var getCanvas = (0, _reselect.createSelector)([_manifests.getManifestoInstance, function (state, _ref) {
  var canvasIndex = _ref.canvasIndex;
  return canvasIndex;
}, function (state, _ref2) {
  var canvasId = _ref2.canvasId;
  return canvasId;
}], function (manifest, canvasIndex, canvasId) {
  if (!manifest) return undefined;
  if (canvasId !== undefined) return manifest.getSequences()[0].getCanvasById(canvasId);
  return manifest.getSequences()[0].getCanvasByIndex(canvasIndex);
});
exports.getCanvas = getCanvas;
var getCurrentCanvas = (0, _reselect.createSelector)([_manifests.getManifestoInstance, _windows.getWindow], function (manifest, window) {
  if (!manifest || !window) return undefined;
  if (!window.canvasId) return manifest.getSequences()[0].getCanvasByIndex(0);
  return manifest.getSequences()[0].getCanvasById(window.canvasId);
});
/** */

exports.getCurrentCanvas = getCurrentCanvas;

function getVisibleCanvases(state, args) {
  var canvas = getCurrentCanvas(state, _objectSpread({}, args));
  if (!canvas) return undefined;
  return getCanvasGrouping(state, _objectSpread({}, args, {
    canvasId: canvas.id
  }));
}
/**
* Return the current canvases grouped by how they'll appear in the viewer
* For book view returns groups of 2, for single returns 1
* @param {object} state
* @param {object} props
* @param {string} props.manifestId
* @param {string} props.windowId
* @return {Array}
*/


var getCanvasGroupings = (0, _reselect.createSelector)([getCanvases, _windows.getWindowViewType], function (canvases, view) {
  return canvases && new _CanvasGroupings["default"](canvases, view).groupings();
});
/**
* Return the current canvases selected in a window
* For book view returns 2, for single returns 1
* @param {object} state
* @param {object} props
* @param {string} props.manifestId
* @param {string} props.windowId
* @return {Array}
*/

var getCanvasGrouping = (0, _reselect.createSelector)([getCanvasGroupings, function (state, _ref3) {
  var canvasId = _ref3.canvasId;
  return canvasId;
}], function (groupings, canvasId, view) {
  return groupings && groupings.find(function (group) {
    return group.some(function (c) {
      return c.id === canvasId;
    });
  }) || [];
});
/**
* Return the next canvas(es) for a window
* For book view returns 2, for single returns 1
* @param {object} state
* @param {object} props
* @param {string} props.manifestId
* @param {string} props.windowId
* @return {Array}
*/

exports.getCanvasGrouping = getCanvasGrouping;
var getNextCanvasGrouping = (0, _reselect.createSelector)([getCanvasGroupings, getCurrentCanvas], function (groupings, canvas, view) {
  if (!groupings) return undefined;
  var currentGroupIndex = groupings.findIndex(function (group) {
    return group.some(function (c) {
      return c.id === canvas.id;
    });
  });
  if (currentGroupIndex < 0 || currentGroupIndex + 1 >= groupings.length) return undefined;
  var newGroup = groupings[currentGroupIndex + 1];
  return newGroup;
});
/**
* Return the previous canvas(es) for a window
* For book view returns 2, for single returns 1
* @param {object} state
* @param {object} props
* @param {string} props.manifestId
* @param {string} props.windowId
* @return {Array}
*/

exports.getNextCanvasGrouping = getNextCanvasGrouping;
var getPreviousCanvasGrouping = (0, _reselect.createSelector)([getCanvasGroupings, getCurrentCanvas], function (groupings, canvas, view) {
  if (!groupings) return undefined;
  var currentGroupIndex = groupings.findIndex(function (group) {
    return group.some(function (c) {
      return c.id === canvas.id;
    });
  });
  if (currentGroupIndex < 1) return undefined;
  var newGroup = groupings[currentGroupIndex - 1];
  return newGroup;
});
/**
* Return canvas label, or alternatively return the given index + 1 to be displayed
* @param {object} canvas
* @return {String|Integer}
*/

exports.getPreviousCanvasGrouping = getPreviousCanvasGrouping;
var getCanvasLabel = (0, _reselect.createSelector)([getCanvas], function (canvas) {
  return canvas && (canvas.getLabel().length > 0 ? canvas.getLabel().map(function (label) {
    return label.value;
  })[0] : String(canvas.index + 1));
});
/**
* Return canvas description
* @param {object} canvas
* @param {String}
*/

exports.getCanvasLabel = getCanvasLabel;
var getCanvasDescription = (0, _reselect.createSelector)([getCanvas], function (canvas) {
  return canvas && canvas.getProperty('description');
});
/** */

exports.getCanvasDescription = getCanvasDescription;

var selectInfoResponses = function selectInfoResponses(state) {
  return state.infoResponses;
};

exports.selectInfoResponses = selectInfoResponses;
var getVisibleCanvasNonTiledResources = (0, _reselect.createSelector)([getVisibleCanvases], function (canvases) {
  return (0, _flatten["default"])(canvases.map(function (canvas) {
    return new _ManifestoCanvas["default"](canvas).imageResources;
  })).filter(function (resource) {
    return resource.getServices().length < 1;
  });
});
exports.getVisibleCanvasNonTiledResources = getVisibleCanvasNonTiledResources;
var selectInfoResponse = (0, _reselect.createSelector)([getCanvas, selectInfoResponses], function (canvas, infoResponses) {
  if (!canvas) return undefined;
  var manifestoCanvas = new _ManifestoCanvas["default"](canvas);
  var image = manifestoCanvas.iiifImageResources[0];
  var iiifServiceId = image && image.getServices()[0].id;
  return iiifServiceId && infoResponses[iiifServiceId] && !infoResponses[iiifServiceId].isFetching && infoResponses[iiifServiceId];
});
exports.selectInfoResponse = selectInfoResponse;
var authServiceProfiles = {
  clickthrough: true,
  external: true,
  kiosk: true,
  login: true
};
/**
 *
 */

function selectNextAuthService(_ref4, resource) {
  var auth = _ref4.auth;
  var filter = arguments.length > 2 && arguments[2] !== undefined ? arguments[2] : authServiceProfiles;
  var orderedAuthServiceProfiles = ['http://iiif.io/api/auth/1/external', 'http://iiif.io/api/auth/1/kiosk', 'http://iiif.io/api/auth/1/clickthrough', 'http://iiif.io/api/auth/1/login'];
  var mapFilterToProfiles = {
    'http://iiif.io/api/auth/1/clickthrough': 'clickthrough',
    'http://iiif.io/api/auth/1/external': 'external',
    'http://iiif.io/api/auth/1/kiosk': 'kiosk',
    'http://iiif.io/api/auth/1/login': 'login'
  };

  for (var _i = 0, _orderedAuthServicePr = orderedAuthServiceProfiles; _i < _orderedAuthServicePr.length; _i++) {
    var profile = _orderedAuthServicePr[_i];
    var services = getServices(resource, profile);

    var _iterator = _createForOfIteratorHelper(services),
        _step;

    try {
      for (_iterator.s(); !(_step = _iterator.n()).done;) {
        var service = _step.value;

        if (!auth[service.id]) {
          return filter[mapFilterToProfiles[profile]] && service;
        }

        if (auth[service.id].isFetching || auth[service.id].ok) return null;
      }
    } catch (err) {
      _iterator.e(err);
    } finally {
      _iterator.f();
    }
  }

  return null;
}
/** */


function selectActiveAuthService(state, resource) {
  var orderedAuthServiceProfiles = ['http://iiif.io/api/auth/1/login', 'http://iiif.io/api/auth/1/clickthrough', 'http://iiif.io/api/auth/1/kiosk', 'http://iiif.io/api/auth/1/external'];

  for (var _i2 = 0, _orderedAuthServicePr2 = orderedAuthServiceProfiles; _i2 < _orderedAuthServicePr2.length; _i2++) {
    var profile = _orderedAuthServicePr2[_i2];
    var services = getServices(resource, profile);
    var service = services.find(function (s) {
      return selectAuthStatus(state, s);
    });
    if (service) return service;
  }

  return null;
}

var selectCanvasAuthService = (0, _reselect.createSelector)([selectInfoResponse, function (state) {
  return state;
}], function (infoResponse, state) {
  var resource = infoResponse && infoResponse.json;
  if (!resource) return undefined;
  return selectNextAuthService(state, resource) || selectActiveAuthService(state, resource);
});
/** */

exports.selectCanvasAuthService = selectCanvasAuthService;

function selectAuthStatus(_ref5, service) {
  var auth = _ref5.auth;
  if (!service) return null;
  if (!auth[service.id]) return null;
  if (auth[service.id].isFetching) return 'fetching';
  if (auth[service.id].ok) return 'ok';
  return 'failed';
}
/** Get all the services that match a profile */


function getServices(resource, profile) {
  var services = _Utils.Utils.getServices(_objectSpread({}, resource, {
    options: {}
  }));

  return services.filter(function (service) {
    return service.getProfile() === profile;
  });
}