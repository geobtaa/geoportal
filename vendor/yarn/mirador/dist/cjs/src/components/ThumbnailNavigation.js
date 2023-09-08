"use strict";

Object.defineProperty(exports, "__esModule", {
  value: true
});
exports.ThumbnailNavigation = void 0;

var _react = _interopRequireWildcard(require("react"));

var _Paper = _interopRequireDefault(require("@material-ui/core/Paper"));

var _reactVirtualizedAutoSizer = _interopRequireDefault(require("react-virtualized-auto-sizer"));

var _reactWindow = require("react-window");

var _classnames = _interopRequireDefault(require("classnames"));

var _CanvasWorld = _interopRequireDefault(require("../lib/CanvasWorld"));

var _ThumbnailCanvasGrouping = _interopRequireDefault(require("../containers/ThumbnailCanvasGrouping"));

var _cssNs = _interopRequireDefault(require("../config/css-ns"));

var _jsxFileName = "/Users/pjreed/dev/mirador/dist/cjs/src/components/ThumbnailNavigation.js";

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
 */
var ThumbnailNavigation = /*#__PURE__*/function (_Component) {
  _inherits(ThumbnailNavigation, _Component);

  var _super = _createSuper(ThumbnailNavigation);

  /**
   */
  function ThumbnailNavigation(props) {
    var _this;

    _classCallCheck(this, ThumbnailNavigation);

    _this = _super.call(this, props);
    _this.scrollbarSize = 15;
    _this.spacing = 8; // 2 * (2px margin + 2px border + 2px padding + 2px padding)

    _this.calculateScaledSize = _this.calculateScaledSize.bind(_assertThisInitialized(_this));
    _this.itemCount = _this.itemCount.bind(_assertThisInitialized(_this));
    _this.handleKeyUp = _this.handleKeyUp.bind(_assertThisInitialized(_this));
    _this.nextCanvas = _this.nextCanvas.bind(_assertThisInitialized(_this));
    _this.previousCanvas = _this.previousCanvas.bind(_assertThisInitialized(_this));
    _this.gridRef = _react["default"].createRef();
    return _this;
  }
  /**
   * If the view has changed and the thumbnailNavigation is open, recompute all
   * of the grids
   */


  _createClass(ThumbnailNavigation, [{
    key: "componentDidUpdate",
    value: function componentDidUpdate(prevProps) {
      var _this$props = this.props,
          canvasIndex = _this$props.canvasIndex,
          position = _this$props.position,
          view = _this$props.view;

      if (prevProps.view !== view && position !== 'off') {
        this.gridRef.current.resetAfterIndex(0);
      }

      if (prevProps.canvasIndex !== canvasIndex) {
        var index = canvasIndex;
        if (view === 'book') index = Math.ceil(index / 2);
        this.gridRef.current.scrollToItem(index, 'center');
      }
    }
    /**
     * When on right, row height
     * When on bottom, column width
     */

  }, {
    key: "calculateScaledSize",
    value: function calculateScaledSize(index) {
      var _this$props2 = this.props,
          config = _this$props2.config,
          canvasGroupings = _this$props2.canvasGroupings,
          position = _this$props2.position;
      var canvases = canvasGroupings.groupings()[index];
      var world = new _CanvasWorld["default"](canvases);
      var bounds = world.worldBounds();

      switch (position) {
        case 'far-right':
          {
            var calc = Math.floor(this.calculatingWidth(canvases.length) * bounds[3] / bounds[2]);
            if (!Number.isInteger(calc)) return config.thumbnailNavigation.width + this.spacing;
            return calc + this.spacing;
          }
        // Default case bottom

        default:
          {
            var _calc = Math.ceil((config.thumbnailNavigation.height - this.scrollbarSize - this.spacing - 4) * bounds[2] / bounds[3]);

            return _calc;
          }
      }
    }
    /** */

  }, {
    key: "calculatingWidth",
    value: function calculatingWidth(canvasesLength) {
      var config = this.props.config;

      if (canvasesLength === 1) {
        return config.thumbnailNavigation.width;
      }

      return config.thumbnailNavigation.width * 2;
    }
    /** */

  }, {
    key: "rightWidth",
    value: function rightWidth() {
      var _this$props3 = this.props,
          view = _this$props3.view,
          config = _this$props3.config;

      switch (view) {
        case 'book':
          return config.thumbnailNavigation.width * 2;

        default:
          return config.thumbnailNavigation.width;
      }
    }
    /** */

  }, {
    key: "style",
    value: function style() {
      var _this$props4 = this.props,
          position = _this$props4.position,
          config = _this$props4.config;

      switch (position) {
        case 'far-right':
          return {
            height: '100%',
            minHeight: 0,
            width: "".concat(this.rightWidth() + this.scrollbarSize + this.spacing, "px")
          };
        // Default case bottom

        default:
          return {
            height: "".concat(config.thumbnailNavigation.height, "px"),
            width: '100%'
          };
      }
    }
    /** */

  }, {
    key: "areaHeight",
    value: function areaHeight(height) {
      var _this$props5 = this.props,
          config = _this$props5.config,
          position = _this$props5.position;

      switch (position) {
        case 'far-right':
          return height;
        // Default case bottom

        default:
          return config.thumbnailNavigation.height;
      }
    }
    /** */

  }, {
    key: "itemCount",
    value: function itemCount() {
      var canvasGroupings = this.props.canvasGroupings;
      return canvasGroupings.groupings().length;
    }
    /** */

  }, {
    key: "handleKeyUp",
    value: function handleKeyUp(e) {
      var position = this.props.position;
      var nextKey = 'ArrowRight';
      var previousKey = 'ArrowLeft';

      if (position === 'far-right') {
        nextKey = 'ArrowDown';
        previousKey = 'ArrowUp';
      }

      switch (e.key) {
        case nextKey:
          this.nextCanvas();
          break;

        case previousKey:
          this.previousCanvas();
          break;

        default:
          break;
      }
    }
    /**
     */

  }, {
    key: "nextCanvas",
    value: function nextCanvas() {
      var _this$props6 = this.props,
          hasNextCanvas = _this$props6.hasNextCanvas,
          setNextCanvas = _this$props6.setNextCanvas;

      if (hasNextCanvas) {
        setNextCanvas();
      }
    }
    /**
     */

  }, {
    key: "previousCanvas",
    value: function previousCanvas() {
      var _this$props7 = this.props,
          hasPreviousCanvas = _this$props7.hasPreviousCanvas,
          setPreviousCanvas = _this$props7.setPreviousCanvas;

      if (hasPreviousCanvas) {
        setPreviousCanvas();
      }
    }
    /**
     * Renders things
     */

  }, {
    key: "render",
    value: function render() {
      var _this2 = this;

      var _this$props8 = this.props,
          t = _this$props8.t,
          canvasGroupings = _this$props8.canvasGroupings,
          classes = _this$props8.classes,
          config = _this$props8.config,
          position = _this$props8.position,
          viewingDirection = _this$props8.viewingDirection,
          windowId = _this$props8.windowId;

      if (position === 'off') {
        return /*#__PURE__*/_react["default"].createElement(_react["default"].Fragment, null);
      }

      var htmlDir = viewingDirection === 'right-to-left' ? 'rtl' : 'ltr';
      return /*#__PURE__*/_react["default"].createElement(_Paper["default"], {
        className: (0, _classnames["default"])((0, _cssNs["default"])('thumb-navigation'), classes.thumbNavigation),
        "aria-label": t('thumbnailNavigation'),
        square: true,
        elevation: 0,
        style: this.style(),
        tabIndex: 0,
        onKeyUp: this.handleKeyUp,
        role: "grid",
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 187,
          columnNumber: 7
        }
      }, /*#__PURE__*/_react["default"].createElement(_reactVirtualizedAutoSizer["default"], {
        defaultHeight: 100,
        defaultWidth: 400,
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 200,
          columnNumber: 9
        }
      }, function (_ref) {
        var height = _ref.height,
            width = _ref.width;
        return /*#__PURE__*/_react["default"].createElement(_reactWindow.VariableSizeList, {
          direction: htmlDir,
          height: _this2.areaHeight(height),
          itemCount: _this2.itemCount(),
          itemSize: _this2.calculateScaledSize,
          width: width,
          layout: position === 'far-bottom' ? 'horizontal' : 'vertical',
          itemData: {
            canvasGroupings: canvasGroupings,
            config: config,
            height: config.thumbnailNavigation.height - _this2.spacing - _this2.scrollbarSize,
            position: position,
            windowId: windowId
          },
          ref: _this2.gridRef,
          __self: _this2,
          __source: {
            fileName: _jsxFileName,
            lineNumber: 205,
            columnNumber: 13
          }
        }, _ThumbnailCanvasGrouping["default"]);
      }));
    }
  }]);

  return ThumbnailNavigation;
}(_react.Component);

exports.ThumbnailNavigation = ThumbnailNavigation;
ThumbnailNavigation.defaultProps = {
  hasNextCanvas: false,
  hasPreviousCanvas: false,
  setNextCanvas: function setNextCanvas() {},
  setPreviousCanvas: function setPreviousCanvas() {},
  view: undefined,
  viewingDirection: ''
};