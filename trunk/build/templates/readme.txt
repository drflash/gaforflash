@project_fullname@
========================================
You can find the latest version of @project_name@ on @project_url@

Installation for Flash CS3
==========================
Before you begin to use the @project_name@ to add tracking within Flash CS3,
you first need to add the @project_name@ SWC to Flash CS3.

To do so:
1. If you have Flash CS3 currently open, quit the application.

2. Navigate to the location where you unzipped the Google Analytics zip
   and find the swc (e.g. lib/analytics.swc).

3. Create a "Google" directory in one of the following locations
   and copy the SWC file there:
   - (Windows) C:\Program Files\Adobe\ Adobe Flash CS3\language\Configuration\Components
   - (Mac OS X) Macintosh HD/Applications/Adobe Flash CS3/Configuration/Components

Flash CS3 is now set up to support the @project_name@.

Installation for Flex Builder 3
===============================
Before you can compile your code, you will need to link it to the @project_name@ SWC file.

To do so:
1. select Project->Properties.
   A Properties dialog box will appear for your project.
   Click on Flex Build Path and then select the Library Path tab:

2. Click Add SWC... within the Library Path pane.
   An Add SWC dialog box will appear.
   Navigate to the location where you unzipped the Google Analytics API
   and select lib/analytics.swc file and click OK.

or

Just drop the analytics.swc file into your Flex project /libs directory

Documentation
=============
Documentation of the @project_name@ is in the /doc directory.

Problem
=======
Please send any usage questions to @project_group@
Please report issues to @project_maintenance@/issues/ (precise the version @release_version@)
