# Class: Token
# Author: Zachary Johnson
#
# This class maintains the constants for each type of token.
# Also holds the type and text of each token.
class Token

  ID = 1
  INT = 2
  STRING = 3
  LCURLY = 4
  RCURLY = 5
  SEMI = 6
  LBRACK = 7
  RBRACK = 8
  ARROW = 9
  EQUALS = 10
  DIGRAPH = 11
  SUBGRAPH = 12
  COMMA = 13
  WS = 14
  INVALID = 15
  EOF = 16

  # Constructor for a Token object
  def initialize (type, text)
    @type = type
    @text = text
  end

  # Returns the type of the token.
  def type
    return @type
  end

  # Returns the text of the token.
  def text
    return @text
  end

  # Override to_s to print based on the type of token.
  def to_s
    if @type == INVALID
      return "illegal char: " + text.to_s.chomp(' ')
    elsif @type != WS
      return "[" + text.to_s.chomp(' ') + ":" + type.to_s + "]"
    end
  end
end