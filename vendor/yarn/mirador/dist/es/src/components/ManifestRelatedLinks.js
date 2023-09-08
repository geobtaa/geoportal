var _jsxFileName = "/Users/pjreed/dev/mirador/dist/es/src/components/ManifestRelatedLinks.js";

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
import Link from '@material-ui/core/Link';
import classNames from 'classnames';
import CollapsibleSection from '../containers/CollapsibleSection';
import ns from '../config/css-ns';
/**
 * ManifestRelatedLinks
 */

export var ManifestRelatedLinks = /*#__PURE__*/function (_Component) {
  _inherits(ManifestRelatedLinks, _Component);

  var _super = _createSuper(ManifestRelatedLinks);

  function ManifestRelatedLinks() {
    _classCallCheck(this, ManifestRelatedLinks);

    return _super.apply(this, arguments);
  }

  _createClass(ManifestRelatedLinks, [{
    key: "render",

    /**
     * render
     * @return
     */
    value: function render() {
      var _this = this;

      var _this$props = this.props,
          classes = _this$props.classes,
          homepage = _this$props.homepage,
          manifestUrl = _this$props.manifestUrl,
          renderings = _this$props.renderings,
          seeAlso = _this$props.seeAlso,
          id = _this$props.id,
          t = _this$props.t;
      return /*#__PURE__*/React.createElement(CollapsibleSection, {
        id: "".concat(id, "-related"),
        label: t('related'),
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 30,
          columnNumber: 7
        }
      }, /*#__PURE__*/React.createElement(Typography, {
        "aria-labelledby": "".concat(id, "-related ").concat(id, "-related-heading"),
        id: "".concat(id, "-related-heading"),
        variant: "h4",
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 34,
          columnNumber: 9
        }
      }, t('links')), /*#__PURE__*/React.createElement("dl", {
        className: classNames(ns('label-value-metadata'), classes.labelValueMetadata),
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 41,
          columnNumber: 9
        }
      }, homepage && /*#__PURE__*/React.createElement(React.Fragment, null, /*#__PURE__*/React.createElement(Typography, {
        variant: "subtitle2",
        component: "dt",
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 44,
          columnNumber: 15
        }
      }, t('iiif_homepage')), homepage.map(function (page) {
        return /*#__PURE__*/React.createElement(Typography, {
          key: page.value,
          variant: "body1",
          component: "dd",
          __self: _this,
          __source: {
            fileName: _jsxFileName,
            lineNumber: 47,
            columnNumber: 19
          }
        }, /*#__PURE__*/React.createElement(Link, {
          target: "_blank",
          rel: "noopener noreferrer",
          href: page.value,
          __self: _this,
          __source: {
            fileName: _jsxFileName,
            lineNumber: 48,
            columnNumber: 21
          }
        }, page.label || page.value));
      })), renderings && renderings.length > 0 && /*#__PURE__*/React.createElement(React.Fragment, null, /*#__PURE__*/React.createElement(Typography, {
        variant: "subtitle2",
        component: "dt",
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 58,
          columnNumber: 15
        }
      }, t('iiif_renderings')), renderings.map(function (rendering) {
        return /*#__PURE__*/React.createElement(Typography, {
          key: rendering.value,
          variant: "body1",
          component: "dd",
          __self: _this,
          __source: {
            fileName: _jsxFileName,
            lineNumber: 61,
            columnNumber: 19
          }
        }, /*#__PURE__*/React.createElement(Link, {
          target: "_blank",
          rel: "noopener noreferrer",
          href: rendering.value,
          __self: _this,
          __source: {
            fileName: _jsxFileName,
            lineNumber: 62,
            columnNumber: 21
          }
        }, rendering.label || rendering.value));
      })), seeAlso && /*#__PURE__*/React.createElement(React.Fragment, null, /*#__PURE__*/React.createElement(Typography, {
        variant: "subtitle2",
        component: "dt",
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 72,
          columnNumber: 15
        }
      }, t('iiif_seeAlso')), seeAlso.map(function (related) {
        return /*#__PURE__*/React.createElement(Typography, {
          key: related.value,
          variant: "body1",
          component: "dd",
          __self: _this,
          __source: {
            fileName: _jsxFileName,
            lineNumber: 75,
            columnNumber: 19
          }
        }, /*#__PURE__*/React.createElement(Link, {
          target: "_blank",
          rel: "noopener noreferrer",
          href: related.value,
          __self: _this,
          __source: {
            fileName: _jsxFileName,
            lineNumber: 76,
            columnNumber: 21
          }
        }, related.label || related.value), related.format && /*#__PURE__*/React.createElement(Typography, {
          component: "span",
          __self: _this,
          __source: {
            fileName: _jsxFileName,
            lineNumber: 80,
            columnNumber: 23
          }
        }, "(".concat(related.format, ")")));
      })), manifestUrl && /*#__PURE__*/React.createElement(React.Fragment, null, /*#__PURE__*/React.createElement(Typography, {
        variant: "subtitle2",
        component: "dt",
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 89,
          columnNumber: 15
        }
      }, t('iiif_manifest')), /*#__PURE__*/React.createElement(Typography, {
        variant: "body1",
        component: "dd",
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 90,
          columnNumber: 15
        }
      }, /*#__PURE__*/React.createElement(Link, {
        target: "_blank",
        rel: "noopener noreferrer",
        href: manifestUrl,
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 91,
          columnNumber: 17
        }
      }, manifestUrl)))));
    }
  }]);

  return ManifestRelatedLinks;
}(Component);
ManifestRelatedLinks.defaultProps = {
  homepage: null,
  manifestUrl: null,
  renderings: null,
  seeAlso: null,
  t: function t(key) {
    return key;
  }
};