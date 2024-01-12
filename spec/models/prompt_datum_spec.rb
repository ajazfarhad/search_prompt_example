require 'rails_helper'

RSpec.describe PromptDatum, type: :model do
  let(:search_service_double) { instance_double(SearchService) }

  before do
    allow(SearchService).to receive(:new).and_return(search_service_double)
  end

  describe 'after_commit :index_record_content' do
    let(:prompt_datum) { build(:prompt_datum) }

    it 'calls index_single_document on SearchService after creating a record' do
      expect(search_service_double).to receive(:index_single_document).with(document: prompt_datum.as_json(only: [:content]))

      prompt_datum.save!
    end
  end
end
