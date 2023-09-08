var _jsxFileName = "/Users/pjreed/dev/mirador/dist/es/src/components/WindowAuthenticationControl.js";

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
import Button from '@material-ui/core/Button';
import Paper from '@material-ui/core/Paper';
import Collapse from '@material-ui/core/Collapse';
import DialogActions from '@material-ui/core/DialogActions';
import Typography from '@material-ui/core/Typography';
import LockIcon from '@material-ui/icons/LockSharp';
import SanitizedHtml from '../containers/SanitizedHtml';
/**
 */

export var WindowAuthenticationControl = /*#__PURE__*/function (_Component) {
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
      if ((!degraded || !profile) && status !== 'fetching') return /*#__PURE__*/React.createElement(React.Fragment, null);
      if (!this.isInteractive() && !failed) return /*#__PURE__*/React.createElement(React.Fragment, null);
      var _this$state = this.state,
          showFailureMessage = _this$state.showFailureMessage,
          open = _this$state.open;
      var isInFailureState = showFailureMessage && failed;
      var hasCollapsedContent = isInFailureState ? failureDescription : header || description;
      var confirmButton = /*#__PURE__*/React.createElement(Button, {
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
      return /*#__PURE__*/React.createElement(Paper, {
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
      }, /*#__PURE__*/React.createElement(Button, {
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
      }, /*#__PURE__*/React.createElement(LockIcon, {
        className: classes.icon,
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 93,
          columnNumber: 11
        }
      }), /*#__PURE__*/React.createElement(Typography, {
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
      }, /*#__PURE__*/React.createElement(SanitizedHtml, {
        htmlString: (isInFailureState ? failureHeader : label) || t('authenticationRequired'),
        ruleSet: "iiif",
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 95,
          columnNumber: 13
        }
      })), /*#__PURE__*/React.createElement("span", {
        className: classes.fauxButton,
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 97,
          columnNumber: 11
        }
      }, hasCollapsedContent ? !open && /*#__PURE__*/React.createElement(Typography, {
        variant: "button",
        color: "inherit",
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 100,
          columnNumber: 15
        }
      }, t('continue')) : confirmButton)), hasCollapsedContent && /*#__PURE__*/React.createElement(Collapse, {
        "in": open,
        onClose: this.handleClose,
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 110,
          columnNumber: 13
        }
      }, /*#__PURE__*/React.createElement(Typography, {
        variant: "body1",
        color: "inherit",
        className: classes.expanded,
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 114,
          columnNumber: 15
        }
      }, isInFailureState ? /*#__PURE__*/React.createElement(SanitizedHtml, {
        htmlString: failureDescription || '',
        ruleSet: "iiif",
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 117,
          columnNumber: 23
        }
      }) : /*#__PURE__*/React.createElement(React.Fragment, null, /*#__PURE__*/React.createElement(SanitizedHtml, {
        htmlString: header || '',
        ruleSet: "iiif",
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 120,
          columnNumber: 25
        }
      }), header && description ? ': ' : '', /*#__PURE__*/React.createElement(SanitizedHtml, {
        htmlString: description || '',
        ruleSet: "iiif",
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 122,
          columnNumber: 25
        }
      }))), /*#__PURE__*/React.createElement(DialogActions, {
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 127,
          columnNumber: 15
        }
      }, /*#__PURE__*/React.createElement(Button, {
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
}(Component);
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