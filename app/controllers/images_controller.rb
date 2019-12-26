class ImagesController < ApplicationController
  before_action :set_image, only: %i[show update destroy]
  wrap_parameters :image, include: ["caption"]
  before_action :authenticate_user!, only: [:create, :update, :destroy]
  after_action :verify_authorized
  after_action :verify_policy_scoped, only: [:index]

  # GET /images
  # GET /images.json
  def index
    authorize Image
    images = policy_scope(Image.all)
    @images = ImagePolicy.merge(images)
  end

  # GET /images/1
  # GET /images/1.json
  def show
    authorize @image
    images = policy_scope(Image.where(id: @image.id))
    @image = ImagePolicy.merge(images).first
  end

  # POST /images
  # POST /images.json
  def create
    authorize Image, :create?

    @image = Image.new(image_params)
    @image.creator_id = current_user.id

    User.transaction do
      if @image.save
        role = current_user.add_role(Role::ORGANIZER, @image)
        @image.user_roles << role.role_name
        role.save!
        render :show, status: :created, location: @image
      else
        render json: @image.errors, status: :unprocessable_entity
      end
    end
  end

  # PATCH/PUT /images/1
  # PATCH/PUT /images/1.json
  def update
    authorize @image

    if @image.update(image_params)
      head :no_content
    else
      render json: @image.errors, status: :unprocessable_entity
    end
  end

  # DELETE /images/1
  # DELETE /images/1.json
  def destroy
    authorize @image
    @image.destroy
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_image
    @image = Image.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def image_params
    params.require(:image).permit(:caption, :creator_id)
  end
end
