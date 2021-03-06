class User < ActiveRecord::Base
  def self.create_with_omniauth(hash)
    create! do |user|
      user.provider = hash['provider']
      user.uid = hash['uid']
      user.name = hash['info']['name']
      user.screen_name = hash['info']['nickname']
    end
  end
end
