Notes for sample exam 1:

Task 6:
* The NetworkPolicy has to be named `lab156pol`. This is only mentioned in the solution video, not in the `Questions Overview` that is meant to be used in the sample exam.
* The task only says to access the Pod and doesn't mention a Service (i.e. you could test access via the Pod IP). But you need to create a Service, or the grading script fails with this rather cryptic message: `podSelector is not set correctly in the NetworkPolicy`.

Task 11:
* The task asks you to remove the node restriction (the taint) after verifying it works. If you do that, the grading script fails this task because `the taint isn't functional`. So don't remove the taint until after you have run the grading script.


Notes for sample exam 2:

Task 3:
* What the `Questions Overview` doesn't tell you: the nginx container has to be named exactly `nginx`. If you name it differently (e.g. `nginx-sidecar`), the grading script FAILs.

Task 6:
* You need to write the name of the Pod that uses the most CPU to the file `/tmp/load.txt`. Unfortunately the `Questions Overview` doesn't tell you, so you get a FAIL.

Task 7:
* If you use affinity instead of a nodeSelector, the grading script FAILs, even though the behaviour is the same.

Task 8:
* The `Questions Overview` tells you to create a Service called `lab168svc`, but the proposed solution in `Configuring Ingress` names the Service `lab168pod` instead.
* The grading script labs/exam2-task8.sh requires *two* Services, one called `lab168svc` and the other `lab168pod`, otherwise you FAIL. This doesn't make any sense.

Task 9:
* If you do as told in the `Questions Overview`, the grading script FAILs with "Node was not reset to normal operational state", which is something you were not asked to do.
* You always get the FAIL `Cannot find any node drain events in the node logs`. The grading script looks for those events in the output of `kubectl describe`, but (for me on k8s 1.37) the events only show up in `kubectl events`.
* This task is funny: you always FAIL, but you get more points if you do nothing than if you solve it.
