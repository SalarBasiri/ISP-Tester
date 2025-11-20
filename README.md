ISP Accessibility Tester 🌐

A PowerShell tool to test internet connectivity, detect censorship, and analyze website accessibility.

This tool allows you to check if specific websites are accessible from your current internet connection (ISP) without using a VPN. It distinguishes between successful connections, server errors (like 404), and network blocks (like Connection Reset or Timeouts), which are often used for censorship.

📂 Files in this Repository

Analyze-Accessibility.ps1: The main script. It tests a list of URLs and shows a real-time dashboard of results.

Filter-TLD.ps1: A helper script to extract specific domains (like .com, .ir, .org) from massive lists (like the Majestic Million).

sample_urls.txt: A small list of top global websites for quick testing.

🚀 How to Use

Prerequisites

You need Windows 10 or 11. No external software (like Python) is required.


Step 0: Download

Download this repository as a ZIP file (Click the green Code button -> Download ZIP).

Extract the ZIP file to a folder on your computer (e.g., C:\InternetTest).

Step 1: Allow Scripts and Run the Accessibility Test

By default, Windows prevents scripts from running for security. You need to allow it temporarily.

Run PowerShell as administrator, type Powershel in search, rightclick on it and select Run as Administrator.

Go to extracted folder (e.g., cd C:\InternetTest)

PowerShell -> Set-ExecutionPolicy RemoteSigned

(Type Y and press Enter if asked to confirm. This allows scripts to run only in this specific window).

To test the included sample list:

In the PowerShell window, type the following and press Enter:

.\Analyze-Accessibility.ps1 url1000.txt

The script will launch a dashboard showing which sites are ACCESSIBLE (Green) and which are BLOCKED (Red).

When finished, the results are saved to Detailed_Accessibility_Log.csv in the folder.

Finally, in the PowerShell window, type the following to return default windows setting:
Set-ExecutionPolicy Restricted


Step 2: Advanced - Testing Specific Regions (TLDs)

If you want to test a massive list (e.g., the top 1 million websites) but only check specific domains (like sites ending in .ir or .cn), follow these steps:

Get a Source List: Download the "Majestic Million" or "Cisco Umbrella" CSV list (search for them online, they are free). Rename it to million_urls.txt and place it in the script folder.

Edit the Filter Script:

Right-click Filter-TLD.ps1 and select Edit.

Change the line $TargetTLD = ".ir" to whatever you want (e.g., $TargetTLD = ".com").

Save the file.

Run the Filter:

.\Filter-TLD.ps1

This will create a new file named urls2.txt containing only the domains you wanted.

Run the Analysis on the New List:

.\Analyze-Accessibility.ps1 urls2.txt

The file url.ir.txt contains top .ir website extracted from 1 million mostly visited website on 9 September 2025 from "Cisco Umbrella" CSV list.

📊 Interpreting Results

ACCESSIBLE (Code 200-399): The website loaded successfully.

CLIENT/SERVER ERROR (Code 400-599): The connection worked, but the website itself has an error (e.g., 404 Not Found). This is usually NOT censorship.

NETWORK BLOCK / NO RESPONSE: The connection timed out or was reset. This often indicates ISP filtering or censorship.

🤝 Contributing

Contributions are welcome! If you have improvements for the scripts or better lists of URLs to test, please feel free to fork this repository, modify the code, and submit a pull request.


📄 License

This project is open source and available under the MIT License. You are free to copy, modify, and distribute the code and results as you wish.


⚠️ Disclaimer
This tool is for educational and diagnostic purposes. Please respect the Terms of Service of the websites you are testing.




