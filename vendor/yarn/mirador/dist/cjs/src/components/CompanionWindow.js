"use strict";

Object.defineProperty(exports, "__esModule", {
  value: true
});
exports.CompanionWindow = void 0;

var _react = _interopRequireWildcard(require("react"));

var _CloseSharp = _interopRequireDefault(require("@material-ui/icons/CloseSharp"));

var _OpenInNewSharp = _interopRequireDefault(require("@material-ui/icons/OpenInNewSharp"));

var _DragIndicatorSharp = _interopRequireDefault(require("@material-ui/icons/DragIndicatorSharp"));

var _Paper = _interopRequireDefault(require("@material-ui/core/Paper"));

var _Typography = _interopRequireDefault(require("@material-ui/core/Typography"));

var _Toolbar = _interopRequireDefault(require("@material-ui/core/Toolbar"));

var _reactRnd = require("react-rnd");

var _MiradorMenuButton = _interopRequireDefault(require("../containers/MiradorMenuButton"));

var _cssNs = _interopRequireDefault(require("../config/css-ns"));

var _jsxFileName = "/Users/pjreed/dev/mirador/dist/cjs/src/components/CompanionWindow.js";

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { "default": obj }; }

function _getRequireWildcardCache() { if (typeof WeakMap !== "function") return null; var cache = new WeakMap(); _getRequireWildcardCache = function _getRequireWildcardCache() { return cache; }; return cache; }

function _interopRequireWildcard(obj) { if (obj && obj.__esModule) { return obj; } if (obj === null || typeof obj !== "object" && typeof obj !== "function") { return { "default": obj }; } var cache = _getRequireWildcardCache(); if (cache && cache.has(obj)) { return cache.get(obj); } var newObj = {}; var hasPropertyDescriptor = Object.defineProperty && Object.getOwnPropertyDescriptor; for (var key in obj) { if (Object.prototype.hasOwnProperty.call(obj, key)) { var desc = hasPropertyDescriptor ? Object.getOwnPropertyDescriptor(obj, key) : null; if (desc && (desc.get || desc.set)) { Object.defineProperty(newObj, key, desc); } else { newObj[key] = obj[key]; } } } newObj["default"] = obj; if (cache) { cache.set(obj, newObj); } return newObj; }

function ownKeys(object, enumerableOnly) { var keys = Object.keys(object); if (Object.getOwnPropertySymbols) { var symbols = Object.getOwnPropertySymbols(object); if (enumerableOnly) symbols = symbols.filter(function (sym) { return Object.getOwnPropertyDescriptor(object, sym).enumerable; }); keys.push.apply(keys, symbols); } return keys; }

function _objectSpread(target) { for (var i = 1; i < arguments.length; i++) { var source = arguments[i] != null ? arguments[i] : {}; if (i % 2) { ownKeys(Object(source), true).forEach(function (key) { _defineProperty(target, key, source[key]); }); } else if (Object.getOwnPropertyDescriptors) { Object.defineProperties(target, Object.getOwnPropertyDescriptors(source)); } else { ownKeys(Object(source)).forEach(function (key) { Object.defineProperty(target, key, Object.getOwnPropertyDescriptor(source, key)); }); } } return target; }

function _defineProperty(obj, key, value) { if (key in obj) { Object.defineProperty(obj, key, { value: value, enumerable: true, configurable: true, writable: true }); } else { obj[key] = value; } return obj; }

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
 * CompanionWindow
 */
var CompanionWindow = /*#__PURE__*/function (_Component) {
  _inherits(CompanionWindow, _Component);

  var _super = _createSuper(CompanionWindow);

  function CompanionWindow() {
    _classCallCheck(this, CompanionWindow);

    return _super.apply(this, arguments);
  }

  _createClass(CompanionWindow, [{
    key: "openInNewStyle",

    /** */
    value: function openInNewStyle() {
      var direction = this.props.direction;
      if (direction === 'rtl') return {
        transform: 'scale(-1, 1)'
      };
      return {};
    }
    /** */

  }, {
    key: "resizeHandles",
    value: function resizeHandles() {
      var _this$props = this.props,
          direction = _this$props.direction,
          position = _this$props.position;
      var positions = {
        ltr: {
          "default": 'left',
          opposite: 'right'
        },
        rtl: {
          "default": 'right',
          opposite: 'left'
        }
      };
      var base = {
        bottom: false,
        bottomLeft: false,
        bottomRight: false,
        left: false,
        right: false,
        top: false,
        topLeft: false,
        topRight: false
      };

      if (position === 'right' || position === 'far-right') {
        return _objectSpread({}, base, _defineProperty({}, positions[direction]["default"], true));
      }

      if (position === 'left') {
        return _objectSpread({}, base, _defineProperty({}, positions[direction].opposite, true));
      }

      if (position === 'bottom' || position === 'far-bottom') {
        return _objectSpread({}, base, {
          top: true
        });
      }

      return base;
    }
    /**
     * render
     * @return
     */

  }, {
    key: "render",
    value: function render() {
      var _this$props2 = this.props,
          ariaLabel = _this$props2.ariaLabel,
          classes = _this$props2.classes,
          paperClassName = _this$props2.paperClassName,
          id = _this$props2.id,
          onCloseClick = _this$props2.onCloseClick,
          updateCompanionWindow = _this$props2.updateCompanionWindow,
          isDisplayed = _this$props2.isDisplayed,
          position = _this$props2.position,
          t = _this$props2.t,
          windowId = _this$props2.windowId,
          title = _this$props2.title,
          children = _this$props2.children,
          titleControls = _this$props2.titleControls,
          size = _this$props2.size,
          defaultSidebarPanelWidth = _this$props2.defaultSidebarPanelWidth;
      var isBottom = position === 'bottom' || position === 'far-bottom';
      return /*#__PURE__*/_react["default"].createElement(_Paper["default"], {
        className: [classes.root, position === 'bottom' ? classes.horizontal : classes.vertical, classes["companionWindow-".concat(position)], (0, _cssNs["default"])("companion-window-".concat(position)), paperClassName].join(' '),
        style: {
          display: isDisplayed ? null : 'none',
          order: position === 'left' ? -1 : null
        },
        square: true,
        component: "aside",
        "aria-label": ariaLabel || title,
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 79,
          columnNumber: 7
        }
      }, /*#__PURE__*/_react["default"].createElement(_reactRnd.Rnd, {
        className: [classes.rnd],
        style: {
          display: 'flex',
          position: 'relative'
        },
        "default": {
          height: isBottom ? 201 : '100%',
          width: isBottom ? 'auto' : defaultSidebarPanelWidth
        },
        disableDragging: true,
        enableResizing: this.resizeHandles(),
        minHeight: 50,
        minWidth: position === 'left' ? 235 : 100,
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 89,
          columnNumber: 9
        }
      }, /*#__PURE__*/_react["default"].createElement(_Toolbar["default"], {
        className: [classes.toolbar, classes.companionWindowHeader, size.width < 370 ? classes.small : null, (0, _cssNs["default"])('companion-window-header')].join(' '),
        disableGutters: true,
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 102,
          columnNumber: 11
        }
      }, /*#__PURE__*/_react["default"].createElement(_Typography["default"], {
        variant: "h3",
        className: classes.windowSideBarTitle,
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 111,
          columnNumber: 13
        }
      }, title), position === 'left' ? updateCompanionWindow && /*#__PURE__*/_react["default"].createElement(_MiradorMenuButton["default"], {
        "aria-label": t('openInCompanionWindow'),
        onClick: function onClick() {
          updateCompanionWindow(windowId, id, {
            position: 'right'
          });
        },
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 118,
          columnNumber: 21
        }
      }, /*#__PURE__*/_react["default"].createElement(_OpenInNewSharp["default"], {
        style: this.openInNewStyle(),
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 122,
          columnNumber: 23
        }
      })) : /*#__PURE__*/_react["default"].createElement(_react["default"].Fragment, null, updateCompanionWindow && /*#__PURE__*/_react["default"].createElement(_MiradorMenuButton["default"], {
        "aria-label": position === 'bottom' ? t('moveCompanionWindowToRight') : t('moveCompanionWindowToBottom'),
        className: classes.positionButton,
        onClick: function onClick() {
          updateCompanionWindow(windowId, id, {
            position: position === 'bottom' ? 'right' : 'bottom'
          });
        },
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 129,
          columnNumber: 25
        }
      }, /*#__PURE__*/_react["default"].createElement(_DragIndicatorSharp["default"], {
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 134,
          columnNumber: 27
        }
      })), /*#__PURE__*/_react["default"].createElement(_MiradorMenuButton["default"], {
        "aria-label": t('closeCompanionWindow'),
        className: classes.closeButton,
        onClick: onCloseClick,
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 138,
          columnNumber: 21
        }
      }, /*#__PURE__*/_react["default"].createElement(_CloseSharp["default"], {
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 143,
          columnNumber: 23
        }
      }))), titleControls && /*#__PURE__*/_react["default"].createElement("div", {
        className: [classes.titleControls, isBottom ? classes.companionWindowTitleControlsBottom : classes.companionWindowTitleControls, (0, _cssNs["default"])('companion-window-title-controls')].join(' '),
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 150,
          columnNumber: 17
        }
      }, titleControls)), /*#__PURE__*/_react["default"].createElement(_Paper["default"], {
        className: classes.content,
        elevation: 0,
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 164,
          columnNumber: 11
        }
      }, children)));
    }
  }]);

  return CompanionWindow;
}(_react.Component);

exports.CompanionWindow = CompanionWindow;
CompanionWindow.defaultProps = {
  ariaLabel: undefined,
  children: undefined,
  defaultSidebarPanelWidth: 235,
  isDisplayed: false,
  onCloseClick: function onCloseClick() {},
  paperClassName: '',
  position: null,
  size: {},
  t: function t(key) {
    return key;
  },
  title: null,
  titleControls: null,
  updateCompanionWindow: undefined
};