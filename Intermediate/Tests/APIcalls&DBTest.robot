*** Settings ***
Library       JSONLibrary
Library       RequestsLibrary
Library       DatabaseLibrary
Test Setup    SESSION_CREATE

Documentation    API calls and DB testing


*** Variables ***
${TOKEN}    allarevalid
${URL}    https://reqres.in
${REGISTER_ENDPOINT}    /api/register
${LOGIN_ENDPOINT}    /api/login
${USER_ENDPOINT}    /api/users/
${TABLE}    contact

*** Keywords ***
SESSION_CREATE
    &{headers}   Create Dictionary   Content-Type=application/json      Authorization=${token}
    Create Session  session   ${URL}    ${headers}
    Set Global Variable    ${session}   session

Req User Getter
    [Arguments]     ${ENDPOINT}     ${REQ_PARAM}     ${STATUS}
    ${RES}    GET    url=${URL}${ENDPOINT}${REQ_PARAM}   expected_status=${STATUS}
    ${res}     Set Variable    ${RES.json()}

*** Tasks ***
Validate POST req
    [Documentation]    ID & TOKEN from body res. ${\n}
    [Tags]    reqres

    ${REQ}    Create Dictionary   email=eve.holt@reqres.in    password=pistol
    ${RES}    POST    url=${URL}${REGISTER_ENDPOINT}     json=${REQ}    expected_status=200
    ${res}     Set Variable    ${RES.json()}

    ${id}    Get Value From JSON     ${res}     $.id
    ${token}    Get Value From JSON     ${res}     $.token
    Should Not Be Empty    ${id}
    Should Not Be Empty    ${token}

DB testing.
    [Documentation]    Create & remove table ${\n}
    [Tags]    Database sqlite

    Connect To Database Using Custom Params    sqlite3  "testing.db"

    Execute SQL String  CREATE TABLE IF NOT EXISTS ${TABLE}(id integer unique,name varchar,gender varchar,email varchar,phone varchar,address varchar);
    Execute SQL String  INSERT INTO ${TABLE} VALUES (343, "Boss", "female", boss@mail.com, "5555555555", "666 somewhere");
    Execute SQL Script  /home/rdrx/Documentos/code/robotframework-playground/Intermediate/Resources/contact_insertData.sql
    Row Count is Greater Than X    SELECT id FROM ${TABLE};    3
    ${output} =    Execute SQL String    DROP TABLE IF EXISTS ${TABLE};
    Log    ${output}
    Should Be Equal As Strings    ${output}    None

DDT
    [Documentation]     Performing GET reqs w params ${\n}
    [Tags]  Data-Driven
    [Template]  Req User Getter
    ${USER_ENDPOINT}    3   200
    ${USER_ENDPOINT}    50  404
    ${USER_ENDPOINT}    X   404
    ${USER_ENDPOINT}    ?page=2   200