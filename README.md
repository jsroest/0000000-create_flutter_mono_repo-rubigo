This program will create a flutter mono repository.

Note, this script uses FVM and relies on "Set Global Version".
https://pub.dev/packages/fvm

Command line parameters

Usage: create_flutter_mono_repo \[arguments\]

* --root-path  
The directory where the project will be created. Defaults to the current directory.
* --customer-id  
Unique id of the customer, only used for the name of the project folder. Convention: numeric, fixed 7 positions.  
Defaults to "0000000"
* --project-name  
Used for the project folder and as the id of the app. Convention: lowercase and underscores.  
Defaults to "flutter_sample_app"
* --customer-name  
Name of the customer, only used for the name of the project folder. Convention: lowercase and underscores.  
Defaults to "rubigo"
* --org  
Name of the company in reverse domain name notation.  
Defaults to "com.example"
* --ios-language  
\[objc, swift\]
Defaults to swift
* --android-language  
\[java, kotlin\]
Default to kotlin
* --flutter-version  
The flutter version to use for this project  
Defaults to "1.22.6"
* --\[no-\]verbose  
Verbose output
* -d, --\[no-\]dry-run  
Dry run, show only the commands.
* -h, --help  
Print this usage information

It does the following steps:
01. It checks the current Flutter version against the requested Flutter version
02. Create a project folder with a name that has a standardized layout
03. Change directory to the project folder
04. Git init
05. Create a folder with the name 'packages'
06. Change directory to the packages folder
07. Call fvm flutter create with the supplied command line options
08. Commit original .gitignore
09. Make changes to .gitignore, to include some important IntelliJ Idea files
10. Commit altered .gitignore
11. Commit the newly created flutter project
12. Call fvm init with the supplied flutter version to use
13. Make changes to .gitignore, to exclude the FVM symbolic link
14. Make changes to <project-name>.iml file to exclude .fvm/flutter_sdk symbolic link in IntelliJ Idea
15. Commit changes for FVM
16. Remove <project-id>_android.iml reference from .idea/modules.xml, as it is not needed
17. Commit changes made to .idea/modules.xml