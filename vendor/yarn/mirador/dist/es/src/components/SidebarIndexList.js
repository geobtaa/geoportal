var _jsxFileName = "/Users/pjreed/dev/mirador/dist/es/src/components/SidebarIndexList.js";

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
import List from '@material-ui/core/List';
import ListItem from '@material-ui/core/ListItem';
import { ScrollTo } from './ScrollTo';
import ManifestoCanvas from '../lib/ManifestoCanvas';
import SidebarIndexItem from '../containers/SidebarIndexItem';
import SidebarIndexThumbnail from '../containers/SidebarIndexThumbnail';
/** */

export var SidebarIndexList = /*#__PURE__*/function (_Component) {
  _inherits(SidebarIndexList, _Component);

  var _super = _createSuper(SidebarIndexList);

  function SidebarIndexList() {
    _classCallCheck(this, SidebarIndexList);

    return _super.apply(this, arguments);
  }

  _createClass(SidebarIndexList, [{
    key: "getIdAndLabelOfCanvases",

    /** @private */
    value: function getIdAndLabelOfCanvases() {
      var canvases = this.props.canvases;
      return canvases.map(function (canvas, index) {
        return {
          id: canvas.id,
          label: new ManifestoCanvas(canvas).getLabel()
        };
      });
    }
    /** */

  }, {
    key: "render",
    value: function render() {
      var _this = this;

      var _this$props = this.props,
          canvases = _this$props.canvases,
          classes = _this$props.classes,
          containerRef = _this$props.containerRef,
          selectedCanvases = _this$props.selectedCanvases,
          setCanvas = _this$props.setCanvas,
          variant = _this$props.variant,
          windowId = _this$props.windowId;
      var canvasesIdAndLabel = this.getIdAndLabelOfCanvases(canvases);
      return /*#__PURE__*/React.createElement(List, {
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 37,
          columnNumber: 7
        }
      }, canvasesIdAndLabel.map(function (canvas, canvasIndex) {
        var onClick = function onClick() {
          setCanvas(windowId, canvas.id);
        }; // eslint-disable-line require-jsdoc, max-len


        return /*#__PURE__*/React.createElement(ScrollTo, {
          containerRef: containerRef,
          key: "".concat(canvas.id, "-").concat(variant),
          offsetTop: 96 // offset for the height of the form above
          ,
          scrollTo: !!selectedCanvases.find(function (c) {
            return c.id === canvas.id;
          }),
          __self: _this,
          __source: {
            fileName: _jsxFileName,
            lineNumber: 43,
            columnNumber: 15
          }
        }, /*#__PURE__*/React.createElement(ListItem, {
          key: canvas.id,
          className: classes.listItem,
          alignItems: "flex-start",
          onClick: onClick,
          button: true,
          component: "li",
          selected: !!selectedCanvases.find(function (c) {
            return c.id === canvas.id;
          }),
          __self: _this,
          __source: {
            fileName: _jsxFileName,
            lineNumber: 49,
            columnNumber: 17
          }
        }, variant === 'item' && /*#__PURE__*/React.createElement(SidebarIndexItem, {
          canvas: canvas,
          __self: _this,
          __source: {
            fileName: _jsxFileName,
            lineNumber: 58,
            columnNumber: 42
          }
        }), variant === 'thumbnail' && /*#__PURE__*/React.createElement(SidebarIndexThumbnail, {
          canvas: canvas,
          otherCanvas: canvases[canvasIndex],
          __self: _this,
          __source: {
            fileName: _jsxFileName,
            lineNumber: 59,
            columnNumber: 47
          }
        })));
      }));
    }
  }]);

  return SidebarIndexList;
}(Component);
SidebarIndexList.defaultProps = {
  selectedCanvases: [],
  variant: 'item'
};