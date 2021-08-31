# frozen_string_literal: true

require_relative '../lib/menu'

def main
  Menu.new.show_menu
end

main if __FILE__ == $PROGRAM_NAME
