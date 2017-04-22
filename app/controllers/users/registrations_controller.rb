class Users::RegistrationsController < Devise::RegistrationsController
  prepend_before_action :authenticate_user_token, only: [:update]
  skip_before_action :authenticate_user_token, only: [:create]

  def respond_with(resource, options={})
    if ['create', 'update'].include?(params[:action])
      unless resource.blank?
        if resource.errors.blank?
          @data = resource
          output = {
            success: true,
            message: I18n.t("users.registrations.#{params[:action]}.success"),
            data: @data.output_api
          }
          return render json: output
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
          message: I18n.t("users.registrations.#{params[:action]}.errors.resource_blank")
        }
        status_code = :unprocessable_entity
      end
      render json: output, status: status_code
    else
      super(resource, options)
    end
  end

  private

  def common_fields
    [
      :password,
      :password_confirmation,
      :email,
      :name,
      :gender,
    ]
  end

  def sign_up_params
    params.require(:user).permit(common_fields)
  end

  def account_update_params
    params.require(:user).permit(
      common_fields.concat([
        :current_password
      ])
    )
  end

  def update_resource(resource, update_params)
    if update_params[:password].blank?
      update_params.delete(:password)
      update_params.delete(:password_confirmation)
    end
    result = resource.update_attributes(update_params)
    resource.clean_up_passwords
    result
  end
end
