"use strict";

Object.defineProperty(exports, "__esModule", {
  value: true
});
exports["default"] = void 0;

var _flatten = _interopRequireDefault(require("lodash/flatten"));

var _flattenDeep = _interopRequireDefault(require("lodash/flattenDeep"));

var _manifesto = require("manifesto.js");

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { "default": obj }; }

function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }

function _defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ("value" in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } }

function _createClass(Constructor, protoProps, staticProps) { if (protoProps) _defineProperties(Constructor.prototype, protoProps); if (staticProps) _defineProperties(Constructor, staticProps); return Constructor; }

/**
 * ManifestoCanvas - adds additional, testable logic around Manifesto's Canvas
 * https://iiif-commons.github.io/manifesto/classes/_canvas_.manifesto.canvas.html
 */
var ManifestoCanvas = /*#__PURE__*/function () {
  /**
   * @param {ManifestoCanvas} canvas
   */
  function ManifestoCanvas(canvas) {
    _classCallCheck(this, ManifestoCanvas);

    this.canvas = canvas;
  }
  /** */


  _createClass(ManifestoCanvas, [{
    key: "getWidth",

    /** */
    value: function getWidth() {
      return this.canvas.getWidth();
    }
    /** */

  }, {
    key: "getHeight",
    value: function getHeight() {
      return this.canvas.getHeight();
    }
    /**
     * Implements Manifesto's canonicalImageUri algorithm to support
     * IIIF Presentation v3
     */

  }, {
    key: "canonicalImageUri",
    value: function canonicalImageUri(w) {
      var format = arguments.length > 1 && arguments[1] !== undefined ? arguments[1] : 'jpg';
      var resourceId = arguments.length > 2 && arguments[2] !== undefined ? arguments[2] : undefined;
      var resource = this.getImageResourceOrDefault(resourceId);
      var service = resource && resource.getServices()[0];
      if (!service) return undefined;
      var region = 'full';
      var size = w;
      var imageWidth = resource.getWidth();
      if (!w || w === imageWidth) size = 'full';

      var quality = _manifesto.Utils.getImageQuality(service.getProfile());

      var id = service.id.replace(/\/+$/, '');
      return [id, region, size, 0, "".concat(quality, ".").concat(format)].join('/');
    }
    /**
     */

  }, {
    key: "processAnnotations",

    /** */
    value: function processAnnotations(fetchAnnotation, receiveAnnotation) {
      var _this = this;

      // IIIF v2
      this.annotationListUris.forEach(function (uri) {
        fetchAnnotation(_this.canvas.id, uri);
      }); // IIIF v3

      this.canvasAnnotationPages.forEach(function (annotation) {
        // If there are no items, try to retrieve the referenced resource.
        // otherwise the resource should be embedded and just add to the store.
        if (!annotation.items) {
          fetchAnnotation(_this.canvas.id, annotation.id);
        } else {
          receiveAnnotation(_this.canvas.id, annotation.id, annotation);
        }
      });
    }
    /**
     * Will negotiate a v2 or v3 type of resource
     */

  }, {
    key: "getImageResourceOrDefault",

    /** */
    value: function getImageResourceOrDefault(resourceId) {
      var resources = this.imageResources;
      if (resourceId) return resources.find(function (r) {
        return r.id === resourceId;
      });
      return resources[0];
    }
    /** @private */

  }, {
    key: "imageInformationUri",
    value: function imageInformationUri(resourceId) {
      var image = this.getImageResourceOrDefault(resourceId);
      var imageId = image && image.getServices()[0].id;
      if (!imageId) return undefined;
      return "".concat(imageId.replace(/\/$/, ''), "/info.json");
    }
    /**
     * checks whether the canvas has a valid height
     */

  }, {
    key: "getLabel",

    /**
     * Get the canvas label
     */
    value: function getLabel() {
      return this.canvas.getLabel().length > 0 ? this.canvas.getLabel().map(function (label) {
        return label.value;
      })[0] : String(this.canvas.index + 1);
    }
    /**
     * Creates a canonical image request for a thumb
     * @param {Number} height
     */

  }, {
    key: "thumbnail",
    value: function thumbnail() {
      var maxWidth = arguments.length > 0 && arguments[0] !== undefined ? arguments[0] : undefined;
      var maxHeight = arguments.length > 1 && arguments[1] !== undefined ? arguments[1] : undefined;
      var resourceId = arguments.length > 2 && arguments[2] !== undefined ? arguments[2] : undefined;
      var width;
      var height;

      if (!this.imageInformationUri(resourceId)) {
        return undefined;
      }

      switch (this.thumbnailConstraints(maxWidth, maxHeight)) {
        case 'sizeByH':
          height = maxHeight;
          break;

        case 'sizeByW':
          width = maxWidth;
          break;

        default:
          height = '150';
      } // note that, although the IIIF server may support sizeByConfinedWh (e.g. !w,h)
      // this is a IIIF level 2 feature, so we're instead providing w, or h,-style requests
      // which are only level 1.


      return this.canonicalImageUri(undefined, undefined, resourceId).replace(/\/full\/.*\/0\//, "/full/".concat(width || '', ",").concat(height || '', "/0/"));
    }
    /** @private */

  }, {
    key: "thumbnailConstraints",
    value: function thumbnailConstraints(maxWidth, maxHeight) {
      if (!maxHeight && !maxWidth) return undefined;
      if (maxHeight && !maxWidth) return 'sizeByH';
      if (!maxHeight && maxWidth) return 'sizeByW';
      var aspectRatio = this.aspectRatio;
      var desiredAspectRatio = maxWidth / maxHeight;
      return desiredAspectRatio < aspectRatio ? 'sizeByW' : 'sizeByH';
    }
  }, {
    key: "id",
    get: function get() {
      return this.canvas.id;
    }
  }, {
    key: "aspectRatio",
    get: function get() {
      return this.canvas.getWidth() / this.canvas.getHeight();
    }
    /**
     * Fetches AnnotationList URIs from canvas's otherContent property
     *
     * Supported otherContent types:
     * - Objects having @type property of "sc:AnnotationList" and URI in @id
     * - Strings being the URIs
     */

  }, {
    key: "annotationListUris",
    get: function get() {
      return (0, _flatten["default"])(new Array(this.canvas.__jsonld.otherContent) // eslint-disable-line no-underscore-dangle
      ).filter(function (otherContent) {
        return otherContent && (typeof otherContent === 'string' || otherContent['@type'] === 'sc:AnnotationList');
      }).map(function (otherContent) {
        return typeof otherContent === 'string' ? otherContent : otherContent['@id'];
      });
    }
    /** */

  }, {
    key: "canvasAnnotationPages",
    get: function get() {
      return (0, _flatten["default"])(new Array(this.canvas.__jsonld.annotations) // eslint-disable-line no-underscore-dangle
      ).filter(function (annotations) {
        return annotations && annotations.type === 'AnnotationPage';
      });
    }
  }, {
    key: "imageResource",
    get: function get() {
      return this.imageResources[0];
    }
    /** */

  }, {
    key: "imageResources",
    get: function get() {
      var _this2 = this;

      var resources = (0, _flattenDeep["default"])([this.canvas.getImages().map(function (i) {
        return i.getResource();
      }), this.canvas.getContent().map(function (i) {
        return i.getBody();
      })]);
      return (0, _flatten["default"])(resources.map(function (resource) {
        switch (resource.getProperty('type')) {
          case 'oa:Choice':
            return new _manifesto.Canvas({
              images: (0, _flatten["default"])([resource.getProperty('default'), resource.getProperty('item')]).map(function (r) {
                return {
                  resource: r
                };
              })
            }, _this2.canvas.options).getImages().map(function (i) {
              return i.getResource();
            });

          default:
            return resource;
        }
      }));
    }
    /** */

  }, {
    key: "iiifImageResources",
    get: function get() {
      return this.imageResources.filter(function (r) {
        return r && r.getServices()[0] && r.getServices()[0].id;
      });
    }
    /** */

  }, {
    key: "imageServiceIds",
    get: function get() {
      return this.iiifImageResources.map(function (r) {
        return r.getServices()[0].id;
      });
    }
  }, {
    key: "hasValidHeight",
    get: function get() {
      return typeof this.canvas.getHeight() === 'number' && this.canvas.getHeight() > 0;
    }
    /**
     * checks whether the canvas has a valid height
     */

  }, {
    key: "hasValidWidth",
    get: function get() {
      return typeof this.canvas.getHeight() === 'number' && this.canvas.getHeight() > 0;
    }
    /**
     * checks whether the canvas has valid dimensions
     */

  }, {
    key: "hasValidDimensions",
    get: function get() {
      return this.hasValidHeight && this.hasValidWidth;
    }
    /**
     * Get the canvas service
     */

  }, {
    key: "service",
    get: function get() {
      return this.canvas.__jsonld.service; // eslint-disable-line no-underscore-dangle
    }
  }]);

  return ManifestoCanvas;
}();

exports["default"] = ManifestoCanvas;