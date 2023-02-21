# frozen_string_literal: true
# namespace 'tool' do
#   desc 'Index All Works'
  task reindex: :environment do
    # NOTE: In order to see progress in the logs, you must have logging at :info or above
    ResourceIndex.resource_index
  end
# end
