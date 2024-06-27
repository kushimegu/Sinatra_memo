# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'json'

helpers do
  def load_memos(file)
    File.open(file) { |file| JSON.parse(file.read) }
  end

  def save_memos(file, memos)
    File.open(file, 'w') do |file|
      JSON.dump(memos, file)
    end
  end
end

get '/' do
  @memos = load_memo("./sample.json")
  erb :index
end

get '/new' do
  erb :new
end

post '/new' do
  memos = File.exist?("./sample.json") ? JSON.parse(File.read("./sample.json")) : {}
  new_memo = { (memos.size + 1).to_s => { "title" => params[:title], "content" => params[:content] }}
  memos.merge!(new_memo)
  save_memos("./sample.json", memos)
  redirect to("/")
end

get "/:id" do
  @id = params[:id]
  @memo = load_memo("./sample.json")[@id.to_s]
  erb :show
end

get "/:id/edit" do
  @id = params[:id]
  @memo = load_memo("./sample.json")[@id.to_s]
  erb :edit
end

patch "/:id/edit" do
  @id = params[:id]
  @memos = load_memo("./sample.json")
  updated_memo = { @id => { "title" => params[:title], "content" => params[:content] }}
  @memos.update(updated_memo)
  save_memos("./sample.json", @memos)
  redirect to("/")
end

delete "/:id" do
  @id = params[:id]
  @memos = load_memo("./sample.json")
  @memos.delete(@id.to_s)
  save_memos("./sample.json", @memos)
  redirect to("/")
end
