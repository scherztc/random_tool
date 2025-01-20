class ResourcesController < ApplicationController

  require 'launchy'

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
#     Resource.order(Arel.sql('RANDOM()')).first.url
    @page = Resource.all.sample.url[0...-2]
    Launchy.open(@page)
    redirect_to root_path, notice: "Check Tab for Random Resource."
  end

  def chatgpt_image
#     client = Openai::Client.new
     @page = Resource.all.sample.title
     @request_body = {
        prompt: '@page',
        n: 1,                  # between 1 and 10
        size: '1024x1024',     # 256x256, 512x512, or 1024x1024
        response_format: 'url' # url or b64_json
     }
     @response = Openai::Client.images.create(@request_body)
     @data = @response["data"].first["url"]
     Launchy.open(@data)
     redirect_to root_path, notice: "Check Tab for ChatGPT Image."
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


end
