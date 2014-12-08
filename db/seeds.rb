puts '==' * 20
puts 'start seeds'

time_start = Time.now


cats = [
  {name: "白酒", title: "白酒", content: "白酒", secret_field: "secret_field"},
  {name: "红酒", title: "红酒", content: "红酒", secret_field: "secret_field"},
  {name: "葡萄酒", title: "葡萄酒", content: "葡萄酒", secret_field: "secret_field"},
  {name: "其他", title: "其他", content: "其他", secret_field: "secret_field"}
]

cats.each do |c|
  Cat.create! c
end

1.upto(50).each do |i|
  if i == 1
    u = User.new(username: 'admin', email: 'admin@gmail.com',
                 password: '12345678', password_confirmation: '12345678')
    u.save
    u.confirm!
    u.add_role :admin
    Profile.create(:user_id => u.id, :mobile => "135604744#{u.id}", :tel => "5555#{u.id}", :province => '广东省', :city => '广州市', :region => '番禺区', :address => '小谷围', :fax => "55555")
  elsif Array(2..10).include?(i)
    u = User.new(:username => "provider#{i}", :email => "provider#{i}@gmail.com", :password => "12345678", :password_confirmation => "12345678")
    u.save
    u.confirm!
    u.add_role :provider
    Profile.create(:user_id => u.id, :mobile => "135604744#{u.id}", :tel => "5555#{u.id}", :province => '广东省', :city => '广州市', :region => '番禺区', :address => '小谷围', :fax => "55555")
  else
    u = User.new(:username => "customer#{i}", :email => "customer#{i}@gmail.com", :password => "12345678", :password_confirmation => "12345678")
    u.save
    u.confirm!
    u.add_role :customer
    Profile.create(:supplier_id => rand(10), :user_id => u.id, :mobile => "135604744#{u.id}", :tel => "5555#{u.id}", :province => '广东省', :city => '广州市', :region => '番禺区', :address => '小谷围', :fax => '55555')
  end
end


time_end = Time.now
time = time_end - time_start
puts time.to_s
puts 'end seeds'
puts '==' * 20
