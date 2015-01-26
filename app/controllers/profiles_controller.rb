
class ProfilesController < ApplicationController
  authorize_resource

  respond_to :html, :json

  before_action :set_profile, only: [:show, :edit, :update, :destroy]

  require 'will_paginate/array'

  def index
    @profiles = []
    if params[:role] == 'provider' && params[:type] == 'all' # 所有区域供应商
      Role.find_by_name('provider').users.order('id DESC').each do |u|
        @profiles.push(u.profile) if !u.profile.nil?
      end
      @profiles = @profiles.paginate(:page => params[:page], :per_page => 10)
    elsif params[:role] == 'customer' && params[:type] == 'all' # 所有客户
      role = Role.find_by_name('customer')
      if !role.nil?
        Role.find_by_name('customer').users.order('id DESC').each do |u|
          @profiles << u.profile
        end
      end
      @profiles = @profiles.paginate(:page => params[:page], :per_page => 10)
    elsif params[:role] == 'customer' && params[:type] == 'own' # 区域供应商自己区域的客户
      @profiles= Profile.where(supplier_id: current_user.id).paginate(:page => params[:page], :per_page => 10).order('id DESC')
    else
      @profiles = @profiles.paginate(:page => params[:page], :per_page => 10)
    end
  end

  def show
  end

  def new
    @profile = Profile.new
  end

  def edit
  end

  def create
    @profile = Profile.new(profile_params)
    @user = User.new(:username => params[:username], :email => params[:email], :password => params[:password], :password_confirmation => params[:password_confirmation])

    Profile.transaction do
      User.transaction do
        @user.save!
        @user.confirm!
        @user.add_role 'provider'
      end
      @profile.user_id = @user.id
      flash[:notice] = '用户创建成功' if @profile.save!
    end
    respond_with(@profile)
  end

  def update
    @user = @profile.user
    user_params = {:username => params[:username], :email => params[:email], :password => params[:password], :password_confirmation => params[:password_confirmation]}
    if user_params[:password].blank? || user_params[:password_confirmation].blank?
      user_params.delete(:password)
      user_params.delete(:password_confirmation)
    end
    User.transaction do
      @user.update!(user_params)
      @profile.user_id = @user.id
      flash[:notice] = '用户资料更新成功' if @profile.update!(profile_params)
    end
    respond_with(@profile)
  end

  def destroy
    User.transaction do
      @profile.user.remove_role 'provider'
      @profile.user.destroy!
      @profile.destroy!
    end
    redirect_to :back, notice: '删除成功'
  end

  private

  def set_profile
    @profile = Profile.find(params[:id])
  end

  def profile_params
    params.require(:profile).permit(:user_id, :parent_id, :lft, :rgt, :depth, :mobile, :tel, :province, :city, :region, :address, :fax, :invite_code, :share_link_code, :default_address_id, :weixin_open_id)
  end
end
