"use strict";

Object.defineProperty(exports, "__esModule", {
  value: true
});
exports.ManifestRelatedLinks = void 0;

var _react = _interopRequireWildcard(require("react"));

var _Typography = _interopRequireDefault(require("@material-ui/core/Typography"));

var _Link = _interopRequireDefault(require("@material-ui/core/Link"));

var _classnames = _interopRequireDefault(require("classnames"));

var _CollapsibleSection = _interopRequireDefault(require("../containers/CollapsibleSection"));

var _cssNs = _interopRequireDefault(require("../config/css-ns"));

var _jsxFileName = "/Users/pjreed/dev/mirador/dist/cjs/src/components/ManifestRelatedLinks.js";

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { "default": obj }; }

function _getRequireWildcardCache() { if (typeof WeakMap !== "function") return null; var cache = new WeakMap(); _getRequireWildcardCache = function _getRequireWildcardCache() { return cache; }; return cache; }

function _interopRequireWildcard(obj) { if (obj && obj.__esModule) { return obj; } if (obj === null || typeof obj !== "object" && typeof obj !== "function") { return { "default": obj }; } var cache = _getRequireWildcardCache(); if (cache && cache.has(obj)) { return cache.get(obj); } var newObj = {}; var hasPropertyDescriptor = Object.defineProperty && Object.getOwnPropertyDescriptor; for (var key in obj) { if (Object.prototype.hasOwnProperty.call(obj, key)) { var desc = hasPropertyDescriptor ? Object.getOwnPropertyDescriptor(obj, key) : null; if (desc && (desc.get || desc.set)) { Object.defineProperty(newObj, key, desc); } else { newObj[key] = obj[key]; } } } newObj["default"] = obj; if (cache) { cache.set(obj, newObj); } return newObj; }

function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }

function _defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ("value" in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } }

function _createClass(Constructor, protoProps, staticProps) { if (protoProps) _defineProperties(Constructor.prototype, protoProps); if (staticProps) _defineProperties(Constructor, staticProps); return Constructor; }

function _inherits(subClass, superClass) { if (typeof superClass !== "function" && superClass !== null) { throw new TypeError("Super expression must either be null or a function"); } subClass.prototype = Object.create(superClass && superClass.prototype, { constructor: { value: subClass, writable: true, configurable: true } }); if (superClass) _setPrototypeOf(subClass, superClass); }

function _setPrototypeOf(o, p) { _setPrototypeOf = Object.setPrototypeOf || function _setPrototypeOf(o, p) { o.__proto__ = p; return o; }; return _setPrototypeOf(o, p); }

function _createSuper(Derived) { return function () { var Super = _getPrototypeOf(Derived), result; if (_isNativeReflectConstruct()) { var NewTarget = _getPrototypeOf(this).constructor; result = Reflect.construct(Super, arguments, NewTarget); } else { result = Super.apply(this, arguments); } return _possibleConstructorReturn(this, result); }; }

function _possibleConstructorReturn(self, call) { if (call && (typeof call === "object" || typeof call === "function")) { return call; } return _assertThisInitialized(self); }

function _assertThisInitialized(self) { if (self === void 0) { throw new ReferenceError("this hasn't been initialised - super() hasn't been called"); } return self; }

function _isNativeReflectConstruct() { if (typeof Reflect === "undefined" || !Reflect.construct) return false; if (Reflect.construct.sham) return false; if (typeof Proxy === "function") return true; try { Date.prototype.toString.call(Reflect.construct(Date, [], function () {})); return true; } catch (e) { return false; } }

function _getPrototypeOf(o) { _getPrototypeOf = Object.setPrototypeOf ? Object.getPrototypeOf : function _getPrototypeOf(o) { return o.__proto__ || Object.getPrototypeOf(o); }; return _getPrototypeOf(o); }

/**
 * ManifestRelatedLinks
 */
var ManifestRelatedLinks = /*#__PURE__*/function (_Component) {
  _inherits(ManifestRelatedLinks, _Component);

  var _super = _createSuper(ManifestRelatedLinks);

  function ManifestRelatedLinks() {
    _classCallCheck(this, ManifestRelatedLinks);

    return _super.apply(this, arguments);
  }

  _createClass(ManifestRelatedLinks, [{
    key: "render",

    /**
     * render
     * @return
     */
    value: function render() {
      var _this = this;

      var _this$props = this.props,
          classes = _this$props.classes,
          homepage = _this$props.homepage,
          manifestUrl = _this$props.manifestUrl,
          renderings = _this$props.renderings,
          seeAlso = _this$props.seeAlso,
          id = _this$props.id,
          t = _this$props.t;
      return /*#__PURE__*/_react["default"].createElement(_CollapsibleSection["default"], {
        id: "".concat(id, "-related"),
        label: t('related'),
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 30,
          columnNumber: 7
        }
      }, /*#__PURE__*/_react["default"].createElement(_Typography["default"], {
        "aria-labelledby": "".concat(id, "-related ").concat(id, "-related-heading"),
        id: "".concat(id, "-related-heading"),
        variant: "h4",
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 34,
          columnNumber: 9
        }
      }, t('links')), /*#__PURE__*/_react["default"].createElement("dl", {
        className: (0, _classnames["default"])((0, _cssNs["default"])('label-value-metadata'), classes.labelValueMetadata),
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 41,
          columnNumber: 9
        }
      }, homepage && /*#__PURE__*/_react["default"].createElement(_react["default"].Fragment, null, /*#__PURE__*/_react["default"].createElement(_Typography["default"], {
        variant: "subtitle2",
        component: "dt",
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 44,
          columnNumber: 15
        }
      }, t('iiif_homepage')), homepage.map(function (page) {
        return /*#__PURE__*/_react["default"].createElement(_Typography["default"], {
          key: page.value,
          variant: "body1",
          component: "dd",
          __self: _this,
          __source: {
            fileName: _jsxFileName,
            lineNumber: 47,
            columnNumber: 19
          }
        }, /*#__PURE__*/_react["default"].createElement(_Link["default"], {
          target: "_blank",
          rel: "noopener noreferrer",
          href: page.value,
          __self: _this,
          __source: {
            fileName: _jsxFileName,
            lineNumber: 48,
            columnNumber: 21
          }
        }, page.label || page.value));
      })), renderings && renderings.length > 0 && /*#__PURE__*/_react["default"].createElement(_react["default"].Fragment, null, /*#__PURE__*/_react["default"].createElement(_Typography["default"], {
        variant: "subtitle2",
        component: "dt",
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 58,
          columnNumber: 15
        }
      }, t('iiif_renderings')), renderings.map(function (rendering) {
        return /*#__PURE__*/_react["default"].createElement(_Typography["default"], {
          key: rendering.value,
          variant: "body1",
          component: "dd",
          __self: _this,
          __source: {
            fileName: _jsxFileName,
            lineNumber: 61,
            columnNumber: 19
          }
        }, /*#__PURE__*/_react["default"].createElement(_Link["default"], {
          target: "_blank",
          rel: "noopener noreferrer",
          href: rendering.value,
          __self: _this,
          __source: {
            fileName: _jsxFileName,
            lineNumber: 62,
            columnNumber: 21
          }
        }, rendering.label || rendering.value));
      })), seeAlso && /*#__PURE__*/_react["default"].createElement(_react["default"].Fragment, null, /*#__PURE__*/_react["default"].createElement(_Typography["default"], {
        variant: "subtitle2",
        component: "dt",
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 72,
          columnNumber: 15
        }
      }, t('iiif_seeAlso')), seeAlso.map(function (related) {
        return /*#__PURE__*/_react["default"].createElement(_Typography["default"], {
          key: related.value,
          variant: "body1",
          component: "dd",
          __self: _this,
          __source: {
            fileName: _jsxFileName,
            lineNumber: 75,
            columnNumber: 19
          }
        }, /*#__PURE__*/_react["default"].createElement(_Link["default"], {
          target: "_blank",
          rel: "noopener noreferrer",
          href: related.value,
          __self: _this,
          __source: {
            fileName: _jsxFileName,
            lineNumber: 76,
            columnNumber: 21
          }
        }, related.label || related.value), related.format && /*#__PURE__*/_react["default"].createElement(_Typography["default"], {
          component: "span",
          __self: _this,
          __source: {
            fileName: _jsxFileName,
            lineNumber: 80,
            columnNumber: 23
          }
        }, "(".concat(related.format, ")")));
      })), manifestUrl && /*#__PURE__*/_react["default"].createElement(_react["default"].Fragment, null, /*#__PURE__*/_react["default"].createElement(_Typography["default"], {
        variant: "subtitle2",
        component: "dt",
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 89,
          columnNumber: 15
        }
      }, t('iiif_manifest')), /*#__PURE__*/_react["default"].createElement(_Typography["default"], {
        variant: "body1",
        component: "dd",
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 90,
          columnNumber: 15
        }
      }, /*#__PURE__*/_react["default"].createElement(_Link["default"], {
        target: "_blank",
        rel: "noopener noreferrer",
        href: manifestUrl,
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 91,
          columnNumber: 17
        }
      }, manifestUrl)))));
    }
  }]);

  return ManifestRelatedLinks;
}(_react.Component);

exports.ManifestRelatedLinks = ManifestRelatedLinks;
ManifestRelatedLinks.defaultProps = {
  homepage: null,
  manifestUrl: null,
  renderings: null,
  seeAlso: null,
  t: function t(key) {
    return key;
  }
};