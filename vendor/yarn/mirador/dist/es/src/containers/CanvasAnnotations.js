import { compose } from 'redux';
import { connect } from 'react-redux';
import { withTranslation } from 'react-i18next';
import { withStyles } from '@material-ui/core/styles';
import * as actions from '../state/actions';
import { getAnnotationResourcesByMotivationForCanvas, getCanvasLabel, getSelectedAnnotationIds, getWindow } from '../state/selectors';
import { CanvasAnnotations } from '../components/CanvasAnnotations';
/**
 * @param {Array} resources
 * @return {Array} [{ id: 'abc123', content: 'Annotation Content' }, ...]
 */

function getIdAndContentOfResources(resources) {
  return resources.map(function (resource, i) {
    return {
      content: resource.chars,
      id: resource.id,
      targetId: resource.targetId
    };
  });
}
/** For connect */


var mapStateToProps = function mapStateToProps(state, _ref) {
  var canvasId = _ref.canvasId,
      windowId = _ref.windowId;
  return {
    allAnnotationsAreHighlighted: getWindow(state, {
      windowId: windowId
    }).displayAllAnnotations,
    annotations: getIdAndContentOfResources(getAnnotationResourcesByMotivationForCanvas(state, {
      canvasId: canvasId,
      motivations: state.config.annotations.filteredMotivations,
      windowId: windowId
    })),
    label: getCanvasLabel(state, {
      canvasId: canvasId,
      windowId: windowId
    }),
    selectedAnnotationIds: getSelectedAnnotationIds(state, {
      windowId: windowId
    })
  };
};
/**
 * mapDispatchToProps - to hook up connect
 * @memberof WindowSideBarAnnotationsPanel
 * @private
 */


var mapDispatchToProps = {
  deselectAnnotation: actions.deselectAnnotation,
  highlightAnnotation: actions.highlightAnnotation,
  selectAnnotation: actions.selectAnnotation
};
/** For withStlyes */

var styles = function styles(theme) {
  return {
    annotationListItem: {
      '&:hover': {
        backgroundColor: theme.palette.action.hover
      },
      borderBottom: "0.5px solid ".concat(theme.palette.divider),
      cursor: 'pointer'
    },
    sectionHeading: {
      paddingLeft: theme.spacing(2),
      paddingRight: theme.spacing(1),
      paddingTop: theme.spacing(2)
    }
  };
};

var enhance = compose(withTranslation(), withStyles(styles), connect(mapStateToProps, mapDispatchToProps));
export default enhance(CanvasAnnotations);