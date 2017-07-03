Feature: Graql Queries
  As a Grakn Developer, I should be able to interact with a Grakn Graph using Graql queries

    Background: A graph containing types and instances
        Given a graph
        And ontology `person sub entity, has name; name sub resource, datatype string;`
        And data `$alice isa person, has name "Alice";`

    Scenario: Valid Insert Query for Types
        When The user issues `insert $x label dog sub entity;`
        Then The type "dog" is in the graph
        And Return a response with new concepts

    Scenario: Redundant Insert Query
        When The user issues `insert $x label person sub entity;`
        Then Return a response with existing concepts

    Scenario: Valid Insert Query for Instances
        When The user issues `insert $bob isa person, has name "Bob";`
        Then The instance with name "Bob" is in the graph
        And Return a response with new concepts

    Scenario: Invalid Insert Query
        When The user issues `insert $dunstan isa dog, has name "Dunstan";`
        Then Return an error

    Scenario: Match Query With Empty Response
        When The user issues `match $x isa person, has name "Precy";`
        Then Return an empty response

    Scenario: Match Query With Non-Empty Response
        When The user issues `match $x isa person, has name "Alice";`
        Then Return a response with matching concepts

    Scenario: Ask Query With False Response
        When The user issues `match $x has name "Precy"; ask;`
        Then The response is `False`

    Scenario: Ask Query With True Response
        When The user issues `match $x has name "Alice"; ask;`
        Then The response is `True`

    Scenario: Aggregate Query
        When The user issues `match $x isa person; aggregate count;`
        Then The response is `1`

    Scenario: Compute Query
        When The user issues `compute count in person;`
        Then The response is `1`

    Scenario: Successful Delete Query
        Given ontology `dog sub entity;`
        When The user issues `match $x label dog; delete $x;`
        Then Return a response

    Scenario: Unsuccessful Delete Query
        When The user issues `match $x label person; delete $x;`
        Then Return an error

    Scenario: Delete Query for non Existent Concept
        When The user issues `match $x has name "Precy"; delete $x;`
        Then Return a response
