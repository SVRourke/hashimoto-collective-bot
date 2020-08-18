class Account
    attr_accessor :card_info, :info
    # attr_accessor :email, :password,:email, :first_name, :last_name, :address_1, :apt_suite, :city, :country, :state, :zip, :card
    def initialize(attrs)
        attrs.each do |k, v|
            self.send("#{k}=", v)
        end
    end
end