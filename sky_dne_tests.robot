*** Settings ***
Documentation  API Testing in Robot Framework
Library  RequestsLibrary
Library  JSONLibrary
Library  jsonschema
Library  Collections


*** Variables ***
${auth_token}=  7a170016b7ee10b2e6161554a07ade2ebbc9d37b28a62a320a400e2878fac02f
# &{headers}=     Create Dictionary  Authorization="Bearer 10c46325c3ead766bb6457c68538839d9b04fc58eb68d14778b032588c978b24"
# &{headers}=  Create Dictionary  Authorization=Bearer ${auth_token}
&{headers}=    Accept=application/json    Content-Type=application/json    Authorization=Bearer ${auth_token}

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
    ${data}=    Evaluate    json.loads(json.dumps(${response.content}))
    # ${type} =    Evaluate    type(${response.content}).__name__
    ${type} =    Evaluate    type(${data[0]}).__name__
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


Verify HTTP response code 200
    [documentation]  This test case verifies if status code returned is 200
    [tags]  Non-Functional
    Create Session  mysession  https://gorest.co.in/  verify=true
    ${response} =  GET On Session  mysession  /public/v2/users/
    Status Should Be  200  ${response}  #Check Status as 200


Verify HTTP response code 201
    [documentation]  This test case verifies if status code returned is 200
    [tags]  Non-Functional
    Create Session  mysession  https://gorest.co.in/    verify=true
    &{body}=    Create Dictionary   name=Batman2  email=bruce.wayne@waynetech2.com  gender=male  status=active
    Log To Console  ${headers} ${body}
    # &{headers}=  Create Dictionary  Authorization=Bearer ${auth_token}
    # Log To Console   ${body}  ${headers}
    ${response} =  POST On Session  mysession  /public/v2/users/    headers=${headers}   json=${body}
    # ${response} =  GET On Session  mysession  /public/v2/users/    headers=${headers}
    # ${response} =   POST    https://gorest.co.in/public/v2/users   data=${body}    headers=${headers}
    Log To Console      ${response} 
    Status Should Be  201  ${response}  #Check Status as 200