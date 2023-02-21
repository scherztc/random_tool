# frozen_string_literal: true

namespace 'tool' do
  desc 'Index All Works'
  task reindex: :environment do
     @resources = Resource.all
     @resources.each do |work|
       pid = work.id
       puts "PID #{pid}"
       work.save
     end
#    ::ResourceIndex.resource_index
  end
end


