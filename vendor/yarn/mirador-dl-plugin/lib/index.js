'use strict';

exports.__esModule = true;

var _miradorDownloadPlugin = require('./miradorDownloadPlugin');

var _miradorDownloadPlugin2 = _interopRequireDefault(_miradorDownloadPlugin);

var _MiradorDownloadDialog = require('./MiradorDownloadDialog');

var _MiradorDownloadDialog2 = _interopRequireDefault(_MiradorDownloadDialog);

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { default: obj }; }

exports.default = {
  miradorDownloadPlugin: _miradorDownloadPlugin2.default,
  MiradorDownloadDialogPlugin: _MiradorDownloadDialog2.default
};
module.exports = exports['default'];