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

