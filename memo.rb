# frozen_string_literal: true

require 'sinatra'
require 'json'


MEMOS_FILE = './memos.json'

def load_memos
  File.open(MEMOS_FILE) { |file| JSON.parse(file.read) }
end

def save_memos(memos)
  File.open(MEMOS_FILE, 'w') { |file| JSON.dump(memos, file) }
end

not_found do
  '存在しないページです'
end

get '/memos' do
  @memos = load_memos
  erb :index
end

get '/memos/new' do
  erb :new
end

post '/memos' do
  memos = load_memos
  new_memo = { SecureRandom.uuid => { 'title' => params[:title], 'content' => params[:content] } }
  memos.merge!(new_memo)
  save_memos(memos)
  redirect to('/memos')
end

get '/memos/:id' do
  @memo = load_memos[params[:id]]
  if @memo
    erb :show
  else
    status 404
  end
end

get '/memos/:id/edit' do
  @memo = load_memos[params[:id]]
  if @memo
    erb :edit
  else
    status 404
  end
end

patch '/memos/:id' do
  memos = load_memos
  memos[params[:id]] = { 'title' => params[:title], 'content' => params[:content] }
  save_memos(memos)
  redirect to("/memos/#{params[:id]}")
end

delete '/memos/:id' do
  memos = load_memos
  memos.delete(params[:id])
  save_memos(memos)
  redirect to('/memos')
end
