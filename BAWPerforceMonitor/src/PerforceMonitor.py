'''
Created on Aug 22, 2013

@author: justin_ng
'''

import logging
import os
import time
import httplib
from P4 import P4,P4Exception

TEST_MODE = True
MAX_UPDATE_SEGMENT = 100    # Number of file updates sent in one message
UPDATE_INTERVAL = 30    # Seconds between perforce syncs

WEBSERVER = "localhost:3000"
COMMANDS_UPDATE_URI = "/updateCommand"
SCRIPTS_UPDATE_URI = "/updateScript"
COMMANDS_DIR = "//depot/main/test/java/modules/Command/.../*.java"
SCRIPTS_DIR = "//depot/main/test/suite/scripts/.../*.act"

P4_HOST = "eng-jng"
P4_USER = "justin_ng"
P4_WORKSPACE = "p4BAW"
P4_PASSWORD = "WelcomeJN!1"
p4 = P4()

def main():
    
    p4.exception_level = 1
    p4.host = P4_HOST
    p4.user = P4_USER
    p4.client = P4_WORKSPACE
    p4.password = P4_PASSWORD
    p4.connect()
    p4.run_login()
    
    if TEST_MODE:
        #updateCommands()
        #updateScripts()
        
        p4.disconnect()
        
    else:
        while True:
            updateCommands()
            updateScripts()
            time.sleep(UPDATE_INTERVAL)
    

def updateCommands():
    
#     syncResult = p4.run("sync", "-n", "//depot/main/test/java/modules/Command/src/com/vontu/test/command/selenium/api/menu/NavigateMenu.java")
    syncResult = p4.run("sync", "-n", COMMANDS_DIR)

    httpBody = ""
    
    i = 0
    for fileAction in syncResult:
        i += 1
        print fileAction + "\n"
        
        filepath = fileAction["depotFile"]
        action = fileAction["action"]
        
        commandName = os.path.splitext(os.path.basename(filepath))[0]
        
        parsedFileAction = action + "," + "E:/p4BAW" + filepath[1:] + "," + commandName
        httpBody += (parsedFileAction + "\n")
        
        if i % MAX_UPDATE_SEGMENT == 0:
            postHttpData(httpBody, COMMANDS_UPDATE_URI)
            httpBody = ""
    else:   #send remainder
        if httpBody:
            postHttpData(httpBody, COMMANDS_UPDATE_URI)
            
    
def updateScripts():
    
#     syncResult = p4.run("sync", "//depot/main/test/suite/scripts/enforce/core/features/maliciousInsider/BAT/...")
    syncResult = p4.run("sync", SCRIPTS_DIR)
    
    httpBody = ""
    
    i = 0
    for fileAction in syncResult:
        i += 1
        print fileAction + "\n"
        
        filepath = fileAction["depotFile"]
        action = fileAction["action"]
                
        parsedFileAction = action + "," + "E:/p4BAW" + filepath[1:]
        httpBody += (parsedFileAction + "\n")
        
        if i % MAX_UPDATE_SEGMENT == 0:
            postHttpData(httpBody, COMMANDS_UPDATE_URI)
            httpBody = ""
    else:   #send remainder
        if httpBody:
            postHttpData(httpBody, COMMANDS_UPDATE_URI)
    
    
def postHttpData(httpBody, url):
    
    print httpBody
    
    httpConn = httplib.HTTPConnection(WEBSERVER)
    httpConn.request("POST", url, httpBody)
    httpConn.getresponse(False)
    httpConn.close()





if __name__ == '__main__':
    main()