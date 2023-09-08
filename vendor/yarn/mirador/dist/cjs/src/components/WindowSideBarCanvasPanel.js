"use strict";

Object.defineProperty(exports, "__esModule", {
  value: true
});
exports.WindowSideBarCanvasPanel = void 0;

var _react = _interopRequireWildcard(require("react"));

var _Typography = _interopRequireDefault(require("@material-ui/core/Typography"));

var _MenuItem = _interopRequireDefault(require("@material-ui/core/MenuItem"));

var _FormControl = _interopRequireDefault(require("@material-ui/core/FormControl"));

var _RootRef = _interopRequireDefault(require("@material-ui/core/RootRef"));

var _Select = _interopRequireDefault(require("@material-ui/core/Select"));

var _CompanionWindow = _interopRequireDefault(require("../containers/CompanionWindow"));

var _SidebarIndexList = _interopRequireDefault(require("../containers/SidebarIndexList"));

var _SidebarIndexTableOfContents = _interopRequireDefault(require("../containers/SidebarIndexTableOfContents"));

var _jsxFileName = "/Users/pjreed/dev/mirador/dist/cjs/src/components/WindowSideBarCanvasPanel.js";

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
 * a panel showing the canvases for a given manifest
 */
var WindowSideBarCanvasPanel = /*#__PURE__*/function (_Component) {
  _inherits(WindowSideBarCanvasPanel, _Component);

  var _super = _createSuper(WindowSideBarCanvasPanel);

  /** */
  function WindowSideBarCanvasPanel(props) {
    var _this;

    _classCallCheck(this, WindowSideBarCanvasPanel);

    _this = _super.call(this, props);
    _this.handleVariantChange = _this.handleVariantChange.bind(_assertThisInitialized(_this));
    _this.state = {
      variantSelectionOpened: false
    };
    _this.containerRef = _react["default"].createRef();
    return _this;
  }
  /** @private */


  _createClass(WindowSideBarCanvasPanel, [{
    key: "handleVariantChange",
    value: function handleVariantChange(event) {
      var updateVariant = this.props.updateVariant;
      updateVariant(event.target.value);
      this.setState({
        variantSelectionOpened: false
      });
    }
    /**
     * render
     */

  }, {
    key: "render",
    value: function render() {
      var _this2 = this;

      var _this$props = this.props,
          classes = _this$props.classes,
          id = _this$props.id,
          t = _this$props.t,
          toggleDraggingEnabled = _this$props.toggleDraggingEnabled,
          variant = _this$props.variant,
          windowId = _this$props.windowId;
      var variantSelectionOpened = this.state.variantSelectionOpened;
      var listComponent;

      if (variant === 'tableOfContents') {
        listComponent = /*#__PURE__*/_react["default"].createElement(_SidebarIndexTableOfContents["default"], {
          id: id,
          containerRef: this.containerRef,
          windowId: windowId,
          __self: this,
          __source: {
            fileName: _jsxFileName,
            lineNumber: 53,
            columnNumber: 9
          }
        });
      } else {
        listComponent = /*#__PURE__*/_react["default"].createElement(_SidebarIndexList["default"], {
          id: id,
          containerRef: this.containerRef,
          windowId: windowId,
          __self: this,
          __source: {
            fileName: _jsxFileName,
            lineNumber: 61,
            columnNumber: 9
          }
        });
      }

      return /*#__PURE__*/_react["default"].createElement(_RootRef["default"], {
        rootRef: this.containerRef,
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 69,
          columnNumber: 7
        }
      }, /*#__PURE__*/_react["default"].createElement(_CompanionWindow["default"], {
        title: t('canvasIndex'),
        id: id,
        windowId: windowId,
        titleControls: /*#__PURE__*/_react["default"].createElement(_FormControl["default"], {
          __self: this,
          __source: {
            fileName: _jsxFileName,
            lineNumber: 75,
            columnNumber: 13
          }
        }, /*#__PURE__*/_react["default"].createElement(_Select["default"], {
          MenuProps: {
            anchorOrigin: {
              horizontal: 'left',
              vertical: 'bottom'
            },
            getContentAnchorEl: null
          },
          displayEmpty: true,
          value: variant,
          onChange: this.handleVariantChange,
          name: "variant",
          open: variantSelectionOpened,
          onOpen: function onOpen(e) {
            toggleDraggingEnabled();

            _this2.setState({
              variantSelectionOpened: true
            });
          },
          onClose: function onClose(e) {
            toggleDraggingEnabled();

            _this2.setState({
              variantSelectionOpened: false
            });
          },
          classes: {
            select: classes.select
          },
          className: classes.selectEmpty,
          __self: this,
          __source: {
            fileName: _jsxFileName,
            lineNumber: 76,
            columnNumber: 15
          }
        }, /*#__PURE__*/_react["default"].createElement(_MenuItem["default"], {
          value: "tableOfContents",
          __self: this,
          __source: {
            fileName: _jsxFileName,
            lineNumber: 100,
            columnNumber: 17
          }
        }, /*#__PURE__*/_react["default"].createElement(_Typography["default"], {
          variant: "body2",
          __self: this,
          __source: {
            fileName: _jsxFileName,
            lineNumber: 100,
            columnNumber: 51
          }
        }, t('tableOfContentsList'))), /*#__PURE__*/_react["default"].createElement(_MenuItem["default"], {
          value: "item",
          __self: this,
          __source: {
            fileName: _jsxFileName,
            lineNumber: 101,
            columnNumber: 17
          }
        }, /*#__PURE__*/_react["default"].createElement(_Typography["default"], {
          variant: "body2",
          __self: this,
          __source: {
            fileName: _jsxFileName,
            lineNumber: 101,
            columnNumber: 40
          }
        }, t('itemList'))), /*#__PURE__*/_react["default"].createElement(_MenuItem["default"], {
          value: "thumbnail",
          __self: this,
          __source: {
            fileName: _jsxFileName,
            lineNumber: 102,
            columnNumber: 17
          }
        }, /*#__PURE__*/_react["default"].createElement(_Typography["default"], {
          variant: "body2",
          __self: this,
          __source: {
            fileName: _jsxFileName,
            lineNumber: 102,
            columnNumber: 45
          }
        }, t('thumbnailList'))))),
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 70,
          columnNumber: 9
        }
      }, listComponent));
    }
  }]);

  return WindowSideBarCanvasPanel;
}(_react.Component);

exports.WindowSideBarCanvasPanel = WindowSideBarCanvasPanel;