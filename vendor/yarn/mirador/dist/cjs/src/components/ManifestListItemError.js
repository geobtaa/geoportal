"use strict";

Object.defineProperty(exports, "__esModule", {
  value: true
});
exports.ManifestListItemError = void 0;

var _react = _interopRequireWildcard(require("react"));

var _Button = _interopRequireDefault(require("@material-ui/core/Button"));

var _ErrorOutlineSharp = _interopRequireDefault(require("@material-ui/icons/ErrorOutlineSharp"));

var _Grid = _interopRequireDefault(require("@material-ui/core/Grid"));

var _Typography = _interopRequireDefault(require("@material-ui/core/Typography"));

var _jsxFileName = "/Users/pjreed/dev/mirador/dist/cjs/src/components/ManifestListItemError.js";

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
 * ManifestListItemError renders a component displaying a
 * message to the user about a problem loading a manifest
*/
var ManifestListItemError = /*#__PURE__*/function (_Component) {
  _inherits(ManifestListItemError, _Component);

  var _super = _createSuper(ManifestListItemError);

  function ManifestListItemError() {
    _classCallCheck(this, ManifestListItemError);

    return _super.apply(this, arguments);
  }

  _createClass(ManifestListItemError, [{
    key: "render",

    /**
     * Returns the rendered component
    */
    value: function render() {
      var _this$props = this.props,
          classes = _this$props.classes,
          manifestId = _this$props.manifestId,
          onDismissClick = _this$props.onDismissClick,
          onTryAgainClick = _this$props.onTryAgainClick,
          t = _this$props.t;
      return /*#__PURE__*/_react["default"].createElement(_Grid["default"], {
        container: true,
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 22,
          columnNumber: 7
        }
      }, /*#__PURE__*/_react["default"].createElement(_Grid["default"], {
        container: true,
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 23,
          columnNumber: 9
        }
      }, /*#__PURE__*/_react["default"].createElement(_Grid["default"], {
        container: true,
        item: true,
        xs: 12,
        sm: 6,
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 24,
          columnNumber: 11
        }
      }, /*#__PURE__*/_react["default"].createElement(_Grid["default"], {
        item: true,
        xs: 4,
        sm: 3,
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 25,
          columnNumber: 13
        }
      }, /*#__PURE__*/_react["default"].createElement(_Grid["default"], {
        container: true,
        justify: "center",
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 26,
          columnNumber: 15
        }
      }, /*#__PURE__*/_react["default"].createElement(_ErrorOutlineSharp["default"], {
        className: classes.errorIcon,
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 27,
          columnNumber: 17
        }
      }))), /*#__PURE__*/_react["default"].createElement(_Grid["default"], {
        item: true,
        xs: 8,
        sm: 9,
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 30,
          columnNumber: 13
        }
      }, /*#__PURE__*/_react["default"].createElement(_Typography["default"], {
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 31,
          columnNumber: 15
        }
      }, t('manifestError')), /*#__PURE__*/_react["default"].createElement(_Typography["default"], {
        className: classes.manifestIdText,
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 32,
          columnNumber: 15
        }
      }, manifestId)))), /*#__PURE__*/_react["default"].createElement(_Grid["default"], {
        container: true,
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 37,
          columnNumber: 9
        }
      }, /*#__PURE__*/_react["default"].createElement(_Grid["default"], {
        container: true,
        item: true,
        xs: 12,
        sm: 6,
        justify: "flex-end",
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 38,
          columnNumber: 11
        }
      }, /*#__PURE__*/_react["default"].createElement(_Grid["default"], {
        item: true,
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 39,
          columnNumber: 13
        }
      }, /*#__PURE__*/_react["default"].createElement(_Button["default"], {
        onClick: function onClick() {
          onDismissClick(manifestId);
        },
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 40,
          columnNumber: 15
        }
      }, t('dismiss')), /*#__PURE__*/_react["default"].createElement(_Button["default"], {
        onClick: function onClick() {
          onTryAgainClick(manifestId);
        },
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 43,
          columnNumber: 15
        }
      }, t('tryAgain'))))));
    }
  }]);

  return ManifestListItemError;
}(_react.Component);

exports.ManifestListItemError = ManifestListItemError;