from appium import webdriver
from appium.options.ios import XCUITestOptions
from appium.webdriver.common.appiumby import AppiumBy
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from selenium.common.exceptions import NoSuchElementException
import time
import subprocess
import os

cur_dirctory = os.getcwd()
file_path =  f"{cur_dirctory}/app/MemoryGraphDemo"

def init_driver():
    
    options = XCUITestOptions()

    options.device_name = 'iPhone 16 Pro'
    options.platform_version = '18.0'
    options.app = f"{file_path}.app" 
    options.automation_name = 'XCUITest'

    options.process_arguments = {'env': {'MallocStackLogging': 'YES'}}

    # 配置WDA端口 (可选)
    options.set_capability('wdaLocalPort', 8100)
    options.set_capability('noReset', False)
    options.set_capability('newCommandTimeout', 300)

    driver = webdriver.Remote('http://localhost:4723', options=options)
    return driver

def export_memory_graph():
    subprocess.run(f"leaks MemoryGraphDemo -outputGraph '{file_path}'", shell=True)
    
    
def click(driver, name):
    element = driver.find_element(AppiumBy.NAME, name)
    element.click()
    

def test(driver):
    click(driver, "Click Me")

    time.sleep(1)
    click(driver, "Retain Cycles")

    time.sleep(1)
    click(driver, "No Active References")

    time.sleep(1)
    click(driver, "Indirect Retain Cycles")

    time.sleep(1)
    click(driver, "Dynamic Indirect Retain Cycles")

def analysis():
    subprocess.run(f"leaks {file_path}.memgraph -quiet > {cur_dirctory}/app/analysis.txt", shell=True)

def main():
    driver = init_driver()
    
    try:
        test(driver)
        export_memory_graph()
        analysis()
     
    finally:
        driver.quit()
        

if __name__ == "__main__":
    main()
