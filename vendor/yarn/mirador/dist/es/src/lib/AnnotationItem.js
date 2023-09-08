function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }

function _defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ("value" in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } }

function _createClass(Constructor, protoProps, staticProps) { if (protoProps) _defineProperties(Constructor.prototype, protoProps); if (staticProps) _defineProperties(Constructor, staticProps); return Constructor; }

import compact from 'lodash/compact';
import flatten from 'lodash/flatten';
import uuid from 'uuid/v4';
/**
 * A modeled WebAnnotation item
 */

var AnnotationItem = /*#__PURE__*/function () {
  /** */
  function AnnotationItem() {
    var resource = arguments.length > 0 && arguments[0] !== undefined ? arguments[0] : {};

    _classCallCheck(this, AnnotationItem);

    this.resource = resource;
  }
  /** */


  _createClass(AnnotationItem, [{
    key: "id",
    get: function get() {
      this._id = this._id || this.resource.id || uuid(); // eslint-disable-line no-underscore-dangle

      return this._id; // eslint-disable-line no-underscore-dangle
    }
    /** */

  }, {
    key: "targetId",
    get: function get() {
      var target = this.target[0];

      switch (typeof target) {
        case 'string':
          return target.replace(/#?xywh=(.*)$/, '');

        default:
          return null;
      }
    }
    /**
     * @return {[Array]}
     */

  }, {
    key: "motivations",
    get: function get() {
      return flatten(compact(new Array(this.resource.motivation)));
    }
    /** */

  }, {
    key: "body",
    get: function get() {
      return flatten(compact(new Array(this.resource.body)));
    }
    /** */

  }, {
    key: "resources",
    get: function get() {
      return this.body;
    }
    /** */

  }, {
    key: "target",
    get: function get() {
      return flatten(compact(new Array(this.resource.target)));
    }
    /** */

  }, {
    key: "chars",
    get: function get() {
      return this.body.map(function (r) {
        return r.value;
      }).join(' ');
    }
    /** */

  }, {
    key: "selector",
    get: function get() {
      var target = this.target[0];

      switch (typeof target) {
        case 'string':
          return target;

        default:
          return null;
      }
    }
    /** */

  }, {
    key: "fragmentSelector",
    get: function get() {
      var selector = this.selector;

      switch (typeof selector) {
        case 'string':
          return selector.match(/xywh=(.*)$/)[1].split(',').map(function (str) {
            return parseInt(str, 10);
          });

        default:
          return null;
      }
    }
  }]);

  return AnnotationItem;
}();

export { AnnotationItem as default };