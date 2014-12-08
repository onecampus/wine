class CreateArticles < ActiveRecord::Migration
  def change
    create_table :articles do |t|
      t.string :title
      t.text :summary
      t.text :content
      t.text :markdown_content
      t.integer :user_id
      t.string :author
      t.string :img
      t.datetime :publish_time
      t.integer :cat_id
      t.integer :is_hot
      t.integer :is_published
      t.integer :is_recommend
      t.integer :can_comment
      t.datetime :start_time
      t.datetime :end_time
      t.text :address
      t.string :speaker
      t.string :emcee
      t.string :organizer
      t.string :sponsor
      t.string :source

      t.timestamps
    end
  end
end
