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

var _CanvasGroupings = _interopRequireDefault(require("../lib/CanvasGroupings"));

var actions = _interopRequireWildcard(require("../state/actions"));

var _ThumbnailNavigation = require("../components/ThumbnailNavigation");

var _selectors = require("../state/selectors");

function _getRequireWildcardCache() { if (typeof WeakMap !== "function") return null; var cache = new WeakMap(); _getRequireWildcardCache = function _getRequireWildcardCache() { return cache; }; return cache; }

function _interopRequireWildcard(obj) { if (obj && obj.__esModule) { return obj; } if (obj === null || typeof obj !== "object" && typeof obj !== "function") { return { "default": obj }; } var cache = _getRequireWildcardCache(); if (cache && cache.has(obj)) { return cache.get(obj); } var newObj = {}; var hasPropertyDescriptor = Object.defineProperty && Object.getOwnPropertyDescriptor; for (var key in obj) { if (Object.prototype.hasOwnProperty.call(obj, key)) { var desc = hasPropertyDescriptor ? Object.getOwnPropertyDescriptor(obj, key) : null; if (desc && (desc.get || desc.set)) { Object.defineProperty(newObj, key, desc); } else { newObj[key] = obj[key]; } } } newObj["default"] = obj; if (cache) { cache.set(obj, newObj); } return newObj; }

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { "default": obj }; }

/**
 * mapStateToProps - used to hook up state to props
 * @memberof ThumbnailNavigation
 * @private
 */
var mapStateToProps = function mapStateToProps(state, _ref) {
  var windowId = _ref.windowId;
  var viewType = (0, _selectors.getWindowViewType)(state, {
    windowId: windowId
  });
  return {
    canvasGroupings: new _CanvasGroupings["default"]((0, _selectors.getManifestCanvases)(state, {
      windowId: windowId
    }), viewType),
    canvasIndex: (0, _selectors.getCanvasIndex)(state, {
      windowId: windowId
    }),
    config: state.config,
    hasNextCanvas: !!(0, _selectors.getNextCanvasGrouping)(state, {
      windowId: windowId
    }),
    hasPreviousCanvas: !!(0, _selectors.getPreviousCanvasGrouping)(state, {
      windowId: windowId
    }),
    position: state.companionWindows[state.windows[windowId].thumbnailNavigationId].position,
    view: viewType,
    viewingDirection: (0, _selectors.getManifestViewingDirection)(state, {
      windowId: windowId
    })
  };
};
/**
 * mapDispatchToProps - used to hook up connect to action creators
 * @memberof ThumbnailNavigation
 * @private
 */


var mapDispatchToProps = function mapDispatchToProps(dispatch, _ref2) {
  var windowId = _ref2.windowId;
  return {
    setNextCanvas: function setNextCanvas() {
      return dispatch(actions.setNextCanvas(windowId));
    },
    setPreviousCanvas: function setPreviousCanvas() {
      return dispatch(actions.setPreviousCanvas(windowId));
    }
  };
};
/**
 * Styles for withStyles HOC
 */


var styles = function styles(theme) {
  return {
    thumbNavigation: {
      '&:focus': {
        boxShadow: 0,
        outline: 0
      }
    }
  };
};

var enhance = (0, _redux.compose)((0, _styles.withStyles)(styles), (0, _reactI18next.withTranslation)(), (0, _reactRedux.connect)(mapStateToProps, mapDispatchToProps), (0, _withPlugins.withPlugins)('ThumbnailNavigation'));

var _default = enhance(_ThumbnailNavigation.ThumbnailNavigation);

exports["default"] = _default;