include:
  - bootstrap

etckeeper:

  pkg:
    - installed
    - require:
      - pkg: git

  file.managed:
    - name: /etc/etckeeper/etckeeper.conf
    - source: salt://minions/base/files/etckeeper.conf

  cmd:
    - run
    - cwd: /etc
    - name: "/usr/bin/etckeeper init && /usr/bin/etckeeper commit 'Initial commit'"
    - require:
      - pkg: etckeeper
      - file: /etc/etckeeper/etckeeper.conf
    - unless: test -d /etc/.git

  cmd:
    - run
    - order: 0
    - cwd: /etc
    - name: "/usr/bin/etckeeper commit 'Start of Salt Run'"
    - onlyif: test -d /etc/.git

  cmd:
    - run
    - order: last
    - cwd: /etc
    - name: "/usr/bin/etckeeper commit 'End of Salt Run'"
    - onlyif: test -d /etc/.git

