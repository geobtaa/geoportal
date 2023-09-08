"use strict";

Object.defineProperty(exports, "__esModule", {
  value: true
});
exports.addError = addError;
exports.removeError = removeError;

var _v = _interopRequireDefault(require("uuid/v4"));

var _actionTypes = _interopRequireDefault(require("./action-types"));

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { "default": obj }; }

/**
 * addError - action creator
 * @param {string} error
 */
function addError(error) {
  return {
    id: "error-".concat((0, _v["default"])()),
    message: error,
    type: _actionTypes["default"].ADD_ERROR
  };
}
/**
 * removeError - action creator
 * @param {string} id
 */


function removeError(id) {
  return {
    id: id,
    type: _actionTypes["default"].REMOVE_ERROR
  };
}