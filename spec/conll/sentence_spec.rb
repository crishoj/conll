
require File.expand_path("../../spec_helper", __FILE__)
require File.expand_path("../../../lib/conll/sentence", __FILE__)
require File.expand_path("../../../lib/conll/corpus", __FILE__)

describe Conll::Sentence do
  before(:all) do
    @corpus = Conll::Corpus.parse(@corpus_filename)
    @sentence = @corpus.sentences.first
  end

  before(:each) do
  end

  it "should have 22 tokens" do
    @sentence.should have(22).tokens
  end

  it "should interpret dependencies" do
    @sentence.tokens.first.head.should_not be_nil
  end

  it "should interpret dependencies correctly" do
    @sentence.tokens.first.head.form.should match(/tror/)
  end

  it "should have a reference to the next sentence" do
    @sentence.next.should be_kind_of(Conll::Sentence)
    @sentence.next.should_not equal @sentence
  end

  it "should refer to a sentence with adjacent index" do
    @sentence.index.succ.should equal(@sentence.next.index)
  end

  it "should know whether it is the last sentence" do
    @sentence.last?.should_not be_true
  end

end

