require 'rails_helper'

RSpec.describe User, type: :request do
    let!(:user) {User.create(
        email: Faker::Internet.email,
        password: "123456",
        password_confirmation: "123456"
    )}
    let(:user_id) { user.id }

    before { host! "localhost:3000/api" }

    before do
        headers = { "Accept" => "application/json" }
    end

    context "GET/" do
        it "index"  do
            get "/users", params: {}, headers: headers
            expect(response).to have_http_status(200)
        end
        it "show" do
            get "/users/#{user_id}", params: {}, headers: headers
            puts(response.body)
            expect(response).to have_http_status(200)
        end
        it "user not found" do
            get "/users/#{20}", params: {}, headers: headers
            puts(response.body)
            expect(response).to have_http_status(404)
        end
    end
end