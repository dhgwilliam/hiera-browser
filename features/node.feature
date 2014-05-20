Feature: Return a hash of keys and values
  Scenario: POST with params
    When I POST to "/api/v1/node/agent" with:
      | Name        | Value     |
      | keys        | ['test_hash'] |
    Then the response should be 200
    And I should receive the JSON:
    """
    {
      "test_array": ["array value 1 from pdx.yaml","array value 2 from pdx.yaml","array value 3 from pdx.yaml"],
      "test_hash": {"test_hash_key1":"test_hash_key1 value from pdx.yaml","test_hash_key2":"test_hash_key2 value from pdx.yaml","test_hash_key3":"test_hash_key3 value from pdx.yaml","test_hash_merge_common":"test_hash_merge_key from common.yaml","test_hash_merge_pdx":"test_hash_merge_key from pdx.yaml"},
      "test_string":"test_string value from pdx.yaml"
    }
    """

