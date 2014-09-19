# vim: ft=yaml:ts=2:sw=2:expandtab

include:
  - buildenv

{% set build_dir = '/home/vagrant/build' %}
{% set source_dir = build_dir ~ '/sql-layer-adapter-odbc-2.0.0' %}
{% set download_path = 'https://github.com/FoundationDB/sql-layer-adapter-odbc/archive/v2.0.0.tar.gz' %}
{% set download_filename = 'sql-layer-odbc-v2.0.0.tar.gz' %}
{% set download_filepath = build_dir ~ '/' ~ download_filename %}
{% set artifact_name = 'fdb-sql-layer-odbcw.so' %}


fetch-source:
  cmd.run:
    - user: vagrant
    - group: vagrant
    - cwd: {{ build_dir  }}
    - name: wget -O sql-layer-odbc-v2.0.0.tar.gz {{ download_path }}
    - unless: "if [ -f {{ download_filepath }} ]; then true; else false; fi"
    - creates: {{ download_filepath }}
    - require:
      - sls: buildenv

tar-exists:
  file.exists:
    - name: {{ download_filepath }}

untar-source:
  cmd.run:
    - user: vagrant
    - group: vagrant
    - cwd: {{ build_dir }}
    - name: tar -xzf {{ download_filename }}
    - creates: {{ source_dir ~ "/" ~ 'autogen.sh' }}
    - unless: 'if [ -f {{ source_dir ~ "/autogen.sh" }} ]; then true; else false; fi'
    - require:
      - file: tar-exists

bootstrap:
  cmd.run:
    - user: vagrant
    - group: vagrant
    - cwd: {{ source_dir }}
    - name: autoreconf -i
    - unless: 'if [ -f {{ source_dir ~ "/configure" }} ]; then true; else false; fi'
    - require:
      - cmd: untar-source

/usr/bin/odbc_config:
  file.managed:
    - source: salt://files/odbc_config
    - user: root
    - group: root
    - mode: 755

configure:
  cmd.run:
    - user: vagrant
    - group: vagrant
    - name: ./configure --with-unixodbc --prefix=/usr/local
    - cwd: {{ source_dir  }}
    - unless: 'if [ -f {{ source_dir ~ "/Makefile" }} ]; then true; else false; fi'
    - creates: {{ source_dir ~ '/Makefile' }}
    - require:
      - cmd: bootstrap
      - file: /usr/bin/odbc_config

makke:
  cmd.run:
    - name: make -j`nproc`
    - cwd: {{ source_dir }}
    - user: vagrant
    - group: vagrant
    - unless: {{ 'if [ -f {{ source_dir ~ "/.libs/" ~ artifact_name }} ]; then true; else false; fi' }}
    - creates: {{ source_dir ~ '/.libs/' ~ artifact_name }}

