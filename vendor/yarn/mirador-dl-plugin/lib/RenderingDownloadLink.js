'use strict';

exports.__esModule = true;
exports.default = undefined;

var _react = require('react');

var _react2 = _interopRequireDefault(_react);

var _propTypes = require('prop-types');

var _propTypes2 = _interopRequireDefault(_propTypes);

var _Link = require('@material-ui/core/Link');

var _Link2 = _interopRequireDefault(_Link);

var _ListItem = require('@material-ui/core/ListItem');

var _ListItem2 = _interopRequireDefault(_ListItem);

var _ListItemText = require('@material-ui/core/ListItemText');

var _ListItemText2 = _interopRequireDefault(_ListItemText);

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { default: obj }; }

function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }

function _possibleConstructorReturn(self, call) { if (!self) { throw new ReferenceError("this hasn't been initialised - super() hasn't been called"); } return call && (typeof call === "object" || typeof call === "function") ? call : self; }

function _inherits(subClass, superClass) { if (typeof superClass !== "function" && superClass !== null) { throw new TypeError("Super expression must either be null or a function, not " + typeof superClass); } subClass.prototype = Object.create(superClass && superClass.prototype, { constructor: { value: subClass, enumerable: false, writable: true, configurable: true } }); if (superClass) Object.setPrototypeOf ? Object.setPrototypeOf(subClass, superClass) : subClass.__proto__ = superClass; }

/**
 * RenderingDownloadLink ~
*/
var RenderingDownloadLink = function (_Component) {
  _inherits(RenderingDownloadLink, _Component);

  function RenderingDownloadLink() {
    _classCallCheck(this, RenderingDownloadLink);

    return _possibleConstructorReturn(this, _Component.apply(this, arguments));
  }

  RenderingDownloadLink.prototype.render = function render() {
    var rendering = this.props.rendering;

    return _react2.default.createElement(
      _ListItem2.default,
      { disableGutters: true, divider: true, key: rendering.id },
      _react2.default.createElement(
        _ListItemText2.default,
        { primaryTypographyProps: { variant: 'body1' } },
        _react2.default.createElement(
          _Link2.default,
          { href: rendering.id, rel: 'noopener noreferrer', target: '_blank', variant: 'body1' },
          rendering.getLabel().map(function (label) {
            return label.value;
          })[0]
        ),
        rendering.getFormat() && rendering.getFormat().value && ' (' + rendering.getFormat().value + ')'
      )
    );
  };

  return RenderingDownloadLink;
}(_react.Component);

exports.default = RenderingDownloadLink;


RenderingDownloadLink.propTypes = process.env.NODE_ENV !== "production" ? {
  rendering: _propTypes2.default.shape({
    id: _propTypes2.default.string.isRequired,
    getLabel: _propTypes2.default.func.isRequired,
    getFormat: _propTypes2.default.func.isRequired
  }).isRequired
} : {};
module.exports = exports['default'];