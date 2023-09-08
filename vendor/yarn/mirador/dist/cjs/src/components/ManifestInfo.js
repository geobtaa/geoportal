"use strict";

Object.defineProperty(exports, "__esModule", {
  value: true
});
exports.ManifestInfo = void 0;

var _react = _interopRequireWildcard(require("react"));

var _Typography = _interopRequireDefault(require("@material-ui/core/Typography"));

var _CollapsibleSection = _interopRequireDefault(require("../containers/CollapsibleSection"));

var _SanitizedHtml = _interopRequireDefault(require("../containers/SanitizedHtml"));

var _LabelValueMetadata = require("./LabelValueMetadata");

var _jsxFileName = "/Users/pjreed/dev/mirador/dist/cjs/src/components/ManifestInfo.js";

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
 * ManifestInfo
 */
var ManifestInfo = /*#__PURE__*/function (_Component) {
  _inherits(ManifestInfo, _Component);

  var _super = _createSuper(ManifestInfo);

  function ManifestInfo() {
    _classCallCheck(this, ManifestInfo);

    return _super.apply(this, arguments);
  }

  _createClass(ManifestInfo, [{
    key: "render",

    /**
     * render
     * @return
     */
    value: function render() {
      var _this$props = this.props,
          manifestDescription = _this$props.manifestDescription,
          manifestLabel = _this$props.manifestLabel,
          manifestMetadata = _this$props.manifestMetadata,
          id = _this$props.id,
          t = _this$props.t;
      return /*#__PURE__*/_react["default"].createElement(_CollapsibleSection["default"], {
        id: "".concat(id, "-resource"),
        label: t('resource'),
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 27,
          columnNumber: 7
        }
      }, manifestLabel && /*#__PURE__*/_react["default"].createElement(_Typography["default"], {
        "aria-labelledby": "".concat(id, "-resource ").concat(id, "-resource-heading"),
        id: "".concat(id, "-resource-heading"),
        variant: "h4",
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 32,
          columnNumber: 11
        }
      }, manifestLabel), manifestDescription && /*#__PURE__*/_react["default"].createElement(_Typography["default"], {
        variant: "body1",
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 42,
          columnNumber: 11
        }
      }, /*#__PURE__*/_react["default"].createElement(_SanitizedHtml["default"], {
        htmlString: manifestDescription,
        ruleSet: "iiif",
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 43,
          columnNumber: 13
        }
      })), manifestMetadata.length > 0 && /*#__PURE__*/_react["default"].createElement(_LabelValueMetadata.LabelValueMetadata, {
        labelValuePairs: manifestMetadata,
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 48,
          columnNumber: 11
        }
      }));
    }
  }]);

  return ManifestInfo;
}(_react.Component);

exports.ManifestInfo = ManifestInfo;
ManifestInfo.defaultProps = {
  manifestDescription: null,
  manifestLabel: null,
  manifestMetadata: [],
  t: function t(key) {
    return key;
  }
};