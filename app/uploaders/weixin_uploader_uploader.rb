# encoding: utf-8

class WeixinUploaderUploader < CarrierWave::Uploader::Base

  # include CarrierWave::MiniMagick

  storage :file

  def extension_white_list
    %w(bmp jpg jpeg gif png)
  end

  def filename
    if original_filename
      @name ||= Digest::MD5.hexdigest(File.dirname(current_path))
      "#{@name}.#{file.extension}"
    end
  end

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    'uploads/weixin/images'
  end
end
