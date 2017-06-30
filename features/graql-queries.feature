Feature: Graql Queries
  As a Grakn Developer, I should be able to interact with a Grakn Graph using Graql queries

    Background: A graph containing types and instances
        Given a graph
        And ontology `person sub entity, has name; name sub resource, datatype string;`
        And data `$alice isa person, has name "Alice";`

    Scenario: Valid Insert Query for Types
        Given A type that does not exist
        When The user inserts the type
        Then The type is in the graph
        And Return a response with new concepts

    Scenario: Redundant Insert Query
        Given A type that already exists
        When The user inserts the type
        Then Return a response with existing concepts

    Scenario: Valid Insert Query for Instances
        Given A type that already exists
        When The user inserts an instance of the type
        Then The instance is in the graph
        And Return a response with new concepts

    Scenario: Invalid Insert Query
        Given A type that does not exist
        When The user inserts an instance of the type
        Then Return an error


    Scenario: Match Query With Empty Response
        When The user issues a match query which should not have results
        Then Return an empty response


    Scenario: Match Query With Non-Empty Response
        When The user issues a match query which should have results
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
        Given An empty type
        When The user deletes the type
        Then Return a response


    Scenario: Unsuccessful Delete Query
        Given A type with instances
        When The user deletes the type
        Then Return an error


    Scenario: Delete Query for non Existent Concept
        Given A concept that does not exist
        When The user deletes the concept
        Then Return a response
