import { compose } from 'redux';
import { connect } from 'react-redux';
import { withTranslation } from 'react-i18next';
import { withStyles } from '@material-ui/core/styles';
import { withPlugins } from '../extend/withPlugins';
import { SidebarIndexThumbnail } from '../components/SidebarIndexThumbnail';
/**
 * mapStateToProps - used to hook up state to props
 * @memberof SidebarIndexThumbnail
 * @private
 */

var mapStateToProps = function mapStateToProps(state, _ref) {
  var data = _ref.data;
  return {
    config: state.config
  };
};
/**
 * Styles for withStyles HOC
 */


var styles = function styles(theme) {
  return {
    label: {
      paddingLeft: theme.spacing(1)
    }
  };
};

var enhance = compose(withStyles(styles), withTranslation(), connect(mapStateToProps, null), withPlugins('SidebarIndexThumbnail'));
export default enhance(SidebarIndexThumbnail);