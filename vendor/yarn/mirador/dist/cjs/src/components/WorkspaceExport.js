"use strict";

Object.defineProperty(exports, "__esModule", {
  value: true
});
exports.WorkspaceExport = void 0;

var _react = _interopRequireWildcard(require("react"));

var _Button = _interopRequireDefault(require("@material-ui/core/Button"));

var _Dialog = _interopRequireDefault(require("@material-ui/core/Dialog"));

var _DialogActions = _interopRequireDefault(require("@material-ui/core/DialogActions"));

var _DialogTitle = _interopRequireDefault(require("@material-ui/core/DialogTitle"));

var _Typography = _interopRequireDefault(require("@material-ui/core/Typography"));

var _reactCopyToClipboard = require("react-copy-to-clipboard");

var _ScrollIndicatedDialogContent = _interopRequireDefault(require("../containers/ScrollIndicatedDialogContent"));

var _jsxFileName = "/Users/pjreed/dev/mirador/dist/cjs/src/components/WorkspaceExport.js";

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
var WorkspaceExport = /*#__PURE__*/function (_Component) {
  _inherits(WorkspaceExport, _Component);

  var _super = _createSuper(WorkspaceExport);

  function WorkspaceExport() {
    _classCallCheck(this, WorkspaceExport);

    return _super.apply(this, arguments);
  }

  _createClass(WorkspaceExport, [{
    key: "exportableState",

    /**
     * @private
     */
    value: function exportableState() {
      var state = this.props.state;
      var companionWindows = state.companionWindows,
          config = state.config,
          elasticLayout = state.elasticLayout,
          viewers = state.viewers,
          windows = state.windows,
          workspace = state.workspace;
      return JSON.stringify({
        companionWindows: companionWindows,
        config: config,
        elasticLayout: elasticLayout,
        viewers: viewers,
        windows: windows,
        workspace: workspace
      }, null, 2);
    }
    /**
     * render
     * @return
     */

  }, {
    key: "render",
    value: function render() {
      var _this$props = this.props,
          children = _this$props.children,
          container = _this$props.container,
          handleClose = _this$props.handleClose,
          open = _this$props.open,
          t = _this$props.t;
      var exportableState = this.exportableState();
      return /*#__PURE__*/_react["default"].createElement(_Dialog["default"], {
        id: "workspace-settings",
        container: container,
        open: open,
        onClose: handleClose,
        scroll: "paper",
        fullWidth: true,
        maxWidth: "sm",
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 48,
          columnNumber: 7
        }
      }, /*#__PURE__*/_react["default"].createElement(_DialogTitle["default"], {
        id: "form-dialog-title",
        disableTypography: true,
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 57,
          columnNumber: 9
        }
      }, /*#__PURE__*/_react["default"].createElement(_Typography["default"], {
        variant: "h2",
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 58,
          columnNumber: 11
        }
      }, t('downloadExport'))), /*#__PURE__*/_react["default"].createElement(_ScrollIndicatedDialogContent["default"], {
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 60,
          columnNumber: 9
        }
      }, children, /*#__PURE__*/_react["default"].createElement("pre", {
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 62,
          columnNumber: 11
        }
      }, exportableState)), /*#__PURE__*/_react["default"].createElement(_DialogActions["default"], {
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 66,
          columnNumber: 9
        }
      }, /*#__PURE__*/_react["default"].createElement(_Button["default"], {
        onClick: function onClick() {
          return handleClose();
        },
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 67,
          columnNumber: 11
        }
      }, t('cancel')), /*#__PURE__*/_react["default"].createElement(_reactCopyToClipboard.CopyToClipboard, {
        text: exportableState,
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 68,
          columnNumber: 11
        }
      }, /*#__PURE__*/_react["default"].createElement(_Button["default"], {
        variant: "contained",
        color: "primary",
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 71,
          columnNumber: 13
        }
      }, t('copy')))));
    }
  }]);

  return WorkspaceExport;
}(_react.Component);

exports.WorkspaceExport = WorkspaceExport;
WorkspaceExport.defaultProps = {
  children: null,
  container: null,
  open: false,
  t: function t(key) {
    return key;
  }
};