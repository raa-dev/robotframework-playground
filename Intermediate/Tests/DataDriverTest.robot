*** Settings ***
Library           DataDriver    file=/home/rdrx/Documentos/code/robotframework-playground/Intermediate/Resources/template.csv
Library           RequestsLibrary
Library           JSONLibrary
Test Setup        SESSION_CREATE
Test Template     Req User Getter
Documentation     Using Test templates

*** Variables ***
${TOKEN}    allarevalid
${URL}  https://reqres.in
${USER_ENDPOINT}    /api/users/

*** Test Cases ***
DDT Data from file
    Req User Getter

*** Keywords ***
SESSION_CREATE
    &{headers}   Create Dictionary   Content-Type=application/json      Authorization=${TOKEN}
    Create Session  session   ${URL}    ${headers}
    Set Global Variable    ${session}   session
Req User Getter
    [Arguments]     ${ENDPOINT}     ${REQ_PARAM}     ${STATUS}
    ${RES}    GET    url=${URL}${ENDPOINT}${REQ_PARAM}   expected_status=${STATUS}
    ${res}     Set Variable    ${RES.json()}