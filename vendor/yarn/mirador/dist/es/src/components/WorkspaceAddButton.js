var _jsxFileName = "/Users/pjreed/dev/mirador/dist/es/src/components/WorkspaceAddButton.js";

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
import Fab from '@material-ui/core/Fab';
import Tooltip from '@material-ui/core/Tooltip';
import AddIcon from '@material-ui/icons/AddSharp';
import CloseIcon from '@material-ui/icons/CloseSharp';
/**
 */

export var WorkspaceAddButton = /*#__PURE__*/function (_Component) {
  _inherits(WorkspaceAddButton, _Component);

  var _super = _createSuper(WorkspaceAddButton);

  function WorkspaceAddButton() {
    _classCallCheck(this, WorkspaceAddButton);

    return _super.apply(this, arguments);
  }

  _createClass(WorkspaceAddButton, [{
    key: "render",

    /**
     * render
     * @return
     */
    value: function render() {
      var _this$props = this.props,
          classes = _this$props.classes,
          t = _this$props.t,
          setWorkspaceAddVisibility = _this$props.setWorkspaceAddVisibility,
          isWorkspaceAddVisible = _this$props.isWorkspaceAddVisible,
          useExtendedFab = _this$props.useExtendedFab;
      return /*#__PURE__*/React.createElement(Tooltip, {
        title: isWorkspaceAddVisible ? t('closeAddResourceMenu') : t('addResource'),
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 20,
          columnNumber: 7
        }
      }, /*#__PURE__*/React.createElement(Fab, {
        size: "medium",
        color: "primary",
        id: "addBtn",
        disableRipple: true,
        "aria-label": isWorkspaceAddVisible ? t('closeAddResourceMenu') : t('addResource'),
        className: classes.fab,
        classes: {
          primary: classes.fabPrimary,
          secondary: classes.fabSecondary
        },
        variant: useExtendedFab ? 'extended' : 'round',
        onClick: function onClick() {
          setWorkspaceAddVisibility(!isWorkspaceAddVisible);
        },
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 21,
          columnNumber: 9
        }
      }, isWorkspaceAddVisible ? /*#__PURE__*/React.createElement(CloseIcon, {
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 34,
          columnNumber: 17
        }
      }) : /*#__PURE__*/React.createElement(AddIcon, {
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 35,
          columnNumber: 17
        }
      }), useExtendedFab && t('startHere')));
    }
  }]);

  return WorkspaceAddButton;
}(Component);
WorkspaceAddButton.defaultProps = {
  isWorkspaceAddVisible: false,
  t: function t(key) {
    return key;
  }
};