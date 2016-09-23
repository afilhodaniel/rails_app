require 'rails_helper'

RSpec.describe ApplicationController, type: :controller do
  let(:unset_current_user) { session[:current_user_id] = nil }
  
  describe "#index" do
    it "render the :index template" do
      get :index

      expect(response).to render_template :index
    end
  end

end