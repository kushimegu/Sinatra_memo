# frozen_string_literal: true

require 'sinatra'
require 'pg'

CONN = PG.connect(dbname: 'sinatra_memo_db')

def load_memos
  CONN.exec('SELECT * FROM memos ORDER BY id')
end

def load_memo(id)
  CONN.exec_params('SELECT * FROM memos WHERE id = $1', [id]).first
end

def create_memo(params)
  CONN.exec_params('INSERT INTO memos (title, content) VALUES ($1, $2)', params.values_at(:title, :content))
end

def update_memo(params)
  CONN.exec_params('UPDATE memos SET title = $1, content = $2 WHERE id = $3', params.values_at(:title, :content, :id))
end

def delete_memo(id)
  CONN.exec_params('DELETE FROM memos WHERE id = $1', [id])
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
  create_memo(params)
  redirect to('/memos')
end

get '/memos/:id' do
  @memo = load_memo(params[:id])
  if @memo
    erb :show
  else
    status 404
  end
end

get '/memos/:id/edit' do
  @memo = load_memo(params[:id])
  if @memo
    erb :edit
  else
    status 404
  end
end

patch '/memos/:id' do
  update_memo(params)
  redirect to("/memos/#{params[:id]}")
end

delete '/memos/:id' do
  delete_memo(params[:id])
  redirect to('/memos')
end
