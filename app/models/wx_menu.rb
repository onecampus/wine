class WxMenu < ActiveRecord::Base

  private

  require 'securerandom'
  def self.generate_key
    SecureRandom.hex
  end
end
