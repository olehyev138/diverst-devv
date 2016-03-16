sudo su -

# either of the next two lines is needed to be able to access "localhost:9200" from the host os
echo "network.bind_host: 0" >> /etc/elasticsearch/elasticsearch.yml
echo "network.host: 0.0.0.0" >> /etc/elasticsearch/elasticsearch.yml

# enable cors (to be able to use Sense)
echo "http.cors.enabled: true" >> /etc/elasticsearch/elasticsearch.yml
echo "http.cors.allow-origin: /https?:\/\/localhost(:[0-9]+)?/" >> /etc/elasticsearch/elasticsearch.yml

# enable dynamic scripting
echo "script.inline: on" >> /etc/elasticsearch/elasticsearch.yml
echo "script.indexed: on" >> /etc/elasticsearch/elasticsearch.yml

# Install the Head plugin
/usr/share/elasticsearch/bin/plugin install mobz/elasticsearch-head