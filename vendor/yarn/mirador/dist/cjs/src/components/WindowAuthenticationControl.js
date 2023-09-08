"use strict";

Object.defineProperty(exports, "__esModule", {
  value: true
});
exports.WindowAuthenticationControl = void 0;

var _react = _interopRequireWildcard(require("react"));

var _Button = _interopRequireDefault(require("@material-ui/core/Button"));

var _Paper = _interopRequireDefault(require("@material-ui/core/Paper"));

var _Collapse = _interopRequireDefault(require("@material-ui/core/Collapse"));

var _DialogActions = _interopRequireDefault(require("@material-ui/core/DialogActions"));

var _Typography = _interopRequireDefault(require("@material-ui/core/Typography"));

var _LockSharp = _interopRequireDefault(require("@material-ui/icons/LockSharp"));

var _SanitizedHtml = _interopRequireDefault(require("../containers/SanitizedHtml"));

var _jsxFileName = "/Users/pjreed/dev/mirador/dist/cjs/src/components/WindowAuthenticationControl.js";

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
var WindowAuthenticationControl = /*#__PURE__*/function (_Component) {
  _inherits(WindowAuthenticationControl, _Component);

  var _super = _createSuper(WindowAuthenticationControl);

  /** */
  function WindowAuthenticationControl(props) {
    var _this;

    _classCallCheck(this, WindowAuthenticationControl);

    _this = _super.call(this, props);
    _this.state = {
      open: false,
      showFailureMessage: true
    };
    _this.handleClickOpen = _this.handleClickOpen.bind(_assertThisInitialized(_this));
    _this.handleClose = _this.handleClose.bind(_assertThisInitialized(_this));
    _this.handleConfirm = _this.handleConfirm.bind(_assertThisInitialized(_this));
    return _this;
  }
  /** */


  _createClass(WindowAuthenticationControl, [{
    key: "handleClickOpen",
    value: function handleClickOpen() {
      this.setState({
        open: true
      });
    }
    /** */

  }, {
    key: "handleClose",
    value: function handleClose() {
      this.setState({
        open: false,
        showFailureMessage: false
      });
    }
    /** */

  }, {
    key: "handleConfirm",
    value: function handleConfirm() {
      var _this$props = this.props,
          handleAuthInteraction = _this$props.handleAuthInteraction,
          infoId = _this$props.infoId,
          serviceId = _this$props.serviceId,
          windowId = _this$props.windowId;
      handleAuthInteraction(windowId, infoId, serviceId);
      this.setState({
        showFailureMessage: true
      });
    }
    /** */

  }, {
    key: "isInteractive",
    value: function isInteractive() {
      var profile = this.props.profile;
      return profile === 'http://iiif.io/api/auth/1/clickthrough' || profile === 'http://iiif.io/api/auth/1/login';
    }
    /** */

  }, {
    key: "render",
    value: function render() {
      var _this$props2 = this.props,
          classes = _this$props2.classes,
          confirmLabel = _this$props2.confirmLabel,
          degraded = _this$props2.degraded,
          description = _this$props2.description,
          failureDescription = _this$props2.failureDescription,
          failureHeader = _this$props2.failureHeader,
          header = _this$props2.header,
          label = _this$props2.label,
          profile = _this$props2.profile,
          status = _this$props2.status,
          t = _this$props2.t;
      var failed = status === 'failed';
      if ((!degraded || !profile) && status !== 'fetching') return /*#__PURE__*/_react["default"].createElement(_react["default"].Fragment, null);
      if (!this.isInteractive() && !failed) return /*#__PURE__*/_react["default"].createElement(_react["default"].Fragment, null);
      var _this$state = this.state,
          showFailureMessage = _this$state.showFailureMessage,
          open = _this$state.open;
      var isInFailureState = showFailureMessage && failed;
      var hasCollapsedContent = isInFailureState ? failureDescription : header || description;

      var confirmButton = /*#__PURE__*/_react["default"].createElement(_Button["default"], {
        onClick: this.handleConfirm,
        className: classes.buttonInvert,
        autoFocus: true,
        color: "secondary",
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 85,
          columnNumber: 7
        }
      }, confirmLabel || (this.isInteractive() ? t('login') : t('retry')));

      return /*#__PURE__*/_react["default"].createElement(_Paper["default"], {
        square: true,
        elevation: 4,
        color: "secondary",
        classes: {
          root: classes.paper
        },
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 91,
          columnNumber: 7
        }
      }, /*#__PURE__*/_react["default"].createElement(_Button["default"], {
        fullWidth: true,
        className: classes.topBar,
        onClick: hasCollapsedContent ? this.handleClickOpen : this.handleConfirm,
        component: "div",
        color: "inherit",
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 92,
          columnNumber: 9
        }
      }, /*#__PURE__*/_react["default"].createElement(_LockSharp["default"], {
        className: classes.icon,
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 93,
          columnNumber: 11
        }
      }), /*#__PURE__*/_react["default"].createElement(_Typography["default"], {
        className: classes.label,
        component: "h3",
        variant: "body1",
        color: "inherit",
        inline: true,
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 94,
          columnNumber: 11
        }
      }, /*#__PURE__*/_react["default"].createElement(_SanitizedHtml["default"], {
        htmlString: (isInFailureState ? failureHeader : label) || t('authenticationRequired'),
        ruleSet: "iiif",
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 95,
          columnNumber: 13
        }
      })), /*#__PURE__*/_react["default"].createElement("span", {
        className: classes.fauxButton,
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 97,
          columnNumber: 11
        }
      }, hasCollapsedContent ? !open && /*#__PURE__*/_react["default"].createElement(_Typography["default"], {
        variant: "button",
        color: "inherit",
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 100,
          columnNumber: 15
        }
      }, t('continue')) : confirmButton)), hasCollapsedContent && /*#__PURE__*/_react["default"].createElement(_Collapse["default"], {
        "in": open,
        onClose: this.handleClose,
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 110,
          columnNumber: 13
        }
      }, /*#__PURE__*/_react["default"].createElement(_Typography["default"], {
        variant: "body1",
        color: "inherit",
        className: classes.expanded,
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 114,
          columnNumber: 15
        }
      }, isInFailureState ? /*#__PURE__*/_react["default"].createElement(_SanitizedHtml["default"], {
        htmlString: failureDescription || '',
        ruleSet: "iiif",
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 117,
          columnNumber: 23
        }
      }) : /*#__PURE__*/_react["default"].createElement(_react["default"].Fragment, null, /*#__PURE__*/_react["default"].createElement(_SanitizedHtml["default"], {
        htmlString: header || '',
        ruleSet: "iiif",
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 120,
          columnNumber: 25
        }
      }), header && description ? ': ' : '', /*#__PURE__*/_react["default"].createElement(_SanitizedHtml["default"], {
        htmlString: description || '',
        ruleSet: "iiif",
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 122,
          columnNumber: 25
        }
      }))), /*#__PURE__*/_react["default"].createElement(_DialogActions["default"], {
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 127,
          columnNumber: 15
        }
      }, /*#__PURE__*/_react["default"].createElement(_Button["default"], {
        onClick: this.handleClose,
        color: "inherit",
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 128,
          columnNumber: 17
        }
      }, t('cancel')), confirmButton)));
    }
  }]);

  return WindowAuthenticationControl;
}(_react.Component);

exports.WindowAuthenticationControl = WindowAuthenticationControl;
WindowAuthenticationControl.defaultProps = {
  confirmLabel: undefined,
  degraded: false,
  description: undefined,
  failureDescription: undefined,
  failureHeader: undefined,
  header: undefined,
  infoId: undefined,
  label: undefined,
  profile: undefined,
  serviceId: undefined,
  status: null,
  t: function t() {}
};