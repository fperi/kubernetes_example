# This script is simpling calling many many times one of the enpoints
# exposed by k8s to test the autoscaling of the pods
for i in {1..5000}
do
  curl -d "[$i,$i+1]" -X POST http://localhost:30001/sum_list
done
