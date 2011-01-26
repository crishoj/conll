
require File.expand_path("../token", __FILE__)

module Conll

  class TokenList < Array

    def forms
      self.collect { |tok| tok.form }
    end

  end

  class Sentence
    attr_accessor :corpus, :index
    attr_reader :tokens, :root

    def self.parse(lines)
      Sentence.new do |sentence|
        lines.each do |line|
          sentence << Token.parse(line)
        end
      end
    end

    def initialize
      @root   = RootToken.new
      @root.sentence = self
      @tokens = TokenList.new
      yield self if block_given?
      self
    end

    def <<(token)
      token.sentence = self
      token.id ||= @tokens.count+1 
      @tokens << token
    end

    def [](*args)
      @tokens[*args]
    end

    def next
      @corpus.sentences[@index.succ]
    end

    def last?
      @index == (@corpus.sentences.size - 1)
    end

    def to_s
      @tokens.join("\n")
    end

    def grep(options = {})
      for token in tokens
        next if options[:pos]     and not token.pos == options[:pos]
        next if options[:cpos]    and not token.cpos == options[:cpos]
        next if options[:form]    and not token.form == options[:form]
        next if options[:feat]    and not token.features.include? options[:feat]
        next if options[:deprel]  and not token.deprel == options[:deprel]
        next if options[:form_re] and not token.form =~ options[:form_re]
        # Matched
        yield token
      end
    end

    def score(gold_sentence)
      total = tokens.size
      head_correct = tokens.find_all { |sent| sent.head_correct? gold_sentence[sent.index] }.size
      both_correct = tokens.find_all { |sent| sent.correct? gold_sentence[sent.index] }.size
      uas = head_correct.to_f / total.to_f
      las = both_correct.to_f / total.to_f
      [uas, las]
    end

  end
end
