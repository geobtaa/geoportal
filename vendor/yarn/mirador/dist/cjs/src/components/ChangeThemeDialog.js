"use strict";

Object.defineProperty(exports, "__esModule", {
  value: true
});
exports.ChangeThemeDialog = void 0;

var _react = _interopRequireWildcard(require("react"));

var _core = require("@material-ui/core");

var _PaletteSharp = _interopRequireDefault(require("@material-ui/icons/PaletteSharp"));

var _jsxFileName = "/Users/pjreed/dev/mirador/dist/cjs/src/components/ChangeThemeDialog.js";

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
 * a simple dialog providing the possibility to switch the theme
 */
var ChangeThemeDialog = /*#__PURE__*/function (_Component) {
  _inherits(ChangeThemeDialog, _Component);

  var _super = _createSuper(ChangeThemeDialog);

  _createClass(ChangeThemeDialog, null, [{
    key: "setInitialFocus",

    /**
     * Set the initial focus when the dialog enters
     * Find the selected item by using the current theme
     * in a selector on the value attribute (which we need to set)
    */
    value: function setInitialFocus(dialogElement, selectedTheme) {
      var selectedListItem = dialogElement.querySelectorAll("li[value=\"".concat(selectedTheme, "\"]"));
      if (!selectedListItem || selectedListItem.length === 0) return;
      selectedListItem[0].focus();
    }
    /**
    */

  }]);

  function ChangeThemeDialog(props) {
    var _this;

    _classCallCheck(this, ChangeThemeDialog);

    _this = _super.call(this, props);
    _this.selectedItemRef = _react["default"].createRef();
    _this.handleThemeChange = _this.handleThemeChange.bind(_assertThisInitialized(_this));
    return _this;
  }
  /**
   * Propagate theme palette type selection into the global state
   */


  _createClass(ChangeThemeDialog, [{
    key: "handleThemeChange",
    value: function handleThemeChange(theme) {
      var _this$props = this.props,
          setSelectedTheme = _this$props.setSelectedTheme,
          handleClose = _this$props.handleClose;
      setSelectedTheme(theme);
      handleClose();
    }
    /** */

  }, {
    key: "render",
    value: function render() {
      var _this2 = this;

      var _this$props2 = this.props,
          classes = _this$props2.classes,
          handleClose = _this$props2.handleClose,
          open = _this$props2.open,
          selectedTheme = _this$props2.selectedTheme,
          t = _this$props2.t,
          themeIds = _this$props2.themeIds;
      return /*#__PURE__*/_react["default"].createElement(_core.Dialog, {
        onClose: handleClose,
        onEntered: function onEntered(dialog) {
          return ChangeThemeDialog.setInitialFocus(dialog, selectedTheme);
        },
        open: open,
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 60,
          columnNumber: 7
        }
      }, /*#__PURE__*/_react["default"].createElement(_core.DialogTitle, {
        id: "change-the-dialog-title",
        disableTypography: true,
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 65,
          columnNumber: 9
        }
      }, /*#__PURE__*/_react["default"].createElement(_core.Typography, {
        variant: "h2",
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 66,
          columnNumber: 11
        }
      }, t('changeTheme'))), /*#__PURE__*/_react["default"].createElement(_core.DialogContent, {
        className: classes.dialogContent,
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 70,
          columnNumber: 9
        }
      }, /*#__PURE__*/_react["default"].createElement(_core.MenuList, {
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 71,
          columnNumber: 11
        }
      }, themeIds.map(function (value) {
        return /*#__PURE__*/_react["default"].createElement(_core.MenuItem, {
          key: value,
          className: classes.listitem,
          onClick: function onClick() {
            _this2.handleThemeChange(value);
          },
          selected: value === selectedTheme,
          value: value,
          __self: _this2,
          __source: {
            fileName: _jsxFileName,
            lineNumber: 74,
            columnNumber: 17
          }
        }, /*#__PURE__*/_react["default"].createElement(_core.ListItemIcon, {
          __self: _this2,
          __source: {
            fileName: _jsxFileName,
            lineNumber: 81,
            columnNumber: 19
          }
        }, /*#__PURE__*/_react["default"].createElement(_PaletteSharp["default"], {
          className: classes[value],
          __self: _this2,
          __source: {
            fileName: _jsxFileName,
            lineNumber: 82,
            columnNumber: 21
          }
        })), /*#__PURE__*/_react["default"].createElement(_core.ListItemText, {
          __self: _this2,
          __source: {
            fileName: _jsxFileName,
            lineNumber: 84,
            columnNumber: 19
          }
        }, t(value)));
      }))));
    }
  }]);

  return ChangeThemeDialog;
}(_react.Component);

exports.ChangeThemeDialog = ChangeThemeDialog;
ChangeThemeDialog.defaultProps = {
  open: false,
  themeIds: []
};