function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }

function _defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ("value" in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } }

function _createClass(Constructor, protoProps, staticProps) { if (protoProps) _defineProperties(Constructor.prototype, protoProps); if (staticProps) _defineProperties(Constructor, staticProps); return Constructor; }

import flatten from 'lodash/flatten';
import AnnotationResource from './AnnotationResource';
/** */

var AnnotationList = /*#__PURE__*/function () {
  /** */
  function AnnotationList(json, target) {
    _classCallCheck(this, AnnotationList);

    this.json = json;
    this.target = target;
  }
  /** */


  _createClass(AnnotationList, [{
    key: "present",

    /** */
    value: function present() {
      return this.resources && this.resources.length > 0;
    }
    /** */

  }, {
    key: "id",
    get: function get() {
      return this.json['@id'];
    }
  }, {
    key: "resources",
    get: function get() {
      if (!this.json || !this.json.resources) return [];
      return flatten([this.json.resources]).map(function (resource) {
        return new AnnotationResource(resource);
      });
    }
  }]);

  return AnnotationList;
}();

export { AnnotationList as default };