class ApplicationController < ActionController::Base
  protect_from_forgery

  def authenticate_admin!
    raise
    header = request.headers['Authorization']
    token = header.split(' ').last if header

    begin
      decoded = JWT.decode(token, ENV['JWT_SECRET_KEY'], true, { algorithm: 'HS256' })
      admin_id = decoded[0]['admin_id']
      @current_admin = Administrator.find(admin_id)
    rescue ActiveRecord::RecordNotFound, JWT::DecodeError
      render json: { error: 'Unauthorized access' }, status: :unauthorized
    end
  end
end
