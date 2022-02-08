# Class: DotLexer
# Author: Zachary Johnson
#
# This class reads in a sample of Dot Language.
# This class also converts the input into a list of tokens
# and maintains that list of tokens.
require_relative 'token.rb'

class DotLexer

  # Constructor for a DotLexer object
  def initialize
    @type = 0
    @input = gets("\t\n").chomp.split('')
    @token_list = create_tokens
    @token_counter = 0
  end

  # Returns the next token in the list
  def next_token
    token = @token_list[@token_counter]
    @token_counter += 1
    return token
  end

  # Converts the input into an array of tokens
  def create_tokens
    token_list = Array.new
    curr_index = 0
    token_count = 0
    token = @input[curr_index]
    while curr_index < @input.length
      if is_token(token, curr_index)
        token_list[token_count] = Token.new(@type, token)
        token_count += 1
        @type = 0
        token = ""
      end
      curr_index += 1
      if is_valid_char(@input[curr_index])
        token += @input[curr_index]
      else
        if curr_index < @input.length
          token_list[token_count] = Token.new(Token::INVALID, @input[curr_index])
          token_count += 1
        else
          token_list[token_count] = Token.new(Token::EOF, @input[curr_index])
          token_count += 1
        end
      end
    end
    return token_list
  end

  # Determines if a given string is a token and of what type.
  def is_token(token, curr_index)
    if token[0].to_s.match?(/[0-9]/) && @input[curr_index + 1] == " "
      @type = Token::INT
    elsif token[0] == "\"" && token[token.length - 1] == "\"" && token.length > 1
      @type = Token::STRING
    elsif token == "{"
      @type = Token::LCURLY
    elsif token == "}"
      @type = Token::RCURLY
    elsif token == ";"
      @type = Token::SEMI
    elsif token == "["
      @type = Token::LBRACK
    elsif token == "]"
      @type = Token::RBRACK
    elsif token == "->"
      @type = Token::ARROW
    elsif token == "="
      @type = Token::EQUALS
    elsif (token == "digraph" || token == "DIGRAPH") && @input[curr_index + 1] == " "
      @type = Token::DIGRAPH
    elsif (token == "subgraph" || token == "SUBGRAPH") && @input[curr_index + 1] == " "
      @type = Token:: SUBGRAPH
    elsif token == ","
      @type = Token::COMMA
    elsif token == "\n" || token == "\t" || token == " "
      @type = Token::WS
    elsif token[0].to_s.match?(/[a-zA-Z]/)
      if !(@input[curr_index + 1].to_s.match?(/[a-zA-Z]/) || @input[curr_index + 1].to_s.match?(/[0-9]/))
        @type = Token::ID
      end
    end
    if @type != 0
      return true
    else
      return false
    end
  end

  # Determines if a given character from input is a valid character in Dot Language.
  def is_valid_char(c)
    is_valid = false
    if c.to_s.match?(/[a-zA-Z]/)
      is_valid = true
    elsif c.to_s.match?(/[0-9]/)
      is_valid = true
    elsif c == "\""
      is_valid = true
    elsif c == "{"
      is_valid = true
    elsif c == "}"
      is_valid = true
    elsif c == ";"
      is_valid = true
    elsif c == "["
      is_valid = true
    elsif c == "]"
      is_valid = true
    elsif c == "-"
      is_valid = true
    elsif c == ">"
      is_valid = true
    elsif c == "="
      is_valid = true
    elsif c == ","
      is_valid = true
    elsif c == "\n" || c == "\t" || c == " "
      is_valid = true
    end
    return is_valid
  end
end