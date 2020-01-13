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

# Calls the block for each chapter, passing that chapter's number, name, and
# contents.
def each_chapter
  @contents.each_with_index do |name, number|
    number += 1
    # binding.pry
    contents = File.read("data/chp#{number}.txt")
    yield number, name, contents
  end
end

# This method returns an Array of Hashes representing chapters that match the
# specified query. Each Hash contain values for its :name and :number keys.
def chapters_matching(query)
  results = []

  return results if !query || query.empty?

  each_chapter do |number, name, contents|
    results << {number: number, name: name} if contents.include?(query)
  end

  results
end

get "/search" do
  @results = chapters_matching(params[:query])
  erb :search
end

# get "/search" do
#   @results = []
#   phrase = params[:query] ||= ""
#
#   (1..@contents.size ).to_a.each_with_index do |n, index|
#     chapter = File.read("data/chp#{n}.txt")
#      if chapter.include?(phrase) && phrase != ""
#        @results << @contents[index]
#      end
#   end
#
#   @results
#   erb(:search)
# end

not_found do
  redirect "/"
end
