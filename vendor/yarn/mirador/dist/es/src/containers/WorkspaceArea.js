import { compose } from 'redux';
import { connect } from 'react-redux';
import { withTranslation } from 'react-i18next';
import { withStyles } from '@material-ui/core/styles';
import { withPlugins } from '../extend/withPlugins';
import { WorkspaceArea } from '../components/WorkspaceArea';
/**
 * mapStateToProps - to hook up connect
 * @memberof App
 * @private
 */

var mapStateToProps = function mapStateToProps(state) {
  return {
    controlPanelVariant: state.workspace.isWorkspaceAddVisible || Object.keys(state.windows).length > 0 ? undefined : 'wide',
    isWorkspaceAddVisible: state.workspace.isWorkspaceAddVisible,
    isWorkspaceControlPanelVisible: state.config.workspaceControlPanel.enabled
  };
};
/**
 *
 * @param theme
 * @returns {{background: {background: string}}}
 */


var styles = function styles(theme) {
  return {
    viewer: {
      background: theme.palette.shades.light,
      bottom: 0,
      left: 0,
      overflow: 'hidden',
      position: 'absolute',
      right: 0,
      top: 0
    }
  };
};

var enhance = compose(withTranslation(), withStyles(styles), connect(mapStateToProps), withPlugins('WorkspaceArea'));
export default enhance(WorkspaceArea);