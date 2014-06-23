#!/bin/bash
#
# Date:	  2014-06-08
# Author: Daniel Zapico
# Desc:   Script to resolve external IP address 
#_____________________________________________________
LSSCRIPT="$(ls -l $0)"
echo "$LSSCRIPT" | awk '$1~/^l/{ecode="1";exit}{ecode="0";exit}END{exit ecode}'
if [[ "$?" == "1" ]]; then
  LINKDIR="$(echo $LSSCRIPT | awk '{print $(NF-2)}' | xargs dirname)"
  cd "$LINKDIR"
  SDIR="$(echo $LSSCRIPT | awk '{print $NF}' | xargs dirname)"
  cd "$SDIR"
  SDIR="$(pwd)"
  TOOLDIR="$(dirname $SDIR)"
else
  # Script and Tool directories
  TOOLDIR="$(cd $(dirname $0) && cd .. && pwd)"
  SDIR="$(cd $(dirname $0) && pwd)"
  # Change current directory to work directory
  cd "$SDIR"
fi

# Get script's name
SNAME="$(basename $0)"

# Get the user name
USER="$(id | nawk '{sub(/^.*\(/,"",$1); sub(/\).*$/,""); print}')"

# Get hostname
HOSTNAME="$(hostname)"

# Date and time
DATENTIME="$(date +%Y%m%d%H%M%S)"

# Includes
. "$SNAME.props"
. "$SNAME.exitcodes"
. "$SNAME.functions"


#################### Main ####################
_ParseInputParams $@
_Print2Log "+++ $SNAME Start +++"

_PrintDebug "MODE=$MODE"
case "$MODE" in
	l)
	  _ListServers
	  ;;
	i)
	  _InitializeVariables
	  _ResolveExternalIP "$INDEX"
	  _CheckExternalIP 
	  echo "$EXTIP"
	  ;;
	*)
	  _InitializeVariables
          _ResolveExternalIP 
          _CheckExternalIP
          echo "$EXTIP"
          ;;
esac
    
_Print2Log "--- $SNAME End ---"
_Exit "$DEFAULTEXITCODE" 
