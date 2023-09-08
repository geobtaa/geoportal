var _jsxFileName = "/Users/pjreed/dev/mirador/dist/es/src/components/SearchPanelNavigation.js";

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
import ChevronLeftIcon from '@material-ui/icons/ChevronLeftSharp';
import ChevronRightIcon from '@material-ui/icons/ChevronRightSharp';
import Typography from '@material-ui/core/Typography';
import MiradorMenuButton from '../containers/MiradorMenuButton';
/**
 * SearchPanelNavigation ~
*/

export var SearchPanelNavigation = /*#__PURE__*/function (_Component) {
  _inherits(SearchPanelNavigation, _Component);

  var _super = _createSuper(SearchPanelNavigation);

  function SearchPanelNavigation() {
    _classCallCheck(this, SearchPanelNavigation);

    return _super.apply(this, arguments);
  }

  _createClass(SearchPanelNavigation, [{
    key: "nextSearchResult",

    /** */
    value: function nextSearchResult(currentHitIndex) {
      var _this$props = this.props,
          searchHits = _this$props.searchHits,
          selectContentSearchAnnotation = _this$props.selectContentSearchAnnotation;
      selectContentSearchAnnotation(searchHits[currentHitIndex + 1].annotations);
    }
    /** */

  }, {
    key: "previousSearchResult",
    value: function previousSearchResult(currentHitIndex) {
      var _this$props2 = this.props,
          searchHits = _this$props2.searchHits,
          selectContentSearchAnnotation = _this$props2.selectContentSearchAnnotation;
      selectContentSearchAnnotation(searchHits[currentHitIndex - 1].annotations);
    }
    /** */

  }, {
    key: "hasNextResult",
    value: function hasNextResult(currentHitIndex) {
      var searchHits = this.props.searchHits;
      if (searchHits.length === 0) return false;
      if (currentHitIndex < searchHits.length - 1) return true;
      return false;
    }
    /** */

  }, {
    key: "hasPreviousResult",
    value: function hasPreviousResult(currentHitIndex) {
      var searchHits = this.props.searchHits;
      if (searchHits.length === 0) return false;
      if (currentHitIndex > 0) return true;
      return false;
    }
    /**
     * Returns the rendered component
    */

  }, {
    key: "render",
    value: function render() {
      var _this = this;

      var _this$props3 = this.props,
          searchHits = _this$props3.searchHits,
          selectedContentSearchAnnotation = _this$props3.selectedContentSearchAnnotation,
          classes = _this$props3.classes,
          t = _this$props3.t,
          direction = _this$props3.direction;
      var iconStyle = direction === 'rtl' ? {
        transform: 'rotate(180deg)'
      } : {};
      var currentHitIndex = searchHits.findIndex(function (val) {
        return val.annotations.includes(selectedContentSearchAnnotation[0]);
      });
      return /*#__PURE__*/React.createElement(React.Fragment, null, searchHits.length > 0 && /*#__PURE__*/React.createElement(Typography, {
        variant: "body2",
        align: "center",
        classes: classes,
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 55,
          columnNumber: 11
        }
      }, /*#__PURE__*/React.createElement(MiradorMenuButton, {
        "aria-label": t('searchPreviousResult'),
        disabled: !this.hasPreviousResult(currentHitIndex),
        onClick: function onClick() {
          return _this.previousSearchResult(currentHitIndex);
        },
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 56,
          columnNumber: 13
        }
      }, /*#__PURE__*/React.createElement(ChevronLeftIcon, {
        style: iconStyle,
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 61,
          columnNumber: 15
        }
      })), /*#__PURE__*/React.createElement("span", {
        style: {
          unicodeBidi: 'plaintext'
        },
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 63,
          columnNumber: 13
        }
      }, t('pagination', {
        current: currentHitIndex + 1,
        total: searchHits.length
      })), /*#__PURE__*/React.createElement(MiradorMenuButton, {
        "aria-label": t('searchNextResult'),
        disabled: !this.hasNextResult(currentHitIndex),
        onClick: function onClick() {
          return _this.nextSearchResult(currentHitIndex);
        },
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 66,
          columnNumber: 13
        }
      }, /*#__PURE__*/React.createElement(ChevronRightIcon, {
        style: iconStyle,
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 71,
          columnNumber: 15
        }
      }))));
    }
  }]);

  return SearchPanelNavigation;
}(Component);
SearchPanelNavigation.defaultProps = {
  classes: {},
  searchHits: [],
  t: function t(key) {
    return key;
  }
};