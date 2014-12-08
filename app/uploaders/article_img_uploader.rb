# encoding: utf-8

class ArticleImgUploader < CarrierWave::Uploader::Base

  include CarrierWave::MiniMagick

  storage :file

  version :thumb do
    process :resize_to_fit => [196, 132]
  end

  def extension_white_list
    %w(jpg jpeg gif png)
  end

  def filename
    if original_filename
      @name ||= Digest::MD5.hexdigest(File.dirname(current_path))
      "#{@name}.#{file.extension}"
    end
  end
end
