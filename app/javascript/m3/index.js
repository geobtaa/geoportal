'use strict';

import Mirador from 'mirador/dist/es/src/index.js';
import miradorDownloadPlugin from 'mirador-dl-plugin/es/miradorDownloadPlugin.js';
import miradorDownloadDialogPlugin from 'mirador-dl-plugin/es/MiradorDownloadDialog.js';
import customIconPlugin from 'm3/plugins/customIconPlugin';

window.Mirador = Mirador;
window.miradorDownloadPlugin = miradorDownloadPlugin;
window.miradorDownloadDialogPlugin = miradorDownloadDialogPlugin;
window.customIconPlugin = customIconPlugin;

// Remove Material UI v4 and Mirador/React prop deprecation warnings
/*
if (process.env.NODE_ENV === 'development' || process.env.NODE_ENV === 'test') {
  const errorFn = global.console.error;
  const warnFn = global.console.warn;

  const contains = (target, pattern) => {
    let value = 0;
    pattern.forEach(word => (value = value + target.includes(word)));
    return value === 1;
  };

  const ignoreListError = [
    'The `fade` color utility was renamed to `alpha` to better describe its functionality.',
    'the createMuiTheme function was renamed to createTheme',
    'The prop `onEntering` of `ForwardRef(Menu)` is deprecated. Use the `TransitionProps` prop instead.',
    'The prop `onExit` of `ForwardRef(Popover)` is deprecated. Use the `TransitionProps` prop instead.',
    'The prop `onExit` of `ForwardRef(Menu)` is deprecated. Use the `TransitionProps` prop instead.'
  ];

  const ignoreListWarn = ['The `theme.typography.round` helper is deprecated.'];

  global.console.error = msg => {
    if (!(typeof msg === 'string' && contains(msg, ignoreListError))) {
      errorFn(msg);
    }
  };

  global.console.warn = msg => {
    if (!(typeof msg === 'string' && contains(msg, ignoreListWarn))) {
      warnFn(msg);
    }
  };
}*/