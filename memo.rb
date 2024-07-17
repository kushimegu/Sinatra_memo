# frozen_string_literal: true

require 'sinatra'
require 'pg'

def conn 
  PG.connect( dbname: 'sinatra_memo_db')
end

not_found do
  '存在しないページです'
end

get '/memos' do
  @memos = conn.exec( "SELECT * FROM memos" )
  erb :index
end

get '/memos/new' do
  erb :new
end

post '/memos' do
  conn.exec_params( "INSERT INTO memos (title, content) VALUES ($1, $2)", [params[:title], params[:content]])
  redirect to('/memos')
end

get '/memos/:id' do
  @memo = conn.exec_params( "SELECT * FROM memos WHERE id=$1", [params[:id]])
  if @memo
    erb :show
  else
    status 404
  end
end

get '/memos/:id/edit' do
  @memo = conn.exec_params( "SELECT * FROM memos WHERE id=$1", [params[:id]] )
  if @memo
    erb :edit
  else
    status 404
  end
end

patch '/memos/:id' do
  conn.transaction do
    conn.exec_params( "UPDATE memos SET title=$1 WHERE id=$2", [params[:title], params[:id]])
    conn.exec_params( "UPDATE memos SET content=$1 WHERE id=$2", [params[:content], params[:id]])
  end
  redirect to("/memos/#{params[:id]}")
end

delete '/memos/:id' do
  conn.exec_params( "DELETE FROM memos WHERE id=$1", [params[:id]])
  redirect to('/memos')
end
