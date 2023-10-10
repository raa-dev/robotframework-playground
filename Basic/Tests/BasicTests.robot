*** Settings ***
Library     String
Library     Collections
Library     SeleniumLibrary
Library     ../Resources/resources.py
Variables   ../Resources/resources.py

Documentation   Basic test automation

Test Setup  Open Browser    https://google.com      ${BROWSER}
Test Teardown   Close Browser

*** Variables ***
${URL}  https://robotframework.org/
${BROWSER}  Chrome
${COMMUNITY_BUTTON} Community
${VIDEO_LIST}

*** Keywords ***
Convert List To Tuple
    [Arguments]     ${list}
    ${result}       resources.To Tuple  ${list}
    [Return]        ${result}

*** Test Cases ***
Video List To Tuple Test
    [Documentation]     Turn video title list into a tuple ${\n}
    [Tags]              Video titles, UI
    Create Webdriver    ${BROWSER}
    Go To               ${URL}
    Click Button        ${COMMUNITY_BUTTON}
    Sleep               1s
    Click Link          xpath=//html/body/div[1]/div[4]/div[4]/div[1]/div[2]/p[2]/a[2]
    Sleep               1s
    @{TABS}             Get Window Handles
    Switch Window       ${TABS}[1]
    Click Element       xpath=//html/body/ytd-app/div[1]/ytd-page-manager/ytd-browse/div[3]/ytd-c4-tabbed-header-renderer/tp-yt-app-header-layout/div/tp-yt-app-header/div[2]/tp-yt-app-toolbar/div/div/tp-yt-paper-tabs/div/div/tp-yt-paper-tab[2]/div/div[1]

    ${VIDEO_TITLES}     Get WebElements     xpath=//*[@id="items"]
    ${VIDEO_LIST} =     Create List
    FOR ${video}        IN  @{VIDEO_TITLES}
        ${title}        Get Text    id:video-title
        Append To List  ${VIDEO_LIST}   ${title}
    END

    ${VIDEO_TITLES_TUPLE}   =   Convert List To Tuple   ${VIDEO_LIST}
    LOG V               Videos Titles Tuple: ${VIDEO_TITLES_TUPLE}

Generate Random Letters and Numbers && Calculate and Round Test
    [Documentation]     Lower and upper results ${\n}
    [Tags]              Random letters
    ${RANDOM} =         Generate Random String  10  [LOWER]ABCDEFGHIJKLMNÑOPQRSTUVWXYZ0123456789
    Log                 Random String (lowercase): ${RANDOM}
    ${RANDOM} =         Convert To Uppercase    ${RANDOM}
    Log                 Random String (uppercase): ${RANDOM}

    Log Calculate and Round
    ${RES} =            Evaluate    round((2.1 + 3.23) * 2, 2)
    Log                 Calculated Result: ${RES}
    Should Be Equal As Numbers  ${RES}  10.66

Retrieve Local Username Test
    [Documentation]     Retrieve local username with OS
    [Tags]              Username
    Log                 ${localUserName}

Verify Web Site Title Test
    [Documentation]     Verify Google as page title ${\n}
    [Tags]              Web site title, Google
    Maximize Browser Window
    ${TITLE} =      Get Title
    Should Be Equal     ${TITLE}    Google