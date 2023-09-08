"use strict";

Object.defineProperty(exports, "__esModule", {
  value: true
});
exports.CanvasLayers = void 0;

var _react = _interopRequireWildcard(require("react"));

var _clsx2 = _interopRequireDefault(require("clsx"));

var _v = _interopRequireDefault(require("uuid/v4"));

var _Input = _interopRequireDefault(require("@material-ui/core/Input"));

var _InputAdornment = _interopRequireDefault(require("@material-ui/core/InputAdornment"));

var _List = _interopRequireDefault(require("@material-ui/core/List"));

var _ListItem = _interopRequireDefault(require("@material-ui/core/ListItem"));

var _Slider = _interopRequireDefault(require("@material-ui/core/Slider"));

var _Tooltip = _interopRequireDefault(require("@material-ui/core/Tooltip"));

var _DragHandleSharp = _interopRequireDefault(require("@material-ui/icons/DragHandleSharp"));

var _VerticalAlignTopSharp = _interopRequireDefault(require("@material-ui/icons/VerticalAlignTopSharp"));

var _VisibilitySharp = _interopRequireDefault(require("@material-ui/icons/VisibilitySharp"));

var _VisibilityOffSharp = _interopRequireDefault(require("@material-ui/icons/VisibilityOffSharp"));

var _OpacitySharp = _interopRequireDefault(require("@material-ui/icons/OpacitySharp"));

var _Typography = _interopRequireDefault(require("@material-ui/core/Typography"));

var _reactBeautifulDnd = require("react-beautiful-dnd");

var _ManifestoCanvas = _interopRequireDefault(require("../lib/ManifestoCanvas"));

var _MiradorMenuButton = _interopRequireDefault(require("../containers/MiradorMenuButton"));

var _CanvasThumbnail = require("./CanvasThumbnail");

var _jsxFileName = "/Users/pjreed/dev/mirador/dist/cjs/src/components/CanvasLayers.js";

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { "default": obj }; }

function _getRequireWildcardCache() { if (typeof WeakMap !== "function") return null; var cache = new WeakMap(); _getRequireWildcardCache = function _getRequireWildcardCache() { return cache; }; return cache; }

function _interopRequireWildcard(obj) { if (obj && obj.__esModule) { return obj; } if (obj === null || typeof obj !== "object" && typeof obj !== "function") { return { "default": obj }; } var cache = _getRequireWildcardCache(); if (cache && cache.has(obj)) { return cache.get(obj); } var newObj = {}; var hasPropertyDescriptor = Object.defineProperty && Object.getOwnPropertyDescriptor; for (var key in obj) { if (Object.prototype.hasOwnProperty.call(obj, key)) { var desc = hasPropertyDescriptor ? Object.getOwnPropertyDescriptor(obj, key) : null; if (desc && (desc.get || desc.set)) { Object.defineProperty(newObj, key, desc); } else { newObj[key] = obj[key]; } } } newObj["default"] = obj; if (cache) { cache.set(obj, newObj); } return newObj; }

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

function _slicedToArray(arr, i) { return _arrayWithHoles(arr) || _iterableToArrayLimit(arr, i) || _unsupportedIterableToArray(arr, i) || _nonIterableRest(); }

function _nonIterableRest() { throw new TypeError("Invalid attempt to destructure non-iterable instance.\nIn order to be iterable, non-array objects must have a [Symbol.iterator]() method."); }

function _unsupportedIterableToArray(o, minLen) { if (!o) return; if (typeof o === "string") return _arrayLikeToArray(o, minLen); var n = Object.prototype.toString.call(o).slice(8, -1); if (n === "Object" && o.constructor) n = o.constructor.name; if (n === "Map" || n === "Set") return Array.from(n); if (n === "Arguments" || /^(?:Ui|I)nt(?:8|16|32)(?:Clamped)?Array$/.test(n)) return _arrayLikeToArray(o, minLen); }

function _arrayLikeToArray(arr, len) { if (len == null || len > arr.length) len = arr.length; for (var i = 0, arr2 = new Array(len); i < len; i++) { arr2[i] = arr[i]; } return arr2; }

function _iterableToArrayLimit(arr, i) { if (typeof Symbol === "undefined" || !(Symbol.iterator in Object(arr))) return; var _arr = []; var _n = true; var _d = false; var _e = undefined; try { for (var _i = arr[Symbol.iterator](), _s; !(_n = (_s = _i.next()).done); _n = true) { _arr.push(_s.value); if (i && _arr.length === i) break; } } catch (err) { _d = true; _e = err; } finally { try { if (!_n && _i["return"] != null) _i["return"](); } finally { if (_d) throw _e; } } return _arr; }

function _arrayWithHoles(arr) { if (Array.isArray(arr)) return arr; }

/** */
var reorder = function reorder(list, startIndex, endIndex) {
  var result = Array.from(list);

  var _result$splice = result.splice(startIndex, 1),
      _result$splice2 = _slicedToArray(_result$splice, 1),
      removed = _result$splice2[0];

  result.splice(endIndex, 0, removed);
  return result;
};
/** */


var CanvasLayers = /*#__PURE__*/function (_Component) {
  _inherits(CanvasLayers, _Component);

  var _super = _createSuper(CanvasLayers);

  _createClass(CanvasLayers, null, [{
    key: "getUseableLabel",

    /** */
    value: function getUseableLabel(resource, index) {
      return resource && resource.getLabel && resource.getLabel().length > 0 ? resource.getLabel().map(function (label) {
        return label.value;
      })[0] : String(index + 1);
    }
    /** */

  }]);

  function CanvasLayers(props) {
    var _this;

    _classCallCheck(this, CanvasLayers);

    _this = _super.call(this, props);
    _this.droppableId = (0, _v["default"])();
    _this.onDragEnd = _this.onDragEnd.bind(_assertThisInitialized(_this));
    _this.handleOpacityChange = _this.handleOpacityChange.bind(_assertThisInitialized(_this));
    _this.setLayerVisibility = _this.setLayerVisibility.bind(_assertThisInitialized(_this));
    _this.moveToTop = _this.moveToTop.bind(_assertThisInitialized(_this));
    return _this;
  }
  /** */


  _createClass(CanvasLayers, [{
    key: "onDragEnd",
    value: function onDragEnd(result) {
      var _this$props = this.props,
          canvas = _this$props.canvas,
          layers = _this$props.layers,
          updateLayers = _this$props.updateLayers,
          windowId = _this$props.windowId;
      if (!result.destination) return;
      if (result.destination.droppableId !== this.droppableId) return;
      if (result.source.droppableId !== this.droppableId) return;
      var sortedLayers = reorder(layers.map(function (l) {
        return l.id;
      }), result.source.index, result.destination.index);
      var payload = layers.reduce(function (acc, layer) {
        acc[layer.id] = {
          index: sortedLayers.indexOf(layer.id)
        };
        return acc;
      }, {});
      updateLayers(windowId, canvas.id, payload);
    }
    /** */

  }, {
    key: "setLayerVisibility",
    value: function setLayerVisibility(layerId, value) {
      var _this$props2 = this.props,
          canvas = _this$props2.canvas,
          updateLayers = _this$props2.updateLayers,
          windowId = _this$props2.windowId;

      var payload = _defineProperty({}, layerId, {
        visibility: value
      });

      updateLayers(windowId, canvas.id, payload);
    }
    /** */

  }, {
    key: "moveToTop",
    value: function moveToTop(layerId) {
      var _this$props3 = this.props,
          canvas = _this$props3.canvas,
          layers = _this$props3.layers,
          updateLayers = _this$props3.updateLayers,
          windowId = _this$props3.windowId;
      var sortedLayers = reorder(layers.map(function (l) {
        return l.id;
      }), layers.findIndex(function (l) {
        return l.id === layerId;
      }), 0);
      var payload = layers.reduce(function (acc, layer) {
        acc[layer.id] = {
          index: sortedLayers.indexOf(layer.id)
        };
        return acc;
      }, {});
      updateLayers(windowId, canvas.id, payload);
    }
    /** */

  }, {
    key: "handleOpacityChange",
    value: function handleOpacityChange(layerId, value) {
      var _this$props4 = this.props,
          canvas = _this$props4.canvas,
          updateLayers = _this$props4.updateLayers,
          windowId = _this$props4.windowId;

      var payload = _defineProperty({}, layerId, {
        opacity: value / 100.0
      });

      updateLayers(windowId, canvas.id, payload);
    }
    /** @private */

  }, {
    key: "renderLayer",
    value: function renderLayer(resource, index) {
      var _this2 = this;

      var _this$props5 = this.props,
          canvas = _this$props5.canvas,
          classes = _this$props5.classes,
          layerMetadata = _this$props5.layerMetadata,
          t = _this$props5.t;
      var manifestoCanvas = new _ManifestoCanvas["default"](canvas);
      var _height$width = {
        height: undefined,
        width: 50
      },
          width = _height$width.width,
          height = _height$width.height;

      var layer = _objectSpread({
        opacity: 1,
        visibility: true
      }, (layerMetadata || {})[resource.id]);

      return /*#__PURE__*/_react["default"].createElement("div", {
        style: {
          flex: 1
        },
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 136,
          columnNumber: 7
        }
      }, /*#__PURE__*/_react["default"].createElement("div", {
        style: {
          alignItems: 'flex-start',
          display: 'flex'
        },
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 137,
          columnNumber: 9
        }
      }, /*#__PURE__*/_react["default"].createElement("div", {
        style: {
          minWidth: 50
        },
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 138,
          columnNumber: 11
        }
      }, /*#__PURE__*/_react["default"].createElement(_CanvasThumbnail.CanvasThumbnail, {
        isValid: manifestoCanvas.hasValidDimensions,
        imageUrl: manifestoCanvas.thumbnail(width, height, resource.id),
        maxHeight: height,
        maxWidth: width,
        aspectRatio: manifestoCanvas.aspectRatio,
        ImageProps: {
          className: classes.image
        },
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 139,
          columnNumber: 13
        }
      })), /*#__PURE__*/_react["default"].createElement(_Typography["default"], {
        className: classes.label,
        component: "div",
        variant: "body1",
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 148,
          columnNumber: 11
        }
      }, CanvasLayers.getUseableLabel(resource, index), /*#__PURE__*/_react["default"].createElement("div", {
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 154,
          columnNumber: 13
        }
      }, /*#__PURE__*/_react["default"].createElement(_MiradorMenuButton["default"], {
        "aria-label": t(layer.visibility ? 'layer_hide' : 'layer_show'),
        edge: "start",
        size: "small",
        onClick: function onClick() {
          _this2.setLayerVisibility(resource.id, !layer.visibility);
        },
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 155,
          columnNumber: 15
        }
      }, layer.visibility ? /*#__PURE__*/_react["default"].createElement(_VisibilitySharp["default"], {
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 156,
          columnNumber: 38
        }
      }) : /*#__PURE__*/_react["default"].createElement(_VisibilityOffSharp["default"], {
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 156,
          columnNumber: 59
        }
      })), layer.index !== 0 && /*#__PURE__*/_react["default"].createElement(_MiradorMenuButton["default"], {
        "aria-label": t('layer_moveToTop'),
        size: "small",
        onClick: function onClick() {
          _this2.moveToTop(resource.id);
        },
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 159,
          columnNumber: 17
        }
      }, /*#__PURE__*/_react["default"].createElement(_VerticalAlignTopSharp["default"], {
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 160,
          columnNumber: 19
        }
      }))))), /*#__PURE__*/_react["default"].createElement("div", {
        style: {
          alignItems: 'center',
          display: 'flex'
        },
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 166,
          columnNumber: 9
        }
      }, /*#__PURE__*/_react["default"].createElement(_Tooltip["default"], {
        title: t('layer_opacity'),
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 167,
          columnNumber: 11
        }
      }, /*#__PURE__*/_react["default"].createElement(_OpacitySharp["default"], {
        className: classes.opacityIcon,
        color: layer.visibility ? 'inherit' : 'disabled',
        fontSize: "small",
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 168,
          columnNumber: 13
        }
      })), /*#__PURE__*/_react["default"].createElement(_Input["default"], {
        classes: {
          input: classes.opacityInput
        },
        disabled: !layer.visibility,
        value: Math.round(layer.opacity * 100),
        type: "number",
        min: 0,
        max: 100,
        onChange: function onChange(e) {
          return _this2.handleOpacityChange(resource.id, e.target.value);
        },
        endAdornment: /*#__PURE__*/_react["default"].createElement(_InputAdornment["default"], {
          disableTypography: true,
          position: "end",
          __self: this,
          __source: {
            fileName: _jsxFileName,
            lineNumber: 178,
            columnNumber: 27
          }
        }, /*#__PURE__*/_react["default"].createElement(_Typography["default"], {
          variant: "caption",
          __self: this,
          __source: {
            fileName: _jsxFileName,
            lineNumber: 178,
            columnNumber: 76
          }
        }, "%")),
        inputProps: {
          'aria-label': t('layer_opacity')
        },
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 170,
          columnNumber: 11
        }
      }), /*#__PURE__*/_react["default"].createElement(_Slider["default"], {
        className: classes.slider,
        disabled: !layer.visibility,
        value: layer.opacity * 100,
        onChange: function onChange(e, value) {
          return _this2.handleOpacityChange(resource.id, value);
        },
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 183,
          columnNumber: 11
        }
      })));
    }
    /** @private */

  }, {
    key: "renderDraggableLayer",
    value: function renderDraggableLayer(resource, index) {
      var _this3 = this;

      var _this$props6 = this.props,
          classes = _this$props6.classes,
          t = _this$props6.t;
      return /*#__PURE__*/_react["default"].createElement(_reactBeautifulDnd.Draggable, {
        key: resource.id,
        draggableId: resource.id,
        index: index,
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 202,
          columnNumber: 7
        }
      }, function (provided, snapshot) {
        return /*#__PURE__*/_react["default"].createElement(_ListItem["default"], Object.assign({
          ref: provided.innerRef
        }, provided.draggableProps, {
          component: "li",
          className: (0, _clsx2["default"])(classes.listItem, _defineProperty({}, classes.dragging, snapshot.isDragging)),
          disableGutters: true,
          key: resource.id,
          __self: _this3,
          __source: {
            fileName: _jsxFileName,
            lineNumber: 204,
            columnNumber: 11
          }
        }), /*#__PURE__*/_react["default"].createElement("div", Object.assign({}, provided.dragHandleProps, {
          className: classes.dragHandle,
          __self: _this3,
          __source: {
            fileName: _jsxFileName,
            lineNumber: 217,
            columnNumber: 13
          }
        }), /*#__PURE__*/_react["default"].createElement(_Tooltip["default"], {
          title: t('layer_move'),
          __self: _this3,
          __source: {
            fileName: _jsxFileName,
            lineNumber: 218,
            columnNumber: 15
          }
        }, /*#__PURE__*/_react["default"].createElement(_DragHandleSharp["default"], {
          __self: _this3,
          __source: {
            fileName: _jsxFileName,
            lineNumber: 219,
            columnNumber: 17
          }
        }))), _this3.renderLayer(resource, index));
      });
    }
    /** */

  }, {
    key: "render",
    value: function render() {
      var _this4 = this;

      var _this$props7 = this.props,
          classes = _this$props7.classes,
          index = _this$props7.index,
          label = _this$props7.label,
          layers = _this$props7.layers,
          t = _this$props7.t,
          totalSize = _this$props7.totalSize;
      return /*#__PURE__*/_react["default"].createElement(_react["default"].Fragment, null, totalSize > 1 && /*#__PURE__*/_react["default"].createElement(_Typography["default"], {
        className: classes.sectionHeading,
        variant: "overline",
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 243,
          columnNumber: 11
        }
      }, t('annotationCanvasLabel', {
        context: "".concat(index + 1, "/").concat(totalSize),
        label: label
      })), /*#__PURE__*/_react["default"].createElement(_reactBeautifulDnd.DragDropContext, {
        onDragEnd: this.onDragEnd,
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 247,
          columnNumber: 9
        }
      }, /*#__PURE__*/_react["default"].createElement(_reactBeautifulDnd.Droppable, {
        droppableId: this.droppableId,
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 248,
          columnNumber: 11
        }
      }, function (provided, snapshot) {
        return /*#__PURE__*/_react["default"].createElement(_List["default"], Object.assign({
          className: classes.list
        }, provided.droppableProps, {
          ref: provided.innerRef,
          __self: _this4,
          __source: {
            fileName: _jsxFileName,
            lineNumber: 250,
            columnNumber: 15
          }
        }), layers && layers.map(function (r, i) {
          return _this4.renderDraggableLayer(r, i);
        }), provided.placeholder);
      })));
    }
  }]);

  return CanvasLayers;
}(_react.Component);

exports.CanvasLayers = CanvasLayers;
CanvasLayers.defaultProps = {
  classes: {},
  layerMetadata: undefined
};