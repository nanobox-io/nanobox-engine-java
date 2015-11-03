echo running tests for java
UUID=$(cat /proc/sys/kernel/random/uuid)

pass "unable to start the $VERSION container" docker run --privileged=true -d --name $UUID nanobox/build-java sleep 365d

defer docker kill $UUID

pass "unable to create code folder" docker exec $UUID mkdir -p /opt/code

fail "Detected something when there shouldn't be anything" docker exec $UUID bash -c "cd /opt/engines/java/bin; ./sniff /opt/code"

pass "Failed to inject java file" docker exec $UUID touch /opt/code/pom.xml

pass "Failed to detect Java" docker exec $UUID bash -c "cd /opt/engines/java/bin; ./sniff /opt/code"