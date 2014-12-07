module GemfileArranger
  module Traverse
    class SortPriorityGemsInGroup < Parser::AST::Processor
      def initialize(keys)
        @keys = Array(keys).dup.map(&:to_s)
      end

      def on_block(node)
        sorted_block = sort_gems_in_group_with_keys(node, @keys)
        node.updated(:block, sorted_block) if node != sorted_block
      end

      def sort_gems_in_group_with_keys(node, keys)
        send_node, args_node, body_node = node.children
        return node if send_node.children[1] != :group
        return node if body_node.type != :begin
        gems = body_node.children.sort_by.with_index do |child, i|
          gem_name = child.children[2].children[0]
          key_index = keys.index(gem_name) || keys.length
          [key_index, i]
        end
        return node if body_node.children == gems

        sorted_body_node = body_node.updated(:begin, gems)
        [send_node, args_node, sorted_body_node]
      end
    end
  end
end
