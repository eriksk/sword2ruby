require 'rexml/document'

module Sword2Ruby
  #This class models the OAI-ORE Sword Statement.
  #
  #For more information, see the Sword2 specification: {section 11.3. "OAI-ORE Serialisation"}[http://sword-app.svn.sourceforge.net/viewvc/sword-app/spec/tags/sword-2.0/SWORDProfile.html?revision=377#statement_oaiore].
  class SwordStatementOAIORE
    
    #The complete statement document, returned as a REXML::Document.
    attr_reader :statement_document
    
    #An array of rdf:descriptions. See the overload methods in REXML::Element for each description's methods.
    attr_reader :rdf_descriptions

    #Creates a new SwordStatementOAIORE object, using the supplied URI and connection object.
    #===Parameters
    #sword_statement_uri:: The URI string to the OAI-ORE Sword Statement.
    #connection:: Sword2Ruby::Connection object used to perform the operation.
    def initialize(sword_statement_uri, connection)
      #Validate parameters
      Utility.check_argument_class('sword_statement_uri', sword_statement_uri, String)
      Utility.check_argument_class('connection', connection, Connection)
      
      response = connection.get(sword_statement_uri)

      if response.is_a? Net::HTTPSuccess
         @statement_document = REXML::Document.new(response.body.to_s.encode('UTF-8'))
         @rdf_descriptions = []
         @statement_document.elements.each("/rdf:RDF/rdf:Description") do |description|
           @rdf_descriptions << description
         end
       else
         raise Sword2Ruby::Exception.new("Failed to do get(#{sword_statement_uri}): server returned code #{response.code} #{response.message}")   
      end
    end
    
  end
end
