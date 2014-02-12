require 'asciidoctor/extensions'
require_relative 'asciidoctor-diagrams/version'

Asciidoctor::Extensions.register do
  require 'asciidoctor-diagrams/plantuml'
  block :plantuml, Asciidoctor::Diagrams::PlantUmlBlock
end
