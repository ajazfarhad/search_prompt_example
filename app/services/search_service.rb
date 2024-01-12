# frozen_string_literal: true

class SearchService
  DEFAULT_COLLECTION_NAME = 'prompt_datum'
  DEFAULT_QUERY_BY = 'content'

  def initialize
    @client = Typesense::Client.new(
      nodes: [Rails.application.config_for(:search_settings)],
      api_key: ENV['TYPESENSE_API_KEY']
    )
  end

  def search(query: '', collection_name: DEFAULT_COLLECTION_NAME, query_by: DEFAULT_QUERY_BY)
    data = client.collections[collection_name].documents.search({
                                                                  query_by:,
                                                                  q: query
                                                                })
    build_search_result(data)
  end

  def index_single_document(collection_name: DEFAULT_COLLECTION_NAME, document: '')
    build_schema(name: collection_name)
    client.collections[collection_name].documents.upsert(document)
  end

  def index_documents(collection_name: DEFAULT_COLLECTION_NAME)
    # index full model records for a given collection
    build_schema(name: collection_name)
    prepare_documents(collection_name)
  end

  private

  attr_reader :client

  def build_search_result(data)
    extract_content_with_highlights = ->(data) { data.values_at('document', 'highlight').pluck('content') }

    data_collection = data['hits'].map(&extract_content_with_highlights)
    data_collection.map(&method(:build_response_with_query_highlights))
  end

  def build_response_with_query_highlights(result_data)
    content, tokens = result_data
    return { 'content' => content } unless tokens

    matched_tokens = tokens['matched_tokens']
    highlight_result = content.gsub(/\b(?:#{matched_tokens.join('|')})\b/i) do |match|
      "<mark>#{match}</mark>"
    end
    { 'content' => highlight_result }
  end

  def build_schema(name:)
    schema = {
      name:,
      fields: [{ name: 'content', type: 'string' }]
    }
    client.collections.create(schema) unless existing_collection?(name)
  end

  def existing_collection?(name)
    client.collections.retrieve.map { |hash| hash['name'] }.include?(name)
  end

  def prepare_documents(collection_name)
    # inefficient way of indexing a full model
    # in production env, indexing should be delegated to a background worker
    # and records can be passed as a batch to the import
    documents = collection_name.classify.constantize.document_data
    client.collections[collection_name].documents.import(documents, action: 'upsert')
  end
end
