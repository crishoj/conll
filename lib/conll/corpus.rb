
require File.expand_path("../sentence", __FILE__)

module Conll
  class Corpus
    attr_reader :sentences, :filename

    def self.parse(file)
      Corpus.new(file) do |corpus|
        File.new(file).each("\n\n") do |part|
          lines = part.split(/\n/)
          corpus << Conll::Sentence.parse(lines)
        end
      end
    end

    def <<(sentence)
      sentence.corpus = self
      sentence.index = @sentences.size
      @sentences << sentence
    end

    def [](*args)
      sentences[*args]
    end

    def initialize(filename = '')
      @filename  = filename
      @sentences = []
      yield self if block_given?
      self
    end

    def evaluate(gold, categories = {})
      @counts = {}
      for sent in @sentences
        gold_sent = gold.sentences[sent.index]
        count_sentence(:total)
        for tok in sent.tokens
          eval_token(:total, tok, gold_sent.tokens[tok.index])
        end
      end
      categories.each_pair do |category, options|
        grep(options) do |sent|
          count_sentence(category)
          gold_sent = gold.sentences[sent.index]
          for tok in sent.tokens
            eval_token(category, tok, gold_sent.tokens[tok.index])
          end
        end
      end
      @counts
    end

    def count_sentence(category)
      @counts[category] ||= Hash.new(0)
      @counts[category][:sentences] += 1
    end

    def eval_token(category, token, gold_token)
      @counts[category] ||= Hash.new(0)
      @counts[category][:tokens] += 1
      if token.head_correct? gold_token
        @counts[category][:head_correct] += 1
        @counts[category][:both_correct] += 1 if token.label_correct? gold_token
      end
    end

    def to_s
      @sentences.join("\n\n") + "\n"
    end

    def grep(options = {})
      for sentence in @sentences
        sentence.grep(options) do |tok|
          yield sentence
          break
        end
      end
    end
    
  end
end
