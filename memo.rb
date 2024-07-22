# frozen_string_literal: true

require 'sinatra'
require 'pg'

CONN = PG.connect(dbname: 'sinatra_memo_db')

def load_memo
  CONN.exec_params('SELECT * FROM memos WHERE id=$1', [params[:id]]).first
end

not_found do
  '存在しないページです'
end

get '/memos' do
  @memos = CONN.exec('SELECT * FROM memos ORDER BY id')
  erb :index
end

get '/memos/new' do
  erb :new
end

post '/memos' do
  CONN.exec_params('INSERT INTO memos (title, content) VALUES ($1, $2)', [params[:title], params[:content]])
  redirect to('/memos')
end

get '/memos/:id' do
  @memo = load_memo
  if @memo
    erb :show
  else
    status 404
  end
end

get '/memos/:id/edit' do
  @memo = load_memo
  if @memo
    erb :edit
  else
    status 404
  end
end

patch '/memos/:id' do
  params = { 1 => params[:title], 2 => params[:content], 3 => params[:id] }
  CONN.exec_params('UPDATE memos SET title=$1, content=$2 WHERE id=$3', params)
  redirect to("/memos/#{params[:id]}")
end

delete '/memos/:id' do
  CONN.exec_params('DELETE FROM memos WHERE id=$1', [params[:id]])
  redirect to('/memos')
end
