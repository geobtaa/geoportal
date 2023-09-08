import { compose } from 'redux';
import { connect } from 'react-redux';
import { withStyles } from '@material-ui/core/styles';
import { withPlugins } from '../extend/withPlugins';
import * as actions from '../state/actions';
import WorkspaceElastic from '../components/WorkspaceElastic';
/**
 * mapStateToProps - to hook up connect
 * @memberof Workspace
 * @private
 */

var mapStateToProps = function mapStateToProps(state) {
  return {
    elasticLayout: state.elasticLayout,
    workspace: state.workspace
  };
};
/**
 * mapDispatchToProps - used to hook up connect to action creators
 * @memberof Workspace
 * @private
 */


var mapDispatchToProps = function mapDispatchToProps(dispatch, props) {
  return {
    setWorkspaceViewportDimensions: function setWorkspaceViewportDimensions(position) {
      dispatch(actions.setWorkspaceViewportDimensions(position));
    },
    setWorkspaceViewportPosition: function setWorkspaceViewportPosition(position) {
      dispatch(actions.setWorkspaceViewportPosition(position));
    },
    toggleWorkspaceExposeMode: function toggleWorkspaceExposeMode(size) {
      return dispatch(actions.toggleWorkspaceExposeMode());
    },
    updateElasticWindowLayout: function updateElasticWindowLayout(windowId, position) {
      dispatch(actions.updateElasticWindowLayout(windowId, position));
    }
  };
};

var styles = {
  workspace: {
    boxSizing: 'border-box',
    margin: 0,
    position: 'absolute',
    transitionDuration: '.7s',
    // order matters
    // eslint-disable-next-line sort-keys
    '& .react-draggable-dragging': {
      transitionDuration: 'unset'
    }
  }
};
var enhance = compose(withStyles(styles), connect(mapStateToProps, mapDispatchToProps), withPlugins('WorkspaceElastic') // further HOC go here
);
export default enhance(WorkspaceElastic);