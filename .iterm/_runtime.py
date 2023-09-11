from datetime import datetime
from os.path import exists

from subprocess import getoutput
import iterm2

async def main(connection):
  app = await iterm2.async_get_app(connection)

  component = iterm2.StatusBarComponent(
    short_description='Runtime clock',
    detailed_description='clock monitoring time of running command.',
    knobs=[],
    exemplar='13:37',
    update_cadence=1,
    identifier='y_nk.runtime_clock'
  )

  @iterm2.StatusBarRPC
  async def tick(knobs):
    try:
      # access session
      window = app.current_terminal_window
      tab = window.current_tab
      session = app.get_session_by_id(tab.active_session_id)

      # get active tty
      tty = await session.async_get_variable('tty')

      # get frontend pid
      pid = getoutput(f"fuser {tty} 2> /dev/null | awk '{{print $2}}'")

      # pid not found
      if len(pid) == 0:
        return '(idle)'

      # uptime of the pid
      upt = getoutput(f"ps -eo pid,etime | grep {pid} | awk '{{print $2}}'")
      return upt

    except BaseException as ex:
      print(ex)
      return ''

  await component.async_register(connection, tick, timeout=2)

iterm2.run_forever(main)
