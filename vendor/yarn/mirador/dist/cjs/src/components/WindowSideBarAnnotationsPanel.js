"use strict";

Object.defineProperty(exports, "__esModule", {
  value: true
});
exports.WindowSideBarAnnotationsPanel = void 0;

var _react = _interopRequireWildcard(require("react"));

var _Typography = _interopRequireDefault(require("@material-ui/core/Typography"));

var _AnnotationSettings = _interopRequireDefault(require("../containers/AnnotationSettings"));

var _CanvasAnnotations = _interopRequireDefault(require("../containers/CanvasAnnotations"));

var _CompanionWindow = _interopRequireDefault(require("../containers/CompanionWindow"));

var _cssNs = _interopRequireDefault(require("../config/css-ns"));

var _jsxFileName = "/Users/pjreed/dev/mirador/dist/cjs/src/components/WindowSideBarAnnotationsPanel.js";

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
 * WindowSideBarAnnotationsPanel ~
*/
var WindowSideBarAnnotationsPanel = /*#__PURE__*/function (_Component) {
  _inherits(WindowSideBarAnnotationsPanel, _Component);

  var _super = _createSuper(WindowSideBarAnnotationsPanel);

  function WindowSideBarAnnotationsPanel() {
    _classCallCheck(this, WindowSideBarAnnotationsPanel);

    return _super.apply(this, arguments);
  }

  _createClass(WindowSideBarAnnotationsPanel, [{
    key: "render",

    /**
     * Returns the rendered component
    */
    value: function render() {
      var _this = this;

      var _this$props = this.props,
          annotationCount = _this$props.annotationCount,
          classes = _this$props.classes,
          selectedCanvases = _this$props.selectedCanvases,
          t = _this$props.t,
          windowId = _this$props.windowId,
          id = _this$props.id;
      return /*#__PURE__*/_react["default"].createElement(_CompanionWindow["default"], {
        title: t('annotations'),
        paperClassName: (0, _cssNs["default"])('window-sidebar-annotation-panel'),
        windowId: windowId,
        id: id,
        titleControls: /*#__PURE__*/_react["default"].createElement(_AnnotationSettings["default"], {
          windowId: windowId,
          __self: this,
          __source: {
            fileName: _jsxFileName,
            lineNumber: 26,
            columnNumber: 24
          }
        }),
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 21,
          columnNumber: 7
        }
      }, /*#__PURE__*/_react["default"].createElement("div", {
        className: classes.section,
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 28,
          columnNumber: 9
        }
      }, /*#__PURE__*/_react["default"].createElement(_Typography["default"], {
        component: "p",
        variant: "subtitle2",
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 29,
          columnNumber: 11
        }
      }, t('showingNumAnnotations', {
        number: annotationCount
      }))), selectedCanvases.map(function (canvas, index) {
        return /*#__PURE__*/_react["default"].createElement(_CanvasAnnotations["default"], {
          canvasId: canvas.id,
          key: canvas.id,
          index: index,
          totalSize: selectedCanvases.length,
          windowId: windowId,
          __self: _this,
          __source: {
            fileName: _jsxFileName,
            lineNumber: 33,
            columnNumber: 11
          }
        });
      }));
    }
  }]);

  return WindowSideBarAnnotationsPanel;
}(_react.Component);

exports.WindowSideBarAnnotationsPanel = WindowSideBarAnnotationsPanel;
WindowSideBarAnnotationsPanel.defaultProps = {
  selectedCanvases: [],
  t: function t(key) {
    return key;
  }
};