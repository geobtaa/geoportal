"use strict";

Object.defineProperty(exports, "__esModule", {
  value: true
});
exports.WorkspaceAdd = void 0;

var _react = _interopRequireDefault(require("react"));

var _classnames = _interopRequireDefault(require("classnames"));

var _AddSharp = _interopRequireDefault(require("@material-ui/icons/AddSharp"));

var _ExpandMoreSharp = _interopRequireDefault(require("@material-ui/icons/ExpandMoreSharp"));

var _AppBar = _interopRequireDefault(require("@material-ui/core/AppBar"));

var _Drawer = _interopRequireDefault(require("@material-ui/core/Drawer"));

var _Grid = _interopRequireDefault(require("@material-ui/core/Grid"));

var _Fab = _interopRequireDefault(require("@material-ui/core/Fab"));

var _List = _interopRequireDefault(require("@material-ui/core/List"));

var _Paper = _interopRequireDefault(require("@material-ui/core/Paper"));

var _Toolbar = _interopRequireDefault(require("@material-ui/core/Toolbar"));

var _Typography = _interopRequireDefault(require("@material-ui/core/Typography"));

var _cssNs = _interopRequireDefault(require("../config/css-ns"));

var _ManifestForm = _interopRequireDefault(require("../containers/ManifestForm"));

var _ManifestListItem = _interopRequireDefault(require("../containers/ManifestListItem"));

var _MiradorMenuButton = _interopRequireDefault(require("../containers/MiradorMenuButton"));

var _jsxFileName = "/Users/pjreed/dev/mirador/dist/cjs/src/components/WorkspaceAdd.js";

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { "default": obj }; }

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

/**
 * An area for managing manifests and adding them to workspace
 * @memberof Workspace
 * @private
 */
var WorkspaceAdd = /*#__PURE__*/function (_React$Component) {
  _inherits(WorkspaceAdd, _React$Component);

  var _super = _createSuper(WorkspaceAdd);

  /** */
  function WorkspaceAdd(props) {
    var _this;

    _classCallCheck(this, WorkspaceAdd);

    _this = _super.call(this, props);
    _this.state = {
      addResourcesOpen: false
    };
    _this.setAddResourcesVisibility = _this.setAddResourcesVisibility.bind(_assertThisInitialized(_this));
    return _this;
  }
  /**
   * @private
   */


  _createClass(WorkspaceAdd, [{
    key: "setAddResourcesVisibility",
    value: function setAddResourcesVisibility(bool) {
      this.setState({
        addResourcesOpen: bool
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
          manifests = _this$props.manifests,
          setWorkspaceAddVisibility = _this$props.setWorkspaceAddVisibility,
          t = _this$props.t,
          classes = _this$props.classes;
      var addResourcesOpen = this.state.addResourcesOpen;
      var manifestList = Object.keys(manifests).map(function (manifest) {
        return /*#__PURE__*/_react["default"].createElement(_ManifestListItem["default"], {
          key: manifest,
          manifestId: manifest,
          handleClose: function handleClose() {
            return setWorkspaceAddVisibility(false);
          },
          __self: _this2,
          __source: {
            fileName: _jsxFileName,
            lineNumber: 51,
            columnNumber: 7
          }
        });
      });
      return /*#__PURE__*/_react["default"].createElement("div", {
        className: (0, _classnames["default"])((0, _cssNs["default"])('workspace-add'), classes.workspaceAdd),
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 59,
          columnNumber: 7
        }
      }, Object.keys(manifests).length < 1 ? /*#__PURE__*/_react["default"].createElement(_Grid["default"], {
        alignItems: "center",
        container: true,
        style: {
          height: '100%'
        },
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 61,
          columnNumber: 11
        }
      }, /*#__PURE__*/_react["default"].createElement(_Grid["default"], {
        xs: 12,
        item: true,
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 68,
          columnNumber: 13
        }
      }, /*#__PURE__*/_react["default"].createElement(_Typography["default"], {
        variant: "h1",
        component: "div",
        align: "center",
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 72,
          columnNumber: 15
        }
      }, t('emptyResourceList')))) : /*#__PURE__*/_react["default"].createElement(_Paper["default"], {
        className: classes.list,
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 82,
          columnNumber: 11
        }
      }, /*#__PURE__*/_react["default"].createElement(_Typography["default"], {
        variant: "srOnly",
        component: "h1",
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 83,
          columnNumber: 13
        }
      }, t('miradorResources')), /*#__PURE__*/_react["default"].createElement(_List["default"], {
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 84,
          columnNumber: 13
        }
      }, manifestList)), /*#__PURE__*/_react["default"].createElement(_Fab["default"], {
        variant: "extended",
        disabled: addResourcesOpen,
        className: (0, _classnames["default"])(classes.fab, (0, _cssNs["default"])('add-resource-button')),
        color: "primary",
        onClick: function onClick() {
          return _this2.setAddResourcesVisibility(true);
        },
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 89,
          columnNumber: 9
        }
      }, /*#__PURE__*/_react["default"].createElement(_AddSharp["default"], {
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 96,
          columnNumber: 11
        }
      }), t('addResource')), /*#__PURE__*/_react["default"].createElement(_Drawer["default"], {
        className: (0, _classnames["default"])(_defineProperty({}, classes.displayNone, !addResourcesOpen)),
        classes: {
          paper: classes.paper
        },
        variant: "persistent",
        anchor: "bottom",
        open: addResourcesOpen,
        ModalProps: {
          disablePortal: true,
          hideBackdrop: true,
          style: {
            position: 'absolute'
          }
        },
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 100,
          columnNumber: 9
        }
      }, /*#__PURE__*/_react["default"].createElement(_Paper["default"], {
        className: classes.form,
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 114,
          columnNumber: 11
        }
      }, /*#__PURE__*/_react["default"].createElement(_AppBar["default"], {
        position: "absolute",
        color: "primary",
        onClick: function onClick() {
          return _this2.setAddResourcesVisibility(false);
        },
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 117,
          columnNumber: 13
        }
      }, /*#__PURE__*/_react["default"].createElement(_Toolbar["default"], {
        variant: "dense",
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 118,
          columnNumber: 15
        }
      }, /*#__PURE__*/_react["default"].createElement(_MiradorMenuButton["default"], {
        "aria-label": t('closeAddResourceForm'),
        className: classes.menuButton,
        color: "inherit",
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 119,
          columnNumber: 17
        }
      }, /*#__PURE__*/_react["default"].createElement(_ExpandMoreSharp["default"], {
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 124,
          columnNumber: 19
        }
      })), /*#__PURE__*/_react["default"].createElement(_Typography["default"], {
        variant: "h2",
        noWrap: true,
        color: "inherit",
        className: classes.typographyBody,
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 126,
          columnNumber: 17
        }
      }, t('addResource')))), /*#__PURE__*/_react["default"].createElement(_ManifestForm["default"], {
        addResourcesOpen: addResourcesOpen,
        onSubmit: function onSubmit() {
          return _this2.setAddResourcesVisibility(false);
        },
        onCancel: function onCancel() {
          return _this2.setAddResourcesVisibility(false);
        },
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 131,
          columnNumber: 13
        }
      }))));
    }
  }]);

  return WorkspaceAdd;
}(_react["default"].Component);

exports.WorkspaceAdd = WorkspaceAdd;
WorkspaceAdd.defaultProps = {
  classes: {},
  t: function t(key) {
    return key;
  }
};