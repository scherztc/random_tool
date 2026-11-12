access_token = ENV['OPENAI_ACCESS_TOKEN']

if access_token.present?
  Openai::Client.configure do |c|
    c.access_token = access_token
    c.organization_id = ENV['OPENAI_ORGANIZATION_ID']
  end
else
  Rails.logger.warn('OPENAI_ACCESS_TOKEN is not set; ChatGPT image generation is disabled.')
end
