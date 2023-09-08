function ownKeys(object, enumerableOnly) { var keys = Object.keys(object); if (Object.getOwnPropertySymbols) { var symbols = Object.getOwnPropertySymbols(object); if (enumerableOnly) symbols = symbols.filter(function (sym) { return Object.getOwnPropertyDescriptor(object, sym).enumerable; }); keys.push.apply(keys, symbols); } return keys; }

function _objectSpread(target) { for (var i = 1; i < arguments.length; i++) { var source = arguments[i] != null ? arguments[i] : {}; if (i % 2) { ownKeys(Object(source), true).forEach(function (key) { _defineProperty(target, key, source[key]); }); } else if (Object.getOwnPropertyDescriptors) { Object.defineProperties(target, Object.getOwnPropertyDescriptors(source)); } else { ownKeys(Object(source)).forEach(function (key) { Object.defineProperty(target, key, Object.getOwnPropertyDescriptor(source, key)); }); } } return target; }

function _defineProperty(obj, key, value) { if (key in obj) { Object.defineProperty(obj, key, { value: value, enumerable: true, configurable: true, writable: true }); } else { obj[key] = value; } return obj; }

import { compose } from 'redux';
import { connect } from 'react-redux';
import { withTranslation } from 'react-i18next';
import { withStyles } from '@material-ui/core/styles';
import { withPlugins } from '../extend/withPlugins';
import { SearchHit } from '../components/SearchHit';
import * as actions from '../state/actions';
import { getCanvasLabel, getVisibleCanvases, getResourceAnnotationForSearchHit, getResourceAnnotationLabel, getSelectedContentSearchAnnotationIds } from '../state/selectors';
/**
 * mapStateToProps - used to hook up connect to state
 * @memberof SearchHit
 * @private
 */

var mapStateToProps = function mapStateToProps(state, _ref) {
  var annotationId = _ref.annotationId,
      hit = _ref.hit,
      companionWindowId = _ref.companionWindowId,
      windowId = _ref.windowId;
  var realAnnoId = annotationId || hit.annotations[0];
  var hitAnnotation = getResourceAnnotationForSearchHit(state, {
    annotationUri: realAnnoId,
    companionWindowId: companionWindowId,
    windowId: windowId
  });
  var annotationLabel = getResourceAnnotationLabel(state, {
    annotationUri: realAnnoId,
    companionWindowId: companionWindowId,
    windowId: windowId
  });
  var selectedCanvasIds = getVisibleCanvases(state, {
    windowId: windowId
  }).map(function (canvas) {
    return canvas.id;
  });
  var selectedAnnotation = getSelectedContentSearchAnnotationIds(state, {
    companionWindowId: companionWindowId,
    windowId: windowId
  });
  return {
    adjacent: selectedCanvasIds.includes(hitAnnotation.targetId),
    annotation: hitAnnotation,
    annotationId: realAnnoId,
    annotationLabel: annotationLabel[0],
    canvasLabel: hitAnnotation && getCanvasLabel(state, {
      canvasId: hitAnnotation.targetId,
      windowId: windowId
    }),
    selected: selectedAnnotation[0] === realAnnoId,
    windowSelected: getSelectedContentSearchAnnotationIds(state, {
      windowId: windowId
    })[0] === realAnnoId
  };
};
/**
 * mapDispatchToProps - to hook up connect
 * @memberof SearchPanelNavigation
 * @private
 */


var mapDispatchToProps = function mapDispatchToProps(dispatch, _ref2) {
  var companionWindowId = _ref2.companionWindowId,
      windowId = _ref2.windowId;
  return {
    selectContentSearchAnnotation: function selectContentSearchAnnotation() {
      for (var _len = arguments.length, args = new Array(_len), _key = 0; _key < _len; _key++) {
        args[_key] = arguments[_key];
      }

      return dispatch(actions.selectContentSearchAnnotation.apply(actions, [windowId, companionWindowId].concat(args)));
    }
  };
};
/** */


var styles = function styles(theme) {
  return {
    adjacent: {},
    focused: {},
    hitCounter: _objectSpread({}, theme.typography.subtitle2, {
      backgroundColor: theme.palette.hitCounter["default"],
      height: 30,
      marginRight: theme.spacing(1),
      verticalAlign: 'inherit'
    }),
    inlineButton: {
      '& span': {
        lineHeight: '1.5em'
      },
      margin: 0,
      padding: 0,
      textTransform: 'none'
    },
    listItem: {
      '&$adjacent': {
        '& $hitCounter': {
          backgroundColor: theme.palette.highlights.secondary
        },
        '&$windowSelected': {
          '& $hitCounter': {
            backgroundColor: theme.palette.highlights.primary
          }
        }
      },
      '&$windowSelected': {
        '& $hitCounter': {
          backgroundColor: theme.palette.highlights.primary
        },
        '&$focused': {
          '&:hover': {
            backgroundColor: 'inherit'
          },
          backgroundColor: 'inherit'
        }
      },
      borderBottom: "0.5px solid ".concat(theme.palette.divider),
      paddingRight: 8
    },
    selected: {},
    subtitle: {
      marginBottom: theme.spacing(1.5)
    },
    windowSelected: {}
  };
};

var enhance = compose(connect(mapStateToProps, mapDispatchToProps), withStyles(styles), withTranslation(), withPlugins('SearchHit'));
export default enhance(SearchHit);