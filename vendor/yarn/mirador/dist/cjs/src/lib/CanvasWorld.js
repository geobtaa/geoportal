"use strict";

Object.defineProperty(exports, "__esModule", {
  value: true
});
exports["default"] = void 0;

var _normalizeUrl = _interopRequireDefault(require("normalize-url"));

var _ManifestoCanvas = _interopRequireDefault(require("./ManifestoCanvas"));

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { "default": obj }; }

function ownKeys(object, enumerableOnly) { var keys = Object.keys(object); if (Object.getOwnPropertySymbols) { var symbols = Object.getOwnPropertySymbols(object); if (enumerableOnly) symbols = symbols.filter(function (sym) { return Object.getOwnPropertyDescriptor(object, sym).enumerable; }); keys.push.apply(keys, symbols); } return keys; }

function _objectSpread(target) { for (var i = 1; i < arguments.length; i++) { var source = arguments[i] != null ? arguments[i] : {}; if (i % 2) { ownKeys(Object(source), true).forEach(function (key) { _defineProperty(target, key, source[key]); }); } else if (Object.getOwnPropertyDescriptors) { Object.defineProperties(target, Object.getOwnPropertyDescriptors(source)); } else { ownKeys(Object(source)).forEach(function (key) { Object.defineProperty(target, key, Object.getOwnPropertyDescriptor(source, key)); }); } } return target; }

function _defineProperty(obj, key, value) { if (key in obj) { Object.defineProperty(obj, key, { value: value, enumerable: true, configurable: true, writable: true }); } else { obj[key] = value; } return obj; }

function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }

function _defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ("value" in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } }

function _createClass(Constructor, protoProps, staticProps) { if (protoProps) _defineProperties(Constructor.prototype, protoProps); if (staticProps) _defineProperties(Constructor, staticProps); return Constructor; }

/**
 * CanvasWorld
 */
var CanvasWorld = /*#__PURE__*/function () {
  /**
   * @param {Array} canvases - Array of Manifesto:Canvas objects to create a
   * world from.
   */
  function CanvasWorld(canvases, layers) {
    var viewingDirection = arguments.length > 2 && arguments[2] !== undefined ? arguments[2] : 'left-to-right';

    _classCallCheck(this, CanvasWorld);

    this.canvases = canvases.map(function (c) {
      return new _ManifestoCanvas["default"](c);
    });
    this.layers = layers;
    this.viewingDirection = viewingDirection;
  }
  /** */


  _createClass(CanvasWorld, [{
    key: "contentResourceToWorldCoordinates",

    /**
     * contentResourceToWorldCoordinates - calculates the contentResource coordinates
     * respective to the world.
     */
    value: function contentResourceToWorldCoordinates(contentResource) {
      var wholeBounds = this.worldBounds();
      var manifestoCanvasIndex = this.canvases.findIndex(function (c) {
        return c.imageResources.find(function (r) {
          return r.id === contentResource.id;
        });
      });
      var aspectRatio = this.canvases[manifestoCanvasIndex].aspectRatio;
      var scaledWidth = Math.floor(wholeBounds[3] * aspectRatio);
      var x = 0;

      if (manifestoCanvasIndex === this.secondCanvasIndex) {
        x = wholeBounds[2] - scaledWidth;
      }

      return [x, 0, scaledWidth, wholeBounds[3]];
    }
    /** */

  }, {
    key: "canvasToWorldCoordinates",
    value: function canvasToWorldCoordinates(canvasId) {
      var wholeBounds = this.worldBounds();
      var manifestoCanvasIndex = this.canvases.findIndex(function (c) {
        return c.id === canvasId;
      });
      var aspectRatio = this.canvases[manifestoCanvasIndex].aspectRatio;
      var scaledWidth = Math.floor(wholeBounds[3] * aspectRatio);
      var x = 0;

      if (manifestoCanvasIndex === this.secondCanvasIndex) {
        x = wholeBounds[2] - scaledWidth;
      }

      return [x, 0, scaledWidth, wholeBounds[3]];
    }
    /**
     * secondCanvasIndex - index of the second canvas used for determining which
     * is first
     */

  }, {
    key: "contentResource",

    /** Get the IIIF content resource for an image */
    value: function contentResource(infoResponseId) {
      var manifestoCanvas = this.canvases.find(function (c) {
        return c.imageServiceIds.some(function (id) {
          return (0, _normalizeUrl["default"])(id, {
            stripAuthentication: false
          }) === (0, _normalizeUrl["default"])(infoResponseId, {
            stripAuthentication: false
          });
        });
      });
      if (!manifestoCanvas) return undefined;
      return manifestoCanvas.imageResources.find(function (r) {
        return (0, _normalizeUrl["default"])(r.getServices()[0].id, {
          stripAuthentication: false
        }) === (0, _normalizeUrl["default"])(infoResponseId, {
          stripAuthentication: false
        });
      });
    }
    /** @private */

  }, {
    key: "getLayerMetadata",
    value: function getLayerMetadata(contentResource) {
      if (!this.layers) return undefined;
      var manifestoCanvas = this.canvases.find(function (c) {
        return c.imageResources.find(function (r) {
          return r.id === contentResource.id;
        });
      });
      if (!manifestoCanvas) return undefined;
      var resourceIndex = manifestoCanvas.imageResources.findIndex(function (r) {
        return r.id === contentResource.id;
      });
      var layer = this.layers[manifestoCanvas.canvas.id];
      var imageResourceLayer = layer && layer[contentResource.id];
      return _objectSpread({
        index: resourceIndex,
        opacity: 1,
        total: manifestoCanvas.imageResources.length,
        visibility: true
      }, imageResourceLayer);
    }
    /** */

  }, {
    key: "layerOpacityOfImageResource",
    value: function layerOpacityOfImageResource(contentResource) {
      var layer = this.getLayerMetadata(contentResource);
      if (!layer) return 1;
      if (!layer.visibility) return 0;
      return layer.opacity;
    }
    /** */

  }, {
    key: "layerIndexOfImageResource",
    value: function layerIndexOfImageResource(contentResource) {
      var layer = this.getLayerMetadata(contentResource);
      if (!layer) return undefined;
      return layer.total - layer.index - 1;
    }
    /**
     * offsetByCanvas - calculates the offset for a given canvas target. Currently
     * assumes a horrizontal only layout.
     */

  }, {
    key: "offsetByCanvas",
    value: function offsetByCanvas(canvasTarget) {
      var coordinates = this.canvasToWorldCoordinates(canvasTarget);
      return {
        x: coordinates[0],
        y: coordinates[1]
      };
    }
    /**
     * worldBounds - calculates the "World" bounds. World in this case is canvases
     * lined up horizontally starting from left to right.
     */

  }, {
    key: "worldBounds",
    value: function worldBounds() {
      var heights = [];
      var dimensions = [];
      this.canvases.forEach(function (canvas) {
        heights.push(canvas.getHeight());
        dimensions.push({
          height: canvas.getHeight(),
          width: canvas.getWidth()
        });
      });
      var minHeight = Math.min.apply(Math, heights);
      var scaledWidth = 0;
      dimensions.forEach(function (dim) {
        var aspectRatio = dim.width / dim.height;
        scaledWidth += Math.floor(minHeight * aspectRatio);
      });
      return [0, 0, scaledWidth, minHeight];
    }
  }, {
    key: "canvasIds",
    get: function get() {
      return this.canvases.map(function (canvas) {
        return canvas.id;
      });
    }
  }, {
    key: "secondCanvasIndex",
    get: function get() {
      return this.viewingDirection === 'right-to-left' ? 0 : 1;
    }
  }]);

  return CanvasWorld;
}();

exports["default"] = CanvasWorld;