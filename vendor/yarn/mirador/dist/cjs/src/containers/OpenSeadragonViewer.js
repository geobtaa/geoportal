"use strict";

Object.defineProperty(exports, "__esModule", {
  value: true
});
exports["default"] = void 0;

var _redux = require("redux");

var _reactRedux = require("react-redux");

var _reactI18next = require("react-i18next");

var _styles = require("@material-ui/core/styles");

var _withPlugins = require("../extend/withPlugins");

var _OpenSeadragonViewer = require("../components/OpenSeadragonViewer");

var actions = _interopRequireWildcard(require("../state/actions"));

var _CanvasWorld = _interopRequireDefault(require("../lib/CanvasWorld"));

var _selectors = require("../state/selectors");

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { "default": obj }; }

function _getRequireWildcardCache() { if (typeof WeakMap !== "function") return null; var cache = new WeakMap(); _getRequireWildcardCache = function _getRequireWildcardCache() { return cache; }; return cache; }

function _interopRequireWildcard(obj) { if (obj && obj.__esModule) { return obj; } if (obj === null || typeof obj !== "object" && typeof obj !== "function") { return { "default": obj }; } var cache = _getRequireWildcardCache(); if (cache && cache.has(obj)) { return cache.get(obj); } var newObj = {}; var hasPropertyDescriptor = Object.defineProperty && Object.getOwnPropertyDescriptor; for (var key in obj) { if (Object.prototype.hasOwnProperty.call(obj, key)) { var desc = hasPropertyDescriptor ? Object.getOwnPropertyDescriptor(obj, key) : null; if (desc && (desc.get || desc.set)) { Object.defineProperty(newObj, key, desc); } else { newObj[key] = obj[key]; } } } newObj["default"] = obj; if (cache) { cache.set(obj, newObj); } return newObj; }

/**
 * mapStateToProps - used to hook up connect to action creators
 * @memberof Window
 * @private
 */
var mapStateToProps = function mapStateToProps(state, _ref) {
  var companionWindowId = _ref.companionWindowId,
      windowId = _ref.windowId;
  return {
    canvasWorld: new _CanvasWorld["default"]((0, _selectors.getVisibleCanvases)(state, {
      windowId: windowId
    }), (0, _selectors.getLayersForVisibleCanvases)(state, {
      windowId: windowId
    }), (0, _selectors.getManifestViewingDirection)(state, {
      windowId: windowId
    })),
    highlightedAnnotations: (0, _selectors.getHighlightedAnnotationsOnCanvases)(state, {
      windowId: windowId
    }),
    label: (0, _selectors.getCanvasLabel)(state, {
      canvasId: ((0, _selectors.getCurrentCanvas)(state, {
        windowId: windowId
      }) || {}).id,
      windowId: windowId
    }),
    nonTiledImages: (0, _selectors.getVisibleCanvasNonTiledResources)(state, {
      windowId: windowId
    }),
    osdConfig: state.config.osdConfig,
    palette: (0, _selectors.getTheme)(state).palette,
    searchAnnotations: (0, _selectors.getSearchAnnotationsForWindow)(state, {
      windowId: windowId
    }),
    selectedAnnotations: (0, _selectors.getSelectedAnnotationsOnCanvases)(state, {
      windowId: windowId
    }),
    selectedContentSearchAnnotations: (0, _selectors.getSelectedContentSearchAnnotations)(state, {
      windowId: windowId
    }),
    viewer: (0, _selectors.getViewer)(state, {
      windowId: windowId
    })
  };
};
/**
 * mapDispatchToProps - used to hook up connect to action creators
 * @memberof ManifestListItem
 * @private
 */


var mapDispatchToProps = {
  updateViewport: actions.updateViewport
};
var styles = {
  osdContainer: {
    flex: 1,
    position: 'relative'
  }
};
var enhance = (0, _redux.compose)((0, _styles.withStyles)(styles), (0, _reactI18next.withTranslation)(), (0, _reactRedux.connect)(mapStateToProps, mapDispatchToProps), (0, _withPlugins.withPlugins)('OpenSeadragonViewer'));

var _default = enhance(_OpenSeadragonViewer.OpenSeadragonViewer);

exports["default"] = _default;