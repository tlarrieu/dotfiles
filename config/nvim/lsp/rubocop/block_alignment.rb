# frozen_string_literal: true

# Preloaded (RUBYOPT) into the rubocop language server by lsp/rubocop.lua.
#
# Layout/BlockAlignment#inside_parentheses? (RuboCop >= 1.91) scans every token of the file for
# each block: quadratic, ~400ms per run on a 2000 lines spec. Tokens are sorted, so a binary search
# finds the ones between the node and the position instead.
#
# RuboCop is not loaded yet when this runs (`bundle exec` loads it later, in the same process):
# the patch is applied once the cop class is defined, and only if the slow implementation is still
# there.

module RuboCopBlockAlignmentPatch
  SLOW = 'processed_source.tokens.select do |token|'

  def self.applicable?(klass)
    return false unless klass.private_method_defined?(:inside_parentheses?, false)

    file, line = klass.instance_method(:inside_parentheses?).source_location
    File.readlines(file)[line, 2].join.include?(SLOW)
  rescue StandardError
    false
  end

  private

  def inside_parentheses?(node, pos)
    tokens = processed_source.tokens
    from = first_token_index_at(tokens, node.source_range.begin_pos)
    to = first_token_index_at(tokens, pos)

    tokens[from...to].sum { |token| token_depth(token) }.positive?
  end

  def first_token_index_at(tokens, pos)
    tokens.bsearch_index { |token| token.begin_pos >= pos } || tokens.size
  end

  def token_depth(token)
    return 1 if token.left_parens? || token.left_bracket?
    return -1 if token.right_parens? || token.right_bracket?

    0
  end
end

TracePoint.new(:end) do |tp|
  klass = tp.self
  next unless klass.is_a?(Class) && klass.name == 'RuboCop::Cop::Layout::BlockAlignment'

  tp.disable
  klass.prepend(RuboCopBlockAlignmentPatch) if RuboCopBlockAlignmentPatch.applicable?(klass)
end.enable
