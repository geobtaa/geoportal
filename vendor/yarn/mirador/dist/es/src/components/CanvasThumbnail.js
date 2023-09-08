var _jsxFileName = "/Users/pjreed/dev/mirador/dist/es/src/components/CanvasThumbnail.js";

function ownKeys(object, enumerableOnly) { var keys = Object.keys(object); if (Object.getOwnPropertySymbols) { var symbols = Object.getOwnPropertySymbols(object); if (enumerableOnly) symbols = symbols.filter(function (sym) { return Object.getOwnPropertyDescriptor(object, sym).enumerable; }); keys.push.apply(keys, symbols); } return keys; }

function _objectSpread(target) { for (var i = 1; i < arguments.length; i++) { var source = arguments[i] != null ? arguments[i] : {}; if (i % 2) { ownKeys(Object(source), true).forEach(function (key) { _defineProperty(target, key, source[key]); }); } else if (Object.getOwnPropertyDescriptors) { Object.defineProperties(target, Object.getOwnPropertyDescriptors(source)); } else { ownKeys(Object(source)).forEach(function (key) { Object.defineProperty(target, key, Object.getOwnPropertyDescriptor(source, key)); }); } } return target; }

function _defineProperty(obj, key, value) { if (key in obj) { Object.defineProperty(obj, key, { value: value, enumerable: true, configurable: true, writable: true }); } else { obj[key] = value; } return obj; }

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
import 'intersection-observer'; // polyfill needed for Safari

import IntersectionObserver from '@researchgate/react-intersection-observer';
/**
 * Uses InteractionObserver to "lazy" load canvas thumbnails that are in view.
 */

export var CanvasThumbnail = /*#__PURE__*/function (_Component) {
  _inherits(CanvasThumbnail, _Component);

  var _super = _createSuper(CanvasThumbnail);

  /**
   */
  function CanvasThumbnail(props) {
    var _this;

    _classCallCheck(this, CanvasThumbnail);

    _this = _super.call(this, props);
    _this.state = {
      image: null,
      loaded: false
    };
    _this.handleIntersection = _this.handleIntersection.bind(_assertThisInitialized(_this));
    return _this;
  }
  /**
   * Handles the intersection (visibility) of a given thumbnail, by requesting
   * the image and then updating the state.
   */


  _createClass(CanvasThumbnail, [{
    key: "handleIntersection",
    value: function handleIntersection(event) {
      var imageUrl = this.props.imageUrl;
      var loaded = this.state.loaded;
      if (loaded || !event.isIntersecting || !imageUrl) return;
      var image = new Image();
      image.src = imageUrl;
      this.setState({
        image: image,
        loaded: true
      });
    }
    /**
     * Return a the image URL if it is loaded and valid, otherwise return a placeholder
    */

  }, {
    key: "imageSrc",
    value: function imageSrc() {
      var isValid = this.props.isValid;
      var _this$state = this.state,
          loaded = _this$state.loaded,
          image = _this$state.image;

      if (loaded && isValid && image && image.src) {
        return image.src;
      }

      return CanvasThumbnail.defaultImgPlaceholder;
    }
    /** */

  }, {
    key: "imageConstraints",
    value: function imageConstraints() {
      var _this$props = this.props,
          maxHeight = _this$props.maxHeight,
          maxWidth = _this$props.maxWidth,
          aspectRatio = _this$props.aspectRatio;
      if (maxHeight && maxWidth && aspectRatio) return 'sizeByConfinedWh';
      if (maxHeight && maxWidth) return 'sizeByDistortedWh';
      if (maxHeight && !maxWidth) return 'sizeByH';
      if (!maxHeight && maxWidth) return 'sizeByW';
      return undefined;
    }
    /**
     *
    */

  }, {
    key: "imageStyles",
    value: function imageStyles() {
      var _this$props2 = this.props,
          maxHeight = _this$props2.maxHeight,
          maxWidth = _this$props2.maxWidth,
          aspectRatio = _this$props2.aspectRatio,
          style = _this$props2.style;
      var height;
      var width;

      switch (this.imageConstraints()) {
        case 'sizeByConfinedWh':
          // size to width
          if (maxWidth / maxHeight < aspectRatio) {
            height = maxWidth / aspectRatio;
            width = maxWidth;
          } else {
            height = maxHeight;
            width = maxHeight * aspectRatio;
          }

          break;

        case 'sizeByDistortedWh':
          height = maxHeight;
          width = maxWidth;
          break;

        case 'sizeByH':
          height = maxHeight;
          width = 'auto';
          break;

        case 'sizeByW':
          height = 'auto';
          width = maxWidth;
          break;

        default:
          height = 'auto';
          width = 'auto';
      }

      return _objectSpread({
        height: height,
        width: width
      }, style);
    }
    /**
     */

  }, {
    key: "render",
    value: function render() {
      var ImageProps = this.props.ImageProps;
      return /*#__PURE__*/React.createElement(React.Fragment, null, /*#__PURE__*/React.createElement(IntersectionObserver, {
        onChange: this.handleIntersection,
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 116,
          columnNumber: 9
        }
      }, /*#__PURE__*/React.createElement("img", Object.assign({
        alt: "",
        role: "presentation",
        src: this.imageSrc(),
        style: this.imageStyles()
      }, ImageProps, {
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 117,
          columnNumber: 11
        }
      }))));
    }
  }]);

  return CanvasThumbnail;
}(Component); // Transparent "gray"

CanvasThumbnail.defaultImgPlaceholder = 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mMMDQmtBwADgwF/Op8FmAAAAABJRU5ErkJggg==';
CanvasThumbnail.defaultProps = {
  aspectRatio: null,
  ImageProps: undefined,
  imageUrl: null,
  isValid: true,
  maxHeight: null,
  maxWidth: null,
  style: {}
};