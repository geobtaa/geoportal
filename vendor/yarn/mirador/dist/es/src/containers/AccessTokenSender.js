import { compose } from 'redux';
import { connect } from 'react-redux';
import { withPlugins } from '../extend/withPlugins';
import * as actions from '../state/actions';
import { AccessTokenSender } from '../components/AccessTokenSender';
/**
 * mapStateToProps - to hook up connect
 * @memberof App
 * @private
 */

var mapStateToProps = function mapStateToProps(_ref) {
  var accessTokens = _ref.accessTokens;
  return {
    url: accessTokens && (Object.values(accessTokens).find(function (e) {
      return e.isFetching;
    }) || {}).id
  };
};
/**
 * mapDispatchToProps - used to hook up connect to action creators
 * @memberof App
 * @private
 */


var mapDispatchToProps = {
  handleAccessTokenMessage: actions.resolveAccessTokenRequest
};
var enhance = compose(connect(mapStateToProps, mapDispatchToProps), withPlugins('AccessTokenSender'));
export default enhance(AccessTokenSender);