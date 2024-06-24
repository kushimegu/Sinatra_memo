# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'json'

get '/' do
  @title = 'メモアプリ'
  @memos = File.open("./sample.json") { |file| JSON.load(file) }
  erb :index
end

get '/new' do
  @title = 'メモアプリ'
  erb :new
end
