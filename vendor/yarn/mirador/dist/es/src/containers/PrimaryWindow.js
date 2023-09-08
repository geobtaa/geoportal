import { compose } from 'redux';
import { withStyles } from '@material-ui/core/styles';
import { withPlugins } from '../extend/withPlugins';
import { PrimaryWindow } from '../components/PrimaryWindow';
var styles = {
  primaryWindow: {
    display: 'flex',
    flex: 1,
    position: 'relative'
  }
};
var enhance = compose(withStyles(styles), withPlugins('PrimaryWindow'));
export default enhance(PrimaryWindow);