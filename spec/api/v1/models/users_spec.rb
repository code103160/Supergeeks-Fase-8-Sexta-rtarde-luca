require 'rails_helper'

RSpec.describe User, type: :model do
    context "User be valid:" do
        it "all attributes are OK" do
            response = User.new(
                email: Faker::Internet.email,
                password: "123456",
                password_confirmation: "123456"
            )
            expect(response).to be_valid
        end
    end

    context "errors in attributes:" do
        it "blank email:" do
            response = User.new(
                email: nil,
                password: "123456",
                password_confirmation: "123456"
            )
            expect(response).to_not be_valid
        end
        it "wrong password cofirm:" do
            response = User.new(
                email: Faker::Internet.email,
                password: "123456",
                password_confirmation: "12346"
            )
            expect(response).to_not be_valid
        end
    end
end