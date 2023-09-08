'use strict';

exports.__esModule = true;
exports.default = undefined;

var _react = require('react');

var _react2 = _interopRequireDefault(_react);

var _propTypes = require('prop-types');

var _propTypes2 = _interopRequireDefault(_propTypes);

var _Typography = require('@material-ui/core/Typography');

var _Typography2 = _interopRequireDefault(_Typography);

var _Link = require('@material-ui/core/Link');

var _Link2 = _interopRequireDefault(_Link);

var _List = require('@material-ui/core/List');

var _List2 = _interopRequireDefault(_List);

var _ListItem = require('@material-ui/core/ListItem');

var _ListItem2 = _interopRequireDefault(_ListItem);

var _uniqBy = require('lodash/uniqBy');

var _uniqBy2 = _interopRequireDefault(_uniqBy);

var _OSDReferences = require('mirador/dist/es/src/plugins/OSDReferences');

var _RenderingDownloadLink = require('./RenderingDownloadLink');

var _RenderingDownloadLink2 = _interopRequireDefault(_RenderingDownloadLink);

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { default: obj }; }

function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }

function _possibleConstructorReturn(self, call) { if (!self) { throw new ReferenceError("this hasn't been initialised - super() hasn't been called"); } return call && (typeof call === "object" || typeof call === "function") ? call : self; }

function _inherits(subClass, superClass) { if (typeof superClass !== "function" && superClass !== null) { throw new TypeError("Super expression must either be null or a function, not " + typeof superClass); } subClass.prototype = Object.create(superClass && superClass.prototype, { constructor: { value: subClass, enumerable: false, writable: true, configurable: true } }); if (superClass) Object.setPrototypeOf ? Object.setPrototypeOf(subClass, superClass) : subClass.__proto__ = superClass; }

/**
 * CanvasDownloadLinks ~
*/
var CanvasDownloadLinks = function (_Component) {
  _inherits(CanvasDownloadLinks, _Component);

  function CanvasDownloadLinks() {
    _classCallCheck(this, CanvasDownloadLinks);

    return _possibleConstructorReturn(this, _Component.apply(this, arguments));
  }

  CanvasDownloadLinks.prototype.zoomedImageLabel = function zoomedImageLabel() {
    var bounds = this.currentBounds();
    return 'Zoomed region (' + Math.floor(bounds.width) + ' x ' + Math.floor(bounds.height) + 'px)';
  };

  CanvasDownloadLinks.prototype.fullImageLabel = function fullImageLabel() {
    var canvas = this.props.canvas;


    return 'Whole image (' + canvas.getWidth() + ' x ' + canvas.getHeight() + 'px)';
  };

  CanvasDownloadLinks.prototype.smallImageLabel = function smallImageLabel() {
    var canvas = this.props.canvas;


    return 'Whole image (1000 x ' + Math.floor(1000 * canvas.getHeight() / canvas.getWidth()) + 'px)';
  };

  CanvasDownloadLinks.prototype.zoomedImageUrl = function zoomedImageUrl() {
    var canvas = this.props.canvas;

    var bounds = this.currentBounds();
    var boundsUrl = canvas.getCanonicalImageUri().replace(/\/full\/.*\/0\//, '/' + bounds.x + ',' + bounds.y + ',' + bounds.width + ',' + bounds.height + '/full/0/');

    return boundsUrl + '?download=true';
  };

  CanvasDownloadLinks.prototype.imageUrlForSize = function imageUrlForSize(size) {
    var canvas = this.props.canvas;


    return canvas.getCanonicalImageUri(size.width) + '?download=true';
  };

  CanvasDownloadLinks.prototype.fullImageUrl = function fullImageUrl() {
    var canvas = this.props.canvas;


    return canvas.getCanonicalImageUri().replace(/\/full\/.*\/0\//, '/full/full/0/') + '?download=true';
  };

  CanvasDownloadLinks.prototype.thousandPixelWideImage = function thousandPixelWideImage() {
    var canvas = this.props.canvas;


    return canvas.getCanonicalImageUri('1000') + '?download=true';
  };

  CanvasDownloadLinks.prototype.osdViewport = function osdViewport() {
    var windowId = this.props.windowId;

    return _OSDReferences.OSDReferences.get(windowId).current.viewer.viewport;
  };

  CanvasDownloadLinks.prototype.currentBounds = function currentBounds() {
    var bounds = this.osdViewport().getBounds();

    return Object.keys(bounds).reduce(function (object, key) {
      object[key] = Math.ceil(bounds[key]); // eslint-disable-line no-param-reassign
      return object;
    }, {});
  };

  CanvasDownloadLinks.prototype.definedSizesRestrictsDownload = function definedSizesRestrictsDownload() {
    var infoResponse = this.props.infoResponse;

    if (!infoResponse.json) return false;
    var _infoResponse$json = infoResponse.json,
        height = _infoResponse$json.height,
        width = _infoResponse$json.width;


    if (this.definedSizes().length !== 1) return false;

    return this.definedSizes()[0].width <= width && this.definedSizes()[0].height <= height;
  };

  CanvasDownloadLinks.prototype.displayCurrentZoomLink = function displayCurrentZoomLink() {
    var _props = this.props,
        restrictDownloadOnSizeDefinition = _props.restrictDownloadOnSizeDefinition,
        infoResponse = _props.infoResponse,
        viewType = _props.viewType;


    if (viewType !== 'single') return false;
    if (restrictDownloadOnSizeDefinition && this.definedSizesRestrictsDownload()) return false;
    if (!(infoResponse && infoResponse.json)) return false;

    var bounds = this.currentBounds();
    return bounds.height < infoResponse.json.height && bounds.width < infoResponse.json.width && bounds.x >= 0 && bounds.y >= 0;
  };

  /**
   * This only returns unique sizes
  */


  CanvasDownloadLinks.prototype.definedSizes = function definedSizes() {
    var infoResponse = this.props.infoResponse;

    if (!(infoResponse && infoResponse.json && infoResponse.json.sizes)) return [];

    return (0, _uniqBy2.default)(infoResponse.json.sizes, function (size) {
      return '' + size.width + size.height;
    });
  };

  CanvasDownloadLinks.prototype.fullImageLink = function fullImageLink() {
    return _react2.default.createElement(
      _ListItem2.default,
      { disableGutters: true, divider: true, key: this.fullImageUrl() },
      _react2.default.createElement(
        _Link2.default,
        { href: this.fullImageUrl(), rel: 'noopener noreferrer', target: '_blank', variant: 'body1' },
        this.fullImageLabel()
      )
    );
  };

  CanvasDownloadLinks.prototype.thousandPixelWideLink = function thousandPixelWideLink() {
    var canvas = this.props.canvas;


    if (canvas.getWidth() < 1000) return '';

    return _react2.default.createElement(
      _ListItem2.default,
      { disableGutters: true, divider: true, key: this.thousandPixelWideImage() },
      _react2.default.createElement(
        _Link2.default,
        { href: this.thousandPixelWideImage(), rel: 'noopener noreferrer', target: '_blank', variant: 'body1' },
        this.smallImageLabel()
      )
    );
  };

  CanvasDownloadLinks.prototype.linksForDefinedSizes = function linksForDefinedSizes() {
    var _this2 = this;

    return this.definedSizes().map(function (size) {
      return _react2.default.createElement(
        _ListItem2.default,
        { disableGutters: true, divider: true, key: '' + size.width + size.height },
        _react2.default.createElement(
          _Link2.default,
          { href: _this2.imageUrlForSize(size), rel: 'noopener noreferrer', target: '_blank', variant: 'body1' },
          'Whole image (' + size.width + ' x ' + size.height + 'px)'
        )
      );
    });
  };

  /**
   * Returns the rendered component
  */


  CanvasDownloadLinks.prototype.render = function render() {
    var _props2 = this.props,
        canvas = _props2.canvas,
        canvasLabel = _props2.canvasLabel,
        classes = _props2.classes;


    return _react2.default.createElement(
      _react2.default.Fragment,
      null,
      _react2.default.createElement(
        _Typography2.default,
        { noWrap: true, variant: 'h3', className: classes.h3 },
        canvasLabel
      ),
      _react2.default.createElement(
        _List2.default,
        null,
        this.displayCurrentZoomLink() && _react2.default.createElement(
          _ListItem2.default,
          { disableGutters: true, divider: true },
          _react2.default.createElement(
            _Link2.default,
            { href: this.zoomedImageUrl(), rel: 'noopener noreferrer', target: '_blank', variant: 'body1' },
            this.zoomedImageLabel()
          )
        ),
        this.definedSizes().length === 0 && [this.fullImageLink(), this.thousandPixelWideLink()],
        this.definedSizes().length > 0 && this.linksForDefinedSizes(),
        canvas.getRenderings().map(function (rendering) {
          return _react2.default.createElement(_RenderingDownloadLink2.default, { rendering: rendering, key: rendering.id });
        })
      )
    );
  };

  return CanvasDownloadLinks;
}(_react.Component);

exports.default = CanvasDownloadLinks;


CanvasDownloadLinks.propTypes = process.env.NODE_ENV !== "production" ? {
  canvas: _propTypes2.default.shape({
    id: _propTypes2.default.string.isRequired,
    getCanonicalImageUri: _propTypes2.default.func.isRequired,
    getHeight: _propTypes2.default.func.isRequired,
    getRenderings: _propTypes2.default.func.isRequired,
    getWidth: _propTypes2.default.func.isRequired
  }).isRequired,
  canvasLabel: _propTypes2.default.string.isRequired, // canvasLabel is passed because we need access to redux
  classes: _propTypes2.default.shape({
    h3: _propTypes2.default.string
  }).isRequired,
  infoResponse: _propTypes2.default.shape({
    json: _propTypes2.default.shape({
      height: _propTypes2.default.number,
      sizes: _propTypes2.default.arrayOf(_propTypes2.default.shape({ height: _propTypes2.default.number, width: _propTypes2.default.number })),
      width: _propTypes2.default.number
    })
  }).isRequired,
  restrictDownloadOnSizeDefinition: _propTypes2.default.bool.isRequired,
  viewType: _propTypes2.default.string.isRequired,
  windowId: _propTypes2.default.string.isRequired
} : {};
module.exports = exports['default'];