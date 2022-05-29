*** Settings ***
Documentation  API Testing in Robot Framework
Library  RequestsLibrary
Library  JSONLibrary
Library  jsonschema
Library  Collections
Library  String

*** Variables ***
${base_url}=    https://gorest.co.in/
${auth_token}=  7a170016b7ee10b2e6161554a07ade2ebbc9d37b28a62a320a400e2878fac02f
&{headers}=    Accept=application/json    Content-Type=application/json    Authorization=Bearer ${auth_token}
${email}=       Generate Random String      10      [LETTERS]


*** Test Cases ***
Do a GET Request and validate the response code and response body
    [documentation]  This test case verifies that the response code of the GET Request should be 200
    [tags]  Functional
    Create Session  mysession  ${base_url}  verify=true
    ${response} =  GET On Session  mysession  /public/v2/users/
    Status Should Be  200  ${response}  #Check Status as 200


Verify response has pagination
    [documentation]  This test case verifies that the response code header for X-Pagination-Pages
    [tags]  Functional
    Create Session  mysession  ${base_url}  verify=true
    ${response} =  GET On Session  mysession  /public/v2/users/
    ${getHeaderValue} =  Get From Dictionary  ${response.headers}   X-Pagination-Pages
    Should be True      ${getHeaderValue} > 1

Verify response has Valid Json Data
    [documentation]  This test case verifies that the response resturns a Valid json
    [tags]  Functional
    Create Session  mysession  ${base_url}  verify=true
    ${response}=  GET On Session  mysession  /public/v2/users/
    ${is_json}      Evaluate     isinstance(${response.content}, int)
    ${data}=    Evaluate    json.loads(json.dumps(${response.content}))
    ${type} =    Evaluate    type(${data[0]}).__name__
    Should be equal As Strings      ${type}     dict

Verify Response Data has email address
    [documentation]  This test case verifies that the response resturns a Valid json
    [tags]  Functional
    Create Session  mysession  ${base_url}  verify=true
    ${response}=  GET On Session  mysession  /public/v2/users/
    ${body}=    Convert To String     ${response.content}
    Should Contain      ${body}     email

Verify all entries on list data have similar attributes
    [documentation]  This test case verifies that the all the response entries have similar keys
    [tags]  Functional
    Create Session  mysession  ${base_url}  verify=true
    ${response}=  GET On Session  mysession  /public/v2/users/
    ${data}=    Evaluate    json.loads(json.dumps(${response.content}))
    ${base_entry}=      Get Dictionary Keys      ${data}[0]
    FOR    ${item}    IN    @{data}
        ${item_keys}=   Get Dictionary Keys      ${item}
        Should be equal     ${item_keys}  ${base_entry}
    END


Verify HTTP response code 200
    [documentation]  This test case verifies if status code returned is 200
    [tags]  Non-Functional
    Create Session  mysession  ${base_url}  verify=true
    ${response} =  GET On Session  mysession  /public/v2/users/
    Status Should Be  200  ${response}  #Check Status as 200


Verify HTTP response code 201
    [documentation]  This test case verifies if status code returned is 201 and creates a new user
    [tags]  Non-Functional
    Create Session  mysession  ${base_url}    verify=true
    ${ran_num}=    Generate Random String    4  [NUMBERS]
    &{body}=    Create Dictionary   name=Batman  email=bruce.wayne_${ran_num}@waynetech.com  gender=male  status=active    
    ${response} =  POST On Session  mysession  /public/v2/users/    headers=${headers}   json=${body}
    Log To Console      ${response} 
    Status Should Be  201  ${response}  #Check Status as 201


Verify REST service without authentication
    [documentation]  This test case verifies if status code returned is 401 for unauthorised POST request
    [tags]  Non-Functional
    Create Session  mysession  ${base_url}    verify=true
    ${ran_num}=    Generate Random String    4  [NUMBERS]
    &{body}=    Create Dictionary   name=Batman  email=bruce.wayne_${ran_num}@waynetech.com  gender=male  status=active
    ${response} =  POST On Session  mysession  /public/v2/users/    json=${body}    expected_status=401
    Status Should Be  401  ${response}  #Check Status as 401    
    
Verify Non-SSL Rest endpoint behaviour
    [documentation]  This test case verifies if status code returned is 200 with non SSL endpoint and certificate vertification disbaled
    [tags]  Non-Functional
    Create Session  mysession  http://gorest.co.in/  verify=false
    ${response} =  GET On Session  mysession  /public/v2/users/
    Status Should Be  200  ${response}  #Check Status as 200