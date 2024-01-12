class PromptDatum < ApplicationRecord
  include Searchable

  after_commit :index_record_content, on: [:create, :update]

  def index_record_content
    Rails.logger.info "#{self.class.name} Document with #{self.id} is being indexed...."
    document = self.as_json(only: [:content])
    SearchService.new.index_single_document(document: document)
  end

  def self.document_data
    select(:content).as_json(except: :id)
  end
end
