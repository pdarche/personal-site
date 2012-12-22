require 'rubygems'
require 'bundler'
require 'base64'
require 'openssl'
require 'rubygems'
require 'hmac-sha1'
require 'base64'
require 'logger'

Bundler.require

require './helpers/partials'
require './helpers/crazylegs'
require './models'
require './zeo'

helpers Sinatra::Partials
helpers Sinatra::Crazylegs 

configure do
	set :root, File.dirname(__FILE__)

	$client = Fitgem::Client.new({
		:consumer_key => CONFIG[:fitbit][:auth][:consumer_key], 
		:consumer_secret => CONFIG[:fitbit][:auth][:consumer_secret], 
		:token => CONFIG[:fitbit][:auth][:access_token],
		:secret => CONFIG[:fitbit][:auth][:access_secret], 
		:user_id => CONFIG[:fitbit][:user_id]
	})
end

class Numeric
    def round_to( places )
        power = 10.0**places
        (self * power).round / power
    end
end

get '/' do
	@title = "pdarche"
	erb :home, :layout => :layout_home
end

get '/blog' do
	redirect('/blog/page/0')
end

get '/blog/page/:page' do
	last_post = params[:page].to_i * 4
	@posts = Post.all(:offset => last_post, :limit => 4, :order => [:id.desc])

	@tagHash = Hash.new {|h,k| h[k]=[]}
	
	@posts.each do |post|
		@tags = Tag.all(:postId => post.id)
		@tagHash[post.title] << @tags
	end
	
	@next_page = params[:page].to_i + 1
	@last_page = params[:page].to_i - 1	
	@title = "blog"
	@style = 'blog.css'
	@javascript = 'blog.js'
	erb :blog
end

get '/blog/:title' do
	title = params[:title].gsub('-', ' ').to_s
	@post = Post.first(:title => title)
	@comments = Comment.all(:postId => @post.id)
	p @comments
	@allTags = Tag.all(:fields => [:tag], :unique => true, :order => [:tag.asc])
	@postTags = Tag.all(:postId => @post.id)
	@javascript = 'full_post.js'
	@style = 'full_post.css'
	erb :full_post 
end

post '/blog/post_comment' do
	@comment = Comment.new(params[:new_comment])
	@comment.date = Time.now
	# postId = params[:postId].to_i
	# @comment.postId = postId

	p params[:new_comment]

	if @comment.save
		redirect '/blog/page/0'
	else
		p "you f'd up"
	end
end

get '/post_count' do
	post_count = Post.count.to_json
end

#code blocks for administering posts
get '/blog_admin' do
	#require_admin
	@posts = Post.all
	@title = "Blog Admin"
	@style = 'blog_admin.css'
	@javascript = 'blog_admin.js'
	erb :blog_admin
end

get '/get_post' do
	id = params[:id].to_i
	@post = Post.get(id).to_json
end

post '/update_post' do
	id = params[:id]
	@post = Post.get(id)
	@post.update(:title => params[:title], :tags => params[:tags], :body => params[:body], :intro_image_url => params[:intro_image_url], :image_urls => params[:image_urls], :video_url => params[:video_url])
	@post.update(:date => Time.now)
	if @post.save
		"success"
	else
		"u f'd up"
	end
end

get '/delete_post' do
	id = params[:id]
	puts id
	@post = Post.get(id)
	@post.destroy
	if @post.destroy
		"destroyed"
	else
		"not destroyed"
	end
end

post '/add_post' do
	@post = Post.new(params[:new_post])
	@post.date = Time.now

	if @post.save
		last = Post.last()
		postId = last.id.to_s
		tags = last.tags.split(', ')
		tags.each do |postTag|
			@tag = Tag.create(:tag => postTag, :postId => postId)

			if @tag.save
				puts "saved"
			else
				puts "f'd up"
			end
		end

		redirect('/blog_admin')
	else
		puts "you f'd up"
	end
end

get '/tag/:tag' do
	tag = params[:tag].gsub('-', ' ').to_s
	@tag = tag
	taggedPosts = Tag.all(:tag => tag)
	postIds = []
	@posts = []

	taggedPosts.each do |tag|
		postIds.push(tag.postId)
	end

	postIds.each do |id|
		@post = Post.get(id)
		@posts.push(@post)
	end

	@posts
	@style = 'tags.css'
	erb :searched_tag
end

enable :sessions

##### ABOUT PAGE
get '/about' do	
	auth = Auth.get(1)
	client = Fitgem::Client.new({:user_id => CONFIG[:fitbit][:user_id], :consumer_key => CONFIG[:fitbit][:auth][:consumer_key], :consumer_secret => CONFIG[:fitbit][:auth][:consumer_secret], :token => auth.access_token, :secret => auth.access_secret})
	request_token = client.request_token
	token = request_token.token
	secret = request_token.secret
	
	# GAWD THIS NEEDS TO BE CLEANED UP
	if auth.state == 0
		auth.state = 1

		if auth.save
			redirect('http://www.fitbit.com/oauth/authorize?oauth_token=' + token)
		else
			puts "you f'd up"
		end	

	elsif auth.state == 1
		auth.state = 2	 
		verifier = params[:oauth_verifier]
		token = params[:oauth_token]
		access_token = client.authorize(token, secret, { :oauth_verifier => verifier })
		auth.access_token = access_token.token
		auth.access_secret = access_token.secret 

		if auth.save
			puts "Verifier is: " + verifier + ", Token is:    "+access_token.token + ", Secret is:   "+ access_token.secret
		else
			puts "you f'd up"
		end
	
	elsif auth.state == 2

		#FITBIT DATA
		fitbitData = client.activities_on_date 'today'
		@steps = fitbitData['summary']['steps']

		#WITHINGS DATA
		userid = '110334'
		public_key = '507bc268681356f2'
		today = Time.now.to_i
		yestr = today.to_i - (24 * 60 * 60)

		url = 'http://wbsapi.withings.net/measure?action=getmeas&userid='
		url += "#{userid}&publickey=#{public_key}&startdate=#{yestr}&enddate=#{today}&limit=1";

		data = RestClient.get(url)
		data = JSON.parse(data.body)
		data = data['body']['measuregrps'][0]['measures'][0]['value'] * 0.00220462
		
		if data != nil 
			@weight = data.round_to(2)
		else
			@weight = 0
		end

		#ZEO DATA
		z = Zeo.new
		res = z.yesterdays_data()

		if res.has_key?("sleepStats")
			sleepMins = res["response"]["sleepStats"]["totalZ"]
			sleepHrs = sleepMins/60.0
			timeAr = sleepHrs.to_s.split('.')
			hrs = timeAr[0]
			mins = ('0.' + timeAr[1]).to_f * 60
			mins = mins.to_f
			mins = mins.round_to(2).to_i

			@hrs = hrs
			@mins = mins
		else
			@hrs = 0
			@mins = 0
		end
		#OPENPATHS DATA
		consumer_key = "YBT3QATFK3NCGWXT3EKEV2NC6GUHJM2IWLSGK4NEANZHUWDVKUOA"
		consumer_secret = "DUHON4YZGHHZL8NUGG4WKBDVTZTCGE0C3AHRYC25SI8CP06BTL1B6PTYNXQ7XH5N"
		base_url = "https://openpaths.cc/api/1"
		credentials = Crazylegs::Credentials.new(consumer_key,consumer_secret)
		url = Crazylegs::SignedURL.new(credentials, base_url,'GET')
		signed_url = url.full_url
		resp = HTTParty.get(signed_url)

	else 
		puts "you f'd up"
	end  

	@title = "about"
	@style = 'about.css'
	@javascript = 'about.js'
	erb :about
end

get '/projects' do
	@projects = Project.all(:order => [:id.desc], :limit => 6)
	@title = "projects"
	@style = 'projects.css'
	@javascript = 'projects.js'
	#@next_page = "projects/" + params[:num]
	erb :projects
end 

get '/getShortDescription' do
	@project = Project.all(:title => params[:title])
end

get '/projects/:id' do 
	@project = Project.get(params[:id])
	@style = 'project.css'
	@javascript = 'project.js'
	erb :project
end

get '/projects_admin' do
	@projects = Project.all
	@title = "projects admin"
	@style = 'projects_admin.css'
	@javascript = 'projects_admin.js'
	erb :projects_admin
end

get '/get_project' do
	id = params[:id].to_i
	@project = Project.get(id).to_json
end

post '/add_project' do
	@project = Project.new(params[:new_project])
	@project.date = Time.now
	
	if @project.save
		redirect('/projects_admin')
	else
		puts "you f'd up"
	end
end

get '/delete_project' do
	id = params[:id]
	project = Project.get(id)
	project.destroy
	if project.destroy
		"destroyed"
	else
		"not destroyed"
	end
end

post '/update_project' do
	id = params[:id]
	@project = Project.get(id)
	@project.update(:title => params[:title], :collaborators => params[:collaborators], :short_description => params[:short_description], :long_description => params[:long_description], :motivation => params[:motivation], :process => params[:process], :small_image_url => params[:small_image_url], :video_url => params[:video_url])

	if @project.save
		"success"
	else
		"u f'd up"
	end
end

get '/contact' do
	@title = "contact"
	@style = 'contact.css'
	@javascript = 'contact.js'
	erb :contact
end
