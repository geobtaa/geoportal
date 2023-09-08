var _jsxFileName = "/Users/pjreed/dev/mirador/dist/es/src/components/CompanionArea.js";

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
import Slide from '@material-ui/core/Slide';
import ArrowLeftIcon from '@material-ui/icons/ArrowLeftSharp';
import ArrowRightIcon from '@material-ui/icons/ArrowRightSharp';
import CompanionWindowFactory from '../containers/CompanionWindowFactory';
import MiradorMenuButton from '../containers/MiradorMenuButton';
import ns from '../config/css-ns';
/** */

export var CompanionArea = /*#__PURE__*/function (_Component) {
  _inherits(CompanionArea, _Component);

  var _super = _createSuper(CompanionArea);

  function CompanionArea() {
    _classCallCheck(this, CompanionArea);

    return _super.apply(this, arguments);
  }

  _createClass(CompanionArea, [{
    key: "areaLayoutClass",

    /** */
    value: function areaLayoutClass() {
      var _this$props = this.props,
          classes = _this$props.classes,
          position = _this$props.position;
      return position === 'bottom' || position === 'far-bottom' ? classes.horizontal : null;
    }
    /** */

  }, {
    key: "collapseIcon",
    value: function collapseIcon() {
      var _this$props2 = this.props,
          companionAreaOpen = _this$props2.companionAreaOpen,
          direction = _this$props2.direction;

      if (direction === 'rtl') {
        if (companionAreaOpen) return /*#__PURE__*/React.createElement(ArrowRightIcon, {
          __self: this,
          __source: {
            fileName: _jsxFileName,
            lineNumber: 25,
            columnNumber: 37
          }
        });
        return /*#__PURE__*/React.createElement(ArrowLeftIcon, {
          __self: this,
          __source: {
            fileName: _jsxFileName,
            lineNumber: 26,
            columnNumber: 14
          }
        });
      }

      if (companionAreaOpen) return /*#__PURE__*/React.createElement(ArrowLeftIcon, {
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 29,
          columnNumber: 35
        }
      });
      return /*#__PURE__*/React.createElement(ArrowRightIcon, {
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 30,
          columnNumber: 12
        }
      });
    }
    /** @private */

  }, {
    key: "slideDirection",
    value: function slideDirection() {
      var _this$props3 = this.props,
          direction = _this$props3.direction,
          position = _this$props3.position;
      var defaultPosition = direction === 'rtl' ? 'left' : 'right';
      var oppositePosition = direction === 'rtl' ? 'right' : 'left';

      switch (position) {
        case 'right':
        case 'far-right':
          return oppositePosition;

        case 'bottom':
        case 'far-bottom':
          return 'up';

        default:
          return defaultPosition;
      }
    }
    /** */

  }, {
    key: "render",
    value: function render() {
      var _this = this;

      var _this$props4 = this.props,
          classes = _this$props4.classes,
          companionWindowIds = _this$props4.companionWindowIds,
          companionAreaOpen = _this$props4.companionAreaOpen,
          setCompanionAreaOpen = _this$props4.setCompanionAreaOpen,
          position = _this$props4.position,
          sideBarOpen = _this$props4.sideBarOpen,
          t = _this$props4.t,
          windowId = _this$props4.windowId;
      return /*#__PURE__*/React.createElement("div", {
        className: [classes.root, this.areaLayoutClass(), ns("companion-area-".concat(position))].join(' '),
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 59,
          columnNumber: 7
        }
      }, setCompanionAreaOpen && position === 'left' && sideBarOpen && companionWindowIds.length > 0 && /*#__PURE__*/React.createElement("div", {
        className: classes.toggle,
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 63,
          columnNumber: 13
        }
      }, /*#__PURE__*/React.createElement(MiradorMenuButton, {
        "aria-label": companionAreaOpen ? t('collapseSidePanel') : t('expandSidePanel'),
        className: classes.toggleButton,
        key: companionAreaOpen ? 'collapse' : 'expand',
        onClick: function onClick() {
          setCompanionAreaOpen(windowId, !companionAreaOpen);
        },
        TooltipProps: {
          placement: 'right'
        },
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 64,
          columnNumber: 15
        }
      }, this.collapseIcon())), /*#__PURE__*/React.createElement(Slide, {
        "in": companionAreaOpen,
        direction: this.slideDirection(),
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 76,
          columnNumber: 9
        }
      }, /*#__PURE__*/React.createElement("div", {
        className: [ns('companion-windows'), companionWindowIds.length > 0 && classes[position], this.areaLayoutClass()].join(' '),
        style: {
          display: companionAreaOpen ? 'flex' : 'none'
        },
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 77,
          columnNumber: 11
        }
      }, companionWindowIds.map(function (id) {
        return /*#__PURE__*/React.createElement(CompanionWindowFactory, {
          id: id,
          key: id,
          windowId: windowId,
          __self: _this,
          __source: {
            fileName: _jsxFileName,
            lineNumber: 80,
            columnNumber: 17
          }
        });
      }))));
    }
  }]);

  return CompanionArea;
}(Component);
CompanionArea.defaultProps = {
  classes: {},
  setCompanionAreaOpen: function setCompanionAreaOpen() {},
  sideBarOpen: false
};