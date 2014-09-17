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
    - name: "/usr/bin/etckeeper commit 'Start of Salt Run'"
    - onlyif: test -d /etc/.git

etckeeper_commit_at_end:
  cmd.run:
    - order: last
    - cwd: /etc
    - name: "/usr/bin/etckeeper commit 'End of Salt Run'"
    - onlyif: test -d /etc/.git

