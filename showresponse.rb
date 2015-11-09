require 'json'

def write_Json(attributes)
  File.open("json_look_at_format.json","w") do |f|
    f.write( JSON.pretty_generate(attributes))
  end
end