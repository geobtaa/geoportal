import _values from "lodash/values";
import _omit from "lodash/omit";
import _first from "lodash/first";
import { compose } from 'redux';
import { connect } from 'react-redux';
import { withTranslation } from 'react-i18next';
import { withPlugins } from '../extend/withPlugins';
import { ErrorDialog } from '../components/ErrorDialog';
import * as actions from '../state/actions';
/**
 * mapStateToProps - to hook up connect
 * @memberof ErrorDialog
 * @private
 */

var mapStateToProps = function mapStateToProps(state) {
  return {
    /* extract 'items' value and get first key-value-pair (an error) */
    error: _first(_values(_omit(state.errors, 'items')))
  };
};
/**
 * mapDispatchToProps - used to hook up connect to action creators
 * @memberof App
 * @private
 */


var mapDispatchToProps = {
  removeError: actions.removeError
};
var enhance = compose(withTranslation(), connect(mapStateToProps, mapDispatchToProps), withPlugins('ErrorDialog'));
export default enhance(ErrorDialog);