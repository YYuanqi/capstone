class ThingImagesController < ApplicationController
  include ActionController::Helpers
  helper ThingsHelper
  wrap_parameters :thing_image, include: ["image_id", "thing_id", "priority"]
  before_action :get_thing_image, only: [:update, :destroy]
  before_action :get_thing, only: [:index, :update, :destroy]
  before_action :get_image, only: [:image_things]
  before_action :authenticate_user!, only: [:create, :update, :destroy]
  after_action :verify_authorized
  after_action :verify_policy_scoped, only: [:linkable_things]

  # GET /thing_images
  # GET /thing_images.json
  def index
    authorize @thing, :get_images?
    @thing_images = @thing.thing_images.prioritized.with_caption
  end

  def image_things
    authorize @image, :get_things?

    @thing_images = @image.thing_images.prioritized.with_name
    render :index
  end

  def linkable_things
    authorize Thing, :get_linkables?
    image = Image.find(params[:image_id])
    things = policy_scope(Thing.not_linked(image))
    @things = ThingPolicy.merge(things)

    render "things/index"
  end

  # POST /thing_images
  # POST /thing_images.json
  def create
    thing_image = ThingImage.new(thing_image_create_params.merge({
                                                                   :image_id => params[:image_id],
                                                                   :thing_id => params[:thing_id]}))
    thing = Thing.where(id: thing_image.thing_id).first
    if !thing
      full_message_error "cannot find thing[#{params[:thing_id]}]", :bad_request
      skip_authorization
      return
    elsif !Image.where(id: thing_image.image_id).exists?
      full_message_error "cannnot find image[#{params[:image_id]}]", :bad_request
      skip_authorization
      return
    end

    authorize thing, :add_image?

    thing_image.creator_id = current_user.id
    if thing_image.save
      head :no_content
    else
      render json: {errors: thing_image.errors.messages}, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /thing_images/1
  # PATCH/PUT /thing_images/1.json
  def update
    authorize @thing, :update_image?
    if @thing_image.update(thing_image_update_params)
      head :no_content
    else
      render json: @thing_image.errors, status: :unprocessable_entity
    end
  end

  # DELETE /thing_images/1
  # DELETE /thing_images/1.json
  def destroy
    authorize @thing, :remove_image?
    @thing_image.destroy
    head :no_content
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def get_thing_image
    @thing_image ||= ThingImage.find(params[:id])
  end

  def get_thing
    @thing ||= Thing.find(params[:thing_id])
  end

  def get_image
    @image ||= Image.find(params[:image_id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def thing_image_create_params
    params.require(:thing_image).tap do |p|
      p.require(:image_id) unless params[:image_id]
      p.require(:thing_id) unless params[:thing_id]
    end.permit(:priority, :image_id, :thing_id)
  end

  def thing_image_update_params
    params.require(:thing_image).permit(:priority)
  end
end
