namespace :resources do
  desc "Export all resources to a CSV file"
  task export: :environment do
    require 'csv'

    # File path for the CSV file
    file_path = Rails.root.join('exported_resources.csv')

    # Open or create the CSV file
    CSV.open(file_path, 'w', headers: true) do |csv|
      # Add headers to the CSV file
      csv << %w[ID Title Description URL Category Created_At Updated_At]

      # Fetch all resources and write their data to the CSV
      Resource.find_each do |resource|
        csv << [
          resource.id,
          resource.title,
          resource.description,
          resource.url,
          resource.category,
          resource.created_at,
          resource.updated_at
        ]
      end
    end

    puts "Resources exported to #{file_path}"
  end
end

