# Item Viewers / Thumbnail Testing

rake geoblacklight_admin:images:harvest_all

### COG
ID: princeton-dc7h14b252v \
TITLE: [Map illustrating the journey of the Pundit Nain Singh through Great Tibet](http://localhost:3000/catalog/princeton-dc7h14b252v)

Note: Harvesting fails on auth
```
DOC_ID=princeton-dc7h14b252v rake geoblacklight_admin:images:harvest_doc_id
```

## ESRI
### Dynamic Map Layer
ID: 4669301e-b4b2-4c8b-bf40-01b968a2865b \
TITLE: [Abandoned Quarries: Indiana](http://localhost:3000/catalog/4669301e-b4b2-4c8b-bf40-01b968a2865b)

```
DOC_ID=4669301e-b4b2-4c8b-bf40-01b968a2865b rake geoblacklight_admin:images:harvest_doc_id
```

### Feature Layer
ID: f406332e63eb4478a9560ad86ae90327_18 \
TITLE: [Maryland Transit - Airports](http://localhost:3000/catalog/f406332e63eb4478a9560ad86ae90327_18)

Note: Harvest fails. No service url.
```
DOC_ID=f406332e63eb4478a9560ad86ae90327_18 rake geoblacklight_admin:images:harvest_doc_id
```

### Image Map Layer
ID: 32653ed6-8d83-4692-8a06-bf13ffe2c018 \
TITLE: [Wabash Topo (27): Indiana, 1929](http://localhost:3000/catalog/32653ed6-8d83-4692-8a06-bf13ffe2c018)

```
DOC_ID=32653ed6-8d83-4692-8a06-bf13ffe2c018 rake geoblacklight_admin:images:harvest_doc_id
```

### Tiled Map Layer
nyu-test-soil-survey-map (not in GeoDev)

### IIIF
ID: p16022coll205:446 \
TITLE: [Albertson's map of the cities at the head of Lake Superior](http://localhost:3000/catalog/p16022coll205:446)

```
DOC_ID=p16022coll205:446 rake geoblacklight_admin:images:harvest_doc_id
```

### Index Map
stanford-fb897vt9938 (not in GeoDev)

### Map

### oEmbed
ID: stanford-dc482zx1528 \
TITLE: [Jōshū Kusatsu Onsenzu](http://localhost:3000/catalog/stanford-dc482zx1528)

Notes: oEmbed not displaying. Nothing harvested.
```
DOC_ID=stanford-dc482zx1528 rake geoblacklight_admin:images:harvest_doc_id
```

### PMTiles
ID: princeton-t722hd30j \
TITLE: [Louisiana voting districts from 2010 Census](http://localhost:3000/catalog/princeton-t722hd30j)

```
DOC_ID=princeton-t722hd30j rake geoblacklight_admin:images:harvest_doc_id
```

### TileJSON
ID: princeton-fk4544658v-tilejson \
TITLE: [The Balkans and Turkey](http://localhost:3000/catalog/princeton-fk4544658v-tilejson)

Notes: Harvested IIIF?
```
DOC_ID=princeton-fk4544658v-tilejson rake geoblacklight_admin:images:harvest_doc_id
```

### TMS
ID: cugir-007957 \
TITLE: [Agricultural Districts, Columbia County NY, 2009 (TMS)](http://localhost:3000/catalog/cugir-007957)

Notes: Harvested IIIF?
```
DOC_ID=cugir-007957 rake geoblacklight_admin:images:harvest_doc_id
```

### WMS
ID: stanford-cz128vq0535 \
TITLE: [2005 Rural Poverty GIS Database: Uganda](http://localhost:3000/catalog/stanford-cz128vq0535)

```
DOC_ID=stanford-cz128vq0535 rake geoblacklight_admin:images:harvest_doc_id
```

### WMTS
ID: princeton-fk4544658v-wmts \
TITLE: [The Balkans and Turkey](http://localhost:3000/catalog/princeton-fk4544658v-wmts)

Notes: Harvested IIIF?
```
DOC_ID=princeton-fk4544658v-wmts rake geoblacklight_admin:images:harvest_doc_id
```

### XYZ
ID: 6f47b103-9955-4bbe-a364-387039623106-xyz \
TITLE: [Quaternary Fault and Fold Database of the United States (XYZ)](http://localhost:3000/catalog/6f47b103-9955-4bbe-a364-387039623106-xyz)

```
DOC_ID=6f47b103-9955-4bbe-a364-387039623106-xyz rake geoblacklight_admin:images:harvest_doc_id
```


- - - - -

## Create Derivatives

```
d = Kithe::Model.find("1078446a-ae55-476f-84bb-2ea196154113")
d.create_derivatives
```