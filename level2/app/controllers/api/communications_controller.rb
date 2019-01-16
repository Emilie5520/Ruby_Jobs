class Api::CommunicationsController < ApplicationController
  include Rails::Pagination

  def create
    practitioner = Practitioner.where(first_name: communication_params[:first_name], last_name: communication_params[:last_name]).first

    communication = Communication.new(practitioner_id: practitioner.id, sent_at: communication_params[:sent_at])

    communication.save

    render json: communication.to_json, status: :created
  end

  def index
    # render json: Communication.paginate(:page => params[:page], per_page: 10)

    # render json: Communication.all.to_json, status: :ok

    communication = Communication.all

    paginate json: communication, page: params[:page], per_page: 25
  end

  def communication_params
    params.require(:communication).permit(:first_name, :last_name, :sent_at)
  end

end
