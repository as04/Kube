<source>
  @type tail
  path /logs/*.log
  pos_file /tmp/fluentd.log.pos
  tag kubernetes.*
  read_from_head true
  <parse>
     @type none
  </parse>
</source>

<match kubernetes.**>
  @type stdout
</match>
