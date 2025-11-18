<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>ISP Accessibility Tester - Documentation</title>
    <style>
        body { font-family: 'Calibri', 'Arial', sans-serif; line-height: 1.6; color: #333; max-width: 800px; margin: 0 auto; padding: 20px; }
        h1 { color: #2E74B5; border-bottom: 2px solid #2E74B5; padding-bottom: 10px; }
        h2 { color: #2E74B5; margin-top: 30px; border-bottom: 1px solid #ddd; padding-bottom: 5px; }
        h3 { color: #444; margin-top: 20px; }
        code { background-color: #f4f4f4; padding: 2px 5px; font-family: 'Consolas', 'Courier New', monospace; border-radius: 3px; }
        pre { background-color: #f4f4f4; padding: 15px; border-left: 4px solid #2E74B5; overflow-x: auto; font-family: 'Consolas', 'Courier New', monospace; }
        ul { margin-bottom: 15px; }
        li { margin-bottom: 5px; }
        .warning { background-color: #fff3cd; color: #856404; padding: 15px; border: 1px solid #ffeeba; border-radius: 4px; }
    </style>
</head>
<body>

    <h1>ISP Accessibility Tester 🌐</h1>

    <p><strong>A PowerShell tool to test internet connectivity, detect censorship, and analyze website accessibility.</strong></p>

    <p>This tool allows you to check if specific websites are accessible from your current internet connection (ISP) without using a VPN. It distinguishes between <strong>successful connections</strong>, <strong>server errors</strong> (like 404), and <strong>network blocks</strong> (like Connection Reset or Timeouts), which are often used for censorship.</p>

    <h2>📂 Files in this Repository</h2>
    <ul>
        <li><strong><code>Analyze-Accessibility.ps1</code></strong>: The main script. It tests a list of URLs and shows a real-time dashboard of results.</li>
        <li><strong><code>Filter-TLD.ps1</code></strong>: A helper script to extract specific domains (like <code>.com</code>, <code>.ir</code>, <code>.org</code>) from massive lists (like the Majestic Million).</li>
        <li><strong><code>sample_urls.txt</code></strong>: A small list of top global websites for quick testing.</li>
    </ul>

    <hr>

    <h2>🚀 How to Use</h2>

    <h3>Prerequisites</h3>
    <p>You need <strong>Windows 10 or 11</strong>. No external software (like Python) is required.</p>

    <h3>Step 0: Download</h3>
    <ol>
        <li>Download this repository as a ZIP file (Click the green <strong>Code</strong> button -> <strong>Download ZIP</strong>).</li>
        <li>Extract the ZIP file to a folder on your computer (e.g., <code>C:\InternetTest</code>).</li>
    </ol>

    <h3>Step 1: Allow Scripts to Run</h3>
    <p>By default, Windows prevents scripts from running for security. You need to allow it temporarily.</p>
    <ol>
        <li>Open the folder where you extracted the files.</li>
        <li>Right-click inside the folder window (in a blank space) and select <strong>"Open in Terminal"</strong> or <strong>"Open PowerShell window here"</strong>.</li>
        <li>If you get a "SecurityError", run this command in the PowerShell window:</li>
    </ol>
    <pre>Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass</pre>
    <p><em>(Type <code>Y</code> and press Enter if asked to confirm. This allows scripts to run only in this specific window).</em></p>

    <hr>

    <h3>Step 2: Run the Accessibility Test</h3>
    <p>To test the included sample list:</p>
    <ol>
        <li>In the PowerShell window, type the following and press Enter:</li>
    </ol>
    <pre>.\Analyze-Accessibility.ps1 sample_urls.txt</pre>
    <ol start="2">
        <li>The script will launch a dashboard showing which sites are <strong>ACCESSIBLE</strong> (Green) and which are <strong>BLOCKED</strong> (Red).</li>
        <li>When finished, the results are saved to <code>Detailed_Accessibility_Log.csv</code> in the folder.</li>
    </ol>

    <hr>

    <h3>Step 3: Advanced - Testing Specific Regions (TLDs)</h3>
    <p>If you want to test a massive list (e.g., the top 1 million websites) but only check specific domains (like sites ending in <code>.ir</code> or <code>.cn</code>), follow these steps:</p>
    <ol>
        <li><strong>Get a Source List:</strong> Download the "Majestic Million" or "Cisco Umbrella" CSV list (search for them online, they are free). Rename it to <code>million_urls.txt</code> and place it in the script folder.</li>
        <li><strong>Edit the Filter Script:</strong>
            <ul>
                <li>Right-click <code>Filter-TLD.ps1</code> and select <strong>Edit</strong>.</li>
                <li>Change the line <code>$TargetTLD = ".ir"</code> to whatever you want (e.g., <code>$TargetTLD = ".com"</code>).</li>
                <li>Save the file.</li>
            </ul>
        </li>
        <li><strong>Run the Filter:</strong></li>
    </ol>
    <pre>.\Filter-TLD.ps1</pre>
    <p><em>This will create a new file named <code>urls2.txt</code> containing only the domains you wanted.</em></p>
    <ol start="4">
        <li><strong>Run the Analysis on the New List:</strong></li>
    </ol>
    <pre>.\Analyze-Accessibility.ps1 urls2.txt</pre>

    <hr>

    <h2>📊 Interpreting Results</h2>
    <ul>
        <li><strong>ACCESSIBLE (Code 200-399):</strong> The website loaded successfully.</li>
        <li><strong>CLIENT/SERVER ERROR (Code 400-599):</strong> The connection worked, but the website itself has an error (e.g., 404 Not Found). <strong>This is usually NOT censorship.</strong></li>
        <li><strong>NETWORK BLOCK / NO RESPONSE:</strong> The connection timed out or was reset. <strong>This often indicates ISP filtering or censorship.</strong></li>
    </ul>

    <hr>

    <h2>🤝 Contributing</h2>
    <p>Contributions are welcome! If you have improvements for the scripts or better lists of URLs to test, please feel free to fork this repository, modify the code, and submit a pull request.</p>

    <h2>📄 License</h2>
    <p>This project is open source and available under the <a href="LICENSE">MIT License</a>. You are free to copy, modify, and distribute the code and results as you wish.</p>

    <hr>

    <div class="warning">
        <h3>⚠️ Disclaimer</h3>
        <p>This tool is for educational and diagnostic purposes. Please respect the Terms of Service of the websites you are testing.</p>
    </div>

</body>
</html>
