*** Settings ***
Documentation  API Testing in Robot Framework
Library  RequestsLibrary
Library  JSONLibrary
Library  Collections

*** Variables ***

*** Test Cases ***
Do a GET Request and validate the response code and response body
    [documentation]  This test case verifies that the response code of the GET Request should be 200
    [tags]  Functional
    Create Session  mysession  https://gorest.co.in/  verify=true
    ${response} =  GET On Session  mysession  /public/v2/users/
    Status Should Be  200  ${response}  #Check Status as 200


Verify response has pagination
    [documentation]  This test case verifies that the response code header for X-Pagination-Pages
    [tags]  Functional
    Create Session  mysession  https://gorest.co.in/  verify=true
    ${response} =  GET On Session  mysession  /public/v2/users/
    ${getHeaderValue} =  Get From Dictionary  ${response.headers}   X-Pagination-Pages
    Log     ${getHeaderValue}
    Should be True      ${getHeaderValue} > 1
