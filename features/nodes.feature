Feature: Display all known nodes
  Nodes should be loaded from the $yamldir
  Nodes should have a set of facts
  Every node-fact should be loaded correctly, given the YAML available at run time
  
  Scenario: Nodes are loaded correctly
    When I GET "/api/v1/nodes"
    Then the response should be 200
    And I should receive the JSON:
    """
    [ "agent", "master" ]
    """

  Scenario: root redirects to /nodes
    When I GET "/" 
    Then I should be redirected to "/nodes"

