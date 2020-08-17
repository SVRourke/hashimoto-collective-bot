class BrowserInterface
    def initialize()
        @browser = Selenium::WebDriver.for :firefox
    end
    # returns a hash of the products details for use by the product object
    def product_info(url)
        info = Hash.new()
        info[:url] = url
        @browser.navigate.to url
        info[:title] = @browser.find_element(:css, "div.sku-title > h1").text()
        # get availability
        avail_text = @browser.find_element(:css, "button.add-to-cart-button").text().upcase
        
        if avail_text != "ADD TO CART"
            info[:availability] = false
        else
            info[:availability] = true
        end

        info
    end

    def product_available?(product)
        @browser.navigate.to product.url
        sleep(3)
        avail_text = @browser.find_element(:css, "button.add-to-cart-button").text().upcase
        avail_text != "ADD TO CART" ? false : true
    end


    
    # logs the browser in to bestbuy
    # leaves the browser on the home page after checking login status
    def login(username, password)
        @browser.navigate.to "https://www.bestbuy.com/identity/global/signin"
        @browser.find_element(:xpath, '//*[@id="fld-e"]').send_keys(username)
        @browser.find_element(:xpath, '//*[@id="fld-p1"]').send_keys(password)
        @browser.find_element(:css, 'button.cia-form__controls__submit').click()
        sleep(10)
        # check to make sure login was successfull
        icon = @browser.find_element(:xpath, "/html/body/div[2]/div/div/div/header/div[2]/div[2]/div/nav[2]/ul/li[1]/button/div[2]/span")

        if icon.text != "Account"
            puts "success"
        else
            puts "FATAL LOGIN ERROR"
            self.down()
        end
    end

    # adds a product to the cart given a url
    # leaves browser on cart page after
    def addToCart(product)
        @browser.navigate.to product
        sleep(10)
        puts driver.find_element(:css, "button.add-to-cart-button").click()
        sleep(10)
        driver.navigate.to "https://www.bestbuy.com/cart"
        sleep(10)
    end
    
    # ALWAYS RUN WHEN STOPPING PROGRAM
    def down
        @browser.quit
    end
end