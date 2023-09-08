'use strict';

exports.__esModule = true;
exports.default = undefined;

var _react = require('react');

var _react2 = _interopRequireDefault(_react);

var _propTypes = require('prop-types');

var _propTypes2 = _interopRequireDefault(_propTypes);

var _List = require('@material-ui/core/List');

var _List2 = _interopRequireDefault(_List);

var _Typography = require('@material-ui/core/Typography');

var _Typography2 = _interopRequireDefault(_Typography);

var _RenderingDownloadLink = require('./RenderingDownloadLink');

var _RenderingDownloadLink2 = _interopRequireDefault(_RenderingDownloadLink);

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { default: obj }; }

function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }

function _possibleConstructorReturn(self, call) { if (!self) { throw new ReferenceError("this hasn't been initialised - super() hasn't been called"); } return call && (typeof call === "object" || typeof call === "function") ? call : self; }

function _inherits(subClass, superClass) { if (typeof superClass !== "function" && superClass !== null) { throw new TypeError("Super expression must either be null or a function, not " + typeof superClass); } subClass.prototype = Object.create(superClass && superClass.prototype, { constructor: { value: subClass, enumerable: false, writable: true, configurable: true } }); if (superClass) Object.setPrototypeOf ? Object.setPrototypeOf(subClass, superClass) : subClass.__proto__ = superClass; }

/**
 * ManifestDownloadLinks ~
*/
var ManifestDownloadLinks = function (_Component) {
  _inherits(ManifestDownloadLinks, _Component);

  function ManifestDownloadLinks() {
    _classCallCheck(this, ManifestDownloadLinks);

    return _possibleConstructorReturn(this, _Component.apply(this, arguments));
  }

  /**
   * Returns the rendered component
  */
  ManifestDownloadLinks.prototype.render = function render() {
    var _props = this.props,
        classes = _props.classes,
        renderings = _props.renderings;


    return _react2.default.createElement(
      _react2.default.Fragment,
      null,
      _react2.default.createElement(
        _Typography2.default,
        { variant: 'h3', className: classes.h3 },
        'Other download options'
      ),
      _react2.default.createElement(
        _List2.default,
        null,
        renderings.map(function (rendering) {
          return _react2.default.createElement(_RenderingDownloadLink2.default, { rendering: rendering, key: rendering.id });
        })
      )
    );
  };

  return ManifestDownloadLinks;
}(_react.Component);

exports.default = ManifestDownloadLinks;


ManifestDownloadLinks.propTypes = process.env.NODE_ENV !== "production" ? {
  classes: _propTypes2.default.shape({
    h3: _propTypes2.default.string
  }).isRequired,
  renderings: _propTypes2.default.array.isRequired // eslint-disable-line react/forbid-prop-types
} : {};
module.exports = exports['default'];