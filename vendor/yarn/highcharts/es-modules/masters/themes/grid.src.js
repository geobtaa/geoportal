/**
 * @license Highcharts JS v11.1.0 (2023-06-05)
 * @module highcharts/themes/grid
 * @requires highcharts
 *
 * (c) 2009-2021 Torstein Honsi
 *
 * License: www.highcharts.com/license
 */
'use strict';
import H from '../../Core/Globals.js';
import GridTheme from '../../Extensions/Themes/Grid.js';
H.theme = GridTheme.options;
GridTheme.apply();
