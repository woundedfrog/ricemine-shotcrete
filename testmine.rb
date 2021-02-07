
ENV['APP_ENV'] = 'test'

require './ricemine-shotcrete'
require 'test/unit'
require 'rack/test'
require 'sinatra/base'
require 'minitest/autorun'
require 'minitest/spec'
require 'json'
require 'pry'
require 'cgi'
require 'rspec'
require 'net/http'

class RicemineTest < Minitest::Test
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  def test_loads_profile
    failed = []
    failed2 = []
    locale = REGION == "JAPAN" ? 'jp' : 'en'
        db = JSON.parse(File.read("data/childs/CharacterDatabase#{locale.capitalize}.json"))
        ref = JSON.parse(File.read("data/childs/characterRefList#{locale.capitalize}.json"))
        names = ref.map {|k| k['en_name']}
        idx = ref.map {|k| k['idx'] }
        idx.each do |id|
          p id
          star = []
          db.each {|k| star = k['grade'] if k['idx'] == id }
          name = ''
          ref.each { |unit| name = unit['en_name'] if unit['idx'] == id}
          next if name.count("a-zA-Z") == 0
          failed << profiles(star, name)
          failed2 << profiles2(star, name)
        end
        puts 'normal units'
        p failed.flatten
        puts 'ignited units'
        p failed2.flatten
  end

  def profiles(star, name)
    failed = []
    name = name.gsub(" ", " ")

    name = ERB::Util.url_encode(name)
    uri = "#{star}/#{name}"
    # p uri = "#{uri.path}"
    get "/childs/#{uri}"
    p uri if last_response.ok?.to_s == 'false'
      p last_response.ok? if last_response.ok?.to_s == 'false'
    failed = [last_response.ok?, name] if last_response.ok? == false
    failed
  end

  def profiles2(star, name)
    failed = []
    name = name.gsub(" ", " ")

    name = ERB::Util.url_encode(name)
    uri = "#{star}/ignited/#{name}"
    # p uri = "#{uri.path}"
    get "/childs/#{uri}"
    p uri if last_response.ok?.to_s == 'false'
      p last_response.ok? if last_response.ok?.to_s == 'false'
    failed = [last_response.ok?, name] if last_response.ok? == false
    failed
  end

  def test_rhea

    get '/childs/stars/rhea%20silvia'
    p last_response.ok?
  end

end
