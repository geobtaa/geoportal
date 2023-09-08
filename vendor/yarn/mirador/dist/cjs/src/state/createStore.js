"use strict";

Object.defineProperty(exports, "__esModule", {
  value: true
});
exports["default"] = _default;

var _reduxThunk = _interopRequireDefault(require("redux-thunk"));

var _redux = require("redux");

var _reduxDevtoolsExtension = require("redux-devtools-extension");

var _rootReducer = _interopRequireDefault(require("./reducers/rootReducer"));

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { "default": obj }; }

// Topics for understanding
// redux modules for nested stores
// state normalisation
// (normalizer library)

/**
 * Configure Store
 */
function _default(pluginReducers) {
  return (0, _redux.createStore)((0, _rootReducer["default"])(pluginReducers), (0, _reduxDevtoolsExtension.composeWithDevTools)((0, _redux.applyMiddleware)(_reduxThunk["default"])));
}