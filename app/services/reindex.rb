# frozen_string_literal: true
class ResourceIndex

  def self.resource_index
    Resource.all.each do |work|
      work.save
      pid = work.id
      Rails.logger.debug "PID #{pid}"
    end
  end

end
