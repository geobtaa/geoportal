var _jsxFileName = "/Users/pjreed/dev/mirador/dist/es/src/components/CanvasAnnotations.js";

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
import ListItemText from '@material-ui/core/ListItemText';
import Typography from '@material-ui/core/Typography';
import SanitizedHtml from '../containers/SanitizedHtml';
/**
 * CanvasAnnotations ~
*/

export var CanvasAnnotations = /*#__PURE__*/function (_Component) {
  _inherits(CanvasAnnotations, _Component);

  var _super = _createSuper(CanvasAnnotations);

  /**
   * constructor -
   */
  function CanvasAnnotations(props) {
    var _this;

    _classCallCheck(this, CanvasAnnotations);

    _this = _super.call(this, props);
    _this.handleClick = _this.handleClick.bind(_assertThisInitialized(_this));
    _this.handleAnnotationHighlight = _this.handleAnnotationHighlight.bind(_assertThisInitialized(_this));
    _this.handleAnnotationUnHighlight = _this.handleAnnotationUnHighlight.bind(_assertThisInitialized(_this));
    return _this;
  }
  /**
   * Handle click event of an annotation.
  */


  _createClass(CanvasAnnotations, [{
    key: "handleClick",
    value: function handleClick(event, annotation) {
      var _this$props = this.props,
          deselectAnnotation = _this$props.deselectAnnotation,
          selectAnnotation = _this$props.selectAnnotation,
          selectedAnnotationIds = _this$props.selectedAnnotationIds,
          windowId = _this$props.windowId;

      if (selectedAnnotationIds.includes(annotation.id)) {
        deselectAnnotation(windowId, annotation.targetId, annotation.id);
      } else {
        selectAnnotation(windowId, annotation.targetId, annotation.id);
      }
    }
    /** */

  }, {
    key: "handleAnnotationHighlight",
    value: function handleAnnotationHighlight(annotation) {
      var _this$props2 = this.props,
          allAnnotationsAreHighlighted = _this$props2.allAnnotationsAreHighlighted,
          highlightAnnotation = _this$props2.highlightAnnotation,
          windowId = _this$props2.windowId;
      if (allAnnotationsAreHighlighted) return;
      highlightAnnotation(windowId, annotation.id);
    }
    /** */

  }, {
    key: "handleAnnotationUnHighlight",
    value: function handleAnnotationUnHighlight() {
      var _this$props3 = this.props,
          allAnnotationsAreHighlighted = _this$props3.allAnnotationsAreHighlighted,
          highlightAnnotation = _this$props3.highlightAnnotation,
          windowId = _this$props3.windowId;
      if (allAnnotationsAreHighlighted) return;
      highlightAnnotation(windowId, null);
    }
    /**
     * Returns the rendered component
    */

  }, {
    key: "render",
    value: function render() {
      var _this2 = this;

      var _this$props4 = this.props,
          annotations = _this$props4.annotations,
          classes = _this$props4.classes,
          index = _this$props4.index,
          label = _this$props4.label,
          selectedAnnotationIds = _this$props4.selectedAnnotationIds,
          t = _this$props4.t,
          totalSize = _this$props4.totalSize;
      if (annotations.length === 0) return /*#__PURE__*/React.createElement(React.Fragment, null);
      return /*#__PURE__*/React.createElement(React.Fragment, null, /*#__PURE__*/React.createElement(Typography, {
        className: classes.sectionHeading,
        variant: "overline",
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 66,
          columnNumber: 9
        }
      }, t('annotationCanvasLabel', {
        context: "".concat(index + 1, "/").concat(totalSize),
        label: label
      })), /*#__PURE__*/React.createElement(List, {
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 69,
          columnNumber: 9
        }
      }, annotations.map(function (annotation) {
        return /*#__PURE__*/React.createElement(ListItem, {
          button: true,
          component: "li",
          className: classes.annotationListItem,
          key: annotation.id,
          selected: selectedAnnotationIds.includes(annotation.id),
          onClick: function onClick(e) {
            return _this2.handleClick(e, annotation);
          },
          onFocus: function onFocus() {
            return _this2.handleAnnotationHighlight(annotation);
          },
          onBlur: _this2.handleAnnotationUnHighlight,
          onMouseEnter: function onMouseEnter() {
            return _this2.handleAnnotationHighlight(annotation);
          },
          onMouseLeave: _this2.handleAnnotationUnHighlight,
          __self: _this2,
          __source: {
            fileName: _jsxFileName,
            lineNumber: 72,
            columnNumber: 15
          }
        }, /*#__PURE__*/React.createElement(ListItemText, {
          primaryTypographyProps: {
            variant: 'body2'
          },
          __self: _this2,
          __source: {
            fileName: _jsxFileName,
            lineNumber: 84,
            columnNumber: 17
          }
        }, /*#__PURE__*/React.createElement(SanitizedHtml, {
          ruleSet: "iiif",
          htmlString: annotation.content,
          __self: _this2,
          __source: {
            fileName: _jsxFileName,
            lineNumber: 85,
            columnNumber: 19
          }
        })));
      })));
    }
  }]);

  return CanvasAnnotations;
}(Component);
CanvasAnnotations.defaultProps = {
  annotations: [],
  classes: {},
  selectedAnnotationIds: []
};