if defined?(ActiveRecordQueryTrace) && Rails.env.development?
  ActiveRecordQueryTrace.enabled = true
end