require 'rails_helper'

RSpec.describe SessionsController, type: :controller do
  let(:set_current_user) {
    @current_user = FactoryGirl.create(:user)
    session[:current_user_id] = @current_user.id
  }

  describe "#unauthenticated" do
    it "render the :unauthenticated template" do
      get :unauthenticated

      expect(response).to render_template :unauthenticated
    end
  end

  describe "#signin_get" do
    it "redirect to root path when existing an authenticated user" do
      set_current_user

      get :signin_get

      expect(response).to redirect_to root_path
    end

    it "render :signin template when not existing an authenticated user" do
      get :signin_get

      expect(response).to render_template :signin
    end
  end

  describe "#signin_post" do
    let(:user) { FactoryGirl.create(:user, password: 'test', password_confirmation: 'test') }

    context "when the request is made in html format" do
      context "when user exists" do
        before { post :signin_post, user: {email: user.email, password: 'test'} }
        
        it "redirect to root path" do
          expect(response).to redirect_to root_path
        end

        it "sets session[:current_user_id] with user id" do
          expect(session[:current_user_id]).to eq(user.id)
        end
      end

      context "when user doesn't exists" do
        before { post :signin_post, user: {email: Faker::Internet.email, password: Faker::Internet.password} }

        it "render :signin template" do
          expect(response).to render_template :signin
        end

        it "sets session[:current_user_id] to nil" do
          expect(session[:current_user_id]).to eq(nil)
        end
      end
    end

    context "when the request is made in json format" do
      context "when user exists" do
        before { post :signin_post, user: {email: user.email, password: 'test'}, format: :json }

        it "render :success template" do
          expect(response).to render_template :success
        end

        it "sets session[:current_user_id] with user id" do
          expect(session[:current_user_id]).to eq(user.id)
        end
      end

      context "when user doesn't exists" do
        before { post :signin_post, user: {email: Faker::Internet.email, password: Faker::Internet.password}, format: :json }

        it "render :error template" do
          expect(response).to render_template :error
        end

        it "sets session[:current_user_id] to nil" do
          expect(session[:current_user_id]).to eq(nil)
        end
      end
    end
  end

  describe "#signup_get" do
    it "redirect to root path when existing an authenticated user" do
      set_current_user

      get :signup_get

      expect(response).to redirect_to root_path
    end

    it "render :signup template when not existing an authenticated user" do
      get :signup_get

      expect(response).to render_template :signup
    end
  end

  describe "#signup_post" do
    context "when the request is made in html format" do
      context "and the request has valid fields" do
        before { post :signup_post, user: FactoryGirl.attributes_for(:user) }

        it "return success flag" do
          expect(flash[:success]).to be_truthy
        end

        it "return :signup template" do
          expect(response).to render_template :signup
        end
      end

      context "#and the request has invalid fields" do
        before { post :signup_post, user: FactoryGirl.attributes_for(:user, email: nil) }

        it "return errors flag" do
          expect(flash[:errors]).to be_truthy
        end

        it "return :signup template" do
          expect(response).to render_template :signup
        end
      end
    end

    context "when the request is made in other format than json" do
      it "raise unknown format error" do
        expect {
          post :signup_post, user: FactoryGirl.attributes_for(:user), format: :json
        }.to raise_error ActionController::UnknownFormat
      end
    end
  end

  describe "#signout" do
    before { set_current_user }
    
    context "when the request is made in html format" do
      before { get :signout }

      it "sets session[:current_user_id] to nil" do
        expect(session[:current_user_id]).to eq(nil)
      end

      it "redirect to root path" do
        expect(response).to redirect_to root_path
      end
    end

    context "when the request is made in other format than html" do
      it "raise unknown format error" do
        expect {
          get :signout, format: :json
        }.to raise_error ActionController::UnknownFormat
      end
    end
  end

end