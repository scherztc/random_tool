require 'test_helper'

class ResourcesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @resource = resources(:one)
  end

  test "should get index" do
    get resources_url
    assert_response :success
  end

  test "should get new" do
    get new_resource_url
    assert_response :success
  end

  test "should create resource" do
    assert_difference('Resource.count') do
      post resources_url, params: { resource: { description: @resource.description, title: @resource.title, url: @resource.url } }
    end

    assert_redirected_to resource_url(Resource.last)
  end

  test "should show resource" do
    get resource_url(@resource)
    assert_response :success
  end

  test "should get edit" do
    get edit_resource_url(@resource)
    assert_response :success
  end

  test "should update resource" do
    patch resource_url(@resource), params: { resource: { description: @resource.description, title: @resource.title, url: @resource.url } }
    assert_redirected_to resource_url(@resource)
  end

  test "should destroy resource" do
    assert_difference('Resource.count', -1) do
      delete resource_url(@resource)
    end

    assert_redirected_to resources_url
  end

  test "random output redirects to a resource url" do
    @resource.update!(url: 'https://example.com/random')

    get random_output_url

    assert_redirected_to 'https://example.com/random'
  end

  test "random output redirects home when no resources exist" do
    Resource.delete_all

    get random_output_url

    assert_redirected_to root_url
    assert_equal 'No resource URL is available.', flash[:alert]
  end

  test "chatgpt image redirects to generated image url" do
    @resource.update!(title: 'Prompt title')

    images_client = Minitest::Mock.new
    images_client.expect(:create, { 'data' => [{ 'url' => 'https://example.com/image.png' }] }, [Hash])

    Openai::Client.stub(:images, images_client) do
      get chatgpt_image_output_url
    end

    images_client.verify
    assert_redirected_to 'https://example.com/image.png'
  end

  test "chatgpt image redirects home when no resources exist" do
    Resource.delete_all

    get chatgpt_image_output_url

    assert_redirected_to root_url
    assert_equal 'No resource title is available for image generation.', flash[:alert]
  end

  test "chatgpt image redirects home when image generation fails" do
    @resource.update!(title: 'Prompt title')

    images_client = Minitest::Mock.new
    images_client.expect(:create, nil) do
      raise StandardError, 'boom'
    end

    Openai::Client.stub(:images, images_client) do
      get chatgpt_image_output_url
    end

    assert_redirected_to root_url
    assert_equal 'Image generation did not return a URL.', flash[:alert]
  end
end
