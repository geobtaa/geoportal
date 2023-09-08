import { compose } from 'redux';
import { connect } from 'react-redux';
import { withPlugins } from '../extend/withPlugins';
import * as actions from '../state/actions';
import { getTheme } from '../state/selectors';
import { App } from '../components/App';
/**
 * mapStateToProps - to hook up connect
 * @memberof App
 * @private
 */

var mapStateToProps = function mapStateToProps(state) {
  return {
    isFullscreenEnabled: state.workspace.isFullscreenEnabled,
    language: state.config.language,
    theme: getTheme(state),
    translations: state.config.translations
  };
};
/**
 * mapDispatchToProps - used to hook up connect to action creators
 * @memberof App
 * @private
 */


var mapDispatchToProps = {
  setWorkspaceFullscreen: actions.setWorkspaceFullscreen
};
var enhance = compose(connect(mapStateToProps, mapDispatchToProps), withPlugins('App'));
export default enhance(App);