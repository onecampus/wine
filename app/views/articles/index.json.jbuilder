json.array!(@articles) do |article|
  json.extract! article, :id, :title, :summary, :content, :markdown_content, :user_id, :author, :img, :publish_time, :cat_id, :is_hot, :is_published, :is_recommend, :can_comment, :start_time, :end_time, :address, :speaker, :emcee, :organizer, :sponsor, :source
  json.url article_url(article, format: :json)
end
