class Users::SessionsController < Devise::SessionsController
  skip_before_action :authenticate_user_token

  def create
    super do |resource|
      @data = resource
      output = {
        success: true,
        message: I18n.t('users.sessions.create.success'),
        data: @data.output_api
      }
      return render json: output
    end
  end

  def respond_to_on_destroy
    destroy_user_token
    render json: {
      success: true,
      message: I18n.t('users.sessions.destroy.success')
    }
  end
end
