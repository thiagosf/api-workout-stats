class ApplicationController < ActionController::API
  before_action :force_json_request
  before_action :authenticate_user_token

  def send_json(data, only_fields=[], message=nil)
    if data.is_a?(String)
      render json: { success: true, message: data }
    else
      data = data.as_json(only: only_fields) unless only_fields.blank?
      render json: { success: true, data: data, message: message }
    end
  end

  def send_json_error(message, status = :bad_request)
    render json: { success: false, message: message }, status: status
  end

  def set_pagination
    @page = (params[:page] || 1).to_i
    @limit = 10
  end

  def get_token
    params[:token]
  end

  def authenticate_user_token
    token = get_token
    unless token.nil?
      user = UserToken.get_user_by_token token
      unless user.nil?
        sign_in user, store: false
      end
    else
      raise I18n.t('user_tokens.auth.errors.not_found')
    end
  rescue Exception => e
    send_json_error e.message, :unauthorized
  end

  def get_errors(resource)
    messages = []
    resource.errors.each_with_index do |(key,value)|
      attribute = resource.class.human_attribute_name(key)
      messages << "#{attribute} #{value}"
    end
    messages.join(', ')
  end

  def destroy_user_token
    UserToken.remove_token get_token
  end

  def force_json_request
    request.format = :json
  end

  def is_flashing_format?
    false
  end
end
