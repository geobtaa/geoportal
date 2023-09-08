import _isUndefined from "lodash/isUndefined";
var _jsxFileName = "/Users/pjreed/dev/mirador/dist/es/src/components/ErrorDialog.js";

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

import React, { Component } from 'react';
import Dialog from '@material-ui/core/Dialog';
import DialogContent from '@material-ui/core/DialogContent';
import DialogTitle from '@material-ui/core/DialogTitle';
import { DialogActions, DialogContentText, Typography } from '@material-ui/core';
import Button from '@material-ui/core/Button';

/**
 */
export var ErrorDialog = /*#__PURE__*/function (_Component) {
  _inherits(ErrorDialog, _Component);

  var _super = _createSuper(ErrorDialog);

  function ErrorDialog() {
    _classCallCheck(this, ErrorDialog);

    return _super.apply(this, arguments);
  }

  _createClass(ErrorDialog, [{
    key: "render",

    /**
     * render
     * @return
     */
    value: function render() {
      var _this$props = this.props,
          error = _this$props.error,
          removeError = _this$props.removeError,
          t = _this$props.t;
      var hasError = !_isUndefined(error);
      return error ? /*#__PURE__*/React.createElement(Dialog, {
        "aria-labelledby": "error-dialog-title",
        id: "error-dialog",
        onClose: function onClose() {
          return removeError(error.id);
        },
        open: hasError,
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 25,
          columnNumber: 7
        }
      }, /*#__PURE__*/React.createElement(DialogTitle, {
        id: "error-dialog-title",
        disableTypography: true,
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 31,
          columnNumber: 9
        }
      }, /*#__PURE__*/React.createElement(Typography, {
        variant: "h2",
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 32,
          columnNumber: 11
        }
      }, t('errorDialogTitle'))), /*#__PURE__*/React.createElement(DialogContent, {
        disableTypography: true,
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 34,
          columnNumber: 9
        }
      }, /*#__PURE__*/React.createElement(DialogContentText, {
        variant: "body2",
        noWrap: true,
        color: "inherit",
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 35,
          columnNumber: 11
        }
      }, "".concat(error.message)), /*#__PURE__*/React.createElement(DialogActions, {
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 38,
          columnNumber: 11
        }
      }, /*#__PURE__*/React.createElement(Button, {
        onClick: function onClick() {
          return removeError(error.id);
        },
        variant: "contained",
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 39,
          columnNumber: 13
        }
      }, t('errorDialogConfirm'))))) : null;
    }
  }]);

  return ErrorDialog;
}(Component);
ErrorDialog.defaultProps = {
  error: null,
  removeError: function removeError() {},
  t: function t(key) {
    return key;
  }
};