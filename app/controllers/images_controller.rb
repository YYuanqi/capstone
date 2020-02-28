class ImagesController < ApplicationController
  before_action :set_image, only: %i(show update destroy content)
  wrap_parameters :image, include: %w(caption)
  before_action :authenticate_user!, only: %i(create update destroy)
  after_action :verify_authorized, except: %i(content)
  after_action :verify_policy_scoped, only: %i(index)

  rescue_from EXIFR::MalformedJPEG, with: :contents_error

  # GET /images
  # GET /images.json
  def index
    authorize Image
    images = policy_scope(Image.all)
    @images = ImagePolicy.merge(images)
  end

  def content
    result = ImageContent.image(@image).smallest(params[:width], params[:height]).first
    if result
      options = {
        type: result.content_type,
        disposition: 'inline',
        filename: "#{@image.basename}.#{result.suffix}"
      }
      send_data result.content.data, options
    else
      render nothing: true, status: :not_found
    end
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
        original = ImageContent.new(image_content_params)
        contents = ImageContentCreator.new(@image, original).build_contents
        if contents.save!
          role = current_user.add_role(Role::ORGANIZER, @image)
          @image.user_roles << role.role_name
          role.save!
          render :show, status: :created, location: @image
        end
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
    ImageContent.image(@image).delete_all
    @image.destroy
    head :no_content
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

  def image_content_params
    params.require(:image_content).tap do |ic|
      ic.require(:content_type)
      ic.require(:content)
    end.permit(:content_type, :content)
  end

  def contents_error(exception)
    full_message_error([exception.message, 'unable to create image contents'], :unprocessable_entity)
    Rails.logger.debug exception.message
  end

  def mongoid_validate_error(exception)
    payload = {
      errors: exception.record.errors.messages
                .slice(:content_type, :content, :full_messages)
                .merge(full_messages: ['unable to create image contents']),
    }
    render json: payload, status: :unprocessable_entity
    Rails.logger.debug exception
  end
end
