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

This seems to be due to an unrelated bug in MiKTeX 
[R-hub issue #503](https://github.com/r-hub/rhub/issues/503)
and can probably be ignored.

0 errors ✔ | 0 warnings ✔ | 2 notes ✖
