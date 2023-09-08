"use strict";

Object.defineProperty(exports, "__esModule", {
  value: true
});
exports.ManifestListItem = void 0;

var _react = _interopRequireDefault(require("react"));

var _ListItem = _interopRequireDefault(require("@material-ui/core/ListItem"));

var _ButtonBase = _interopRequireDefault(require("@material-ui/core/ButtonBase"));

var _Grid = _interopRequireDefault(require("@material-ui/core/Grid"));

var _Typography = _interopRequireDefault(require("@material-ui/core/Typography"));

var _Skeleton = _interopRequireDefault(require("@material-ui/lab/Skeleton"));

var _reactImage = _interopRequireDefault(require("react-image"));

var _ManifestListItemError = _interopRequireDefault(require("../containers/ManifestListItemError"));

var _cssNs = _interopRequireDefault(require("../config/css-ns"));

var _jsxFileName = "/Users/pjreed/dev/mirador/dist/cjs/src/components/ManifestListItem.js";

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { "default": obj }; }

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
 * Handling open button click
 */
var handleOpenButtonClick = function handleOpenButtonClick(event, manifest, addWindow) {
  addWindow({
    manifestId: manifest
  });
};
/**
 * Represents an item in a list of currently-loaded or loading manifests
 * @param {object} props
 * @param {object} [props.manifest = string]
 */

/** */


var ManifestListItem = /*#__PURE__*/function (_React$Component) {
  _inherits(ManifestListItem, _React$Component);

  var _super = _createSuper(ManifestListItem);

  function ManifestListItem() {
    _classCallCheck(this, ManifestListItem);

    return _super.apply(this, arguments);
  }

  _createClass(ManifestListItem, [{
    key: "componentDidMount",

    /** */
    value: function componentDidMount() {
      var _this$props = this.props,
          fetchManifest = _this$props.fetchManifest,
          manifestId = _this$props.manifestId,
          ready = _this$props.ready,
          isFetching = _this$props.isFetching,
          error = _this$props.error;
      if (!ready && !error && !isFetching) fetchManifest(manifestId);
    }
    /** */

  }, {
    key: "render",
    value: function render() {
      var _this$props2 = this.props,
          active = _this$props2.active,
          manifestId = _this$props2.manifestId,
          ready = _this$props2.ready,
          title = _this$props2.title,
          thumbnail = _this$props2.thumbnail,
          manifestLogo = _this$props2.manifestLogo,
          addWindow = _this$props2.addWindow,
          handleClose = _this$props2.handleClose,
          size = _this$props2.size,
          classes = _this$props2.classes,
          provider = _this$props2.provider,
          t = _this$props2.t,
          error = _this$props2.error;

      var placeholder = /*#__PURE__*/_react["default"].createElement(_Grid["default"], {
        container: true,
        className: (0, _cssNs["default"])('manifest-list-item'),
        spacing: 2,
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 54,
          columnNumber: 7
        }
      }, /*#__PURE__*/_react["default"].createElement(_Grid["default"], {
        item: true,
        xs: 3,
        sm: 2,
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 55,
          columnNumber: 9
        }
      }, /*#__PURE__*/_react["default"].createElement(_Skeleton["default"], {
        className: classes.placeholder,
        variant: "rect",
        height: 80,
        width: 120,
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 56,
          columnNumber: 11
        }
      })), /*#__PURE__*/_react["default"].createElement(_Grid["default"], {
        item: true,
        xs: 9,
        sm: 6,
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 58,
          columnNumber: 9
        }
      }, /*#__PURE__*/_react["default"].createElement(_Skeleton["default"], {
        className: classes.placeholder,
        variant: "text",
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 59,
          columnNumber: 11
        }
      })), /*#__PURE__*/_react["default"].createElement(_Grid["default"], {
        item: true,
        xs: 8,
        sm: 2,
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 61,
          columnNumber: 9
        }
      }, /*#__PURE__*/_react["default"].createElement(_Skeleton["default"], {
        className: classes.placeholder,
        variant: "text",
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 62,
          columnNumber: 11
        }
      }), /*#__PURE__*/_react["default"].createElement(_Skeleton["default"], {
        className: classes.placeholder,
        variant: "text",
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 63,
          columnNumber: 11
        }
      })), /*#__PURE__*/_react["default"].createElement(_Grid["default"], {
        item: true,
        xs: 4,
        sm: 2,
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 65,
          columnNumber: 9
        }
      }, /*#__PURE__*/_react["default"].createElement(_Skeleton["default"], {
        className: classes.placeholder,
        variant: "rect",
        height: 60,
        width: 60,
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 66,
          columnNumber: 11
        }
      })));

      if (error) {
        return /*#__PURE__*/_react["default"].createElement(_ListItem["default"], {
          divider: true,
          elevation: 1,
          className: classes.root,
          "data-manifestid": manifestId,
          __self: this,
          __source: {
            fileName: _jsxFileName,
            lineNumber: 73,
            columnNumber: 9
          }
        }, /*#__PURE__*/_react["default"].createElement(_ManifestListItemError["default"], {
          manifestId: manifestId,
          __self: this,
          __source: {
            fileName: _jsxFileName,
            lineNumber: 74,
            columnNumber: 11
          }
        }));
      }

      return /*#__PURE__*/_react["default"].createElement(_ListItem["default"], {
        divider: true,
        elevation: 1,
        className: [classes.root, active ? classes.active : ''].join(' '),
        "data-manifestid": manifestId,
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 80,
          columnNumber: 7
        }
      }, ready ? /*#__PURE__*/_react["default"].createElement(_Grid["default"], {
        container: true,
        className: (0, _cssNs["default"])('manifest-list-item'),
        spacing: 2,
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 82,
          columnNumber: 11
        }
      }, /*#__PURE__*/_react["default"].createElement(_Grid["default"], {
        item: true,
        xs: 12,
        sm: 6,
        className: classes.buttonGrid,
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 83,
          columnNumber: 13
        }
      }, /*#__PURE__*/_react["default"].createElement(_ButtonBase["default"], {
        className: (0, _cssNs["default"])('manifest-list-item-title'),
        style: {
          width: '100%'
        },
        onClick: function onClick(event) {
          handleOpenButtonClick(event, manifestId, addWindow);
          handleClose();
        },
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 84,
          columnNumber: 15
        }
      }, /*#__PURE__*/_react["default"].createElement(_Grid["default"], {
        container: true,
        spacing: 2,
        className: classes.label,
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 91,
          columnNumber: 17
        }
      }, /*#__PURE__*/_react["default"].createElement(_Grid["default"], {
        item: true,
        xs: 4,
        sm: 3,
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 92,
          columnNumber: 19
        }
      }, /*#__PURE__*/_react["default"].createElement(_reactImage["default"], {
        className: (0, _cssNs["default"])('manifest-list-item-thumb'),
        src: [thumbnail],
        alt: "",
        height: "80",
        unloader: /*#__PURE__*/_react["default"].createElement(_Skeleton["default"], {
          variant: "rect",
          animation: false,
          className: classes.placeholder,
          height: 80,
          width: 120,
          __self: this,
          __source: {
            fileName: _jsxFileName,
            lineNumber: 99,
            columnNumber: 25
          }
        }),
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 93,
          columnNumber: 21
        }
      })), /*#__PURE__*/_react["default"].createElement(_Grid["default"], {
        item: true,
        xs: 8,
        sm: 9,
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 109,
          columnNumber: 19
        }
      }, /*#__PURE__*/_react["default"].createElement(_Typography["default"], {
        component: "span",
        variant: "h6",
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 110,
          columnNumber: 21
        }
      }, title || manifestId))))), /*#__PURE__*/_react["default"].createElement(_Grid["default"], {
        item: true,
        xs: 8,
        sm: 4,
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 117,
          columnNumber: 13
        }
      }, /*#__PURE__*/_react["default"].createElement(_Typography["default"], {
        className: (0, _cssNs["default"])('manifest-list-item-provider'),
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 118,
          columnNumber: 15
        }
      }, provider || t('addedFromUrl')), /*#__PURE__*/_react["default"].createElement(_Typography["default"], {
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 119,
          columnNumber: 15
        }
      }, t('numItems', {
        number: size
      }))), /*#__PURE__*/_react["default"].createElement(_Grid["default"], {
        item: true,
        xs: 4,
        sm: 2,
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 122,
          columnNumber: 13
        }
      }, /*#__PURE__*/_react["default"].createElement(_reactImage["default"], {
        src: [manifestLogo],
        alt: "",
        role: "presentation",
        className: classes.logo,
        unloader: /*#__PURE__*/_react["default"].createElement(_Skeleton["default"], {
          variant: "rect",
          animation: false,
          className: classes.placeholder,
          height: 60,
          width: 60,
          __self: this,
          __source: {
            fileName: _jsxFileName,
            lineNumber: 129,
            columnNumber: 19
          }
        }),
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 123,
          columnNumber: 15
        }
      }))) : placeholder);
    }
  }]);

  return ManifestListItem;
}(_react["default"].Component);

exports.ManifestListItem = ManifestListItem;
ManifestListItem.defaultProps = {
  active: false,
  classes: {},
  error: null,
  handleClose: function handleClose() {},
  isFetching: false,
  manifestLogo: null,
  provider: null,
  ready: false,
  size: 0,
  t: function t(key) {
    return key;
  },
  thumbnail: null,
  title: null
};