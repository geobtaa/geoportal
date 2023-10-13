# Be sure to restart your server when you modify this file.

# Add new mime types for use in respond_to blocks:
# Mime::Type.register "text/richtext", :rtf

# GBL‡ADMIN
## Order is important. ActiveStorage needs :json to be last
Mime::Type.register "application/json", :json_aardvark
Mime::Type.register "application/json", :json_btaa_aardvark
Mime::Type.register "application/json", :json_file
Mime::Type.register "application/json", :json_gbl_v1
Mime::Type.register "application/json", :json

Mime::Type.register "text/csv", :csv_document_downloads
Mime::Type.register "text/csv", :csv_document_access_links
