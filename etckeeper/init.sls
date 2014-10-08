include:
  - .deps

etckeeper:
  pkg:
    - installed
    - require:
      - pkg: etckeeper_deps

/etc/etckeeper:
  file:
    - directory
    - clean: True
    - mode: 0755
    - owner: root
    - group: root
    - require:
      - pkg: etckeeper

/etc/etckeeper/etckeeper.conf:
  file:
    - managed
    - source: salt://etckeeper/files/etckeeper.conf
    - mode: 0644
    - owner: root
    - group: root

{% set subdirs = [
    'pre-install.d',
    'post-install.d',
    'init.d',
    'uninit.d',
    'unclean.d',
    'update-ignore.d',
    'pre-commit.d',
    'commit.d',
    'vcs.d',
    'list-installed.d'
    ]
%}

{% for subdir in subdirs %}
/etc/etckeeper/{{subdir}}:
  file:
    - recurse
    - source: salt://etckeeper/files/{{subdir}}
    - clean: True
    - dir_mode: 0755
    - file_mode: 0755
    - exclude_pat: README
    - owner: root
    - group: root
    - require:
       - pkg: etckeeper
{% endfor %}

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
    - name: '/usr/bin/etckeeper commit "Changes found prior to start of salt run #salt-start"'
    - onlyif: 'test -d /etc/.git && test -n "$(git status --porcelain)"'

etckeeper_commit_at_end:
  cmd.run:
    - order: last
    - cwd: /etc
    - name: '/usr/bin/etckeeper commit "Changes made during salt run #salt-end"'
    - onlyif: 'test -d /etc/.git && test -n "$(git status --porcelain)"'

