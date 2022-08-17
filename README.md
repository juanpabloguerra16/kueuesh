# Demo

Follow these suggested steps to observe the capabilities of queue:

1. To setup a cluster, run `./create_cluster.sh`
2. Start a pane to observe the status of each ClusterQueue:
    ```
    watch -n 2 kubectl get clusterqueue alpha-cq -o wide
    watch -n 2 kubectl get clusterqueue beta-cq -o wide
    ```
3. Create jobs in each namespace:

    ```
    ./create_jobs.sh alpha-job.yaml 3s
    ./create_jobs.sh beta-job.yaml 3s
    ```
4. Stop the script for the `beta` namespace. Once all the pending jobs from the
   namespace `beta` are processed, observe how more jobs from the namespace `alpha`
   are admitted.
5. Resume the script for the `beta` namespace.
6. Edit the `spot-cq` ClusterQueue to set `cohort: all`:
    ```
    kubectl edit clusterqueue spot-cq
    ```
7. Observe how admitted workloads spike for both `alpha-cq` and `beta-cq` with
   the added quota.
