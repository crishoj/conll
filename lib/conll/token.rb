
require File.expand_path("../sentence", __FILE__)
require File.expand_path("../corpus", __FILE__)

module Conll
  Token = Struct.new(:id, :form, :lemma, :cpos, :pos, :feats, :head_id, :deprel, :phead_id, :pdeprel)

  class Token
    attr_accessor :sentence

    def self.parse(line)
      fields = line.split(/\t/)
      fields = fields[0..2] + fields[3..-1].collect do |f|
        # Interpret dash/underscore as "missing value" and use nil instead
        (f == '_' or f == '-') ? nil : f
      end unless fields.size < 4
      # Pass in a reference to the sentence
      Token.new(*fields)
    end

    def initialize(*vals)
      super(*vals)
      # Split features
      @features = vals[5].split(/\|/) unless vals[5].nil?
      yield self if block_given?
    end

    # Gives the base-0 index of this token into the sentence
    def index
      self.id.to_i - 1
    end

    def first?
      self.index == 0
    end

    def last?
      self.index == @sentence.tokens.size - 1
    end

    def next
      @sentence.tokens[index + 1]
    end

    def prev
      @sentence.tokens[index - 1]
    end

    def features
      @features ||= []
    end

    def head
      find_token(self.head_id)
    end

    def dependents
      @sentence.tokens.find_all { |tok| tok.head_id == self.id }
    end

    def phead
      find_token(self.phead_id)
    end

    def to_s
      if self.features.size > 0
        self.feats = self.features.to_a.join('|')
      else
        self.feats = nil
      end
      self.values.collect { |val|
        val.nil? ? '_' : val
      }.join("\t")
    end

    def head_correct? gold_token
      self.head.id == gold_token.head.id
    end

    def label_correct? gold_token
      self.deprel == gold_token.deprel
    end

    def correct? gold_token
      head_correct? gold_token and label_correct? gold_token
    end

    def leading(n)
      @sentence.tokens[self.index-n .. self.index-1]
    end

    def trailing(n)
      @sentence.tokens[self.index+1 .. self.index+n]
    end

    private

    def find_token(id)
      if id == '0'
        @sentence.root
      else
        @sentence.tokens[id.to_i - 1]
      end
    end

  end

  class RootToken < Token
    def initialize
      super('0', 'ROOT')
    end
  end
  
end
