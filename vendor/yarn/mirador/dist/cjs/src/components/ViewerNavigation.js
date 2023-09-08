"use strict";

Object.defineProperty(exports, "__esModule", {
  value: true
});
exports.ViewerNavigation = void 0;

var _react = _interopRequireWildcard(require("react"));

var _PlayCircleOutlineSharp = _interopRequireDefault(require("@material-ui/icons/PlayCircleOutlineSharp"));

var _classnames = _interopRequireDefault(require("classnames"));

var _MiradorMenuButton = _interopRequireDefault(require("../containers/MiradorMenuButton"));

var _cssNs = _interopRequireDefault(require("../config/css-ns"));

var _jsxFileName = "/Users/pjreed/dev/mirador/dist/cjs/src/components/ViewerNavigation.js";

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
 */
var ViewerNavigation = /*#__PURE__*/function (_Component) {
  _inherits(ViewerNavigation, _Component);

  var _super = _createSuper(ViewerNavigation);

  function ViewerNavigation() {
    _classCallCheck(this, ViewerNavigation);

    return _super.apply(this, arguments);
  }

  _createClass(ViewerNavigation, [{
    key: "render",

    /**
     * Renders things
     */
    value: function render() {
      var _this$props = this.props,
          hasNextCanvas = _this$props.hasNextCanvas,
          hasPreviousCanvas = _this$props.hasPreviousCanvas,
          setNextCanvas = _this$props.setNextCanvas,
          setPreviousCanvas = _this$props.setPreviousCanvas,
          t = _this$props.t,
          classes = _this$props.classes,
          viewingDirection = _this$props.viewingDirection;
      var htmlDir = 'ltr';
      var nextIconStyle = {
        transform: 'rotate(180deg)'
      };
      var previousIconStyle = {};

      if (viewingDirection === 'right-to-left') {
        htmlDir = 'rtl';
        nextIconStyle = {};
        previousIconStyle = {
          transform: 'rotate(180deg)'
        };
      }

      return /*#__PURE__*/_react["default"].createElement("div", {
        className: (0, _classnames["default"])((0, _cssNs["default"])('osd-navigation'), classes.osdNavigation),
        dir: htmlDir,
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 30,
          columnNumber: 7
        }
      }, /*#__PURE__*/_react["default"].createElement(_MiradorMenuButton["default"], {
        "aria-label": t('previousCanvas'),
        className: (0, _cssNs["default"])('previous-canvas-button'),
        disabled: !hasPreviousCanvas,
        onClick: function onClick() {
          hasPreviousCanvas && setPreviousCanvas();
        },
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 34,
          columnNumber: 9
        }
      }, /*#__PURE__*/_react["default"].createElement(_PlayCircleOutlineSharp["default"], {
        style: nextIconStyle,
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 40,
          columnNumber: 11
        }
      })), /*#__PURE__*/_react["default"].createElement(_MiradorMenuButton["default"], {
        "aria-label": t('nextCanvas'),
        className: (0, _cssNs["default"])('next-canvas-button'),
        disabled: !hasNextCanvas,
        onClick: function onClick() {
          hasNextCanvas && setNextCanvas();
        },
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 42,
          columnNumber: 9
        }
      }, /*#__PURE__*/_react["default"].createElement(_PlayCircleOutlineSharp["default"], {
        style: previousIconStyle,
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 48,
          columnNumber: 11
        }
      })));
    }
  }]);

  return ViewerNavigation;
}(_react.Component);

exports.ViewerNavigation = ViewerNavigation;
ViewerNavigation.defaultProps = {
  hasNextCanvas: false,
  hasPreviousCanvas: false,
  setNextCanvas: function setNextCanvas() {},
  setPreviousCanvas: function setPreviousCanvas() {},
  viewingDirection: ''
};