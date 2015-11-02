ENV['RACK_ENV'] = 'development'

require 'rack/test'
require 'json'
require 'minitest/autorun'
require_relative 'app'

include Rack::Test::Methods

def app
  Sinatra::Application
end

def write_Json(attributes)
  File.open("json_look_at_format.json","w") do |f|
    f.write( JSON.pretty_generate(attributes))
  end
end

describe "get home page" do 
  it "go to home page" do
    get '/'
    attributes = JSON.parse(last_response.to_json) # RACK
    write_Json(attributes)
    attributes[:status].must_equal == 200 #OK
  end # it
end

# describe "get sign in page" do
#   it "go to sign in page" do
#     get '/signin'
#     attributes = JSON.pars(last_response.to_json)
#     write_Json(attributes)
#   end
# end
    

#     describe "sign in as chen" do
#       it "sign in as chen" do
#       post '/signin',  {"username" => "user1", "password" => "1234"}
#       attributes = JSON.parse(last_response.to_json) # RACK
# #       attributes[:status].must_equal == 200
#       write_Json(attributes)
#       end
#     end # it
    
#     it "create and delete new user" do
#       post '/user/submit_regis', {"user" => {"username" => "chen", "password" => "123"}}.to_json
#       attributes = JSON.parse(last_response.to_json) # RACK
#       write_Json(attributes)
#     end # it
#   end # describe



  
  