include:
  - .deps

etckeeper:
  pkg:
    - installed
    - require:
      - pkg: etckeeper_deps
  file.managed:
    - name: /etc/etckeeper/etckeeper.conf
    - source: salt://etckeeper/files/etckeeper.conf

etckeeper_initial_commit:
  cmd.run:
    - cwd: /etc
    - name: "/usr/bin/etckeeper init && /usr/bin/etckeeper commit 'Initial commit'"
    - require:
      - pkg: etckeeper
      - file: /etc/etckeeper/etckeeper.conf
    - unless: test -d /etc/.git

etckeeper_commit_at_start:
  cmd.run:
    - order: 0
    - cwd: /etc
    - name: 'if [ -n "$(git status --porcelain)" ]; then /usr/bin/etckeeper commit "Changes found prior to start of salt run #salt-start"; fi'
    - onlyif: 'test -d /etc/.git && test -n "$(git status --porcelain)"'

etckeeper_commit_at_end:
  cmd.run:
    - order: last
    - cwd: /etc
    - name: '/usr/bin/etckeeper commit "Changes made during salt run #salt-end"'
    - onlyif: 'test -d /etc/.git && test -n "$(git status --porcelain)"'

