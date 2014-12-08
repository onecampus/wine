class ArticlesController < ApplicationController

  authorize_resource

  respond_to :html, :json
  before_action :set_article, only: [:show, :edit, :update, :destroy]

  def index
    @articles = Article.all.paginate(page: params[:page],
                                     per_page: 10).order('id DESC')
    respond_with(@articles)
  end

  def show
    respond_with(@article)
  end

  def new
    @article = Article.new
    @categories = Cat.nested_set.select('id, title, content, parent_id')
    respond_with(@article)
  end

  def edit
  end

  def create
    @article = Article.new(article_params)
    @article.user_id = current_user.id if current_user
    tags = params[:tags].split(',')
    @article.save
    tags.each do |t|
      @article.tag_list.add(t)
    end
    respond_with(@article)
  end

  def update
    tags = params[:tags].split(',')
    @article.tag_list = ''
    @article.save
    @article.reload
    tags.each do |t|
      @article.tag_list.add(t)
    end
    @article.update(article_params)
    respond_with(@article)
  end

  def destroy
    @article.tag_list = ''
    @article.save
    @article.reload
    @article.destroy
    respond_with(@article)
  end

  private
    def set_article
      @article = Article.find(params[:id])
      @categories = Cat.nested_set.select('id, title, content, parent_id')
    end

    def article_params
      params.require(:article).permit(:title, :summary, :content,
                                      :markdown_content, :user_id,
                                      :author, :img, :publish_time,
                                      :cat_id, :is_hot, :is_published,
                                      :is_recommend, :can_comment,
                                      :start_time, :end_time, :address,
                                      :speaker, :emcee, :organizer,
                                      :sponsor, :source)
    end
end
