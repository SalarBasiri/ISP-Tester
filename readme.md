ISP Accessibility Tester 🌐
A PowerShell tool to test internet connectivity, detect censorship, and analyze website accessibility.
This tool allows you to check if specific websites are accessible from your current internet connection (ISP) without using a VPN. It distinguishes between successful connections, server errors (like 404), and network blocks (like Connection Reset or Timeouts), which are often used for censorship.
📂 Files in this Repository
    • Analyze-Accessibility.ps1: The main script. It tests a list of URLs and shows a real-time dashboard of results.
    • urls_normal.txt: A pre-compiled "Gold Standard" list of browser-accessible websites (HTTP 200 OK) ready for testing.
    • Filter-TLD.ps1: (Advanced) A helper script to extract specific domains (like .com, .ir, .org) from massive lists.
    • filter_GET_friendly_url.ps1: (Advanced) A mining script to create your own "Gold Standard" lists.
🟢 Section 1: Quick Start (For Basic Users)
Goal: Test your ISP immediately using our ready-made list of websites (urls_normal.txt).
Prerequisites
    • You need Windows 10 or 11.
    • No external software (like Python) is required.
How to Run the Test
    1. Download: Click the green Code button -> Download ZIP and extract it to a folder (e.g., C:\InternetTest).
    2. Disconnect VPN: Ensure your VPN is OFF so you are testing your local ISP.
    3. Open PowerShell as Administrator:
        ◦ Click the Start button or Search box on your taskbar.
        ◦ Type "PowerShell".
        ◦ Right-click on "Windows PowerShell" and select "Run as administrator".
        ◦ In the blue window that appears, type the following command to go to your folder and press Enter:
          cd C:\InternetTest
    4. Run the Command: Copy and paste the following block into PowerShell and press Enter. This allows the script to run safely and then resets your security settings immediately after.
<!-- end list -->
Set-ExecutionPolicy RemoteSigned

.\Analyze-Accessibility.ps1 urls_normal.txt

Set-ExecutionPolicy Restricted
(If prompted to confirm the policy change, type Y or A and press Enter).
What happens next?
    • A dashboard will appear showing which sites are ACCESSIBLE (Green) and which are BLOCKED (Red).
    • When finished, the results are saved to Detailed_Accessibility_Log.csv.
🔴 Section 2: Advanced Users (Custom Lists)
Goal: Create your own custom lists or test specific regions (e.g., all .ir websites).
Option A: Filter Specific Domains (TLDs)
If you have a massive list (like the Majestic Million) and want to test only specific domains (e.g., .ir or .cn):
    1. Download a source list (e.g., million_urls.txt) and place it in the folder.
    2. Edit Filter-TLD.ps1 to set your target TLD (e.g., $TargetTLD = ".ir").
    3. Run the filter:
       Set-ExecutionPolicy RemoteSigned
       .\Filter-TLD.ps1
       Set-ExecutionPolicy Restricted
    4. Use the resulting urls2.txt with the main analyzer.
Option B: Create a "Browser-Friendly" Gold Standard List
Raw lists often contain APIs or servers that don't open in a browser. To create a clean list like urls_normal.txt:
    1. Turn ON your VPN (Connect to free internet).
    2. Run the mining script on your raw list:
       Set-ExecutionPolicy RemoteSigned
       .\filter_GET_friendly_url.ps1 million_urls.txt
       Set-ExecutionPolicy Restricted
    3. The script will verify sites that return HTTP 200 OK and save them to urls_normal.txt.
    4. Turn OFF your VPN and run the main analysis on this new list.
📊 Interpreting Results
    • ACCESSIBLE (Code 200-399): The website loaded successfully.
    • CLIENT/SERVER ERROR (Code 400-599): The connection worked, but the website itself has an error. This is usually NOT censorship.
    • NETWORK BLOCK / NO RESPONSE: The connection timed out or was reset. This often indicates ISP filtering or censorship.
📄 License
This project is open source and available under the MIT License.
⚠️ Disclaimer
This tool is for educational and diagnostic purposes. Please respect the Terms of Service of the websites you are testing.
