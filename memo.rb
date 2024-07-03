# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'json'

helpers do
  def h(text)
    Rack::Utils.escape_html(text)
  end
end

FILE = './memos.json'

def load_memos(source_file)
  File.open(source_file) { |file| JSON.parse(file.read) }
end

def save_memos(source_file, memos)
  File.open(source_file, 'w') { |file| JSON.dump(memos, file) }
end

not_found do
  '存在しないページです'
end

get '/memos' do
  @memos = load_memos(FILE)
  erb :index
end

get '/memos/new' do
  erb :new
end

post '/memos' do
  memos = load_memos(FILE)
  max_memo_id = memos.keys.max.to_i
  new_memo = { (max_memo_id + 1).to_s => { 'title' => params[:title], 'content' => params[:content] } }
  memos.merge!(new_memo)
  save_memos(FILE, memos)
  redirect to('/memos')
end

get '/memos/:id' do
  @memo = load_memos(FILE)[params[:id]]
  if @memo
    erb :show
  else
    status 404
  end
end

get '/memos/:id/edit' do
  @memo = load_memos(FILE)[params[:id]]
  if @memo
    erb :edit
  else
    status 404
  end
end

patch '/memos/:id' do
  @memos = load_memos(FILE)
  updated_memo = { params[:id] => { 'title' => params[:title], 'content' => params[:content] } }
  @memos.update(updated_memo)
  save_memos(FILE, @memos)
  redirect to("/memos/#{params[:id]}")
end

delete '/memos/:id' do
  @memos = load_memos(FILE)
  @memos.delete(params[:id])
  save_memos(FILE, @memos)
  redirect to('/memos')
end
