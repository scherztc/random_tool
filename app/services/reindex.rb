# frozen_string_literal: true
class ResourceIndex

  def self.resource_index
    Resources.each do |type|
      Rails.logger.debug "Work Type : #{type}"
      type.all.each do |work|
        work.save
        pid = work.id
        Rails.logger.debug "PID #{pid}"
      end
    end
  end

end
