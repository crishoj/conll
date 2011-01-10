
require File.expand_path("../../spec_helper", __FILE__)
require File.expand_path("../../../lib/conll/token", __FILE__)

describe Conll::Token do

  before(:each) do
    @token = Conll::Token.parse(@token_line)
  end

  it "should return a Token for a parsed line" do
    @token.should be_kind_of(Conll::Token)
  end

  it "should have a form" do
    @token.should respond_to(:form)
  end

  it "should have form 'To'" do
    @token.form.should match(/To/)
  end

  it "should have CPOS 'A'" do
    @token.cpos.should match(/^A$/)
  end

  it "should have POS 'AC'" do
    @token.pos.should match(/^AC$/)
  end

  it "should have enumerable features" do
    @token.features.should be_kind_of(Enumerable)
  end

  it "should register itself on the sentence" do
    sentence = Conll::Sentence.new
    sentence << @token
    sentence.tokens.last.should equal(@token)
  end

  it "should dump itself in the CoNLL format" do
    @token.to_s.should be_kind_of(String)
    # Best way to test string equality?
    @token.to_s.should include(@token_line)
    @token_line.should include(@token.to_s)
  end

  it "should know of its dependents" do
    @corpus = Conll::Corpus.parse(@corpus_filename)
    @sentence = @corpus.sentences.first
    @token = @sentence.tokens[14]
    @token.form.should match(/kan/)
    @token.should have(3).dependents
    dep_forms = @token.dependents.map(&:form)
    %w{Rusland udvikles uden}.each do |form|
      dep_forms.should include(form)
    end
  end

end

