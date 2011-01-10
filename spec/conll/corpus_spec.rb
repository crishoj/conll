
require File.expand_path("../../spec_helper", __FILE__)
require File.expand_path("../../../lib/conll/corpus", __FILE__)

describe Conll::Corpus do
  before(:each) do
    @corpus = Conll::Corpus.parse(@corpus_filename)
  end

  it "should have 4 sentences" do
    @corpus.should have(4).sentences
  end
end

