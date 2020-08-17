class BrowserInterface


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
        # get email field
        email_field = form.find_element(:css, "input#login-email")
        # get password field
        password_field = form.find_element(:css, "input#login-password")
        # get submit button
        login_button = form.find_element(:css, "input.button")

        email_field.send_keys(@account.email)
        password_field.send_keys(@account.password)
        puts "waiting"
        sleep(10)
        login_button.click()



    end
    
    # =======================================================
    # CHECKS PRODUCT AVAILABILITY
    def in_stock?
        buy_button = @browser.find_element(:css, "button.shopify-payment-button__button").text().upcase
        buy_button != ""
    end
    
    # =======================================================
    # ADD TO CART

    def add_to_cart
    end
    
    # =======================================================
    # CHECKOUT
    def checkout
    end
    
    # =======================================================
    # HELPERS

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