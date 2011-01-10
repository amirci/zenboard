require 'openid/store/filesystem'

Rails.application.config.middleware.use OmniAuth::Builder do
	provider :twitter, 'JBKSUc489yzWDzGGuLZoBg', 'ev14l3onHdxqvKc2YscyfhsjGUrxYgJDg8LjHPEPnk'
  provider :open_id, OpenID::Store::Filesystem.new('/tmp')
  provider :google_apps, OpenID::Store::Filesystem.new('/tmp'), :domain => 'gmail.com'
end