require "sinatra"
require "sinatra/reloader"
require "tilt/erubis"
require "pry"

get "/" do
  @title = "The Adventures of Sherlock Holmes"
  @contents = File.readlines('data/toc.txt')
  erb(:home)
end

get "/chapters/:number" do
  @contents = File.readlines('data/toc.txt')
  number = params[:number].to_i
  chapter_name = @contents[number - 1] 
  @chapter = File.read("data/chp#{number}.txt")
  # binding.pry
  @title = "Chapter #{number}: #{chapter_name}"

  # binding.pry

  erb(:chapter)
end

get "/show/:name" do
  params[:name]
end
