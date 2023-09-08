import { compose } from 'redux';
import { connect } from 'react-redux';
import { withTranslation } from 'react-i18next';
import { withStyles } from '@material-ui/core/styles';
import { withPlugins } from '../extend/withPlugins';
import { getVisibleCanvases, getAnnotationResourcesByMotivation } from '../state/selectors';
import { WindowSideBarAnnotationsPanel } from '../components/WindowSideBarAnnotationsPanel';
/**
 * mapStateToProps - to hook up connect
 * @memberof WindowSideBarAnnotationsPanel
 * @private
 */

var mapStateToProps = function mapStateToProps(state, _ref) {
  var windowId = _ref.windowId;
  return {
    annotationCount: getAnnotationResourcesByMotivation(state, {
      motivations: state.config.annotations.filteredMotivations,
      windowId: windowId
    }).length,
    selectedCanvases: getVisibleCanvases(state, {
      windowId: windowId
    })
  };
};
/** */


var styles = function styles(theme) {
  return {
    section: {
      borderBottom: ".5px solid ".concat(theme.palette.section_divider),
      paddingBottom: theme.spacing(1),
      paddingLeft: theme.spacing(2),
      paddingRight: theme.spacing(1),
      paddingTop: theme.spacing(2)
    }
  };
};

var enhance = compose(withTranslation(), withStyles(styles), connect(mapStateToProps, null), withPlugins('WindowSideBarAnnotationPanel') // further HOC
);
export default enhance(WindowSideBarAnnotationsPanel);