import { compose } from 'redux';
import { connect } from 'react-redux';
import { withTranslation } from 'react-i18next';
import { withPlugins } from '../extend/withPlugins';
import { WorkspaceExport } from '../components/WorkspaceExport';
/**
 * mapStateToProps - to hook up connect
 * @memberof Workspace
 * @private
 */

var mapStateToProps = function mapStateToProps(state) {
  return {
    state: state
  };
};

var enhance = compose(withTranslation(), connect(mapStateToProps, {}), withPlugins('WorkspaceExport'));
export default enhance(WorkspaceExport);