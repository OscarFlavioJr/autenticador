require 'json'
require 'dotenv/load'

users = File.readlines(ENV['usuarios']).map{ |line| line.chomp.strip }

puts users
