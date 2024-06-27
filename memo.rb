# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'json'

get '/' do
  @title = 'メモアプリ'
  @memos = File.open("./sample.json") { |file| JSON.parse(file.read) }
  erb :index
end

get '/new' do
  @title = 'メモアプリ'
  erb :new
end

post '/new' do
  existing_memos = File.exist?("./sample.json") ? JSON.parse(File.read("./sample.json")) : {}
  new_memo = { (existing_memos.size + 1).to_s => { "title" => params[:title], "content" => params[:content] }}
  existing_memos.merge!(new_memo)
  File.open("./sample.json", 'w') do |file|
    JSON.dump(existing_memos, file)
  end
  redirect to("/")
end

File.open("./sample.json") { |file| JSON.parse(file.read) }.each do |key, value|
  get "/#{key}" do
    @title = 'メモアプリ'
    @id = key
    @memo = value
    erb :show
  end

  get "/#{key}/edit" do
    @title = 'メモアプリ'
    @memo = value
    erb :edit
  end

  delete "/#{key}" do
    @id = key
    existing_memos = File.exist?("./sample.json") ? JSON.parse(File.read("./sample.json")) : {}
    existing_memos.delete(@id.to_s)
    File.open("./sample.json", 'w') do |file|
      JSON.dump(existing_memos, file)
    end
    redirect to("/")
  end
end


