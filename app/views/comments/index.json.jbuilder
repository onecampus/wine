json.array!(@comments) do |comment|
  json.extract! comment, :id, :commentable_id, :commentable_type, :title, :body, :subject, :user_id, :parent_id, :lft, :rgt
  json.url comment_url(comment, format: :json)
end
