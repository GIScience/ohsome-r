## Test environments
- R-hub windows-x86_64-devel (r-devel)
- R-hub ubuntu-gcc-release (r-release)
- R-hub fedora-clang-devel (r-devel)

## R CMD check results
❯ On windows-x86_64-devel (r-devel)
  checking for non-standard things in the check directory ... NOTE
  Found the following files/directories:
    ''NULL''
    
This seems to be an Rhub issue and can likely be ignored. See [R-hub issue #560](https://github.com/r-hub/rhub/issues/560) 

❯ On windows-x86_64-devel (r-devel)
  checking for detritus in the temp directory ... NOTE
  Found the following files/directories:
    'lastMiKTeXException'

This seems to be an Rhub issue and can likely be ignored. See [R-hub issue #503](https://github.com/r-hub/rhub/issues/503)


❯ On fedora-clang-devel (r-devel), ubuntu-gcc-release (r-release)
  checking HTML version of manual ... NOTE
  Skipping checking HTML validation: no command 'tidy' found
  
This seems to indicate that HTML validity checks were skipped due to missing 
'tidy' in R-hub's environment. However, the package manual has passed 
HTML validity checks in the Windows environment. Thus, the note can
probably be ignored.

0 errors ✔ | 0 warnings ✔ | 3 notes ✖
