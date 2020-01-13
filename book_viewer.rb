require "sinatra"
require "sinatra/reloader"
require "tilt/erubis"
require "pry"

before do
  @contents = File.readlines('data/toc.txt')
end

helpers do
  def in_paragraphs(chap_content)
    chap_content.split("\n\n").map { |line| "<p>#{line}</p>" }.join 

  end
end

get "/" do
  @title = "The Adventures of Sherlock Holmes"
  erb(:home)
end

get "/chapters/:number" do
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
