var _jsxFileName = "/Users/pjreed/dev/mirador/dist/es/src/components/GalleryViewThumbnail.js";

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
import Avatar from '@material-ui/core/Avatar';
import Chip from '@material-ui/core/Chip';
import Typography from '@material-ui/core/Typography';
import classNames from 'classnames';
import ManifestoCanvas from '../lib/ManifestoCanvas';
import { CanvasThumbnail } from './CanvasThumbnail';
/**
 * Represents a WindowViewer in the mirador workspace. Responsible for mounting
 * OSD and Navigation
 */

export var GalleryViewThumbnail = /*#__PURE__*/function (_Component) {
  _inherits(GalleryViewThumbnail, _Component);

  var _super = _createSuper(GalleryViewThumbnail);

  /** */
  function GalleryViewThumbnail(props) {
    var _this;

    _classCallCheck(this, GalleryViewThumbnail);

    _this = _super.call(this, props);
    _this.handleSelect = _this.handleSelect.bind(_assertThisInitialized(_this));
    _this.handleKey = _this.handleKey.bind(_assertThisInitialized(_this));
    return _this;
  }
  /** @private */


  _createClass(GalleryViewThumbnail, [{
    key: "handleSelect",
    value: function handleSelect() {
      var _this$props = this.props,
          canvas = _this$props.canvas,
          selected = _this$props.selected,
          setCanvas = _this$props.setCanvas,
          focusOnCanvas = _this$props.focusOnCanvas;

      if (selected) {
        focusOnCanvas();
      } else {
        setCanvas(canvas.id);
      }
    }
    /** @private */

  }, {
    key: "handleKey",
    value: function handleKey(event) {
      var _this$props2 = this.props,
          canvas = _this$props2.canvas,
          setCanvas = _this$props2.setCanvas,
          focusOnCanvas = _this$props2.focusOnCanvas;
      this.keys = {
        enter: 'Enter',
        space: ' '
      };
      this.chars = {
        enter: 13,
        space: 32
      };
      var enterOrSpace = event.key === this.keys.enter || event.which === this.chars.enter || event.key === this.keys.space || event.which === this.chars.space;

      if (enterOrSpace) {
        focusOnCanvas();
      } else {
        setCanvas(canvas.index, canvas.id);
      }
    }
    /**
     * Renders things
     */

  }, {
    key: "render",
    value: function render() {
      var _this$props3 = this.props,
          annotationsCount = _this$props3.annotationsCount,
          annotationSelected = _this$props3.annotationSelected,
          canvas = _this$props3.canvas,
          classes = _this$props3.classes,
          config = _this$props3.config,
          selected = _this$props3.selected;
      var manifestoCanvas = new ManifestoCanvas(canvas);
      return /*#__PURE__*/React.createElement("div", {
        key: canvas.index,
        className: classNames(classes.galleryViewItem, selected ? classes.selected : '', annotationsCount > 0 ? classes.hasAnnotations : ''),
        onClick: this.handleSelect,
        onKeyUp: this.handleKey,
        role: "button",
        tabIndex: 0,
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 77,
          columnNumber: 7
        }
      }, /*#__PURE__*/React.createElement(CanvasThumbnail, {
        imageUrl: manifestoCanvas.thumbnail(config.width, config.height),
        isValid: manifestoCanvas.hasValidDimensions,
        maxHeight: config.height,
        aspectRatio: manifestoCanvas.aspectRatio,
        style: {
          margin: '0 auto',
          maxWidth: "".concat(Math.ceil(config.height * manifestoCanvas.aspectRatio), "px")
        },
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 91,
          columnNumber: 9
        }
      }), /*#__PURE__*/React.createElement(Typography, {
        variant: "caption",
        className: classes.galleryViewCaption,
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 101,
          columnNumber: 9
        }
      }, manifestoCanvas.getLabel()), annotationsCount > 0 && /*#__PURE__*/React.createElement(Chip, {
        avatar: /*#__PURE__*/React.createElement(Avatar, {
          className: classes.avatar,
          __self: this,
          __source: {
            fileName: _jsxFileName,
            lineNumber: 106,
            columnNumber: 21
          }
        }),
        label: annotationsCount,
        className: classNames(classes.chip, annotationSelected ? classes.selected : ''),
        size: "small",
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 105,
          columnNumber: 11
        }
      }));
    }
  }]);

  return GalleryViewThumbnail;
}(Component);
GalleryViewThumbnail.defaultProps = {
  annotationsCount: 0,
  annotationSelected: false,
  config: {
    height: 100,
    width: null
  },
  selected: false
};