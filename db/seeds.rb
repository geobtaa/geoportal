# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
GeoblacklightAdmin::Engine.load_seed

# db/seeds.rb

reference_types = [
  { name: 'arcgis_dynamic_map_layer', reference_type: 'ArcGIS DynamicMapLayer', reference_uri: 'urn:x-esri:serviceType:ArcGIS#DynamicMapLayer', label: false, note: '-', position: 1 },
  { name: 'arcgis_feature_layer', reference_type: 'ArcGIS FeatureLayer', reference_uri: 'urn:x-esri:serviceType:ArcGIS#FeatureLayer', label: false, note: '-', position: 2 },
  { name: 'arcgis_image_map_layer', reference_type: 'ArcGIS ImageMapLayer', reference_uri: 'urn:x-esri:serviceType:ArcGIS#ImageMapLayer', label: false, note: '-', position: 3 },
  { name: 'arcgis_tiled_map_layer', reference_type: 'ArcGIS TiledMapLayer', reference_uri: 'urn:x-esri:serviceType:ArcGIS#TiledMapLayer', label: false, note: '-', position: 4 },
  { name: 'cog', reference_type: 'Cloud Optimized GeoTIFF (COG)', reference_uri: 'https://github.com/cogeotiff/cog-spec', label: false, note: '-', position: 5 },
  { name: 'documentation_download', reference_type: 'Data dictionary / supplemental documentation', reference_uri: 'http://lccn.loc.gov/sh85035852', label: false, note: 'Functions as a link to download documentation (not a viewer)', position: 6 },
  { name: 'documentation_external', reference_type: 'Documentation (External)', reference_uri: 'http://schema.org/url', label: false, note: '-', position: 7 },
  { name: 'download', reference_type: 'Download file', reference_uri: 'http://schema.org/downloadUrl', label: true, note: 'Link to download file (for multiple files see the multiple downloads guidelines)', position: 8 },
  { name: 'geo_json', reference_type: 'GeoJSON', reference_uri: 'http://geojson.org/geojson-spec.html', label: false, note: '-', position: 9 },
  { name: 'full_layer_description', reference_type: 'Full layer description', reference_uri: 'http://schema.org/url', label: false, note: 'To view further descriptive information about the layer or a link to its landing page', position: 10 },
  { name: 'iiif_image', reference_type: 'International Image Interoperability Framework (IIIF) Image API', reference_uri: 'http://iiif.io/api/image', label: false, note: 'Load the image viewer using Leaflet-IIIF', position: 11 },
  { name: 'iiif_manifest', reference_type: 'International Image Interoperability Framework (IIIF) Presentation API Manifest', reference_uri: 'http://iiif.io/api/presentation#manifest', label: false, note: 'View the IIIF manifest - uses the Clover viewer by default https://samvera-labs.github.io/clover-iiif/docs', position: 12 },
  { name: 'image', reference_type: 'Image file', reference_uri: 'http://schema.org/image', label: true, note: '-', position: 13 },
  { name: 'metadata_fgdc', reference_type: 'Metadata in FGDC', reference_uri: 'http://www.opengis.net/cat/csw/csdgm', label: false, note: 'Provides an HTML view of an XML file in the FGDC standard', position: 14 },
  { name: 'metadata_html', reference_type: 'Metadata in HTML', reference_uri: 'http://www.w3.org/1999/xhtml', label: false, note: 'View structured metadata in any standard expressed as HTML', position: 15 },
  { name: 'metadata_iso', reference_type: 'Metadata in ISO 19139', reference_uri: 'http://www.isotc211.org/schemas/2005/gmd/', label: false, note: 'Provides an HTML view of an XML file in the ISO 19139 standard', position: 16 },
  { name: 'metadata_mods', reference_type: 'Metadata in MODS', reference_uri: 'http://www.loc.gov/mods/v3', label: false, note: 'Provides a raw XML view of metadata in the MODS format', position: 17 },
  { name: 'oembed', reference_type: 'oEmbed', reference_uri: 'https://oembed.com', label: false, note: '-', position: 18 },
  { name: 'open_index_map', reference_type: 'OpenIndexMap', reference_uri: 'https://openindexmaps.org', label: false, note: 'Provides an interactive preview of a GeoJSON file formatted as an OpenIndexMap', position: 19 },
  { name: 'pmtiles', reference_type: 'PMTiles', reference_uri: 'https://github.com/protomaps/PMTiles', label: false, note: '-', position: 20 },
  { name: 'thumbnail', reference_type: 'Thumbnail file', reference_uri: 'http://schema.org/thumbnailUrl', label: true, note: '-', position: 21 },
  { name: 'tile_map_service', reference_type: 'Tile Mapping Service (TMS)', reference_uri: 'https://wiki.osgeo.org/wiki/Tile_Map_Service_Specification', label: false, note: '-', position: 22 },
  { name: 'tile_json', reference_type: 'TileJSON', reference_uri: 'https://github.com/mapbox/tilejson-spec', label: false, note: '-', position: 23 },
  { name: 'wcs', reference_type: 'Web Coverage Service (WCS)', reference_uri: 'http://www.opengis.net/def/serviceType/ogc/wcs', label: false, note: '-', position: 24 },
  { name: 'wfs', reference_type: 'Web Feature Service (WFS)', reference_uri: 'http://www.opengis.net/def/serviceType/ogc/wfs', label: false, note: 'Provides a to download generated vector datasets (GeoJSON, shapefile)', position: 25 },
  { name: 'wmts', reference_type: 'Web Mapping Service (WMS)', reference_uri: 'http://www.opengis.net/def/serviceType/ogc/wms', label: false, note: 'Provides a service to visually preview a layer and inspect its features', position: 26 },
  { name: 'wms', reference_type: 'WMTS', reference_uri: 'http://www.opengis.net/def/serviceType/ogc/wmts', label: false, note: '-', position: 27 },
  { name: 'xyz_tiles', reference_type: 'XYZ tiles', reference_uri: 'https://wiki.openstreetmap.org/wiki/Slippy_map_tilenames', label: false, note: 'Link to an XYZ tile server', position: 28 }
]

reference_types.each do |attributes|
  ReferenceType.create!(attributes)
end

puts "Reference types seeded successfully."