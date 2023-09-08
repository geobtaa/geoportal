var _jsxFileName = "/Users/pjreed/dev/mirador/dist/es/src/components/WorkspaceSelectionDialog.js";

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
import DialogTitle from '@material-ui/core/DialogTitle';
import { Card, CardContent, MenuList, MenuItem, Typography } from '@material-ui/core';
import WorkspaceTypeElasticIcon from './icons/WorkspaceTypeElasticIcon';
import WorkspaceTypeMosaicIcon from './icons/WorkspaceTypeMosaicIcon';
import ScrollIndicatedDialogContent from '../containers/ScrollIndicatedDialogContent';
/**
 */

export var WorkspaceSelectionDialog = /*#__PURE__*/function (_Component) {
  _inherits(WorkspaceSelectionDialog, _Component);

  var _super = _createSuper(WorkspaceSelectionDialog);

  _createClass(WorkspaceSelectionDialog, null, [{
    key: "setInitialFocus",

    /**
     * Set the initial focus when the dialog enters
     * Find the selected item by using the current workspace type
     * in a selector on the value attribute (which we need to set)
    */
    value: function setInitialFocus(dialogElement, workspaceType) {
      var selectedListItem = dialogElement.querySelectorAll("li[value=\"".concat(workspaceType, "\"]"));
      if (!selectedListItem || selectedListItem.length === 0) return;
      selectedListItem[0].focus();
    }
    /**
     * constructor
     */

  }]);

  function WorkspaceSelectionDialog(props) {
    var _this;

    _classCallCheck(this, WorkspaceSelectionDialog);

    _this = _super.call(this, props);
    _this.handleWorkspaceTypeChange = _this.handleWorkspaceTypeChange.bind(_assertThisInitialized(_this));
    return _this;
  }
  /**
   * Propagate workspace type selection into the global state
   */


  _createClass(WorkspaceSelectionDialog, [{
    key: "handleWorkspaceTypeChange",
    value: function handleWorkspaceTypeChange(workspaceType) {
      var _this$props = this.props,
          handleClose = _this$props.handleClose,
          updateWorkspace = _this$props.updateWorkspace;
      updateWorkspace({
        type: workspaceType
      });
      handleClose();
    }
    /**
     * render
     * @return
     */

  }, {
    key: "render",
    value: function render() {
      var _this2 = this;

      var _this$props2 = this.props,
          classes = _this$props2.classes,
          container = _this$props2.container,
          handleClose = _this$props2.handleClose,
          open = _this$props2.open,
          children = _this$props2.children,
          t = _this$props2.t,
          workspaceType = _this$props2.workspaceType;
      return /*#__PURE__*/React.createElement(Dialog, {
        "aria-labelledby": "workspace-selection-dialog-title",
        container: container,
        id: "workspace-selection-dialog",
        onClose: handleClose,
        onEntered: function onEntered(dialog) {
          return WorkspaceSelectionDialog.setInitialFocus(dialog, workspaceType);
        },
        onEscapeKeyDown: handleClose,
        open: open,
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 60,
          columnNumber: 7
        }
      }, /*#__PURE__*/React.createElement(DialogTitle, {
        id: "workspace-selection-dialog-title",
        disableTypography: true,
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 69,
          columnNumber: 9
        }
      }, /*#__PURE__*/React.createElement(Typography, {
        variant: "h2",
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 70,
          columnNumber: 11
        }
      }, t('workspaceSelectionTitle'))), /*#__PURE__*/React.createElement(ScrollIndicatedDialogContent, {
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 72,
          columnNumber: 9
        }
      }, children, /*#__PURE__*/React.createElement(MenuList, {
        classes: {
          root: classes.list
        },
        selected: workspaceType,
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 74,
          columnNumber: 11
        }
      }, /*#__PURE__*/React.createElement(MenuItem, {
        className: classes.menuItem,
        onClick: function onClick() {
          return _this2.handleWorkspaceTypeChange('elastic');
        },
        selected: workspaceType === 'elastic',
        value: "elastic",
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 78,
          columnNumber: 13
        }
      }, /*#__PURE__*/React.createElement(Card, {
        className: classes.card,
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 84,
          columnNumber: 15
        }
      }, /*#__PURE__*/React.createElement(WorkspaceTypeElasticIcon, {
        className: classes.svgIcon,
        viewBox: "0 0 120 90",
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 85,
          columnNumber: 17
        }
      }), /*#__PURE__*/React.createElement("div", {
        className: classes.details,
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 89,
          columnNumber: 17
        }
      }, /*#__PURE__*/React.createElement(CardContent, {
        classes: {
          root: classes.root
        },
        className: classes.content,
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 90,
          columnNumber: 19
        }
      }, /*#__PURE__*/React.createElement(Typography, {
        className: classes.headline,
        component: "p",
        variant: "h3",
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 94,
          columnNumber: 21
        }
      }, t('elastic')), /*#__PURE__*/React.createElement(Typography, {
        variant: "body1",
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 95,
          columnNumber: 21
        }
      }, t('elasticDescription')))))), /*#__PURE__*/React.createElement(MenuItem, {
        className: classes.menuItem,
        onClick: function onClick() {
          return _this2.handleWorkspaceTypeChange('mosaic');
        },
        selected: workspaceType === 'mosaic',
        value: "mosaic",
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 100,
          columnNumber: 13
        }
      }, /*#__PURE__*/React.createElement(Card, {
        className: classes.card,
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 106,
          columnNumber: 15
        }
      }, /*#__PURE__*/React.createElement(WorkspaceTypeMosaicIcon, {
        className: classes.svgIcon,
        viewBox: "0 0 120 90",
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 107,
          columnNumber: 17
        }
      }), /*#__PURE__*/React.createElement("div", {
        className: classes.details,
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 111,
          columnNumber: 17
        }
      }, /*#__PURE__*/React.createElement(CardContent, {
        className: classes.content,
        classes: {
          root: classes.root
        },
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 112,
          columnNumber: 19
        }
      }, /*#__PURE__*/React.createElement(Typography, {
        className: classes.headline,
        component: "p",
        variant: "h3",
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 116,
          columnNumber: 21
        }
      }, t('mosaic')), /*#__PURE__*/React.createElement(Typography, {
        variant: "body1",
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 117,
          columnNumber: 21
        }
      }, t('mosaicDescription')))))))));
    }
  }]);

  return WorkspaceSelectionDialog;
}(Component);
WorkspaceSelectionDialog.defaultProps = {
  children: null,
  container: null,
  open: false,
  t: function t(key) {
    return key;
  }
};