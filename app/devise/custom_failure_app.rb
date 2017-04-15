class CustomFailureApp < Devise::FailureApp
  def http_auth_body
    return i18n_message unless request_format
    method = "to_#{request_format}"
    if method == "to_xml"
      { success: false, message: i18n_message }.to_xml(root: "errors")
    elsif {}.respond_to?(method)
      { success: false, message: i18n_message }.send(method)
    else
      i18n_message
    end
  end
end
