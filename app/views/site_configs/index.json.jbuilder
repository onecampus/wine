json.array!(@site_configs) do |site_config|
  json.extract! site_config, :id, :key, :val, :img, :config_type
  json.url site_config_url(site_config, format: :json)
end
