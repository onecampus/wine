json.array!(@wx_menus) do |wx_menu|
  json.extract! wx_menu, :id, :name, :msg, :url, :msg_or_url, :button_type, :key, :parent_id, :level
  json.url wx_menu_url(wx_menu, format: :json)
end
