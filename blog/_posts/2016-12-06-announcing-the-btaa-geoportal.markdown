---
layout: post
title:  "Announcing the Big Ten Academic Alliance Geoportal"
date:   2016-12-06
---

The [Big Ten Academic Alliance Geospatial Data Project](https://z.umn.edu/btaagdp) (formerly CIC Geospatial Data Discovery Project) has launched the Big Ten Academic Alliance Geoportal, built with [GeoBlacklight](http://geoblacklight.org/). This project is collectively managed by a task force of librarians and geospatial specialists at ten research institutions from across the [Big Ten Academic Alliance](http://www.btaa.org/). These institutions have collaboratively aggregated and edited thousands of metadata records from multiple GIS data clearinghouses, FTP sites, and library catalogs.

## Background
The Big Ten Academic Alliance Geospatial Data Project began in 2015 to provide discoverability, facilitate access, and connect scholars across the Big Ten Academic Alliance to geospatial data resources. The project’s current outputs include a public geoportal, a harvestable collection of well over 3000 geospatial records in a uniform metadata standard, and workflow documentation.  

## The GeoBlacklight Choice
A few months after the project began, the task force met in Minneapolis for a Project Summit. One of the key decisions made at the Summit was the selection of GeoBlacklight for the geoportal platform. Some of the key features of the application that appealed to the task force were the intuitive faceting options, the durability of URL addresses, and the responsive, mobile friendly interface.  Another contributing factor was the accessibility of the [GeoBlacklight metadata schema](https://github.com/geoblacklight/geoblacklight-schema), which represents a library-centric approach to geospatial metadata with a focus on discoverability.

## Workflow
A significant challenge to this project has been combining metadata records from multiple sources. Because of the wide variations between metadata standards and levels of completeness, it has not been possible to blindly ingest and publish the records.  Our strategy to address this has resulted in the following five-step metadata workflow:

 **1. Submit Records:** Task force members identify and collect metadata records in the form of individual files, harvestable links, or downloadable datasets.

 **2. Metadata Transition:** The Project Metadata Coordinator cleans, transforms, and adds template information to the records.

 **3. Edit Records:** Records are uploaded to an online editor: GeoNetwork for GIS datasets or Omeka for digitized maps. Task force members and the Project Metadata Coordinator can then work together to edit the records manually or with a spreadsheet update process.

[GeoNetwork](http://geonetwork-opensource.org/): This application is used for editing metadata for GIS datasets in the ISO 19115 standard. Records are exported from GeoNetwork using Catalog Service for the Web operations as ISO 19139 XML and GeoBlacklight JSON files.  

[Omeka](http://omeka.org/): This application is used for editing metadata records for digitized maps in the Dublin Core/ Geoblacklight standard.  An essential part of this tool's usefulness is New York University's [GeoBlacklight Metadata](https://github.com/sgbalogh/omeka_GeoBlacklightMetadata-JSON) plugin to edit and export the records into the GeoBlacklight standard.

**4. Publish Records:** The approved records are published to both [OpenGeoMetadata](https://github.com/OpenGeoMetadata) and to [Solr](http://lucene.apache.org/solr/), the back indexing engine for the geoportal.

**5. Maintenance:** The final step of the workflow involves periodic spot checks and database comparisons with the source web portals to keep the records current and error-free.

## Collaborations

 The core of this project is collaboration between many different groups.  

 There are over 20 task force members from 10 different universities working together to plan the project and build a collection of metadata records. In addition to these activities, many members have also worked together over the past year to deliver joint conference presentations, create posters, and publish papers about the project.

 In many regions, the process of curating public geospatial records has served to strengthen the lines of communication between university library staff and local geospatial repositories.  The task force members have been able to find out more about how GIS clearinghouses operate and offer their own knowledge about best practices in metadata management.

 The project is heavily supported by the dedicated resources provided by the University of Minnesota Libraries Web Development department. The project's GeoNetwork and GeoBlacklight applications are hosted at the University of Minnesota. The Web Development team has also been able to contribute their advanced skills in managing and customizing these open source technologies.

 Finally, the project has benefited from many developments made across the growing geospatial community in recent years. In particular, it is indebted to the contributors of [OpenGeoportal](http://opengeoportal.org/),  GeoBlacklight, and OpenGeoMetadata.
