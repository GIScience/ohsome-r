## Test environments
- R-hub windows-x86_64-devel (r-devel)
- R-hub ubuntu-gcc-release (r-release)
- R-hub fedora-clang-devel (r-devel)

## R CMD check results
❯ On windows-x86_64-devel (r-devel), 
  ubuntu-gcc-release (r-release), 
  fedora-clang-devel (r-devel)
  checking CRAN incoming feasibility ... NOTE
  Maintainer: 'Oliver Fritz <oliver.fritz@heigit.org>'
  New submission
  
This is the first submission of 'ohsome'.

❯ On windows-x86_64-devel (r-devel)
  checking for detritus in the temp directory ... NOTE
  Found the following files/directories:
    'lastMiKTeXException'

This seems to be due to an unrelated bug in R-hub 
[R-hub issue #503](https://github.com/r-hub/rhub/issues/503)
and can probably be ignored.

❯ On fedora-clang-devel (r-devel)
  checking HTML version of manual ... NOTE
  Skipping checking HTML validation: no command 'tidy' found
  
This seems to indicate that HTML validity checks were skipped due to missing 
'tidy' in R-hub's Fedora environment. However, the package manual has passed 
HTML validity checks both in Windows and Ubuntu environment. Thus, the note can
probably be ignored.

0 errors ✔ | 0 warnings ✔ | 3 notes ✖
