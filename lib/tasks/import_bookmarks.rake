namespace :bookmarks do
  desc "Import Chrome bookmark file (HTML) and check for duplicates"
  task import: :environment do
    # Ask for the file path
    puts "Please provide the path to the Chrome bookmark HTML file (e.g., bookmarks.html):"
    file_path = STDIN.gets.strip

    # Check if file exists
    unless File.exist?(file_path)
      puts "File does not exist at #{file_path}."
      exit
    end

    # Parse the HTML data from the file using Nokogiri
    begin
      html = File.read(file_path)
      doc = Nokogiri::HTML(html)
    rescue => e
      puts "Failed to parse the file. Error: #{e.message}"
      exit
    end

    # Extract bookmarks from the HTML structure
    bookmarks = extract_bookmarks(doc)

    # Import each bookmark and check for duplicates
    bookmarks.each do |bookmark|
      # Check if URL already exists
      if Resource.exists?(url: bookmark[:url])
        puts "Duplicate found for URL: #{bookmark[:url]}"
      else
        # Create the new Resource (adjust based on your model attributes)
        Resource.create!(url: bookmark[:url], title: bookmark[:title], description: bookmark[:description])
        puts "Imported: #{bookmark[:title]} (#{bookmark[:url]})"
      end
    end

    puts "Bookmark import completed."
  end

  # Helper method to extract bookmarks from the HTML using Nokogiri
  def extract_bookmarks(doc)
    bookmarks = []

    # Iterate over each <a> tag (bookmark link) in the HTML file
    doc.css('a').each do |link|
      # Only process <a> tags with the 'href' attribute (bookmark URLs)
      if link['href']
        bookmarks << { 
          url: link['href'], 
          title: link.text.strip,  # The title of the bookmark is the text inside the <a> tag
          description: link.text.strip  # You can modify this if you want to extract more details
        }
      end
    end

    bookmarks
  end
end

