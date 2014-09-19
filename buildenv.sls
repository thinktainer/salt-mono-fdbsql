# vim: ft=yaml:ts=2:sw=2:expandtab

custompkgs:
  pkg.installed:
    - pkgs:
      - vim
      - zsh

buildpkgs:
  pkg.installed:
    - pkgs:
      - autoconf
      - git
      - build-essential
      - shtool
      - libtool
      - unixodbc
      - unixodbc-dev
      - libpq-dev

chsh:
  cmd.run:
    - user: root
    - unless: "if [ $(getent passwd vagrant | awk -F: '{print $NF}') = `which zsh` ]; then true; else false; fi"
    - name: chsh -s `which zsh` vagrant
    - require:
      - pkg: custompkgs

get-purezsh:
  cmd.run:
    - creates: /usr/local/share/zsh/site-functions/prompt_pure_setup
    - unless: "if [ -f /usr/local/share/zsh/site-functions/prompt_pure_setup ]; then true; else false; fi"
    - name: wget -O prompt_pure_setup https://github.com/sindresorhus/pure/raw/master/pure.zsh
    - user: vagrant
    - cwd: /usr/local/share/zsh/site-functions
    - user: root
    - require:
      - pkg: custompkgs

/home/vagrant/.zshrc:
  file.managed:
    - user: vagrant
    - group: vagrant
    - mode: 640
    - source: salt://files/zshrc

/home/vagrant/conn.fs:
  file.managed:
    - user: vagrant
    - group: vagrant
    - mode: 644
    - source: salt://files/conn.fs

