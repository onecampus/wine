json.array!(@profiles) do |profile|
  json.extract! profile, :id, :user_id, :parent_id, :lft, :rgt, :depth, :mobile, :tel, :province, :city, :region, :address, :fax, :invite_code, :share_link_code, :default_address_id, :weixin_open_id
  json.url profile_url(profile, format: :json)
end
