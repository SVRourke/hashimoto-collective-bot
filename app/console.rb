require_relative "./../environment.rb"

login_url = "https://store.hashimotocontemporary.com/account/login"
base_url = "https://store.hashimotocontemporary.com/collections/"
available_url = "#{base_url}prints/products/lizzie-gill-meet-me-anywhere-but-my-apartment-ii-print-1"
soldOut_url = "#{base_url}prints/products/stephanie-brown-swailing-print"
user_attrs = {
    :info => {
        :email => "flossyflynt7@gmail.com",
        :first_name => "Samuel",
        :last_name => "Rourke",
        :address_1 => "666 highway to hell",
        :apt_suite => "",
        :city => "Miami",
        # :country => "",
        :state => "Florida",
        :zip => "33311"
    },
    :card_info => {
        :number => "444444444444",
        :name => "Samuel Rourke",
        :expiry => "01/24",
        :verification_value => '444'
    }
}

browsers = Array.new

ac1 = Account.new(user_attrs)

ix = BrowserInterface.new(ac1)
ix.clear_modal(base_url)

ix.goto_page(available_url)
sleep(2)
ix.start_checkout
sleep(2)
ix.checkout_customer_info
sleep(2)
ix.checkout_shipping
# sleep(2)



# ix.login

binding.pry
