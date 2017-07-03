Feature: Client
    As a Grakn Developer I should be able to connect to a running Grakn Instance and use that instance to issue queries.


    Scenario: Issuing a query with a broken connection
        Given a broken connection to the database
        When the user issues `match $x sub entity;`
        Then return an error

    @skip
    Scenario: Creating a connection to a graph
        Given a graph which exists
        When the user connects to the graph
        Then return a usable connection

    @skip
    Scenario: Creating a connection to a non-existant graph
        Given a graph which does not exist
        When the user connects to the graph
        Then create a new graph
