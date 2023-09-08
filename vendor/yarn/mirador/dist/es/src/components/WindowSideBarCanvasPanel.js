var _jsxFileName = "/Users/pjreed/dev/mirador/dist/es/src/components/WindowSideBarCanvasPanel.js";

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
import Typography from '@material-ui/core/Typography';
import MenuItem from '@material-ui/core/MenuItem';
import FormControl from '@material-ui/core/FormControl';
import RootRef from '@material-ui/core/RootRef';
import Select from '@material-ui/core/Select';
import CompanionWindow from '../containers/CompanionWindow';
import SidebarIndexList from '../containers/SidebarIndexList';
import SidebarIndexTableOfContents from '../containers/SidebarIndexTableOfContents';
/**
 * a panel showing the canvases for a given manifest
 */

export var WindowSideBarCanvasPanel = /*#__PURE__*/function (_Component) {
  _inherits(WindowSideBarCanvasPanel, _Component);

  var _super = _createSuper(WindowSideBarCanvasPanel);

  /** */
  function WindowSideBarCanvasPanel(props) {
    var _this;

    _classCallCheck(this, WindowSideBarCanvasPanel);

    _this = _super.call(this, props);
    _this.handleVariantChange = _this.handleVariantChange.bind(_assertThisInitialized(_this));
    _this.state = {
      variantSelectionOpened: false
    };
    _this.containerRef = React.createRef();
    return _this;
  }
  /** @private */


  _createClass(WindowSideBarCanvasPanel, [{
    key: "handleVariantChange",
    value: function handleVariantChange(event) {
      var updateVariant = this.props.updateVariant;
      updateVariant(event.target.value);
      this.setState({
        variantSelectionOpened: false
      });
    }
    /**
     * render
     */

  }, {
    key: "render",
    value: function render() {
      var _this2 = this;

      var _this$props = this.props,
          classes = _this$props.classes,
          id = _this$props.id,
          t = _this$props.t,
          toggleDraggingEnabled = _this$props.toggleDraggingEnabled,
          variant = _this$props.variant,
          windowId = _this$props.windowId;
      var variantSelectionOpened = this.state.variantSelectionOpened;
      var listComponent;

      if (variant === 'tableOfContents') {
        listComponent = /*#__PURE__*/React.createElement(SidebarIndexTableOfContents, {
          id: id,
          containerRef: this.containerRef,
          windowId: windowId,
          __self: this,
          __source: {
            fileName: _jsxFileName,
            lineNumber: 53,
            columnNumber: 9
          }
        });
      } else {
        listComponent = /*#__PURE__*/React.createElement(SidebarIndexList, {
          id: id,
          containerRef: this.containerRef,
          windowId: windowId,
          __self: this,
          __source: {
            fileName: _jsxFileName,
            lineNumber: 61,
            columnNumber: 9
          }
        });
      }

      return /*#__PURE__*/React.createElement(RootRef, {
        rootRef: this.containerRef,
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 69,
          columnNumber: 7
        }
      }, /*#__PURE__*/React.createElement(CompanionWindow, {
        title: t('canvasIndex'),
        id: id,
        windowId: windowId,
        titleControls: /*#__PURE__*/React.createElement(FormControl, {
          __self: this,
          __source: {
            fileName: _jsxFileName,
            lineNumber: 75,
            columnNumber: 13
          }
        }, /*#__PURE__*/React.createElement(Select, {
          MenuProps: {
            anchorOrigin: {
              horizontal: 'left',
              vertical: 'bottom'
            },
            getContentAnchorEl: null
          },
          displayEmpty: true,
          value: variant,
          onChange: this.handleVariantChange,
          name: "variant",
          open: variantSelectionOpened,
          onOpen: function onOpen(e) {
            toggleDraggingEnabled();

            _this2.setState({
              variantSelectionOpened: true
            });
          },
          onClose: function onClose(e) {
            toggleDraggingEnabled();

            _this2.setState({
              variantSelectionOpened: false
            });
          },
          classes: {
            select: classes.select
          },
          className: classes.selectEmpty,
          __self: this,
          __source: {
            fileName: _jsxFileName,
            lineNumber: 76,
            columnNumber: 15
          }
        }, /*#__PURE__*/React.createElement(MenuItem, {
          value: "tableOfContents",
          __self: this,
          __source: {
            fileName: _jsxFileName,
            lineNumber: 100,
            columnNumber: 17
          }
        }, /*#__PURE__*/React.createElement(Typography, {
          variant: "body2",
          __self: this,
          __source: {
            fileName: _jsxFileName,
            lineNumber: 100,
            columnNumber: 51
          }
        }, t('tableOfContentsList'))), /*#__PURE__*/React.createElement(MenuItem, {
          value: "item",
          __self: this,
          __source: {
            fileName: _jsxFileName,
            lineNumber: 101,
            columnNumber: 17
          }
        }, /*#__PURE__*/React.createElement(Typography, {
          variant: "body2",
          __self: this,
          __source: {
            fileName: _jsxFileName,
            lineNumber: 101,
            columnNumber: 40
          }
        }, t('itemList'))), /*#__PURE__*/React.createElement(MenuItem, {
          value: "thumbnail",
          __self: this,
          __source: {
            fileName: _jsxFileName,
            lineNumber: 102,
            columnNumber: 17
          }
        }, /*#__PURE__*/React.createElement(Typography, {
          variant: "body2",
          __self: this,
          __source: {
            fileName: _jsxFileName,
            lineNumber: 102,
            columnNumber: 45
          }
        }, t('thumbnailList'))))),
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 70,
          columnNumber: 9
        }
      }, listComponent));
    }
  }]);

  return WindowSideBarCanvasPanel;
}(Component);