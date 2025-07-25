## The Task

Make a Windows application which will gather information about all running processes in a system and display it in its main window in a form of tree.

- Root tree elements are two: the first named "Processes", which children are root
system processes, their children elements are processes, that started by that root
processes, etc. Element name of tree should be exe file name of the corresponding
process.
- Second root element is named "Sessions", which children elements represent
currently running user sessions. Element name is Session ID.
- On click of any tree element, in another part of same window, extended information
of the clicked element should be displayed, which contains at least (for process): full
exe file path and name, process ID, User session ID. For session element the
extended info is Session state only.
- The information of the tree and detailed view should be refreshed each 10 sec
without any flickering of any visual elements of window.
- The window should contain a button which allows to calculate sha-256 hashes of exe
files of all running processes. This should be done in background, without
interrupting of tree refresh or window repainting.
- Resulting hashes should be listed in separate memo control, placed in the main
window.
- A progress indicator shows the progress of that operation.
- Application should stay responsive to user input at any time.
- Using external/third-party code for calculating hashes is allowed. Please place it in
separate uarate uarate unit in the case.
