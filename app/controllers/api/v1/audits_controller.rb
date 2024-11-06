# encoding: utf-8
module Api
  module V1
    class AuditsController < ApplicationController
      before_filter :authenticate_admin!
      def index
        render json: AuditLog.all
      end
    end
  end
end
