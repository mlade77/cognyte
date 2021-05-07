#!/bin/bash
vms=(vm1 vm2)
host_ports=(10001 10002)

test_ports_inside_guest () {
    vagrant ssh $1 -c "sudo lsof -i :80" > /dev/null 2>&1
    status="$?"
    if [[ $status != 0 ]]; then
        echo "Nothing is listening on port 80 on "$1""
        exit 1
    else
        echo "httpd service is listening on port 80 on "$1""
    fi
}

test_port_map () {
    netstat -alnp | grep $1 > /dev/null 2>&1
    status="$?"
    if [[ $status != 0 ]]; then
        echo "Port "$1" is not mapped - nothing is listening on it"
        exit 1
    else
        echo "Map port "$1" to localhost is ok"
    fi
}

test_service () {
    vagrant ssh $1 -c "sudo systemctl status httpd" > /dev/null 2>&1
    status="$?"
    if [[ $status != 0 ]]; then
        echo "httpd service is no running on "$1""
        exit 1
    else
        echo "httpd service is running on "$1""
    fi
}

test_lb_web () {
    web_vm=$(curl -s localhost | grep -o 'vm.')
    if [[ -z $web_vm ]]; then
        echo "None of the web servers behind loadbalancer replies"
        exit 1
    else
        iter="$web_vm"
        a=0
            while [[ "$web_vm" == "$iter" ]] && [[ "$a" -le 10 ]]; do 
                iter=$(curl -s localhost | grep -o 'vm.')
                if [[ "$web_vm" != "$iter" ]] && [[ ! -z "$iter" ]] ; then
                    echo "Both Web servers, "$web_vm" and "$iter" are working"
                    break
                else
                    a=$(($a+1))
                    echo "Web server "$iter" is working. Trying the other one..."
                fi
                sleep 3
            done
    fi
}

for i in ${vms[@]}; do
    test_service $i
    test_ports_inside_guest $i
done

for i in ${host_ports[@]}; do
    test_port_map $i
done

test_lb_web