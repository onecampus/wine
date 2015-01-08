class SiteConfigsController < ApplicationController
  authorize_resource
  respond_to :html, :json
  before_action :set_site_config, only: [:show, :edit, :update, :destroy]

  def edit_index_imgs
    @site_config1 = SiteConfig.where(key: 'CustomerIndexImgConfigKey1', config_type: 'CustomerIndexImgConfig').first
    @site_config2 = SiteConfig.where(key: 'CustomerIndexImgConfigKey2', config_type: 'CustomerIndexImgConfig').first
    @site_config3 = SiteConfig.where(key: 'CustomerIndexImgConfigKey3', config_type: 'CustomerIndexImgConfig').first
  end

  def show_index_imgs
    @site_config1 = SiteConfig.where(key: 'CustomerIndexImgConfigKey1', config_type: 'CustomerIndexImgConfig').first
    @site_config2 = SiteConfig.where(key: 'CustomerIndexImgConfigKey2', config_type: 'CustomerIndexImgConfig').first
    @site_config3 = SiteConfig.where(key: 'CustomerIndexImgConfigKey3', config_type: 'CustomerIndexImgConfig').first
  end

  def update_index_imgs
    @site_config1 = SiteConfig.where(key: 'CustomerIndexImgConfigKey1', config_type: 'CustomerIndexImgConfig').first
    @site_config2 = SiteConfig.where(key: 'CustomerIndexImgConfigKey2', config_type: 'CustomerIndexImgConfig').first
    @site_config3 = SiteConfig.where(key: 'CustomerIndexImgConfigKey3', config_type: 'CustomerIndexImgConfig').first
    @site_config1.val = params[:CustomerIndexImgConfigVal1]
    @site_config1.img = params[:CustomerIndexImgConfigImg1]
    @site_config1.save
    @site_config2.val = params[:CustomerIndexImgConfigVal2]
    @site_config2.img = params[:CustomerIndexImgConfigImg2]
    @site_config2.save
    @site_config3.val = params[:CustomerIndexImgConfigVal3]
    @site_config3.img = params[:CustomerIndexImgConfigImg3]
    @site_config3.save
    flash.notice = '首页活动图片更新成功'
    redirect_to action: :show_index_imgs
  end

  def index
    @site_configs = SiteConfig.all.paginate(page: params[:page], per_page: 10).order('id DESC')
    respond_with(@site_configs)
  end

  def show
    respond_with(@site_config)
  end

  def new
    @site_config = SiteConfig.new
    respond_with(@site_config)
  end

  def edit
  end

  def create
    @site_config = SiteConfig.new(site_config_params)
    flash[:notice] = 'SiteConfig was successfully created.' if @site_config.save
    respond_with(@site_config)
  end

  def update
    flash[:notice] = 'SiteConfig was successfully updated.' if @site_config.update(site_config_params)
    respond_with(@site_config)
  end

  def destroy
    @site_config.destroy
    respond_with(@site_config)
  end

  private
    def set_site_config
      @site_config = SiteConfig.find(params[:id])
    end

    def site_config_params
      params.require(:site_config).permit(:key, :val, :img, :config_type)
    end
end
