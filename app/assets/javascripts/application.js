// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//

//= require jquery
//= require jquery3
//= require rails-ujs

// Required by Advanced Search
//= require 'blacklight_advanced_search'
//= require chosen-jquery
//= require modules/advanced_chosen

// Required by Blacklight
//= require popper
//= require twitter/typeahead
//= require bootstrap
//= require blacklight/blacklight

// Geoportal
// Required by GeoBlacklight
//= require handlebars.runtime
//= require geoblacklight/geoblacklight
//= require geoblacklight/basemaps
//= require geoblacklight/controls

// Custom list of viewers
//= require geoblacklight/viewers/viewer
//= require ./geoportal/viewers/map
//= require ./geoportal/viewers/b1g_image
//= require ./geoportal/viewers/download
//= require ./geoportal/viewers/esri
//= require ./geoportal/viewers/esri/dynamic_map_layer
//= require ./geoportal/viewers/esri/feature_layer
//= require ./geoportal/viewers/esri/image_map_layer
//= require ./geoportal/viewers/esri/tiled_map_layer
//= require geoblacklight/viewers/iiif
//= require ./geoportal/viewers/iiif_manifest
//= require ./geoportal/viewers/index_map
//= require geoblacklight/viewers/oembed
//= require ./geoportal/viewers/wms
// require ./geoportal/viewers/tms

// Custom list of modules
//= require geoblacklight/modules/bookmarks
//= require geoblacklight/modules/download
//= require ./geoportal/modules/geosearch
//= require geoblacklight/modules/help_text
//= require ./geoportal/modules/home
//= require ./geoportal/modules/item
//= require geoblacklight/modules/layer_opacity
//= require geoblacklight/modules/metadata_download_button
//= require geoblacklight/modules/metadata
//= require ./geoportal/modules/relations
//= require ./geoportal/modules/results
//= require geoblacklight/modules/svg_tooltips
//= require geoblacklight/modules/util

//= require geoblacklight/downloaders
//= require geoblacklight
//= require leaflet-iiif
//= require esri-leaflet

// Geoportal Libraries
//= require linkifyjs/dist/linkify
//= require linkifyjs/dist/linkify-jquery
//= require Leaflet/Leaflet.fullscreen/Leaflet.fullscreen.js
//= require Leaflet/leaflet.markercluster/leaflet.markercluster.js
//= require Leaflet/leaflet.prunecluster/PruneCluster.js
//= require Leaflet/leaflet.esri_leaflet_cluster/esri_leaflet_cluster.js
//= require Leaflet/leaflet.extra-markers/leaflet.extra-markers.js
//= require oboe/oboe-browser.js
//= require screenfull/screenfull.min.js
//= require js-cookie/src/js.cookie.js

//= require geoportal
