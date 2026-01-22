# Required
json.set! :gbl_mdVersion_s, "BTAA Aardvark"

Element.exportable.each do |elm|
  if document.send(elm.export_value).is_a?(Array)
    if document.send(elm.export_value).any?(&:present?)
      json.set! elm.solr_field.to_s.to_sym, document.send(elm.export_value)
    end
  else
    json.set! elm.solr_field.to_s.to_sym, document.send(elm.export_value) unless document.send(elm.export_value).blank?
  end
end
