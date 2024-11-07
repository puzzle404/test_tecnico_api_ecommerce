# encoding: utf-8
module Api
  module V1
    class AuditsController < ApplicationController
      before_filter :authenticate_admin!
      def index
        render json: AuditLog.order("created_at DESC")
      end
    end
  end
end
