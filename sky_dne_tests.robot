*** Settings ***
Documentation  API Testing in Robot Framework
Library  RequestsLibrary
Library  JSONLibrary
Library  jsonschema
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
    # Log     ${getHeaderValue}
    Should be True      ${getHeaderValue} > 1

Verify response has Valid Json Data
    [documentation]  This test case verifies that the response resturns a Valid json
    [tags]  Functional
    Create Session  mysession  https://gorest.co.in/  verify=true
    ${response} =  GET On Session  mysession  /public/v2/users/
    # ${data} = ${response.content}
    # ${json_dict}    Evaluate    json.loads(${response.content})   modules=json
    # Should be True      ${getHeaderValue} > 1
    ${is_json}      Evaluate     isinstance(${response.content}, int)
    ${type} =    Evaluate    type(${response.content}).__name__
    # Log To Console      ${response.content} ${type} ${is_json}
    Should be equal As Strings      ${type}     dict

Verify Response Data has email address
    [documentation]  This test case verifies that the response resturns a Valid json
    [tags]  Functional
    Create Session  mysession  https://gorest.co.in/  verify=true
    ${response}=  GET On Session  mysession  /public/v2/users/
    ${body}=    Convert To String     ${response.content}
    Should Contain      ${body}     email

Verify all entries on list data have similar attributes
    [documentation]  This test case verifies that the all the response entries have similar keys
    [tags]  Functional
    Create Session  mysession  https://gorest.co.in/  verify=true
    ${response}=  GET On Session  mysession  /public/v2/users/
    ${data}=    Evaluate    json.loads(json.dumps(${response.content}))
    # Log To Console 
    ${base_entry}=      Get Dictionary Keys      ${data}[0]
    FOR    ${item}    IN    @{data}
        # Log To Console   ${item.keys()} == ${base_entry}
        ${item_keys}=   Get Dictionary Keys      ${item}
        Should be equal     ${item_keys}  ${base_entry}
    END
    # Should Contain      ${body}     email