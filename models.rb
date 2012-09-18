DataMapper::setup(:default, "sqlite3://#{Dir.pwd}/projects.db")

	class Project

		include DataMapper::Resource

		property :id, 					Serial
		property :date, 				Date
		property :title, 				String
		property :collaborators,		String
		property :short_description,	Text
		property :long_description,		Text
		property :motivation,			Text
		property :process,				Text
		property :small_image_url,		String
		property :video_url,			String  

	end

	class Post

		include DataMapper::Resource

		property :id, 					Serial
		property :date,					Date
		property :title,				String
		property :body,					Text
		property :tags,					String
		property :intro_image_url,		String
		property :image_urls, 			String
		property :video_url,			String

	end

	class Tag

		include DataMapper::Resource

		property :id, 					Serial
		property :tag,					String
		property :postId,				String 
	
	end

	class Comment 

		include DataMapper::Resource

		property :id, 					Serial
		property :postId,				String
		property :date, 				Date
		property :commenter,			String
		property :comment, 				Text

	end 

	class Auth

		include DataMapper::Resource

		property :id, 					Serial
		property :user_id,				String
		property :consumer_key,			String
		property :consumer_secret,		String
		property :access_token,			String
		property :access_secret,		String
		property :state,				Integer

	end

DataMapper.finalize

DataMapper.auto_upgrade!