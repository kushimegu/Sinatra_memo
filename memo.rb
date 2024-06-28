# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'json'

helpers do
  def load_memos(source_file)
    File.open(source_file) { |file| JSON.parse(file.read) }
  end

  def save_memos(source_file, memos)
    File.open(source_file, 'w') do |file|
      JSON.dump(memos, file)
    end
  end

  def escape_html(text)
    Rack::Utils.escape_html(text)
  end
end

get '/memos' do
  @memos = load_memos('./sample.json')
  erb :index
end

get '/memos/new' do
  erb :new
end

post '/memos' do
  memos = load_memos('./sample.json')
  max_memo_id = memos.keys.max.to_i
  new_memo = { (max_memo_id + 1).to_s => { 'title' => escape_html(params[:title]), 'content' => escape_html(params[:content]) } }
  memos.merge!(new_memo)
  save_memos('./sample.json', memos)
  redirect to('/memos')
end

get '/memos/:id' do
  @id = params[:id]
  @memo = load_memos('./sample.json')[@id.to_s]
  erb :show
end

get '/memos/:id/edit' do
  @id = params[:id]
  @memo = load_memos('./sample.json')[@id.to_s]
  erb :edit
end

patch '/memos/:id' do
  @id = params[:id]
  @memos = load_memos('./sample.json')
  updated_memo = { @id => { 'title' => params[:title], 'content' => params[:content] } }
  @memos.update(updated_memo)
  save_memos('./sample.json', @memos)
  redirect to('/memos')
end

delete '/memos/:id' do
  @id = params[:id]
  @memos = load_memos('./sample.json')
  @memos.delete(@id.to_s)
  save_memos('./sample.json', @memos)
  redirect to('/memos')
end
