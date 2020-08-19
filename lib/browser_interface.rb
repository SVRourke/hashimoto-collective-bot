class BrowserInterface
    attr_accessor :browser
    # Opens a browser on initialization
    def initialize(account)
        print "Starting Browser"
        @browser = Selenium::WebDriver.for :firefox
        @account = account
        puts "-DONE"
    end

    # =======================================================
    # CHECKS PRODUCT AVAILABILITY
    def in_stock?
        buy_button = @browser.find_element(:css, "button.shopify-payment-button__button").text().upcase
        buy_button != ""
    end
    
    # =======================================================
    # 01: Start Checkout
    def start_checkout
        begin
            print "Starting Checkout Process"
            checkout_wait = Selenium::WebDriver::Wait.new(:timeout => 40)
            checkout_wait.until {@browser.find_element(:css, "button.shopify-payment-button__button")}
            @browser.find_element(:css, "button.shopify-payment-button__button").click()
            puts "-DONE"
        rescue 
            puts "ERROR - RETRYING"
            puts ""
            retry
        end
        
    end
    
    # =======================================================
    # 02: Checkout Customer Info
    def checkout_customer_info
        begin
            print "Submitting Customer Info"
            wait = Selenium::WebDriver::Wait.new(:timeout => 20) 
            email = wait.until {@browser.find_element(:css, "input#checkout_email")}
            
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
    
            puts "-DONE"
        rescue Selenium::WebDriver::Error
            puts ""
            puts "ERROR-RETRYING"
            retry
        end
    end
    
    # =======================================================
    # 04: CHECKOUT SHIPPING
    def checkout_shipping
        begin
            print "Accepting Default Shipping"
            wait = Selenium::WebDriver::Wait.new(:timeout => 30) 
            wait.until {@browser.find_element(:css, 'html.js.linux.firefox.desktop.page--no-banner.page--logo-main.page--show.card-fields.cors.svg.opacity.placeholder.no-touchevents.displaytable.display-table.generatedcontent.cssanimations.flexbox.no-flexboxtweener.anyflexbox.shopemoji.floating-labels body div.content div.wrap div.main main.main__content div.step form.edit_checkout div.step__footer button#continue_button.step__footer__continue-btn.btn')}
            sleep(2)
            @browser.find_element(:css, 'html.js.linux.firefox.desktop.page--no-banner.page--logo-main.page--show.card-fields.cors.svg.opacity.placeholder.no-touchevents.displaytable.display-table.generatedcontent.cssanimations.flexbox.no-flexboxtweener.anyflexbox.shopemoji.floating-labels body div.content div.wrap div.main main.main__content div.step form.edit_checkout div.step__footer button#continue_button.step__footer__continue-btn.btn').click()
            puts "-DONE"
        rescue
            retry
        end
    end
    
    # =======================================================
    # 05: CHECKOUT PAYMENT
    def checkout_payment_info
        puts "Submitting Payment Info"
        
        wait = Selenium::WebDriver::Wait.new(:timeout => 20) 
        wait.until { 
            @browser.find_element(:xpath, '/html/body/div/div/div/main/div[1]/div/form/div[1]/div[2]/div[2]')
        }

        card_form = @browser.find_element(:xpath, '/html/body/div/div/div/main/div[1]/div/form/div[1]/div[2]/div[2]')
        frames = build_frame_hash(card_form)

        # :number, :name, :expiry, :verification_value
        puts "      inputting card number"
        fill_card_number(frames[:number])
        puts "      inputting cardholder name"
        fill_cardholder_name(frames[:name])
        puts "      inputting expiration date"
        fill_card_expiration(frames[:expiry])
        puts "      inputting cvc"
        fill_card_cvc(frames[:verification_value])
        puts "-DONE"
    end


    # =======================================================
    # 06: CHECKOUT BILLING ADDRESS
    def checkout_billing_address
        form = @browser.find_by(:css, "div#section--billing-address__different")
        first_name = form.find_element(:css, "input#checkout_billing_address_first_name")
        last_name = form.find_element(:css, "input#checkout_billing_address_last_name")
        address = form.find_element(:css, "input#checkout_billing_address_address1")
        apt_suite = form.find_element(:css, "input#checkout_billing_address_address2")
        city = form.find_element(:css, "input#checkout_billing_address_city")
        zipcode = form.find_element(:css, "input#checkout_billing_address_zip")

        first_name.send_keys(@account.billing_address[:first_name])
    end

    # =======================================================
    # HELPERS
    def fill_card_cvc(frame)
        frame.click()
        @browser.switch_to.active_element().send_keys(@account.card_info[:verification_value])
    end

    def fill_card_expiration(frame)
        frame.click()
        @account.card_info[:expiry].split("").each do |char|
            @browser.switch_to.active_element().send_keys(char)
        end        
    end

    def fill_cardholder_name(frame)
        frame.click()
        @browser.switch_to.active_element().send_keys(@account.card_info[:name])
    end

    def fill_card_number(frame)
        frame.click()
        @account.card_info[:number].split("-").each do |n|
            @browser.switch_to().active_element().send_keys(n)
        end
    end

    def build_frame_hash(form)
        iframes = form.find_elements("tag_name", "iframe").select {|f| f.attribute("class").length > 3}
        frames = Hash.new()

        form.find_elements(:tag_name, 'iframe').each do |frame|
            field_name = frame.attribute('id').split('-')[2]
            frames[field_name.to_sym] = frame
        end

        frames
    end

    # clears the Signup modal that displays when the site is visited
    def clear_modal
        begin
            wait = Selenium::WebDriver::Wait.new(:timeout => 30)
            wait.until { @browser.find_element(:xpath, '/html/body/div[5]/div[2]/div[1]')}
            @browser.find_element(:xpath, '/html/body/div[5]/div[2]/div[1]').click()
            puts "Modal Cleared"
        rescue Selenium::WebDriver::Error::ElementNotInteractableError
            puts "ERROR - RETRYING"
            puts ""
            retry
        end        
    end

    # navigates to the desired url
    def goto_page(url)
        @browser.navigate.to url
        puts "Moved TO #{url}"
    end
    
    # reload
    def reload
        @browser.navigate.refresh()
        puts "Page Refreshed"
    end
    
    # ALWAYS RUN WHEN STOPPING PROGRAM
    def down
        @browser.quit
    end


       # =======================================================
    # LOGS IN TO THE ACCOUNT, LEAVES BROWSER @ TARGET URL
    # def login
    #     # form
    #     form = @browser.find_element(:css, "form#customer_login")
    #     email_field = form.find_element(:css, "input#login-email")
    #     password_field = form.find_element(:css, "input#login-password")
    #     login_button = form.find_element(:css, "input.button")
        
    #     # filling form and submitting
    #     email_field.send_keys(@account.email)
    #     password_field.send_keys(@account.password)
    #     login_button.click()
    # end
end