require "active_support/concern"

module Searchable
  extend ActiveSupport::Concern

  class_methods do
    def search(query: '')
      SearchService.new.search(query: query, collection_name: self.name.underscore)
    end
  end
end