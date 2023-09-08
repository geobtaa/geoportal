"use strict";

Object.defineProperty(exports, "__esModule", {
  value: true
});
exports.WindowViewSettings = void 0;

var _react = _interopRequireWildcard(require("react"));

var _reactDom = _interopRequireDefault(require("react-dom"));

var _FormControlLabel = _interopRequireDefault(require("@material-ui/core/FormControlLabel"));

var _MenuItem = _interopRequireDefault(require("@material-ui/core/MenuItem"));

var _ListSubheader = _interopRequireDefault(require("@material-ui/core/ListSubheader"));

var _CropOriginalSharp = _interopRequireDefault(require("@material-ui/icons/CropOriginalSharp"));

var _BookViewIcon = _interopRequireDefault(require("./icons/BookViewIcon"));

var _GalleryViewIcon = _interopRequireDefault(require("./icons/GalleryViewIcon"));

var _jsxFileName = "/Users/pjreed/dev/mirador/dist/cjs/src/components/WindowViewSettings.js";

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
 *
 */
var WindowViewSettings = /*#__PURE__*/function (_Component) {
  _inherits(WindowViewSettings, _Component);

  var _super = _createSuper(WindowViewSettings);

  /**
   * constructor -
   */
  function WindowViewSettings(props) {
    var _this;

    _classCallCheck(this, WindowViewSettings);

    _this = _super.call(this, props);
    _this.handleChange = _this.handleChange.bind(_assertThisInitialized(_this));
    return _this;
  }
  /**
   * Take action when the component mounts for the first time
   */


  _createClass(WindowViewSettings, [{
    key: "componentDidMount",
    value: function componentDidMount() {
      if (this.selectedRef) {
        // MUI uses ReactDOM.findDOMNode and refs for handling focus
        _reactDom["default"].findDOMNode(this.selectedRef).focus(); // eslint-disable-line react/no-find-dom-node

      }
    }
    /**
     * @private
     */

  }, {
    key: "handleSelectedRef",
    value: function handleSelectedRef(ref) {
      if (this.selectedRef) return;
      this.selectedRef = ref;
    }
    /**
     * @private
     */

  }, {
    key: "handleChange",
    value: function handleChange(value) {
      var _this$props = this.props,
          windowId = _this$props.windowId,
          setWindowViewType = _this$props.setWindowViewType;
      setWindowViewType(windowId, value);
    }
    /**
     * render
     *
     * @return {type}  description
     */

  }, {
    key: "render",
    value: function render() {
      var _this2 = this;

      var _this$props2 = this.props,
          classes = _this$props2.classes,
          handleClose = _this$props2.handleClose,
          t = _this$props2.t,
          windowViewType = _this$props2.windowViewType;
      return /*#__PURE__*/_react["default"].createElement(_react["default"].Fragment, null, /*#__PURE__*/_react["default"].createElement(_ListSubheader["default"], {
        role: "presentation",
        disableSticky: true,
        tabIndex: "-1",
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 63,
          columnNumber: 9
        }
      }, t('view')), /*#__PURE__*/_react["default"].createElement(_MenuItem["default"], {
        className: classes.MenuItem,
        ref: function ref(_ref) {
          return _this2.handleSelectedRef(_ref);
        },
        onClick: function onClick() {
          _this2.handleChange('single');

          handleClose();
        },
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 65,
          columnNumber: 9
        }
      }, /*#__PURE__*/_react["default"].createElement(_FormControlLabel["default"], {
        value: "single",
        classes: {
          label: windowViewType === 'single' ? classes.selectedLabel : classes.label
        },
        control: /*#__PURE__*/_react["default"].createElement(_CropOriginalSharp["default"], {
          color: windowViewType === 'single' ? 'secondary' : undefined,
          __self: this,
          __source: {
            fileName: _jsxFileName,
            lineNumber: 73,
            columnNumber: 22
          }
        }),
        label: t('single'),
        labelPlacement: "bottom",
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 70,
          columnNumber: 11
        }
      })), /*#__PURE__*/_react["default"].createElement(_MenuItem["default"], {
        className: classes.MenuItem,
        onClick: function onClick() {
          _this2.handleChange('book');

          handleClose();
        },
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 78,
          columnNumber: 9
        }
      }, /*#__PURE__*/_react["default"].createElement(_FormControlLabel["default"], {
        value: "book",
        classes: {
          label: windowViewType === 'book' ? classes.selectedLabel : classes.label
        },
        control: /*#__PURE__*/_react["default"].createElement(_BookViewIcon["default"], {
          color: windowViewType === 'book' ? 'secondary' : undefined,
          __self: this,
          __source: {
            fileName: _jsxFileName,
            lineNumber: 82,
            columnNumber: 22
          }
        }),
        label: t('book'),
        labelPlacement: "bottom",
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 79,
          columnNumber: 11
        }
      })), /*#__PURE__*/_react["default"].createElement(_MenuItem["default"], {
        className: classes.MenuItem,
        onClick: function onClick() {
          _this2.handleChange('gallery');

          handleClose();
        },
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 87,
          columnNumber: 9
        }
      }, /*#__PURE__*/_react["default"].createElement(_FormControlLabel["default"], {
        value: "gallery",
        classes: {
          label: windowViewType === 'gallery' ? classes.selectedLabel : classes.label
        },
        control: /*#__PURE__*/_react["default"].createElement(_GalleryViewIcon["default"], {
          color: windowViewType === 'gallery' ? 'secondary' : undefined,
          __self: this,
          __source: {
            fileName: _jsxFileName,
            lineNumber: 91,
            columnNumber: 22
          }
        }),
        label: t('gallery'),
        labelPlacement: "bottom",
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 88,
          columnNumber: 11
        }
      })));
    }
  }]);

  return WindowViewSettings;
}(_react.Component);

exports.WindowViewSettings = WindowViewSettings;
WindowViewSettings.defaultProps = {
  handleClose: function handleClose() {},
  t: function t(key) {
    return key;
  }
};