"use strict";

Object.defineProperty(exports, "__esModule", {
  value: true
});
exports["default"] = void 0;

var _redux = require("redux");

var _reactRedux = require("react-redux");

var _flatten = _interopRequireDefault(require("lodash/flatten"));

var _styles = require("@material-ui/core/styles");

var actions = _interopRequireWildcard(require("../state/actions"));

var _GalleryViewThumbnail = require("../components/GalleryViewThumbnail");

var _selectors = require("../state/selectors");

function _getRequireWildcardCache() { if (typeof WeakMap !== "function") return null; var cache = new WeakMap(); _getRequireWildcardCache = function _getRequireWildcardCache() { return cache; }; return cache; }

function _interopRequireWildcard(obj) { if (obj && obj.__esModule) { return obj; } if (obj === null || typeof obj !== "object" && typeof obj !== "function") { return { "default": obj }; } var cache = _getRequireWildcardCache(); if (cache && cache.has(obj)) { return cache.get(obj); } var newObj = {}; var hasPropertyDescriptor = Object.defineProperty && Object.getOwnPropertyDescriptor; for (var key in obj) { if (Object.prototype.hasOwnProperty.call(obj, key)) { var desc = hasPropertyDescriptor ? Object.getOwnPropertyDescriptor(obj, key) : null; if (desc && (desc.get || desc.set)) { Object.defineProperty(newObj, key, desc); } else { newObj[key] = obj[key]; } } } newObj["default"] = obj; if (cache) { cache.set(obj, newObj); } return newObj; }

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { "default": obj }; }

function ownKeys(object, enumerableOnly) { var keys = Object.keys(object); if (Object.getOwnPropertySymbols) { var symbols = Object.getOwnPropertySymbols(object); if (enumerableOnly) symbols = symbols.filter(function (sym) { return Object.getOwnPropertyDescriptor(object, sym).enumerable; }); keys.push.apply(keys, symbols); } return keys; }

function _objectSpread(target) { for (var i = 1; i < arguments.length; i++) { var source = arguments[i] != null ? arguments[i] : {}; if (i % 2) { ownKeys(Object(source), true).forEach(function (key) { _defineProperty(target, key, source[key]); }); } else if (Object.getOwnPropertyDescriptors) { Object.defineProperties(target, Object.getOwnPropertyDescriptors(source)); } else { ownKeys(Object(source)).forEach(function (key) { Object.defineProperty(target, key, Object.getOwnPropertyDescriptor(source, key)); }); } } return target; }

function _defineProperty(obj, key, value) { if (key in obj) { Object.defineProperty(obj, key, { value: value, enumerable: true, configurable: true, writable: true }); } else { obj[key] = value; } return obj; }

/**
 * Styles to be passed to the withStyles HOC
 */
var styles = function styles(theme) {
  return {
    avatar: {
      backgroundColor: theme.palette.hitCounter["default"]
    },
    chip: _objectSpread({}, theme.typography.caption, {
      '&$selected $avatar': {
        backgroundColor: theme.palette.highlights.primary
      },
      left: '50%',
      position: 'absolute',
      top: 80,
      transform: 'translate(-50%, 0)'
    }),
    galleryViewCaption: {
      boxOrient: 'vertical',
      display: '-webkit-box',
      height: '3em',
      lineClamp: '2',
      lineHeight: '1.5em',
      overflow: 'hidden',
      textOverflow: 'ellipsis',
      wordBreak: 'break-word'
    },
    galleryViewItem: {
      '&$hasAnnotations': {
        border: "2px solid ".concat(theme.palette.action.selected)
      },
      '&$selected,&$selected$hasAnnotations': {
        border: "2px solid ".concat(theme.palette.primary.main)
      },
      '&:focus': {
        outline: 'none'
      },
      '&:hover': {
        backgroundColor: theme.palette.action.hover
      },
      border: '2px solid transparent',
      cursor: 'pointer',
      display: 'inline-block',
      height: function height(props) {
        return props.config.height + 45;
      },
      margin: "".concat(theme.spacing(1), "px ").concat(theme.spacing(0.5), "px"),
      minWidth: '60px',
      overflow: 'hidden',
      padding: theme.spacing(0.5),
      position: 'relative',
      width: 'min-content'
    },
    hasAnnotations: {},
    selected: {}
  };
};
/** */


var mapStateToProps = function mapStateToProps(state, _ref) {
  var canvas = _ref.canvas,
      windowId = _ref.windowId;
  var currentCanvas = (0, _selectors.getCurrentCanvas)(state, {
    windowId: windowId
  });
  var selectedAnnotations = (0, _selectors.getSelectedContentSearchAnnotations)(state, {
    windowId: windowId
  });
  var annotationResources = (0, _flatten["default"])(selectedAnnotations.map(function (a) {
    return a.resources;
  }));
  var selectedAnnotationCanvases = annotationResources.map(function (a) {
    return a.targetId;
  });
  var searchAnnotations = (0, _selectors.getSearchAnnotationsForWindow)(state, {
    windowId: windowId
  });
  return {
    annotationsCount: (0, _flatten["default"])(searchAnnotations.map(function (a) {
      return a.resources;
    })).filter(function (a) {
      return a.targetId === canvas.id;
    }).length,
    annotationSelected: selectedAnnotationCanvases.includes(canvas.id),
    config: state.config.galleryView,
    selected: currentCanvas && currentCanvas.id === canvas.id
  };
};
/**
 * mapDispatchToProps - used to hook up connect to action creators
 * @memberof WindowViewer
 * @private
 */


var mapDispatchToProps = function mapDispatchToProps(dispatch, _ref2) {
  var id = _ref2.id,
      windowId = _ref2.windowId;
  return {
    focusOnCanvas: function focusOnCanvas() {
      return dispatch(actions.setWindowViewType(windowId, 'single'));
    },
    setCanvas: function setCanvas() {
      for (var _len = arguments.length, args = new Array(_len), _key = 0; _key < _len; _key++) {
        args[_key] = arguments[_key];
      }

      return dispatch(actions.setCanvas.apply(actions, [windowId].concat(args)));
    }
  };
};

var enhance = (0, _redux.compose)((0, _reactRedux.connect)(mapStateToProps, mapDispatchToProps), (0, _styles.withStyles)(styles) // further HOC go here
);

var _default = enhance(_GalleryViewThumbnail.GalleryViewThumbnail);

exports["default"] = _default;