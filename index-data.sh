echo "Creating index settings and mappings"
curl -k -X PUT -u admin  "https://localhost:9200/bbuy_products" -H 'Content-Type: application/json' -d @/workspace/search_with_machine_learning_course/opensearch/bbuy_products.json
curl -k -X PUT -u admin  "https://localhost:9200/bbuy_queries" -H 'Content-Type: application/json' -d @/workspace/search_with_machine_learning_course/opensearch/bbuy_queries.json

cd /workspace/logstash/logstash-7.13.2/
echo "Launching Logstash indexing in the background via nohup.  See product_indexing.log and queries_indexing.log for log output"
echo "Cleaning up any old indexing information by deleting products_data.  If this is the first time you are running this, you might see an error."
rm -rf /workspace/logstash/logstash-7.13.2/products_data
nohup bin/logstash --pipeline.workers 1 --path.data ./products_data -f /workspace/search_with_machine_learning_course/logstash/index-bbuy.logstash > product_indexing.log &
echo "Cleaning up any old indexing information by deleting query_data.  If this is the first time you are running this, you might see an error."
rm -rf /workspace/logstash/logstash-7.13.2/query_data
nohup bin/logstash --pipeline.workers 1 --path.data ./query_data -f /workspace/search_with_machine_learning_course/logstash/index-bbuy-queries.logstash > queries_indexing.log &