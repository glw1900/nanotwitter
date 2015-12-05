require 'http'


def user_logout()
  HTTP.get(@url + '/logout')
end

def user_delete_everything(username)
  HTTP.post(@url + '/delete/user/' + username)
end