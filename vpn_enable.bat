'''Run as bat script... 2>NUL
@echo off & call python %0 %* &
exit /b
'''

username = "redacted"
password = "redacted"

#%%
from selenium import webdriver
from selenium.webdriver.firefox.options import Options
from selenium.webdriver.common.desired_capabilities import DesiredCapabilities
import time


options = Options()
cap = DesiredCapabilities().FIREFOX
cap["marionette"] = True #optional
driver = webdriver.Firefox(options=options, capabilities=cap) #, executable_path="C:\\Utility\\BrowserDrivers\\geckodriver.exe")
driver.get("http://192.168.1.77")


driver.get(f"http://{username}:{password}@192.168.1.77/PPTP.asp")


from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC

#%%
def openvpn(enable=True):
    wait = WebDriverWait(driver, 10)
    thing = wait.until(EC.element_to_be_clickable((By.XPATH, f'//input[@type="radio"][@name="openvpn_enable"][@value="{int(enable)}"]')))
    thing.click()

def start_openvpn_client(enable=True):
    wait = WebDriverWait(driver, 10)
    thing = wait.until(EC.element_to_be_clickable((By.XPATH, f'//input[@type="radio"][@name="openvpncl_enable"][@value="{int(enable)}"]')))
    thing.click()

def apply_settings():
    wait = WebDriverWait(driver, 10)
    thing = wait.until(EC.element_to_be_clickable((By.XPATH, f'//input[@type="button"][@name="apply_button"][@value="Apply Settings"]')))
    thing.click()

def save():
    wait = WebDriverWait(driver, 10)
    thing = wait.until(EC.element_to_be_clickable((By.XPATH, f'//input[@type="button"][@name="save_button"][@value="Save"]')))
    thing.click()


import sys
disable_or_enable = 1
if len(sys.argv)>=2:
    disable_or_enable = int(sys.argv[1])

openvpn(disable_or_enable)
start_openvpn_client(disable_or_enable)
apply_settings()

#%%
print("VPN "+["disabled","enabled"][disable_or_enable] + " ...")

time.sleep(4)
save()
print("Saving ...")
time.sleep(2)
print("Done")

#%%
driver.quit()
