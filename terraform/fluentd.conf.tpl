<source>
  @type tail
  path /logs/*.log
  pos_file /var/log/fluentd.log.pos
  tag kubernetes.*
  read_from_head true
  <parse>
    @type regexp
    expression /^(?<time>[^ ]*) - (?<severity>[^ ]*) - (?<message>.*)$/
    time_format %Y-%m-%d %H:%M:%S,%L
  </parse>
</source>

<match kubernetes.**>
  @type stdout
</match>
