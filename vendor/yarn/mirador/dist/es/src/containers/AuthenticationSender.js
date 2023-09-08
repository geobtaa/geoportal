import { compose } from 'redux';
import { connect } from 'react-redux';
import { withPlugins } from '../extend/withPlugins';
import * as actions from '../state/actions';
import { AuthenticationSender } from '../components/AuthenticationSender';
/**
 * mapStateToProps - to hook up connect
 * @memberof App
 * @private
 */

var mapStateToProps = function mapStateToProps(_ref) {
  var auth = _ref.auth,
      config = _ref.config;
  return {
    center: config.window.authNewWindowCenter,
    url: auth && (Object.values(auth).find(function (e) {
      return e.isFetching && e.profile !== 'http://iiif.io/api/auth/1/external';
    }) || {}).id
  };
};
/**
 * mapDispatchToProps - used to hook up connect to action creators
 * @memberof App
 * @private
 */


var mapDispatchToProps = {
  handleInteraction: actions.resolveAuthenticationRequest
};
var enhance = compose(connect(mapStateToProps, mapDispatchToProps), withPlugins('AuthenticationSender'));
export default enhance(AuthenticationSender);