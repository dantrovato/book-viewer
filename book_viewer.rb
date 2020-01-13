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
  redirect "/" unless (1..@contents.size).cover? number
  # binding.pry
  @title = "Chapter #{number}: #{chapter_name}"
  # binding.pry
  erb(:chapter)
end

get "/search" do
  @results = []
  phrase = params[:query] ||= ""

  (1..@contents.size ).to_a.each_with_index do |n, index|
    chapter = File.read("data/chp#{n}.txt")
     if chapter.include?(phrase) && phrase != ""
       @results << @contents[index]
     end
  end

  @results
  erb(:search)
end

not_found do
  redirect "/"
end
