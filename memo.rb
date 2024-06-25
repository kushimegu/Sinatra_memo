# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'json'

memos = File.open("./sample.json") { |file| JSON.load(file) }

get '/' do
  @title = 'メモアプリ'
  @memos = memos
  erb :index
end

get '/new' do
  @title = 'メモアプリ'
  erb :new
end

memos.each do |key, value|
  get "/#{key}" do
    @title = 'メモアプリ'
    @id = 1
    @memo = value
    erb :show
  end

  get "/#{key}/edit" do
    @title = 'メモアプリ'
    @memo = value
    erb :edit
  end

end

delete '/:id' do
  @id = memos.delete(params[:id])
  redirect to("/")
end
