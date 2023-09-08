"use strict";

Object.defineProperty(exports, "__esModule", {
  value: true
});
exports.WindowViewer = void 0;

var _react = _interopRequireWildcard(require("react"));

var _flatten = _interopRequireDefault(require("lodash/flatten"));

var _OpenSeadragonViewer = _interopRequireDefault(require("../containers/OpenSeadragonViewer"));

var _WindowCanvasNavigationControls = _interopRequireDefault(require("../containers/WindowCanvasNavigationControls"));

var _ManifestoCanvas = _interopRequireDefault(require("../lib/ManifestoCanvas"));

var _jsxFileName = "/Users/pjreed/dev/mirador/dist/cjs/src/components/WindowViewer.js";

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
 * Represents a WindowViewer in the mirador workspace. Responsible for mounting
 * OSD and Navigation
 */
var WindowViewer = /*#__PURE__*/function (_Component) {
  _inherits(WindowViewer, _Component);

  var _super = _createSuper(WindowViewer);

  /** */
  function WindowViewer(props) {
    var _this;

    _classCallCheck(this, WindowViewer);

    _this = _super.call(this, props);
    _this.state = {};
    return _this;
  }
  /** */


  _createClass(WindowViewer, [{
    key: "componentDidMount",

    /**
     * componentDidMount - React lifecycle method
     * Request the initial canvas on mount
     */
    value: function componentDidMount() {
      var _this$props = this.props,
          currentCanvases = _this$props.currentCanvases,
          fetchInfoResponse = _this$props.fetchInfoResponse,
          fetchAnnotation = _this$props.fetchAnnotation,
          receiveAnnotation = _this$props.receiveAnnotation;

      if (!this.infoResponseIsInStore()) {
        currentCanvases.forEach(function (canvas) {
          var manifestoCanvas = new _ManifestoCanvas["default"](canvas);
          manifestoCanvas.imageResources.forEach(function (imageResource) {
            fetchInfoResponse({
              imageResource: imageResource
            });
          });
          manifestoCanvas.processAnnotations(fetchAnnotation, receiveAnnotation);
        });
      }
    }
    /**
     * componentDidUpdate - React lifecycle method
     * Request a new canvas if it is needed
     */

  }, {
    key: "componentDidUpdate",
    value: function componentDidUpdate(prevProps) {
      var _this$props2 = this.props,
          currentCanvasId = _this$props2.currentCanvasId,
          currentCanvases = _this$props2.currentCanvases,
          view = _this$props2.view,
          fetchInfoResponse = _this$props2.fetchInfoResponse,
          fetchAnnotation = _this$props2.fetchAnnotation,
          receiveAnnotation = _this$props2.receiveAnnotation;

      if (prevProps.view !== view || prevProps.currentCanvasId !== currentCanvasId && !this.infoResponseIsInStore()) {
        currentCanvases.forEach(function (canvas) {
          var manifestoCanvas = new _ManifestoCanvas["default"](canvas);
          manifestoCanvas.imageResources.forEach(function (imageResource) {
            fetchInfoResponse({
              imageResource: imageResource
            });
          });
          manifestoCanvas.processAnnotations(fetchAnnotation, receiveAnnotation);
        });
        currentCanvases.map(function (canvas) {
          return new _ManifestoCanvas["default"](canvas);
        }).map(function (manifestoCanvas) {
          return manifestoCanvas.annotationListUris.forEach(function (uri) {
            fetchAnnotation(manifestoCanvas.canvas.id, uri);
          });
        });
      }
    }
    /**
     * infoResponseIsInStore - checks whether or not an info response is already
     * in the store. No need to request it again.
     * @return [Boolean]
     */

  }, {
    key: "infoResponseIsInStore",
    value: function infoResponseIsInStore() {
      var responses = this.currentInfoResponses();

      if (responses.length === this.imageServiceIds().length) {
        return true;
      }

      return false;
    }
    /** */

  }, {
    key: "imageServiceIds",
    value: function imageServiceIds() {
      var currentCanvases = this.props.currentCanvases;
      return (0, _flatten["default"])(currentCanvases.map(function (canvas) {
        return new _ManifestoCanvas["default"](canvas).imageServiceIds;
      }));
    }
    /**
     * currentInfoResponses - Selects infoResponses that are relevent to existing
     * canvases to be displayed.
     */

  }, {
    key: "currentInfoResponses",
    value: function currentInfoResponses() {
      var infoResponses = this.props.infoResponses;
      return this.imageServiceIds().map(function (imageId) {
        return infoResponses[imageId];
      }).filter(function (infoResponse) {
        return infoResponse !== undefined && infoResponse.isFetching === false && infoResponse.error === undefined;
      });
    }
    /**
     * Return an image information response from the store for the correct image
     */

  }, {
    key: "infoResponsesFetchedFromStore",
    value: function infoResponsesFetchedFromStore() {
      var responses = this.currentInfoResponses(); // Only return actual tileSources when all current canvases have completed.

      if (responses.length === this.imageServiceIds().length) {
        return responses;
      }

      return [];
    }
    /**
     * Renders things
     */

  }, {
    key: "render",
    value: function render() {
      var windowId = this.props.windowId;
      var hasError = this.state.hasError;

      if (hasError) {
        return /*#__PURE__*/_react["default"].createElement(_react["default"].Fragment, null);
      }

      return /*#__PURE__*/_react["default"].createElement(_OpenSeadragonViewer["default"], {
        infoResponses: this.infoResponsesFetchedFromStore(),
        windowId: windowId,
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 131,
          columnNumber: 7
        }
      }, /*#__PURE__*/_react["default"].createElement(_WindowCanvasNavigationControls["default"], {
        key: "canvas_nav",
        windowId: windowId,
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 135,
          columnNumber: 9
        }
      }));
    }
  }], [{
    key: "getDerivedStateFromError",
    value: function getDerivedStateFromError(error) {
      // Update state so the next render will show the fallback UI.
      return {
        hasError: true
      };
    }
  }]);

  return WindowViewer;
}(_react.Component);

exports.WindowViewer = WindowViewer;