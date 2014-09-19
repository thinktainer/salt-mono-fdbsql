# vim: ft=yaml:ts=2:sw=2:expandtab

{% set build_dir = '/home/vagrant/build' %}
{% set source_dir = build_dir ~ '/sql-layer-adapter-odbc-2.0.0' %}
{% set artifact_name = 'fdb-sql-layer-odbcw.so' %}

include:
  - build-odbc

makeinstall:
  cmd.run:
    - cwd: {{ source_dir }}
    - user: root
    - unless: 'if [ -f {{ "/usr/local/lib/" ~ artifact_name }} ]; then true; else false; fi'
    - creates: {{ '/usr/local/lib/' ~ artifact_name }}
    - name: make install
    - require:
      - sls: build-odbc

/etc/odbc.ini:
  file.managed:
    - source: salt://files/odbc.ini
    - user: root
    - group: root
    - mode: 644

