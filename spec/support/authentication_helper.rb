
module AuthenticationHelper
  def generate_jwt_token_for_admin
    @admin = Administrator.create!(
          name: 'Test Admin',
          email: 'test@example.com',
          password: 'password123', # bcrypt se encarga de generar el hash de esta contraseña
          password_confirmation: 'password123' # Asegúrate de que `password_confirmation` esté presente
        )
    payload = { admin_id: @admin.id, exp: 24.hours.from_now.to_i } # Configura el payload según lo necesites
    token = JWT.encode(payload, ENV['JWT_SECRET_KEY'], 'HS256')
  end
end
