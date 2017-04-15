class UserTokensController < ApplicationController
  before_action :valid_request?

  def auth
    token = params[:token]
    @data = UserToken.get_user_by_token token
    unless @data.blank?
      render json: { success: true, data: @data.output_api }
    else
      send_json_error I18n.t('user_tokens.auth.errors.invalid'), :unauthorized
    end
  end

  private

  def valid_request?
    if params[:token].blank?
      raise I18n.t('user_tokens.auth.errors.invalid_request')
    end
  rescue Exception => e
    send_json_error e.message, :unauthorized
  end
end
