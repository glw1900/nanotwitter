require 'http'

$url = "http://hugetwitter.herokuapp.com"


$u = 500
$t = 500
$f = 30


HTTP.get($url + "/test/reset/all")
HTTP.get($url + "/test/seed/" + $u.to_s)
HTTP.get($url + "/test/tweets/" + $t.to_s)
HTTP.get($url + "/test/follow/" + $f.to_s)
