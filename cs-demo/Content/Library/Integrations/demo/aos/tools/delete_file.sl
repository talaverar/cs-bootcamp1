########################################################################################################################
#!!
#! @input host: host RT
#! @input username: username RT
#! @input password: password RT
#! @input filename: filename RT
#!!#
########################################################################################################################
namespace: Integrations.demo.aos.tools
flow:
  name: delete_file
  inputs:
    - host: 10.0.46.100
    - username: root
    - password: admin@123
    - filename: install_java.sh
  workflow:
    - delete_file:
        do:
          io.cloudslang.base.ssh.ssh_command:
            - host: '${host}'
            - command: "${'cd '+get_sp('script_location')+' && rm -f '+filename}"
            - username: '${username}'
            - password:
                value: '${password}'
                sensitive: true
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      delete_file:
        x: 104
        y: 146
        navigate:
          d04ea992-198d-6ac8-6796-b44f88fe318e:
            targetId: 8503e2e5-bdd9-d976-16e6-4e8c74945069
            port: SUCCESS
    results:
      SUCCESS:
        8503e2e5-bdd9-d976-16e6-4e8c74945069:
          x: 443
          y: 136
