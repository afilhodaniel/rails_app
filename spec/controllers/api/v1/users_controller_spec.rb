require 'rails_helper'

RSpec.describe Api::V1::UsersController, type: :controller do
  before {
    @current_user = FactoryGirl.create(:user)
    session[:current_user_id] = @current_user.id
  }

  describe "#index" do
    context "when the request is made in json format" do
      before { get :index, format: :json }

      it "gets an array of users" do
        expect(assigns(:users)).to eq([@current_user])
      end

      it "render the :index template" do
        expect(response).to render_template :index
      end
    end

    context "when the request is made in other format than json" do
      it "raise unknown format error" do
        expect {
          get :index
        }.to raise_error ActionController::UnknownFormat
      end
    end
  end

  describe "#show" do
    context "when the request has valid fields" do
      before { get :show, id: @current_user.id, format: :json }

      it "gets an user object" do
        expect(assigns(:errors)).to be_falsy
        expect(assigns(:user)).to eq(@current_user)
      end

      it "render the :show template" do
        expect(response).to render_template :show
      end
    end

    context "when the request has invalid fields" do
      it "raise record not found error" do
        expect {
          get :show, id: 9999, format: :json
        }.to raise_error ActiveRecord::RecordNotFound
      end
    end

    context "when the request is made in other format other than json" do
      it "raise unknown format error" do
        expect {
          get :show, id: @current_user.id
        }.to raise_error ActionController::UnknownFormat
      end
    end
  end

  describe "#create" do
    context "when the request has valid fields" do
      before { post :create, user: FactoryGirl.attributes_for(:user), format: :json }
      
      it "gets a valid user object" do
        expect(assigns(:errors)).to be_falsy
        expect(assigns(:user)).to be_truthy
      end

      it "return the :success template" do
        expect(response).to render_template :success
      end
    end

    context "when de request has invalid fields" do
      before { post :create, user: FactoryGirl.attributes_for(:user, password_confirmation: nil), format: :json }

      it "gets an invalid user object" do
        expect(assigns(:errors)).to be_truthy
        expect(assigns(:user)).to be_truthy
      end

      it "return the :error template" do
        expect(response).to render_template :error
      end
    end

    context "when the request is made in other format than json" do
      it "raise unknown format error" do
        expect {
          post :create, user: FactoryGirl.attributes_for(:user)
        }.to raise_error ActionController::UnknownFormat
      end
    end
  end

  describe "#update" do
    context "when the request has valid fields" do
      before { put :update, id: @current_user.id, user:FactoryGirl.attributes_for(:user, name: Faker::Name.name), format: :json }

      it "gets a valid user object" do
        expect(assigns(:errors)).to be_falsy
        expect(assigns(:user)).to be_truthy
      end

      it "render the :success template" do
        expect(response).to render_template :success
      end
    end

    context "when the request has invalid fields" do
      before { put :update, id: @current_user.id, user:FactoryGirl.attributes_for(:user, name: nil), format: :json }

      it "gets a invalid user object" do
        expect(assigns(:errors)).to be_truthy
        expect(assigns(:user)).to be_truthy
      end

      it "return the :error template" do
        expect(response).to render_template :error
      end
    end

    context "when the request is made in other format than json" do
      it "raise unknown format error" do
        expect {
          put :update, id: @current_user.id, user:FactoryGirl.attributes_for(:user, name: nil)
        }.to raise_error ActionController::UnknownFormat
      end
    end
  end

  describe "#delete" do
    context "when the request has valid fields" do
      before { delete :destroy, id: @current_user.id, format: :json }

      it "gets a valid user object" do
        expect(assigns(:errors)).to be_falsy
        expect(assigns(:user)).to be_truthy
      end

      it "return the :success template" do
        expect(response).to render_template :success
      end
    end

    context "when the request has invalid fields" do
      it "raise record not found error" do
        expect {
          delete :destroy, id: 9999, format: :json
        }.to raise_error ActiveRecord::RecordNotFound
      end
    end

    context "when the request is made in other format than json" do
      it "raise unknown format errorr" do
        expect {
          delete :destroy, id: @current_user.id
        }.to raise_error ActionController::UnknownFormat
      end
    end
  end

end