BASEDIR := `pwd`

@bootstrap list="packages fonts links templates services X11 shell crontab root":
  just green "Bootstrapping system..."
  just {{list}}
  just yellow "Done."

import '.just/config/links.just'
import '.just/config/templates.just'
import '.just/system/packages.just'
import '.just/system/assets.just'
import '.just/system/system.just'
import '.just/other/repos.just'

# ------------------------------------------------------------------------------
# helpers
# ------------------------------------------------------------------------------

[private]
template name:
  @cp --update=none {{BASEDIR}}/templates/{{name}} ~/{{name}}

[private]
clone repo target:
  #!/usr/bin/env bash
  [ ! -d {{target}} ] && just do_clone {{repo}} {{target}} || /bin/true

[private]
@do_clone repo target:
  echo Getting {{repo}}...
  -git clone https://github.com/{{repo}} {{target}}
  echo Done.

[private]
@green label:
  echo {{GREEN + ITALIC + label + NORMAL}}

[private]
@yellow label:
  echo {{YELLOW + ITALIC + label + NORMAL}}
