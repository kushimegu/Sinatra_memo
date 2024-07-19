# Sinatra_memo
## アプリの概要
Sinatraを使ったJSON形式でデータを保存する簡単なメモアプリ。メモ一覧の表示、新規メモの作成、メモ詳細の表示と編集、削除を行うことができる。
## アプリの立ち上げ方
1. リポジトリをクローンする
```bash
$ git clone https://github.com/kushimegu/Sinatra_memo.git
```
2. リポジトリへ移動する
```bash
$ cd Sinatra_memo
```
3. Gemをインストールする
```bash
$ bundle install
```
4. postgresqlをインストールし、データベースに接続する
5. データベースを作成する
```sql
=# CREATE DATABASE sinatra_memo_db;
```
6. SQLファイルを元にデータベースにテーブルを作成する
```bash
$ psql -d sinatra_memo_db -f create_table.sql
```
7. アプリを実行する
```bash
$ bundle exec ruby memo.rb
```
8. ブラウザで[localhost:4567/memos](http://localhost:4567/memos)にアクセスする
