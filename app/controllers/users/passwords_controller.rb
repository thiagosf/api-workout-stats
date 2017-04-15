class Users::PasswordsController < Devise::PasswordsController
  skip_before_action :authenticate_user_token

  def respond_with(resource, options={})
    case params[:action]
    when 'create'
      if resource.blank?
        output = {
          success: true,
          message: I18n.t("users.passwords.#{params[:action]}.success"),
        }
        status_code = :ok
      else
        output = {
          success: false,
          message: I18n.t("users.passwords.#{params[:action]}.errors.resource_blank")
        }
        status_code = :unprocessable_entity
      end
      render json: output, status: status_code
    when 'update'
      unless resource.blank?
        if resource.errors.blank?
          output = {
            success: true,
            message: I18n.t("users.passwords.#{params[:action]}.success"),
          }
          status_code = :ok
        else
          output = {
            success: false,
            message: get_errors(resource)
          }
          status_code = :unprocessable_entity
        end
      else
        output = {
          success: false,
          message: I18n.t("users.passwords.#{params[:action]}.errors.resource_blank")
        }
        status_code = :unprocessable_entity
      end
      render json: output, status: status_code
    else
      super(resource, options)
    end
  end
end
