class ResourcesController < ApplicationController

  before_action :set_resource, only: %i[ show edit update destroy ]

  # GET /resources or /resources.json
  def index
    @resources = Resource.all
  end

  # GET /resources/1 or /resources/1.json
  def show
#    get_document
#    authz_document
#    get_object
#    get_children
#    get_attachments
  end


  # GET /resources/new
  def new
    @resource = Resource.new
  end

  # GET /resources/1/edit
  def edit
  end

  # POST /resources or /resources.json
  def create
    @resource = Resource.new(resource_params)

    respond_to do |format|
      if @resource.save
        format.html { redirect_to @resource, notice: "Resource was successfully created." }
        format.json { render :show, status: :created, location: @resource }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @resource.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /resources/1 or /resources/1.json
  def update
    respond_to do |format|
      if @resource.update(resource_params)
        format.html { redirect_to @resource, notice: "Resource was successfully updated." }
        format.json { render :show, status: :ok, location: @resource }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @resource.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /resources/1 or /resources/1.json
  def destroy
    @resource.destroy
    respond_to do |format|
      format.html { redirect_to resources_url, notice: "Resource was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def get_object
    @object = SolrService.reify_solr_result(@document)
  end

  def random_output
    resource = Resource.order(Arel.sql('RANDOM()')).first

    if resource&.url.present?
      redirect_to resource.url.strip, allow_other_host: true
    else
      redirect_to root_path, alert: 'No resource URL is available.'
    end
  end

  def chatgpt_image
    resource = Resource.order(Arel.sql('RANDOM()')).first

    unless resource&.title.present?
      redirect_to root_path, alert: 'No resource title is available for image generation.'
      return
    end

    image_url = generate_image_url(resource.title)

    if image_url.present?
      redirect_to image_url, allow_other_host: true
    else
      redirect_to root_path, alert: 'Image generation did not return a URL.'
    end
  end

  private

    # Use callbacks to share common setup or constraints between actions.
    def set_resource
      @resource = Resource.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def resource_params
      params.require(:resource).permit(:title, :description, :url, :category)
    end

    def generate_image_url(prompt)
      request_body = {
        prompt: prompt,
        n: 1,
        size: '1024x1024',
        response_format: 'url'
      }

      response = Openai::Client.images.create(request_body)
      response.fetch('data', []).first&.fetch('url', nil)
    rescue KeyError, StandardError => e
      Rails.logger.error("OpenAI image generation failed: #{e.class}: #{e.message}")
      nil
    end


end
