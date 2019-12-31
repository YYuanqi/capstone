class ThingsController < ApplicationController
  include ActionController::Helpers
  helper ThingsHelper
  before_action :set_thing, only: [:show, :update, :destroy]
  before_action :authenticate_user!, only: [:index, :create, :update, :destroy]
  wrap_parameters :thing, include: ["name", "description", "notes"]
  after_action :verify_authorized
  after_action :verify_policy_scoped, only: [:index]

  # GET /things
  # GET /things.json
  def index
    authorize Thing

    things = policy_scope(Thing.all)
    @things = ThingPolicy.merge(things)
  end

  # GET /things/1
  # GET /things/1.json
  def show
    authorize @thing
  end

  # POST /things
  # POST /things.json
  def create
    authorize Thing
    @thing = Thing.new(thing_params)

    User.transaction do
      if @thing.save
        role = current_user.add_role(Role::ORGANIZER, @thing)
        @thing.user_roles << role.role_name
        role.save!
        render :show, status: :created, location: @thing
      else
        render json: @thing.errors, status: :unprocessable_entity
      end
    end
  end

  # PATCH/PUT /things/1
  # PATCH/PUT /things/1.json
  def update
    authorize thing

    if @thing.update(thing_params)
      head :no_content
    else
      render json: @thing.errors, status: :unprocessable_entity
    end
  end

  # DELETE /things/1
  # DELETE /things/1.json
  def destroy
    authorize @thing

    @thing.destroy
    head :no_content
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_thing
    @thing = Thing.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def thing_params
    params.require(:thing).tap { |p|
      p.require(:name)
    }.permit(:name, :description, :notes)
  end
end
