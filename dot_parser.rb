# Class: DotParser
# Author: Zachary Johnson
#
# This class takes a list of tokens and parses it
# into different statements.
class DotParser

  # Constructor a dot parser object
  def initialize(lexer)
    @token_list = lexer.instance_variable_get(:@token_list)
    @curr_index = 0
  end

  # Parses out a digraph from the list of tokens
  def graph
    if @token_list[@curr_index].instance_variable_get(:@type) == Token::DIGRAPH
      puts "Start recognizing a digraph"
      @curr_index += 1
      whitespace
      if id
        whitespace
        if @token_list[@curr_index].instance_variable_get(:@type) == Token::LCURLY
          puts "Start recognizing a cluster"
          @curr_index += 1
          whitespace
          if stmt_list
            whitespace
            if @token_list[@curr_index].instance_variable_get(:@type) == Token::RCURLY
              puts "Finish recognizing a cluster"
              puts "Finish recognizing a digraph"
              @curr_index += 1
              whitespace
              graph
            end
          end
        end
      end
    end
  end

  # Parses out a statement list from the tokens
  def stmt_list
    while @token_list[@curr_index].instance_variable_get(:@type) != Token::RCURLY
      if stmt
        whitespace
        if @token_list[@curr_index].instance_variable_get(:@type) == Token::SEMI
          @curr_index += 1
          whitespace
        end
      else
        return false
      end
    end
    return true
  end

  # Parses out a statement from the tokens
  def stmt
    if subgraph
      whitespace
      return true
    end

    if edge_stmt
      whitespace
      return true
    end

    if id
      whitespace
      if @token_list[@curr_index].instance_variable_get(:@type) == Token::EQUALS
        puts "Start recognizing a property"
        @curr_index += 1
        whitespace
        if id
          puts "Finish recognizing a property"
          whitespace
          return true
        end
      end
    end

    puts "Error: expecting property, edge or subgraph, but found: " + @token_list[@curr_index].instance_variable_get(:@text)
    return false

  end

  # Parses out an edge statement from the tokens
  def edge_stmt
    if id || subgraph
      whitespace
      if edge
        puts "Start recognizing an edge statement"
        whitespace
        if edgeRHS
          whitespace
          if @token_list[@curr_index].instance_variable_get(:@type) == Token::LBRACK
            @curr_index += 1
            whitespace
            if attr_list
              whitespace
              if @token_list[@curr_index].instance_variable_get(:@type) == Token::RBRACK
                @curr_index+= 1
                whitespace
              end
            end
          end
          puts "Finish recognizing an edge statement"
          return true
        end
      end
      @curr_index -= 1
    end
    return false
  end

  # Parses out an attribute list from the tokens
  def attr_list
    if id
      puts "Start recognizing a property"
      whitespace
      if @token_list[@curr_index].instance_variable_get(:@type) == Token::EQUALS
        @curr_index += 1
        whitespace
        if id
          whitespace
        end
      end
      puts "Finish recognizing a property"
      while @token_list[@curr_index].instance_variable_get(:@type) == Token::COMMA
        puts "Start recognizing a property"
        @curr_index += 1
        whitespace
        if id
          whitespace
          if @token_list[@curr_index].instance_variable_get(:@type) == Token::EQUALS
            @curr_index += 1
            whitespace
            if id
              whitespace
            end
          end
          puts "Finish recognizing a property"
        end
      end
      return true
    end
    return false
  end

  # Parses out an edge Right Hand Side from the tokens
  def edgeRHS
    if id || subgraph
      whitespace
      while edge
        whitespace
        if id || subgraph
          whitespace
        end
      end
      return true
    end
    return false
  end

  # Parses out an edge from the tokens
  def edge
    if @token_list[@curr_index].instance_variable_get(:@type) == Token::ARROW
      @curr_index += 1
      whitespace
      return true
    end
    return false
  end

  # Parses out a subgraph from the tokens
  def subgraph
    if @token_list[@curr_index].instance_variable_get(:@type) == Token::SUBGRAPH
      puts "Start recognizing a subgraph"
      @curr_index += 1
      whitespace
      if id
        whitespace
        if @token_list[@curr_index].instance_variable_get(:@type) == Token::LCURLY
          puts "Start recognizing a cluster"
          @curr_index += 1
          whitespace
          if stmt_list
            whitespace
            if @token_list[@curr_index].instance_variable_get(:@type) == Token::RCURLY
              puts "Finish recognizing a cluster"
              puts "Finish recognizing a subgraph"
              @curr_index += 1
              whitespace
              if @token_list[@curr_index].instance_variable_get(:@type) == Token::SUBGRAPH
                subgraph
              end
              return true
            end
          end
        end
      end
    end
    return false
  end

  # Parses out an id from the tokens
  def id
    if @token_list[@curr_index].instance_variable_get(:@type) == Token::ID || @token_list[@curr_index].instance_variable_get(:@type) == Token::STRING || @token_list[@curr_index].instance_variable_get(:@type) == Token::INT
      @curr_index += 1
      whitespace
      return true
    end
    return false
  end

  # Parses out the whitespace from the tokens
  def whitespace
    while @token_list[@curr_index].instance_variable_get(:@type) == Token::WS
      @curr_index += 1
    end
  end
end