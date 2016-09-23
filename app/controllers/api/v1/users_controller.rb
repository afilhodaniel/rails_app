module Api
  module V1
    class UsersController < BaseController
      skip_before_action :force_authentication, only: [:create]

      private
        
        def user_params
          params.require(:user).permit(:name, :username, :email, :password, :password_confirmation)
        end
        
        def query_params
          params.permit(:id)
        end
    end
  end
end