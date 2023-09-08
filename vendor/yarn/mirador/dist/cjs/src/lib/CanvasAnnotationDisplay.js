"use strict";

Object.defineProperty(exports, "__esModule", {
  value: true
});
exports["default"] = void 0;

function _toConsumableArray(arr) { return _arrayWithoutHoles(arr) || _iterableToArray(arr) || _unsupportedIterableToArray(arr) || _nonIterableSpread(); }

function _nonIterableSpread() { throw new TypeError("Invalid attempt to spread non-iterable instance.\nIn order to be iterable, non-array objects must have a [Symbol.iterator]() method."); }

function _unsupportedIterableToArray(o, minLen) { if (!o) return; if (typeof o === "string") return _arrayLikeToArray(o, minLen); var n = Object.prototype.toString.call(o).slice(8, -1); if (n === "Object" && o.constructor) n = o.constructor.name; if (n === "Map" || n === "Set") return Array.from(n); if (n === "Arguments" || /^(?:Ui|I)nt(?:8|16|32)(?:Clamped)?Array$/.test(n)) return _arrayLikeToArray(o, minLen); }

function _iterableToArray(iter) { if (typeof Symbol !== "undefined" && Symbol.iterator in Object(iter)) return Array.from(iter); }

function _arrayWithoutHoles(arr) { if (Array.isArray(arr)) return _arrayLikeToArray(arr); }

function _arrayLikeToArray(arr, len) { if (len == null || len > arr.length) len = arr.length; for (var i = 0, arr2 = new Array(len); i < len; i++) { arr2[i] = arr[i]; } return arr2; }

function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }

function _defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ("value" in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } }

function _createClass(Constructor, protoProps, staticProps) { if (protoProps) _defineProperties(Constructor.prototype, protoProps); if (staticProps) _defineProperties(Constructor, staticProps); return Constructor; }

/**
 * CanvasAnnotationDisplay - class used to display a SVG and fragment based
 * annotations.
 */
var CanvasAnnotationDisplay = /*#__PURE__*/function () {
  /** */
  function CanvasAnnotationDisplay(_ref) {
    var resource = _ref.resource,
        color = _ref.color,
        zoom = _ref.zoom,
        offset = _ref.offset,
        width = _ref.width;

    _classCallCheck(this, CanvasAnnotationDisplay);

    this.resource = resource;
    this.color = color;
    this.zoom = zoom;
    this.offset = offset;
    this.width = width || 1000;
  }
  /** */


  _createClass(CanvasAnnotationDisplay, [{
    key: "toContext",
    value: function toContext(context) {
      if (this.resource.svgSelector) {
        this.svgContext(context);
      } else {
        this.fragmentContext(context);
      }
    }
    /** */

  }, {
    key: "svgContext",

    /** */
    value: function svgContext(context) {
      var _this = this;

      _toConsumableArray(this.svgPaths).forEach(function (element) {
        /**
         *  Note: Path2D is not supported in IE11.
         *  TODO: Support multi canvas offset
         *  One example: https://developer.mozilla.org/en-US/docs/Web/API/Path2D/addPath
         */
        context.save();
        context.translate(_this.offset.x, _this.offset.y);
        var p = new Path2D(element.attributes.d.nodeValue);
        /**
         * Note: we could do something to return the svg styling attributes as
         * some have encoded information in these values. However, how should we
         * handle highlighting and other complications?
         *  context.strokeStyle = element.attributes.stroke.nodeValue;
         *  context.lineWidth = element.attributes['stroke-width'].nodeValue;
         */

        context.strokeStyle = _this.color; // eslint-disable-line no-param-reassign

        context.lineWidth = _this.lineWidth(); // eslint-disable-line no-param-reassign

        context.stroke(p);
        context.restore();
      });
    }
    /** */

  }, {
    key: "fragmentContext",
    value: function fragmentContext(context) {
      var fragment = this.resource.fragmentSelector;
      fragment[0] += this.offset.x;
      fragment[1] += this.offset.y;
      context.strokeStyle = this.color; // eslint-disable-line no-param-reassign

      context.lineWidth = this.lineWidth(); // eslint-disable-line no-param-reassign

      context.strokeRect.apply(context, _toConsumableArray(fragment));
    }
    /** */

  }, {
    key: "lineWidth",
    value: function lineWidth() {
      return Math.ceil(10 / (this.zoom * this.width));
    }
    /** */

  }, {
    key: "svgString",
    get: function get() {
      return this.resource.svgSelector.value;
    }
  }, {
    key: "svgPaths",
    get: function get() {
      var parser = new DOMParser();
      var xmlDoc = parser.parseFromString(this.svgString, 'text/xml');
      return xmlDoc.getElementsByTagName('path');
    }
  }]);

  return CanvasAnnotationDisplay;
}();

exports["default"] = CanvasAnnotationDisplay;