json.response do
  json.docs @presenter.documents
  json.pages @presenter.pagination_info
end
