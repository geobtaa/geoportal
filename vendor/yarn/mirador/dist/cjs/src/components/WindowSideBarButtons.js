"use strict";

Object.defineProperty(exports, "__esModule", {
  value: true
});
exports.WindowSideBarButtons = void 0;

var _react = _interopRequireWildcard(require("react"));

var _reactDom = _interopRequireDefault(require("react-dom"));

var _Badge = _interopRequireDefault(require("@material-ui/core/Badge"));

var _Tabs = _interopRequireDefault(require("@material-ui/core/Tabs"));

var _Tab = _interopRequireDefault(require("@material-ui/core/Tab"));

var _Tooltip = _interopRequireDefault(require("@material-ui/core/Tooltip"));

var _InfoSharp = _interopRequireDefault(require("@material-ui/icons/InfoSharp"));

var _CommentSharp = _interopRequireDefault(require("@material-ui/icons/CommentSharp"));

var _CopyrightSharp = _interopRequireDefault(require("@material-ui/icons/CopyrightSharp"));

var _LayersSharp = _interopRequireDefault(require("@material-ui/icons/LayersSharp"));

var _SearchSharp = _interopRequireDefault(require("@material-ui/icons/SearchSharp"));

var _CanvasIndexIcon = _interopRequireDefault(require("./icons/CanvasIndexIcon"));

var _KeyHelper = require("../lib/KeyHelper");

var _jsxFileName = "/Users/pjreed/dev/mirador/dist/cjs/src/components/WindowSideBarButtons.js";

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { "default": obj }; }

function _getRequireWildcardCache() { if (typeof WeakMap !== "function") return null; var cache = new WeakMap(); _getRequireWildcardCache = function _getRequireWildcardCache() { return cache; }; return cache; }

function _interopRequireWildcard(obj) { if (obj && obj.__esModule) { return obj; } if (obj === null || typeof obj !== "object" && typeof obj !== "function") { return { "default": obj }; } var cache = _getRequireWildcardCache(); if (cache && cache.has(obj)) { return cache.get(obj); } var newObj = {}; var hasPropertyDescriptor = Object.defineProperty && Object.getOwnPropertyDescriptor; for (var key in obj) { if (Object.prototype.hasOwnProperty.call(obj, key)) { var desc = hasPropertyDescriptor ? Object.getOwnPropertyDescriptor(obj, key) : null; if (desc && (desc.get || desc.set)) { Object.defineProperty(newObj, key, desc); } else { newObj[key] = obj[key]; } } } newObj["default"] = obj; if (cache) { cache.set(obj, newObj); } return newObj; }

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

/**
 *
 */
var WindowSideBarButtons = /*#__PURE__*/function (_Component) {
  _inherits(WindowSideBarButtons, _Component);

  var _super = _createSuper(WindowSideBarButtons);

  _createClass(WindowSideBarButtons, null, [{
    key: "activateTab",

    /**
     * selects the given tab
     * @param {*} tab the tab to activate
     */
    value: function activateTab(tab) {
      tab.removeAttribute('tabindex');
      tab.setAttribute('aria-selected', 'true');
    }
    /** */

  }]);

  function WindowSideBarButtons(props) {
    var _this;

    _classCallCheck(this, WindowSideBarButtons);

    _this = _super.call(this, props);
    _this.handleChange = _this.handleChange.bind(_assertThisInitialized(_this));
    _this.handleKeyUp = _this.handleKeyUp.bind(_assertThisInitialized(_this));
    return _this;
  }
  /**
   *
   */


  _createClass(WindowSideBarButtons, [{
    key: "componentDidMount",
    value: function componentDidMount() {
      this.tabBar = _reactDom["default"].findDOMNode(this.tabsRef); // eslint-disable-line react/no-find-dom-node

      this.tabs = Array.from(this.tabBar.querySelectorAll('button[role=tab]'));
      /*
        the change event isn't fired, when the tabs component is initialized,
        so we have to perform the required actions on our own
      */

      var selectedTab = this.tabs.find(function (t) {
        return t.getAttribute('aria-selected') === 'true';
      }) || this.tabs[0];
      this.selectTab(selectedTab);
      selectedTab.focus();
    }
    /**
     * Set the ref to the parent tabs element
     */

  }, {
    key: "setTabsRef",
    value: function setTabsRef(ref) {
      if (this.tabsRef) return;
      this.tabsRef = ref;
    }
    /**
     * @param {object} event the change event
     * @param {string} value the tab's value
    */

  }, {
    key: "handleChange",
    value: function handleChange(event, value) {
      var addCompanionWindow = this.props.addCompanionWindow;
      var tab = event.target;
      this.selectTab(tab);
      addCompanionWindow(value);
    }
    /**
     *
     * @param {*} tab the tab to select
     */

  }, {
    key: "selectTab",
    value: function selectTab(tab) {
      WindowSideBarButtons.activateTab(tab);
      this.deactivateTabs(this.tabs.indexOf(tab));
    }
    /**
     * @param {number} omit tab index to omit
     */

  }, {
    key: "deactivateTabs",
    value: function deactivateTabs() {
      var omit = arguments.length > 0 && arguments[0] !== undefined ? arguments[0] : -1;
      this.tabs.map(function (v, k) {
        if (k !== omit) {
          v.setAttribute('tabindex', '-1');
          v.setAttribute('aria-selected', 'false');
        }

        return null;
      });
    }
    /**
     *
     * @param {object} event the keyUp event
     */

  }, {
    key: "handleKeyUp",
    value: function handleKeyUp(event) {
      if (event.key === _KeyHelper.keys.up || event.which === _KeyHelper.chars.up) {
        event.preventDefault();
        return this.focusPreviousTab(event.target);
      }

      if (event.key === _KeyHelper.keys.down || event.which === _KeyHelper.chars.down) {
        event.preventDefault();
        return this.focusNextTab(event.target);
      }

      return null;
    }
    /**
     * focus the previous tab
     * @param {object} tab the currently selected tab
     */

  }, {
    key: "focusPreviousTab",
    value: function focusPreviousTab(tab) {
      var previousTab = tab.previousSibling || this.tabs[this.tabs.length - 1];
      previousTab.focus();
    }
    /**
     * focus the next tab
     * @param {object} tab the currently selected tab
     */

  }, {
    key: "focusNextTab",
    value: function focusNextTab(tab) {
      var nextTab = tab.nextSibling || this.tabs[0];
      nextTab.focus();
    }
    /**
     * render
     *
     * @return {type}  description
     */

  }, {
    key: "render",
    value: function render() {
      var _this2 = this;

      var _this$props = this.props,
          classes = _this$props.classes,
          hasAnnotations = _this$props.hasAnnotations,
          hasAnyLayers = _this$props.hasAnyLayers,
          hasCurrentLayers = _this$props.hasCurrentLayers,
          hasSearchResults = _this$props.hasSearchResults,
          hasSearchService = _this$props.hasSearchService,
          panels = _this$props.panels,
          sideBarPanel = _this$props.sideBarPanel,
          t = _this$props.t;
      /** */

      var TabButton = function TabButton(props) {
        return /*#__PURE__*/_react["default"].createElement(_Tooltip["default"], {
          title: t('openCompanionWindow', {
            context: props.value
          }),
          __self: _this2,
          __source: {
            fileName: _jsxFileName,
            lineNumber: 147,
            columnNumber: 7
          }
        }, /*#__PURE__*/_react["default"].createElement(_Tab["default"], Object.assign({}, props, {
          classes: {
            root: classes.tab,
            selected: classes.tabSelected
          },
          "aria-label": t('openCompanionWindow', {
            context: props.value
          }),
          disableRipple: true,
          onKeyUp: _this2.handleKeyUp,
          __self: _this2,
          __source: {
            fileName: _jsxFileName,
            lineNumber: 148,
            columnNumber: 9
          }
        })));
      };

      return /*#__PURE__*/_react["default"].createElement(_Tabs["default"], {
        classes: {
          flexContainer: classes.tabsFlexContainer,
          indicator: classes.tabsIndicator
        },
        value: sideBarPanel === 'closed' ? false : sideBarPanel,
        onChange: this.handleChange,
        variant: "fullWidth",
        indicatorColor: "primary",
        textColor: "primary",
        "aria-orientation": "vertical",
        "aria-label": t('sidebarPanelsNavigation'),
        ref: function ref(_ref) {
          return _this2.setTabsRef(_ref);
        },
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 161,
          columnNumber: 7
        }
      }, panels.info && /*#__PURE__*/_react["default"].createElement(TabButton, {
        value: "info",
        icon: /*#__PURE__*/_react["default"].createElement(_InfoSharp["default"], {
          __self: this,
          __source: {
            fileName: _jsxFileName,
            lineNumber: 175,
            columnNumber: 20
          }
        }),
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 173,
          columnNumber: 11
        }
      }), panels.attribution && /*#__PURE__*/_react["default"].createElement(TabButton, {
        value: "attribution",
        icon: /*#__PURE__*/_react["default"].createElement(_CopyrightSharp["default"], {
          __self: this,
          __source: {
            fileName: _jsxFileName,
            lineNumber: 181,
            columnNumber: 20
          }
        }),
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 179,
          columnNumber: 11
        }
      }), panels.canvas && /*#__PURE__*/_react["default"].createElement(TabButton, {
        value: "canvas",
        icon: /*#__PURE__*/_react["default"].createElement(_CanvasIndexIcon["default"], {
          __self: this,
          __source: {
            fileName: _jsxFileName,
            lineNumber: 187,
            columnNumber: 20
          }
        }),
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 185,
          columnNumber: 11
        }
      }), panels.annotations && /*#__PURE__*/_react["default"].createElement(TabButton, {
        value: "annotations",
        icon: /*#__PURE__*/_react["default"].createElement(_Badge["default"], {
          classes: {
            badge: classes.badge
          },
          invisible: !hasAnnotations,
          variant: "dot",
          __self: this,
          __source: {
            fileName: _jsxFileName,
            lineNumber: 194,
            columnNumber: 15
          }
        }, /*#__PURE__*/_react["default"].createElement(_CommentSharp["default"], {
          __self: this,
          __source: {
            fileName: _jsxFileName,
            lineNumber: 195,
            columnNumber: 17
          }
        })),
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 191,
          columnNumber: 11
        }
      }), panels.search && hasSearchService && /*#__PURE__*/_react["default"].createElement(TabButton, {
        value: "search",
        icon: /*#__PURE__*/_react["default"].createElement(_Badge["default"], {
          classes: {
            badge: classes.badge
          },
          invisible: !hasSearchResults,
          variant: "dot",
          __self: this,
          __source: {
            fileName: _jsxFileName,
            lineNumber: 204,
            columnNumber: 15
          }
        }, /*#__PURE__*/_react["default"].createElement(_SearchSharp["default"], {
          __self: this,
          __source: {
            fileName: _jsxFileName,
            lineNumber: 205,
            columnNumber: 17
          }
        })),
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 201,
          columnNumber: 11
        }
      }), panels.layers && hasAnyLayers && /*#__PURE__*/_react["default"].createElement(TabButton, {
        value: "layers",
        icon: /*#__PURE__*/_react["default"].createElement(_Badge["default"], {
          classes: {
            badge: classes.badge
          },
          invisible: !hasCurrentLayers,
          variant: "dot",
          __self: this,
          __source: {
            fileName: _jsxFileName,
            lineNumber: 214,
            columnNumber: 15
          }
        }, /*#__PURE__*/_react["default"].createElement(_LayersSharp["default"], {
          __self: this,
          __source: {
            fileName: _jsxFileName,
            lineNumber: 215,
            columnNumber: 17
          }
        })),
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 211,
          columnNumber: 11
        }
      }));
    }
  }]);

  return WindowSideBarButtons;
}(_react.Component);

exports.WindowSideBarButtons = WindowSideBarButtons;
WindowSideBarButtons.defaultProps = {
  classes: {},
  hasAnnotations: false,
  hasAnyLayers: false,
  hasCurrentLayers: false,
  hasSearchResults: false,
  hasSearchService: false,
  panels: [],
  sideBarPanel: 'closed',
  t: function t(key) {
    return key;
  }
};