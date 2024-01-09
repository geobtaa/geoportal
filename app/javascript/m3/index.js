'use strict';

import Mirador from 'mirador/dist/es/src/index.js';
import miradorDownloadPlugin from 'mirador-dl-plugin/es/miradorDownloadPlugin.js';
import miradorDownloadDialogPlugin from 'mirador-dl-plugin/es/MiradorDownloadDialog.js';
import customIconPlugin from 'm3/plugins/customIconPlugin';

window.Mirador = Mirador;
window.miradorDownloadPlugin = miradorDownloadPlugin;
window.miradorDownloadDialogPlugin = miradorDownloadDialogPlugin;
window.customIconPlugin = customIconPlugin;