# Powershell-event-log
PowerShell scripts to query Windows logs

How to use
1.	Clone the repo

git clone https://github.com/rikosintie/Powershell-event-log.git

2.	Run in PowerShell:

   cd Powershell-event-log
   
   .\Get-NmapWerCrashes.ps1

3. Grab the CSV from:
c:\Users\<you>\nmap_crash_report.csv


Why this fits your workflow
	•	Works on restricted Windows jump hosts
	•	No installs, no admin elevation
	•	Produces clean evidence for customers
	•	Zero dependency on Npcap, debuggers, or event viewer GUIs

Exactly the kind of “get in, get proof, get out” tool a contractor needs.
