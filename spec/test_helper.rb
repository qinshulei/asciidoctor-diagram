require 'asciidoctor'
require 'asciidoctor/cli/invoker'

require 'fileutils'
require 'stringio'
require 'tmpdir'

require_relative '../lib/asciidoctor-diagram'
require_relative '../lib/asciidoctor-diagram/blockdiag/extension'
require_relative '../lib/asciidoctor-diagram/ditaa/extension'
require_relative '../lib/asciidoctor-diagram/graphviz/extension'
require_relative '../lib/asciidoctor-diagram/mermaid/extension'
require_relative '../lib/asciidoctor-diagram/plantuml/extension'
require_relative '../lib/asciidoctor-diagram/shaape/extension'
require_relative '../lib/asciidoctor-diagram/wavedrom/extension'

module Asciidoctor
  class AbstractBlock
    def find(&block)
      blocks.each do |b|
        if block.call(b)
          return b
        end

        if (found_block = b.find(&block))
          return found_block
        end
      end
      nil
    end
  end
end

RSpec.configure do |c|
  if /darwin/ =~ RUBY_PLATFORM
    c.filter_run_excluding :broken_on_osx => true
  end

  if ENV['TRAVIS']
    c.filter_run_excluding :broken_on_ci => true
  end

  TEST_DIR = File.expand_path('testing')

  c.before(:suite) do
    FileUtils.rm_r TEST_DIR if Dir.exists? TEST_DIR
    FileUtils.mkdir_p TEST_DIR
  end

  c.around(:each) do |example|
    metadata = example.metadata
    group_dir = File.expand_path(metadata[:example_group][:full_description].gsub(/[^\w]+/, '_'), TEST_DIR)
    Dir.mkdir(group_dir) unless Dir.exists?(group_dir)

    test_dir = File.expand_path(metadata[:description].gsub(/[^\w]+/, '_'), group_dir)
    Dir.mkdir(test_dir)

    Dir.chdir(test_dir) do
      example.run
    end
  end
end