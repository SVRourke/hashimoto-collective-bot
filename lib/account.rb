class Account
    attr_accessor :email, :password
    def initialize(attrs)
        attrs.each do |k, v|
            self.send("#{k}=", v)
        end
    end
end