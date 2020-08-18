class BrowserInterface
    attr_accessor :browser


    # Opens a browser on initialization
    def initialize(account)
        @browser = Selenium::WebDriver.for :firefox
        @account = account 
    end

    # =======================================================
    # LOGS IN TO THE ACCOUNT, LEAVES BROWSER @ TARGET URL
    def login
        # form
        form = @browser.find_element(:css, "form#customer_login")
        email_field = form.find_element(:css, "input#login-email")
        password_field = form.find_element(:css, "input#login-password")
        login_button = form.find_element(:css, "input.button")
        
        # filling form and submitting
        email_field.send_keys(@account.email)
        password_field.send_keys(@account.password)
        login_button.click()
    end
    
    # =======================================================
    # CHECKS PRODUCT AVAILABILITY
    def in_stock?
        buy_button = @browser.find_element(:css, "button.shopify-payment-button__button").text().upcase
        buy_button != ""
    end
    
    # =======================================================
    # Start Checkout

    def start_checkout
        @browser.find_element(:css, "button.shopify-payment-button__button").click()
    end
    
    # =======================================================
    # CHECKOUT CUSTOMER INFO
    def checkout_customer_info
        email = @browser.find_element(:css, "input#checkout_email")
        
        shipping_address = @browser.find_element(:css, "div.section--shipping-address")
        
        first_name = shipping_address.find_element(:css, "input#checkout_shipping_address_first_name")
        last_name = shipping_address.find_element(:css, "input#checkout_shipping_address_last_name")
        address_1 = shipping_address.find_element(:css, "input#checkout_shipping_address_address1")
        apt_suite = shipping_address.find_element(:css, "input#checkout_shipping_address_address2")
        city = shipping_address.find_element(:css, "input#checkout_shipping_address_city")
        # submit button
        submit = shipping_address.find_element(:xpath, '//*[@id="continue_button"]')
        # country  = shipping_address.find_element(:css, "select#checkout_shipping_address_country")
        state = shipping_address.find_element(:xpath, '//*[@id="checkout_shipping_address_province"]')
        zip = shipping_address.find_element(:css, "input#checkout_shipping_address_zip")

        
        email.send_keys(@account.info[:email])
        first_name.send_keys(@account.info[:first_name])
        last_name.send_keys(@account.info[:last_name])
        address_1.send_keys(@account.info[:address_1])
        apt_suite.send_keys(@account.info[:apt_suite])
        city.send_keys(@account.info[:city])
        zip.send_keys(@account.info[:zip])

        submit.click()

    end
    
    # =======================================================
    # CHECKOUT SHIPPING
    def checkout_shipping
        @browser.find_element(:xpath, '//*[@id="continue_button"]').click()
    end
    
    # =======================================================
    # CHECKOUT PAYMENT
    # remove the elements with empty strings as keys
    # click the iframe, then switch_to.active_element().sendkeys()
    # switch_to.default_content() to return from iframe
    def checkout_payment_info
        card_form = @browser.find_element(:xpath, '/html/body/div/div/div/main/div[1]/div/form/div[1]/div[2]/div[2]')
        card_frames = build_frame_hash(card_form)

        card_frames.each do |k, v|
            v.send_keys(@account.card_info[k])
        end       
    end

    # =======================================================
    # HELPERS
    def build_frame_hash(form)
        frames = Hash.new()
        form.find_elements(:css, 'iframe').each do |frame|
            field_name = frame.attribute('class').split('-')[2]
            frames[field_name.to_sym] = frame
        end
        frames
    end

    # clears the Signup modal that displays when the site is visited
    def clear_modal(home_url)
        @browser.navigate.to(home_url)
        sleep(3)
        if @browser.find_elements(:css, "div.mc-closeModal").count > 0
            @browser.find_element(:css, "div.mc-closeModal").click()
        end        
    end

    # navigates to the desired url
    def goto_page(url)
        @browser.navigate.to url
    end
    
    # reload
    def reload
        @browser.navigate.refresh()
    end
    
    # ALWAYS RUN WHEN STOPPING PROGRAM
    def down
        @browser.quit
    end

    # =======================================================
    # =======================================================
    # =======================================================

    # def product_available?(product)
    #     @browser.navigate.to product.url
    #     sleep(3)
    #     avail_text = @browser.find_element(:css, "button.add-to-cart-button").text().upcase
    #     avail_text != "ADD TO CART" ? false : true
    # end

    # # adds a product to the cart given a url
    # # leaves browser on cart page after
    # def addToCart(product)
    #     @browser.navigate.to product
    #     sleep(10)
    #     puts driver.find_element(:css, "button.add-to-cart-button").click()
    #     sleep(10)
    #     driver.navigate.to "https://www.bestbuy.com/cart"
    #     sleep(10)
    # end
    
    
end