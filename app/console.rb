require_relative "./../environment.rb"

login_url = "https://store.hashimotocontemporary.com/account/login"
base_url = "https://store.hashimotocontemporary.com/collections/"
available_url = "#{base_url}prints/products/lizzie-gill-meet-me-anywhere-but-my-apartment-ii-print-1"
soldOut_url = "#{base_url}prints/products/stephanie-brown-swailing-print"
user_attrs = {
    :info => {
        :email => "test@example.com",
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
        :number => "4444-4444-4444-4444",
        :name => "Samuel Rourke",
        :expiry => "0124",
        :verification_value => '444'
    },
    :billing_address => {
        :first_name => "Samuel",
        :last_name => "Rourke",
        :address => "300 oakwood ln",
        :apt_suite => "",
        :zip => "33020",
    }
}
browsers = Array.new

ac1 = Account.new(user_attrs)

ix = BrowserInterface.new(ac1)
ix.goto_page(base_url)
ix.clear_modal

scheduler = Rufus::Scheduler.new
scheduler.at '16:55:00' do
    ix.goto_page(available_url)
    ix.start_checkout
    ix.checkout_customer_info
    ix.checkout_shipping
    ix.checkout_payment_info
    ix.checkout_billing_address
end

scheduler.join

# sleep(5)


# sleep(2)



# ix.login

binding.pry
# begin
# rescue Selenium::WebDriver::Error::ElementNotInteractableError
#     retry
# end