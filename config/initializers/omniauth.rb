Rails.application.config.middleware.use OmniAuth::Builder do
	provider :twitter, 'JBKSUc489yzWDzGGuLZoBg', 'ev14l3onHdxqvKc2YscyfhsjGUrxYgJDg8LjHPEPnk'
	provider :facebook, 'APP_ID', 'APP_SECRET'
end