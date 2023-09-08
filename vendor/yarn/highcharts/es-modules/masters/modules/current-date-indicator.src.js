/**
 * @license Highcharts Gantt JS v11.1.0 (2023-06-05)
 * @module highcharts/modules/current-date-indicator
 * @requires highcharts
 *
 * CurrentDateIndicator
 *
 * (c) 2010-2021 Lars A. V. Cabrera
 *
 * License: www.highcharts.com/license
 */
'use strict';
import Highcharts from '../../Core/Globals.js';
import CurrentDateIndication from '../../Extensions/CurrentDateIndication.js';
const G = Highcharts;
CurrentDateIndication.compose(G.Axis, G.PlotLineOrBand);
