'use strict';

import Mirador from 'mirador/dist/es/src/index.js';
import osdReferencePlugin from 'mirador-dl-plugin/es/OSDReferences.js';
import miradorDownloadPlugin from 'mirador-dl-plugin/es/miradorDownloadPlugin.js';
import miradorDownloadDialogPlugin from 'mirador-dl-plugin/es/MiradorDownloadDialog.js';

window.Mirador = Mirador;
window.miradorDownloadPlugin = miradorDownloadPlugin;

window.miradorDownloadDialogPlugin = miradorDownloadDialogPlugin;
window.osdReferencePlugin = osdReferencePlugin;
