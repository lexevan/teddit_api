require 'pry'
require 'rest-client'
require "JSON"

def calculate_upvotes(story, category)
  upvotes = 1

  upvotes *= 5 if story.downcase.include? 'cats' or category.downcase.include? 'cats'
  upvotes *= 8 if story.downcase.include? 'bacon' or category.downcase.include? 'bacon'
  upvotes *= 3 if story.downcase.include? 'food' or category.downcase.include? 'food'

  upvotes
end

url = "http://reddit.com/.json"

puts "We're going to check the top posts on reddit. Would you like to check a subreddit instead?"
user_response = gets.strip

if user_response != "no"
  puts "Great! Let's do that. Please give me a subreddit topic to check."
  subreddit_topic = gets.strip
  url = "http://reddit.com/r/#{subreddit_topic}.json"
end

response = RestClient.get(url)

parsed_response = JSON.parse(response)

posts = []

parsed_response['data']['children'].map { |post|
  title = post['data']['title']
  category = post['data']['subreddit']
  upvotes = calculate_upvotes(title,category)
  post = {title: title, category: category, upvotes: upvotes}
  posts << post
}

posts.each do |post|
  puts "Title: #{post[:title]}"
  puts "Category: #{post[:category].capitalize}"
  puts "Current Upvotes: #{post[:upvotes]}"
  puts
end