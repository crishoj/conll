
RSpec.configure do |config|

  config.before(:all) do
    @corpus_filename = 'spec/corpus.conll'
    @corpus_file = File.open(@corpus_filename, 'r')
    @token_line = @corpus_file.gets
  end

end