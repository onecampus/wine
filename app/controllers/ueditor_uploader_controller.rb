class UeditorUploaderController < ApplicationController
  skip_before_filter :verify_authenticity_token, only: [:index]
  def index
    action = request.query_parameters[:action]
    return_hash = {}
    case action
    when 'config'
      return_hash = {
        imageActionName: 'uploadimage',
        imageFieldName: 'upfile',
        imageMaxSize: 2048000,
        imageAllowFiles: ['.png', '.jpg', '.jpeg', '.gif', '.bmp'],
        imageCompressEnable: true,
        imageCompressBorder: 1600,
        imageInsertAlign: 'none',
        imageUrlPrefix: '',
        imagePathFormat: '/uploads/ueditor/images',

        scrawlActionName: 'uploadscrawl',
        scrawlFieldName: 'upfile',
        scrawlPathFormat: '/uploads/ueditor/scrawls',
        scrawlMaxSize: 2048000,
        scrawlUrlPrefix: '',
        scrawlInsertAlign: 'none',

        snapscreenActionName: 'uploadimage',
        snapscreenPathFormat: '/uploads/ueditor/snapscreens',
        snapscreenUrlPrefix: '',
        snapscreenInsertAlign: 'none',

        catcherLocalDomain: ['127.0.0.1', 'localhost', 'img.baidu.com'],
        catcherActionName: 'catchimage',
        catcherFieldName: 'source',
        catcherPathFormat: '/ueditor/php/upload/image/{yyyy}{mm}{dd}/{time}{rand:6}',
        catcherUrlPrefix: '',
        catcherMaxSize: 2048000,
        catcherAllowFiles: ['.png', '.jpg', '.jpeg', '.gif', '.bmp'],

        videoActionName: 'uploadvideo',
        videoFieldName: 'upfile',
        videoPathFormat: '/uploads/ueditor/videos',
        videoUrlPrefix: '',
        videoMaxSize: 102400000,
        videoAllowFiles: [
          '.flv', '.swf', '.mkv', '.avi', '.rm', '.rmvb', '.mpeg', '.mpg',
          '.ogg', '.ogv', '.mov', '.wmv', '.mp4', '.webm', '.mp3', '.wav', '.mid'
        ],

        fileActionName: 'uploadfile',
        fileFieldName: 'upfile',
        filePathFormat: '/uploads/ueditor/files',
        fileUrlPrefix: '',
        fileMaxSize: 51200000,
        fileAllowFiles: [
          '.png', '.jpg', '.jpeg', '.gif', '.bmp',
          '.flv', '.swf', '.mkv', '.avi', '.rm', '.rmvb', '.mpeg', '.mpg',
          '.ogg', '.ogv', '.mov', '.wmv', '.mp4', '.webm', '.mp3', '.wav', '.mid',
          '.rar', '.zip', '.tar', '.gz', '.7z', '.bz2', '.cab', '.iso',
          '.doc', '.docx', '.xls', '.xlsx', '.ppt', '.pptx', '.pdf', '.txt', '.md', '.xml'
        ],

        imageManagerActionName: 'listimage',
        imageManagerListPath: '/uploads/ueditor/images',
        imageManagerListSize: 20,
        imageManagerUrlPrefix: '',
        imageManagerInsertAlign: 'none',
        imageManagerAllowFiles: ['.png', '.jpg', '.jpeg', '.gif', '.bmp'],

        fileManagerActionName: 'listfile',
        fileManagerListPath: '/uploads/ueditor/files',
        fileManagerUrlPrefix: '',
        fileManagerListSize: 20,
        fileManagerAllowFiles: [
          '.png', '.jpg', '.jpeg', '.gif', '.bmp',
          '.flv', '.swf', '.mkv', '.avi', '.rm', '.rmvb', '.mpeg', '.mpg',
          '.ogg', '.ogv', '.mov', '.wmv', '.mp4', '.webm', '.mp3', '.wav', '.mid',
          '.rar', '.zip', '.tar', '.gz', '.7z', '.bz2', '.cab', '.iso',
          '.doc', '.docx', '.xls', '.xlsx', '.ppt', '.pptx', '.pdf', '.txt', '.md', '.xml'
        ]
      }
    when 'uploadimage'
      image = UeditorImageUploader.new
      image.store!(params[:upfile])
      return_hash = {
        state: 'SUCCESS',
        url: image.url,
        title: image.filename,
        original: image.filename
      }
    when 'listimage'
      size = params[:size].to_i
      start_size = params[:start].to_i
      end_size = size + start_size
      list_imgs = list_files 'images'
      list_imgs_as_hash = []
      list_imgs.each { |filename| list_imgs_as_hash.push({url: '/uploads/ueditor/images/' + filename}) }
      return_hash = {
        state: 'SUCCESS',
        list: list_imgs_as_hash,
        start: start_size,
        total: list_imgs.count
      }
    else
      return_hash[:state] = '请求地址出错'
    end
    render json: return_hash
  end

  private

  def list_files(path)
    Dir.chdir(Rails.root.join('public', 'uploads', 'ueditor', path))
    Dir.glob('*')
  end
end
