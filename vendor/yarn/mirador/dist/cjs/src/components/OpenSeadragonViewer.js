"use strict";

Object.defineProperty(exports, "__esModule", {
  value: true
});
exports.OpenSeadragonViewer = void 0;

var _react = _interopRequireWildcard(require("react"));

var _isEqual = _interopRequireDefault(require("lodash/isEqual"));

var _openseadragon = _interopRequireDefault(require("openseadragon"));

var _classnames = _interopRequireDefault(require("classnames"));

var _cssNs = _interopRequireDefault(require("../config/css-ns"));

var _OpenSeadragonCanvasOverlay = _interopRequireDefault(require("../lib/OpenSeadragonCanvasOverlay"));

var _CanvasWorld = _interopRequireDefault(require("../lib/CanvasWorld"));

var _CanvasAnnotationDisplay = _interopRequireDefault(require("../lib/CanvasAnnotationDisplay"));

var _jsxFileName = "/Users/pjreed/dev/mirador/dist/cjs/src/components/OpenSeadragonViewer.js";

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { "default": obj }; }

function _getRequireWildcardCache() { if (typeof WeakMap !== "function") return null; var cache = new WeakMap(); _getRequireWildcardCache = function _getRequireWildcardCache() { return cache; }; return cache; }

function _interopRequireWildcard(obj) { if (obj && obj.__esModule) { return obj; } if (obj === null || typeof obj !== "object" && typeof obj !== "function") { return { "default": obj }; } var cache = _getRequireWildcardCache(); if (cache && cache.has(obj)) { return cache.get(obj); } var newObj = {}; var hasPropertyDescriptor = Object.defineProperty && Object.getOwnPropertyDescriptor; for (var key in obj) { if (Object.prototype.hasOwnProperty.call(obj, key)) { var desc = hasPropertyDescriptor ? Object.getOwnPropertyDescriptor(obj, key) : null; if (desc && (desc.get || desc.set)) { Object.defineProperty(newObj, key, desc); } else { newObj[key] = obj[key]; } } } newObj["default"] = obj; if (cache) { cache.set(obj, newObj); } return newObj; }

function _construct(Parent, args, Class) { if (_isNativeReflectConstruct()) { _construct = Reflect.construct; } else { _construct = function _construct(Parent, args, Class) { var a = [null]; a.push.apply(a, args); var Constructor = Function.bind.apply(Parent, a); var instance = new Constructor(); if (Class) _setPrototypeOf(instance, Class.prototype); return instance; }; } return _construct.apply(null, arguments); }

function _toConsumableArray(arr) { return _arrayWithoutHoles(arr) || _iterableToArray(arr) || _unsupportedIterableToArray(arr) || _nonIterableSpread(); }

function _nonIterableSpread() { throw new TypeError("Invalid attempt to spread non-iterable instance.\nIn order to be iterable, non-array objects must have a [Symbol.iterator]() method."); }

function _unsupportedIterableToArray(o, minLen) { if (!o) return; if (typeof o === "string") return _arrayLikeToArray(o, minLen); var n = Object.prototype.toString.call(o).slice(8, -1); if (n === "Object" && o.constructor) n = o.constructor.name; if (n === "Map" || n === "Set") return Array.from(n); if (n === "Arguments" || /^(?:Ui|I)nt(?:8|16|32)(?:Clamped)?Array$/.test(n)) return _arrayLikeToArray(o, minLen); }

function _iterableToArray(iter) { if (typeof Symbol !== "undefined" && Symbol.iterator in Object(iter)) return Array.from(iter); }

function _arrayWithoutHoles(arr) { if (Array.isArray(arr)) return _arrayLikeToArray(arr); }

function _arrayLikeToArray(arr, len) { if (len == null || len > arr.length) len = arr.length; for (var i = 0, arr2 = new Array(len); i < len; i++) { arr2[i] = arr[i]; } return arr2; }

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

/**
 * Represents a OpenSeadragonViewer in the mirador workspace. Responsible for mounting
 * and rendering OSD.
 */
var OpenSeadragonViewer = /*#__PURE__*/function (_Component) {
  _inherits(OpenSeadragonViewer, _Component);

  var _super = _createSuper(OpenSeadragonViewer);

  _createClass(OpenSeadragonViewer, null, [{
    key: "annotationsMatch",

    /**
     * annotationsMatch - compares previous annotations to current to determine
     * whether to add a new updateCanvas method to draw annotations
     * @param  {Array} currentAnnotations
     * @param  {Array} prevAnnotations
     * @return {Boolean}
     */
    value: function annotationsMatch(currentAnnotations, prevAnnotations) {
      if (currentAnnotations.length === 0 && prevAnnotations.length === 0) return true;
      if (currentAnnotations.length !== prevAnnotations.length) return false;
      return currentAnnotations.every(function (annotation, index) {
        var newIds = annotation.resources.map(function (r) {
          return r.id;
        });
        var prevIds = prevAnnotations[index].resources.map(function (r) {
          return r.id;
        });
        if (newIds.length === 0 && prevIds.length === 0) return true;
        if (newIds.length !== prevIds.length) return false;

        if (annotation.id === prevAnnotations[index].id && (0, _isEqual["default"])(newIds, prevIds)) {
          return true;
        }

        return false;
      });
    }
    /**
     * @param {Object} props
     */

  }]);

  function OpenSeadragonViewer(props) {
    var _this;

    _classCallCheck(this, OpenSeadragonViewer);

    _this = _super.call(this, props);
    _this.viewer = null;
    _this.osdCanvasOverlay = null; // An initial value for the updateCanvas method

    _this.updateCanvas = function () {};

    _this.ref = _react["default"].createRef();
    _this.onUpdateViewport = _this.onUpdateViewport.bind(_assertThisInitialized(_this));
    _this.onViewportChange = _this.onViewportChange.bind(_assertThisInitialized(_this));
    _this.zoomToWorld = _this.zoomToWorld.bind(_assertThisInitialized(_this));
    _this.osdUpdating = false;
    return _this;
  }
  /**
   * React lifecycle event
   */


  _createClass(OpenSeadragonViewer, [{
    key: "componentDidMount",
    value: function componentDidMount() {
      var _this2 = this;

      var _this$props = this.props,
          osdConfig = _this$props.osdConfig,
          viewer = _this$props.viewer;

      if (!this.ref.current) {
        return;
      }

      this.viewer = new _openseadragon["default"](_objectSpread({
        id: this.ref.current.id
      }, osdConfig));
      this.osdCanvasOverlay = new _OpenSeadragonCanvasOverlay["default"](this.viewer);
      this.viewer.addHandler('update-viewport', this.onUpdateViewport); // Set a flag when OSD starts animating (so that viewer updates are not used)

      this.viewer.addHandler('animation-start', function () {
        _this2.osdUpdating = true;
      });
      this.viewer.addHandler('animation-finish', this.onViewportChange);
      this.viewer.addHandler('animation-finish', function () {
        _this2.osdUpdating = false;
      });
      this.updateCanvas = this.canvasUpdateCallback();

      if (viewer) {
        this.viewer.viewport.panTo(viewer, true);
        this.viewer.viewport.zoomTo(viewer.zoom, viewer, true);
      }

      this.addAllImageSources();
    }
    /**
     * When the tileSources change, make sure to close the OSD viewer.
     * When the annotations change, reset the updateCanvas method to make sure
     * they are added.
     * When the viewport state changes, pan or zoom the OSD viewer as appropriate
     */

  }, {
    key: "componentDidUpdate",
    value: function componentDidUpdate(prevProps) {
      var _this$props2 = this.props,
          viewer = _this$props2.viewer,
          canvasWorld = _this$props2.canvasWorld,
          highlightedAnnotations = _this$props2.highlightedAnnotations,
          selectedAnnotations = _this$props2.selectedAnnotations,
          searchAnnotations = _this$props2.searchAnnotations,
          selectedContentSearchAnnotations = _this$props2.selectedContentSearchAnnotations;
      var highlightsUpdated = !OpenSeadragonViewer.annotationsMatch(highlightedAnnotations, prevProps.highlightedAnnotations);
      var selectionsUpdated = !OpenSeadragonViewer.annotationsMatch(selectedAnnotations, prevProps.selectedAnnotations);
      var searchAnnotationsUpdated = !OpenSeadragonViewer.annotationsMatch(searchAnnotations, prevProps.searchAnnotations);
      var selectedContentSearchAnnotationsUpdated = !OpenSeadragonViewer.annotationsMatch(selectedContentSearchAnnotations, prevProps.selectedContentSearchAnnotations);

      if (searchAnnotationsUpdated || selectedContentSearchAnnotationsUpdated || highlightsUpdated || selectionsUpdated) {
        this.updateCanvas = this.canvasUpdateCallback();
        this.viewer.forceRedraw();
      }

      if (!this.infoResponsesMatch(prevProps.infoResponses) || !this.nonTiledImagedMatch(prevProps.nonTiledImages)) {
        this.viewer.close();
        this.addAllImageSources();
      } else if (!(0, _isEqual["default"])(canvasWorld.layers, prevProps.canvasWorld.layers)) {
        this.refreshTileProperties();
      } else if (viewer && !this.osdUpdating) {
        var viewport = this.viewer.viewport;

        if (viewer.x !== viewport.centerSpringX.target.value || viewer.y !== viewport.centerSpringY.target.value) {
          this.viewer.viewport.panTo(viewer, false);
        }

        if (viewer.zoom !== viewport.zoomSpring.target.value) {
          this.viewer.viewport.zoomTo(viewer.zoom, viewer, false);
        }
      }
    }
    /**
     */

  }, {
    key: "componentWillUnmount",
    value: function componentWillUnmount() {
      this.viewer.removeAllHandlers();
    }
    /**
     * onUpdateViewport - fires during OpenSeadragon render method.
     */

  }, {
    key: "onUpdateViewport",
    value: function onUpdateViewport(event) {
      this.updateCanvas();
    }
    /**
     * Forward OSD state to redux
     */

  }, {
    key: "onViewportChange",
    value: function onViewportChange(event) {
      var _this$props3 = this.props,
          updateViewport = _this$props3.updateViewport,
          windowId = _this$props3.windowId;
      var viewport = event.eventSource.viewport;
      updateViewport(windowId, {
        x: Math.round(viewport.centerSpringX.target.value),
        y: Math.round(viewport.centerSpringY.target.value),
        zoom: viewport.zoomSpring.target.value
      });
    }
    /** */

  }, {
    key: "canvasUpdateCallback",
    value: function canvasUpdateCallback() {
      var _this3 = this;

      return function () {
        _this3.osdCanvasOverlay.clear();

        _this3.osdCanvasOverlay.resize();

        _this3.osdCanvasOverlay.canvasUpdate(_this3.renderAnnotations.bind(_this3));
      };
    }
    /**
     * annotationsToContext - converts anontations to a canvas context
     */

  }, {
    key: "annotationsToContext",
    value: function annotationsToContext(annotations) {
      var color = arguments.length > 1 && arguments[1] !== undefined ? arguments[1] : 'yellow';
      var canvasWorld = this.props.canvasWorld;
      var context = this.osdCanvasOverlay.context2d;
      var zoom = this.viewer.viewport.getZoom(true);
      var width = canvasWorld.worldBounds()[2];
      annotations.forEach(function (annotation) {
        annotation.resources.forEach(function (resource) {
          if (!canvasWorld.canvasIds.includes(resource.targetId)) return;
          var offset = canvasWorld.offsetByCanvas(resource.targetId);
          var canvasAnnotationDisplay = new _CanvasAnnotationDisplay["default"]({
            color: color,
            offset: offset,
            resource: resource,
            width: width,
            zoom: zoom
          });
          canvasAnnotationDisplay.toContext(context);
        });
      });
    }
    /** */

  }, {
    key: "addAllImageSources",
    value: function addAllImageSources() {
      var _this4 = this;

      var _this$props4 = this.props,
          nonTiledImages = _this$props4.nonTiledImages,
          infoResponses = _this$props4.infoResponses;
      Promise.all(infoResponses.map(function (infoResponse) {
        return _this4.addTileSource(infoResponse);
      }), nonTiledImages.map(function (image) {
        return _this4.addNonTiledImage(image);
      })).then(function () {
        if (infoResponses[0] || nonTiledImages[0]) {
          _this4.zoomToWorld();

          _this4.refreshTileProperties();
        }
      });
    }
    /** */

  }, {
    key: "addNonTiledImage",
    value: function addNonTiledImage(contentResource) {
      var _this5 = this;

      var canvasWorld = this.props.canvasWorld;
      return new Promise(function (resolve, reject) {
        if (!_this5.viewer) {
          return;
        }

        _this5.viewer.addSimpleImage({
          error: function error(event) {
            return reject(event);
          },
          fitBounds: _construct(_openseadragon["default"].Rect, _toConsumableArray(canvasWorld.contentResourceToWorldCoordinates(contentResource))),
          index: canvasWorld.layerIndexOfImageResource(contentResource),
          opacity: canvasWorld.layerOpacityOfImageResource(contentResource),
          success: function success(event) {
            return resolve(event);
          },
          url: contentResource.id
        });
      });
    }
    /**
     */

  }, {
    key: "addTileSource",
    value: function addTileSource(infoResponse) {
      var _this6 = this;

      var canvasWorld = this.props.canvasWorld;
      return new Promise(function (resolve, reject) {
        if (!_this6.viewer) {
          return;
        }

        var tileSource = infoResponse.json;
        var contentResource = canvasWorld.contentResource(infoResponse.id);
        if (!contentResource) return;

        _this6.viewer.addTiledImage({
          error: function error(event) {
            return reject(event);
          },
          fitBounds: _construct(_openseadragon["default"].Rect, _toConsumableArray(canvasWorld.contentResourceToWorldCoordinates(contentResource))),
          index: canvasWorld.layerIndexOfImageResource(contentResource),
          opacity: canvasWorld.layerOpacityOfImageResource(contentResource),
          success: function success(event) {
            return resolve(event);
          },
          tileSource: tileSource
        });
      });
    }
    /** */

  }, {
    key: "refreshTileProperties",
    value: function refreshTileProperties() {
      var canvasWorld = this.props.canvasWorld;
      var world = this.viewer.world;
      var items = [];

      for (var i = 0; i < world.getItemCount(); i += 1) {
        items.push(world.getItemAt(i));
      }

      items.forEach(function (item, i) {
        var contentResource = canvasWorld.contentResource(item.source['@id'] || item.source.id);
        var newIndex = canvasWorld.layerIndexOfImageResource(contentResource);
        if (i !== newIndex) world.setItemIndex(item, newIndex);
        item.setOpacity(canvasWorld.layerOpacityOfImageResource(contentResource));
      });
    }
    /**
     */

  }, {
    key: "fitBounds",
    value: function fitBounds(x, y, w, h) {
      var immediately = arguments.length > 4 && arguments[4] !== undefined ? arguments[4] : true;
      this.viewer.viewport.fitBounds(new _openseadragon["default"].Rect(x, y, w, h), immediately);
    }
    /**
     * infoResponsesMatch - compares previous tileSources to current to determine
     * whether a refresh of the OSD viewer is needed.
     * @param  {Array} prevTileSources
     * @return {Boolean}
     */

  }, {
    key: "infoResponsesMatch",
    value: function infoResponsesMatch(prevInfoResponses) {
      var infoResponses = this.props.infoResponses;
      if (infoResponses.length === 0 && prevInfoResponses.length === 0) return true;
      return infoResponses.some(function (infoResponse, index) {
        if (!prevInfoResponses[index]) {
          return false;
        }

        if (!infoResponse.json) {
          return false;
        }

        if (infoResponse.json['@id'] === (prevInfoResponses[index].json || {})['@id']) {
          return true;
        }

        return false;
      });
    }
    /**
     * nonTiledImagedMatch - compares previous images to current to determin
     * whether a refresh of the OSD viewer is needed
     */

  }, {
    key: "nonTiledImagedMatch",
    value: function nonTiledImagedMatch(prevNonTiledImages) {
      var nonTiledImages = this.props.nonTiledImages;
      if (nonTiledImages.length === 0 && prevNonTiledImages.length === 0) return true;
      return nonTiledImages.some(function (image, index) {
        if (!prevNonTiledImages[index]) {
          return false;
        }

        if (image.id === prevNonTiledImages[index].id) {
          return true;
        }

        return false;
      });
    }
    /**
     * zoomToWorld - zooms the viewer to the extent of the canvas world
     */

  }, {
    key: "zoomToWorld",
    value: function zoomToWorld() {
      var immediately = arguments.length > 0 && arguments[0] !== undefined ? arguments[0] : true;
      var canvasWorld = this.props.canvasWorld;
      this.fitBounds.apply(this, _toConsumableArray(canvasWorld.worldBounds()).concat([immediately]));
    }
    /** */

  }, {
    key: "renderAnnotations",
    value: function renderAnnotations() {
      var _this$props5 = this.props,
          searchAnnotations = _this$props5.searchAnnotations,
          selectedContentSearchAnnotations = _this$props5.selectedContentSearchAnnotations,
          highlightedAnnotations = _this$props5.highlightedAnnotations,
          selectedAnnotations = _this$props5.selectedAnnotations,
          palette = _this$props5.palette;
      this.annotationsToContext(searchAnnotations, palette.highlights.secondary);
      this.annotationsToContext(selectedContentSearchAnnotations, palette.highlights.primary);
      this.annotationsToContext(highlightedAnnotations, palette.highlights.secondary);
      this.annotationsToContext(selectedAnnotations, palette.highlights.primary);
    }
    /**
     * Renders things
     */

  }, {
    key: "render",
    value: function render() {
      var _this7 = this;

      var _this$props6 = this.props,
          children = _this$props6.children,
          classes = _this$props6.classes,
          label = _this$props6.label,
          t = _this$props6.t,
          windowId = _this$props6.windowId;

      var enhancedChildren = _react["default"].Children.map(children, function (child) {
        return _react["default"].cloneElement(child, {
          zoomToWorld: _this7.zoomToWorld
        });
      });

      return /*#__PURE__*/_react["default"].createElement(_react["default"].Fragment, null, /*#__PURE__*/_react["default"].createElement("section", {
        className: (0, _classnames["default"])((0, _cssNs["default"])('osd-container'), classes.osdContainer),
        id: "".concat(windowId, "-osd"),
        ref: this.ref,
        "aria-label": t('item', {
          label: label
        }),
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 386,
          columnNumber: 9
        }
      }, enhancedChildren));
    }
  }]);

  return OpenSeadragonViewer;
}(_react.Component);

exports.OpenSeadragonViewer = OpenSeadragonViewer;
OpenSeadragonViewer.defaultProps = {
  children: null,
  highlightedAnnotations: [],
  infoResponses: [],
  label: null,
  nonTiledImages: [],
  osdConfig: {},
  palette: {},
  searchAnnotations: [],
  selectedAnnotations: [],
  selectedContentSearchAnnotations: [],
  viewer: null
};