require 'rails_helper'

RSpec.describe User, type: :request do
    let(:headers) { { "Accept" => "application/json"} }
    let(:user_attributes) {
        {
            email: Faker::Internet.email,
            password: "abcdef",
            password_confirmation: "abcdef"
        }
    }
    let!(:user) {
        User.create(
            email: Faker::Internet.email,
            password: "123456",
            password_confirmation: "123456"
        )
    }
    let(:user_id) { user.id }

    before { host! "localhost:3000/api" }

    describe "GET/" do
        context "valid request:" do
            it "[index]"  do
                get "/users", params: {}, headers: headers
                expect(response).to have_http_status(200)
            end
            it "[show] user found" do
                get "/users/#{user_id}", params: {}, headers: headers
                expect(response).to have_http_status(200)
            end
        end
        context "invalid request:" do
            it "[show] user not found" do
                get "/users/#{20}", params: {}, headers: headers
                expect(response).to have_http_status(404)
            end
        end
    end
    describe "POST/" do
        context "valid request:" do
            it "[create] valid user" do
                post "/users", params: { user: user_attributes }, headers: headers
                expect(response).to have_http_status(201)
            end
        end
        context "invalid request:" do
            it "[create] invalid e-mail" do
                post "/users", params: { user: {
                    email: "abc,ced@",
                    password: "123456",
                    password_confirmation: "123456"
                }}, headers: headers
                expect(response).to have_http_status(422)
            end
            it "[create] wrong password confirmation" do
                post "/users", params: { user: {
                    email: "abc,ced@",
                    password: "123456",
                    password_confirmation: "12345f"
                }}, headers: headers
                expect(response).to have_http_status(422)
            end
            it "[create] e-mail already exists" do
                post "/users", params: { user: {
                    email: user.email,
                    password: "123456",
                    password_confirmation: "12345"
                }}, headers: headers
                expect(response).to have_http_status(422)
            end
        end
    end
    describe "PUT/" do
        context "valid request:" do
            let(:user_param) { { email: Faker::Internet.email } }
            before do
                put "/users/#{user_id}", params: {user: user_param }, headers: headers 
            end
            it "[update] update user" do
                expect(response).to have_http_status(200)
            end
            it "[update] return new data for updated user" do
                user_body = JSON.parse(response.body)
                expect(user_body["email"]).to eq(user_param[:email])
            end
        end
        context "invalid request:" do
            let(:user_param) { { email: 'abc,def@' } }
            before do
                put "/users/#{user_id}", params: {user: user_param }, headers: headers 
            end
            it "[update] invalid email" do
                expect(response).to have_http_status(422)
            end
            it "[update] found errors" do
                user_body = JSON.parse(response.body)
                expect(user_body).to have_key('errors')
            end
        end
    end
    describe "DELETE/" do
        context "valid request:" do
            before do
                delete "/users/#{user_id}", params: {}, headers: headers
            end
            it "[destroy] returns status code 204" do
                expect(response).to have_http_status(204)
            end
            it "[destroy] removes the user from database" do
                expect( User.find_by(id: user_id) ).to be_nil
            end
        end
    end
end