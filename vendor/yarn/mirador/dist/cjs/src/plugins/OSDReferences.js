"use strict";

Object.defineProperty(exports, "__esModule", {
  value: true
});
exports["default"] = exports.OSDReferences = void 0;

var _react = _interopRequireDefault(require("react"));

var _jsxFileName = "/Users/pjreed/dev/mirador/dist/cjs/src/plugins/OSDReferences.js";

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

var OSDReferences = {
  /** */
  get: function get(windowId) {
    return this.refs[windowId];
  },
  refs: {},

  /** */
  set: function set(windowId, ref) {
    this.refs[windowId] = ref;
  }
};
/** */

exports.OSDReferences = OSDReferences;

var OSDReferenceComponent = /*#__PURE__*/function (_React$Component) {
  _inherits(OSDReferenceComponent, _React$Component);

  var _super = _createSuper(OSDReferenceComponent);

  /** */
  function OSDReferenceComponent(props) {
    var _this;

    _classCallCheck(this, OSDReferenceComponent);

    _this = _super.call(this, props);
    var windowId = props.targetProps.windowId;
    _this.osdRef = _react["default"].createRef();
    OSDReferences.set(windowId, _this.osdRef);
    return _this;
  }
  /** */


  _createClass(OSDReferenceComponent, [{
    key: "render",
    value: function render() {
      var targetProps = this.props.targetProps;
      return /*#__PURE__*/_react["default"].createElement(this.props.TargetComponent, Object.assign({}, targetProps, {
        ref: this.osdRef,
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 30,
          columnNumber: 12
        }
      }));
    }
  }]);

  return OSDReferenceComponent;
}(_react["default"].Component);

var _default = {
  component: OSDReferenceComponent,
  mode: 'wrap',
  name: 'OSD Reference',
  target: 'OpenSeadragonViewer'
};
exports["default"] = _default;