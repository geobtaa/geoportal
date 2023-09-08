"use strict";

Object.defineProperty(exports, "__esModule", {
  value: true
});

var _annotations = require("./annotations");

Object.keys(_annotations).forEach(function (key) {
  if (key === "default" || key === "__esModule") return;
  Object.defineProperty(exports, key, {
    enumerable: true,
    get: function get() {
      return _annotations[key];
    }
  });
});

var _canvases = require("./canvases");

Object.keys(_canvases).forEach(function (key) {
  if (key === "default" || key === "__esModule") return;
  Object.defineProperty(exports, key, {
    enumerable: true,
    get: function get() {
      return _canvases[key];
    }
  });
});

var _companionWindows = require("./companionWindows");

Object.keys(_companionWindows).forEach(function (key) {
  if (key === "default" || key === "__esModule") return;
  Object.defineProperty(exports, key, {
    enumerable: true,
    get: function get() {
      return _companionWindows[key];
    }
  });
});

var _config = require("./config");

Object.keys(_config).forEach(function (key) {
  if (key === "default" || key === "__esModule") return;
  Object.defineProperty(exports, key, {
    enumerable: true,
    get: function get() {
      return _config[key];
    }
  });
});

var _manifests = require("./manifests");

Object.keys(_manifests).forEach(function (key) {
  if (key === "default" || key === "__esModule") return;
  Object.defineProperty(exports, key, {
    enumerable: true,
    get: function get() {
      return _manifests[key];
    }
  });
});

var _windows = require("./windows");

Object.keys(_windows).forEach(function (key) {
  if (key === "default" || key === "__esModule") return;
  Object.defineProperty(exports, key, {
    enumerable: true,
    get: function get() {
      return _windows[key];
    }
  });
});

var _workspace = require("./workspace");

Object.keys(_workspace).forEach(function (key) {
  if (key === "default" || key === "__esModule") return;
  Object.defineProperty(exports, key, {
    enumerable: true,
    get: function get() {
      return _workspace[key];
    }
  });
});

var _searches = require("./searches");

Object.keys(_searches).forEach(function (key) {
  if (key === "default" || key === "__esModule") return;
  Object.defineProperty(exports, key, {
    enumerable: true,
    get: function get() {
      return _searches[key];
    }
  });
});

var _ranges = require("./ranges");

Object.keys(_ranges).forEach(function (key) {
  if (key === "default" || key === "__esModule") return;
  Object.defineProperty(exports, key, {
    enumerable: true,
    get: function get() {
      return _ranges[key];
    }
  });
});

var _layers = require("./layers");

Object.keys(_layers).forEach(function (key) {
  if (key === "default" || key === "__esModule") return;
  Object.defineProperty(exports, key, {
    enumerable: true,
    get: function get() {
      return _layers[key];
    }
  });
});