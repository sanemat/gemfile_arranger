module GemfileArranger
  class SortBlockTraverser < Parser::AST::Processor
    def initialize(keys)
      @keys = Array(keys.dup).map(&:to_sym)
    end

    def on_begin(node)
      sorted_block = sort_block_with_keys(node, @keys)
      node.updated(:begin, sorted_block) if node != sorted_block
    end

    def sort_block_with_keys(node, keys)
      node.children.sort_by.with_index do |child, i|
        _, gem_name, *_ = child.children
        key_index = keys.index(gem_name) || keys.length
        [key_index, i]
      end
    end
  end
end
