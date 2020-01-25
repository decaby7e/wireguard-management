###############################
#          common.sh          #
###############################
#
# A collection of commonly used bash functions
# and variables to reduce reused code in many
# bash scripts
#
# decaby7e - 2020.01.17


#~#~#~#~#~#~#~#~#~#~#~#
#      Variables      #
#~#~#~#~#~#~#~#~#~#~#~#

## Color Variables ##

RED='\033[0;31m'    # Red
L_RED='\033[1;31m'  # Light red
YELLOW='\033[1;33m' # Yellow
WHITE='\033[1;34m'  # White
ORANGE='\033[0;33m' # Orange
NC='\033[0m'        # No Color

## Path Variables ##

#
# Return the full path of a running script
#
REL_PATH="`dirname \"$0\"`"
FULL_PATH="`( cd \"$REL_PATH\" && pwd )`"


#~#~#~#~#~#~#~#~#~#~#~#
#      Functions      #
#~#~#~#~#~#~#~#~#~#~#~#


## Logging Variables ##

#
# For use when debugging scripts. Should be removed
# in production scripts...
#
# Usage: debug "Debug Message"
#
debug(){
  printf "${ORANGE}[ DEBUG ]${NC} $1\n"
}

#
# For use with any kind of common info to be
# displayed to the terminal. Should allow for
# sparse use of printf and echo in giving the
# user information.
#
# Usage: info "Information Message"
#
info(){
  printf "${WHITE}[ INFO ] ${NC} $1\n"
}

#
# Warn the user of a serious error but one
# that is not serious enough to cause a crash
#
# Usage: warn "Warning Message"
#
warn(){
  printf "${YELLOW}[WARNING]${NC} $1\n"
}

#
# Warn the user of a script-breaking crash
# then immediatly exit
#
# Usage: fatal "Error Message"
#
fatal(){
  printf "${RED}[ FATAL ]${NC} $1\n"
  exit 1
}


## Try-Catch Functions ##

#
# Will attempt to run a command. On faliure,
# the specified execption is run. Should both
# fail, a fatal error is thrown.
#
# Usage: try "helloworld" "echo 'Oops! That command isn\'t real \:\\' "
#
try(){
  sh -c $1 ||\
  sh -c $2 ||\
  fatal "Failed exception!"
}

## Privilage Checks ##

#
# Will check if user is root. If not, it will throw
# a fatal error and notify the user to use root.
#
# Usage: is_root
#
is_root(){
  if [ "$EUID" -ne 0 ]; then
    fatal "Must be run as root."
  fi
}
