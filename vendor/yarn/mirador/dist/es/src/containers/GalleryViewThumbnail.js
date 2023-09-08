function ownKeys(object, enumerableOnly) { var keys = Object.keys(object); if (Object.getOwnPropertySymbols) { var symbols = Object.getOwnPropertySymbols(object); if (enumerableOnly) symbols = symbols.filter(function (sym) { return Object.getOwnPropertyDescriptor(object, sym).enumerable; }); keys.push.apply(keys, symbols); } return keys; }

function _objectSpread(target) { for (var i = 1; i < arguments.length; i++) { var source = arguments[i] != null ? arguments[i] : {}; if (i % 2) { ownKeys(Object(source), true).forEach(function (key) { _defineProperty(target, key, source[key]); }); } else if (Object.getOwnPropertyDescriptors) { Object.defineProperties(target, Object.getOwnPropertyDescriptors(source)); } else { ownKeys(Object(source)).forEach(function (key) { Object.defineProperty(target, key, Object.getOwnPropertyDescriptor(source, key)); }); } } return target; }

function _defineProperty(obj, key, value) { if (key in obj) { Object.defineProperty(obj, key, { value: value, enumerable: true, configurable: true, writable: true }); } else { obj[key] = value; } return obj; }

import { compose } from 'redux';
import { connect } from 'react-redux';
import flatten from 'lodash/flatten';
import { withStyles } from '@material-ui/core/styles';
import * as actions from '../state/actions';
import { GalleryViewThumbnail } from '../components/GalleryViewThumbnail';
import { getSearchAnnotationsForWindow, getSelectedContentSearchAnnotations, getCurrentCanvas } from '../state/selectors';
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
  var currentCanvas = getCurrentCanvas(state, {
    windowId: windowId
  });
  var selectedAnnotations = getSelectedContentSearchAnnotations(state, {
    windowId: windowId
  });
  var annotationResources = flatten(selectedAnnotations.map(function (a) {
    return a.resources;
  }));
  var selectedAnnotationCanvases = annotationResources.map(function (a) {
    return a.targetId;
  });
  var searchAnnotations = getSearchAnnotationsForWindow(state, {
    windowId: windowId
  });
  return {
    annotationsCount: flatten(searchAnnotations.map(function (a) {
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

var enhance = compose(connect(mapStateToProps, mapDispatchToProps), withStyles(styles) // further HOC go here
);
export default enhance(GalleryViewThumbnail);