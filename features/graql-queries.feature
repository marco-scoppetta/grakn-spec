Feature: Graql Queries
  As a Grakn Developer, I should be able to interact with a Grakn knowledge base using Graql queries

    Background: A knowledge base containing types and instances
        Given a knowledge base
        And schema `person sub entity, has name; name sub attribute, datatype string;`
        And data `$alice isa person, has name "Alice";`

    Scenario: Valid Insert Query for Types
        When the user issues `insert $x label dog sub entity;`
        Then the type "dog" is in the knowledge base
        And return a response with new concepts

    Scenario: Redundant Insert Query
        When the user issues `insert $x label person sub entity;`
        Then return a response with existing concepts

    Scenario: Valid Insert Query for Instances
        When the user issues `insert $bob isa person, has name "Bob";`
        Then the instance with name "Bob" is in the knowledge base
        And return a response with new concepts

    Scenario: Invalid Insert Query
        When the user issues `insert $dunstan isa dog, has name "Dunstan";`
        Then return an error

    Scenario: Match Query With Empty Response
        When the user issues `match $x isa person, has name "Precy";`
        Then the response has no results

    Scenario: Match Query With Non-Empty Response
        When the user issues `match $x isa person, has name "Alice";`
        Then the response has 1 result

    Scenario: Ask Query With False Response
        When the user issues `match $x has name "Precy"; ask;`
        Then the response is `False`

    Scenario: Ask Query With True Response
        When the user issues `match $x has name "Alice"; ask;`
        Then the response is `True`

    Scenario: Aggregate Query
        When the user issues `match $x isa person; aggregate count;`
        Then the response is `1`

    Scenario: Compute Query
        When the user issues `compute count in person;`
        Then the response is `1`

    Scenario: Successful Delete Query
        Given ontology `dog sub entity;`
        When the user issues `match $x label dog; delete $x;`
        Then the response is empty

    Scenario: Unsuccessful Delete Query
        When the user issues `match $x label person; delete $x;`
        Then return an error

    Scenario: Delete Query for non Existent Concept
        When the user issues `match $x has name "Precy"; delete $x;`
        Then the response is empty
