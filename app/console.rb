require_relative "./../environment.rb"

login_url = "https://store.hashimotocontemporary.com/account/login"
base_url = "https://store.hashimotocontemporary.com/collections/"
available_url = "#{base_url}prints/products/lizzie-gill-meet-me-anywhere-but-my-apartment-ii-print-1"
soldOut_url = "#{base_url}prints/products/stephanie-brown-swailing-print"
user_attrs = {
    :email => "flossyflynt7@gmail.com",
    :password => "Password"
}
ac1 = Account.new(user_attrs)

ix = BrowserInterface.new(ac1)
ix.goto_page(soldOut_url)

binding.pry
