"use strict";

Object.defineProperty(exports, "__esModule", {
  value: true
});
exports.ManifestForm = void 0;

var _react = _interopRequireWildcard(require("react"));

var _reactDom = _interopRequireDefault(require("react-dom"));

var _Button = _interopRequireDefault(require("@material-ui/core/Button"));

var _Grid = _interopRequireDefault(require("@material-ui/core/Grid"));

var _TextField = _interopRequireDefault(require("@material-ui/core/TextField"));

var _jsxFileName = "/Users/pjreed/dev/mirador/dist/cjs/src/components/ManifestForm.js";

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
 * Provides a form for user input of a manifest url
 * @prop {Function} fetchManifest
 */
var ManifestForm = /*#__PURE__*/function (_Component) {
  _inherits(ManifestForm, _Component);

  var _super = _createSuper(ManifestForm);

  /**
   * constructor -
   */
  function ManifestForm(props) {
    var _this;

    _classCallCheck(this, ManifestForm);

    _this = _super.call(this, props);
    _this.state = {
      formValue: ''
    };
    _this.formSubmit = _this.formSubmit.bind(_assertThisInitialized(_this));
    _this.handleCancel = _this.handleCancel.bind(_assertThisInitialized(_this));
    _this.handleInputChange = _this.handleInputChange.bind(_assertThisInitialized(_this));
    _this.setInputRef = _this.setInputRef.bind(_assertThisInitialized(_this));
    return _this;
  }
  /**
   *
   * @param {*} prevProps
   * @param {*} prevState
   */


  _createClass(ManifestForm, [{
    key: "componentDidUpdate",
    value: function componentDidUpdate() {
      var addResourcesOpen = this.props.addResourcesOpen;

      if (this.input && addResourcesOpen) {
        _reactDom["default"].findDOMNode(this.input).querySelector('#manifestURL').focus(); // eslint-disable-line react/no-find-dom-node

      }
    }
    /**
     * Set the ref to the manifest input
     * @param {*} input
     */

  }, {
    key: "setInputRef",
    value: function setInputRef(input) {
      if (this.input) return;
      this.input = input;
    }
    /**
     * formSubmit - triggers manifest update and sets lastRequested
     * @param  {Event} event
     * @private
     */

  }, {
    key: "formSubmit",
    value: function formSubmit(event) {
      var _this$props = this.props,
          fetchManifest = _this$props.fetchManifest,
          onSubmit = _this$props.onSubmit;
      var formValue = this.state.formValue;
      event.preventDefault();
      onSubmit();
      fetchManifest(formValue);
      this.setState({
        formValue: ''
      });
    }
    /**
     * Reset the form state
     */

  }, {
    key: "handleCancel",
    value: function handleCancel() {
      var onCancel = this.props.onCancel;
      onCancel();
      this.setState({
        formValue: ''
      });
    }
    /**
     * handleInputChange - sets state based on input change.
     * @param  {Event} event
     * @private
     */

  }, {
    key: "handleInputChange",
    value: function handleInputChange(event) {
      var that = this;
      event.preventDefault();
      that.setState({
        formValue: event.target.value
      });
    }
    /**
     * render
     * @return {String} - HTML markup for the component
     */

  }, {
    key: "render",
    value: function render() {
      var _this2 = this;

      var formValue = this.state.formValue;
      var _this$props2 = this.props,
          classes = _this$props2.classes,
          onCancel = _this$props2.onCancel,
          t = _this$props2.t;
      return /*#__PURE__*/_react["default"].createElement("form", {
        onSubmit: this.formSubmit,
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 99,
          columnNumber: 7
        }
      }, /*#__PURE__*/_react["default"].createElement(_Grid["default"], {
        container: true,
        spacing: 2,
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 100,
          columnNumber: 9
        }
      }, /*#__PURE__*/_react["default"].createElement(_Grid["default"], {
        item: true,
        xs: 12,
        sm: 8,
        md: 9,
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 101,
          columnNumber: 11
        }
      }, /*#__PURE__*/_react["default"].createElement(_TextField["default"], {
        ref: function ref(_ref) {
          return _this2.setInputRef(_ref);
        },
        fullWidth: true,
        value: formValue,
        id: "manifestURL",
        type: "text",
        onChange: this.handleInputChange,
        variant: "filled",
        label: t('addManifestUrl'),
        helperText: t('addManifestUrlHelp'),
        InputLabelProps: {
          shrink: true
        },
        InputProps: {
          className: classes.input
        },
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 102,
          columnNumber: 13
        }
      })), /*#__PURE__*/_react["default"].createElement(_Grid["default"], {
        item: true,
        xs: 12,
        sm: 4,
        md: 3,
        className: classes.buttons,
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 120,
          columnNumber: 11
        }
      }, onCancel && /*#__PURE__*/_react["default"].createElement(_Button["default"], {
        onClick: this.handleCancel,
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 122,
          columnNumber: 15
        }
      }, t('cancel')), /*#__PURE__*/_react["default"].createElement(_Button["default"], {
        id: "fetchBtn",
        type: "submit",
        variant: "contained",
        color: "primary",
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 126,
          columnNumber: 13
        }
      }, t('fetchManifest')))));
    }
  }]);

  return ManifestForm;
}(_react.Component);

exports.ManifestForm = ManifestForm;
ManifestForm.defaultProps = {
  classes: {},
  onCancel: null,
  onSubmit: function onSubmit() {},
  t: function t(key) {
    return key;
  }
};