########################################################################################################################
#!!
#! @input host: host RT
#! @input username: username RT
#! @input password: password RT
#! @input url: the url
#!!#
########################################################################################################################
namespace: Integrations.demo.aos.sub_flows
flow:
  name: remote_copy
  inputs:
    - host: 10.0.46.100
    - username: root
    - password: admin@123
    - url: 'http://vmdocker.hcm.demo.local:36980/job/AOS-repo/ws/install_java.sh'
  workflow:
    - extract_filename:
        do:
          io.cloudslang.demo.aos.tools.extract_filename:
            - url: '${url}'
        publish:
          - filename
        navigate:
          - SUCCESS: get_file
          - FAILURE: on_failure
    - remote_secure_copy:
        do:
          io.cloudslang.base.remote_file_transfer.remote_secure_copy:
            - source_path: '${filename}'
            - destination_host: '${host}'
            - destination_path: /tmp
            - destination_username: '${username}'
            - destination_password:
                value: '${password}'
                sensitive: true
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
    - get_file:
        do:
          io.cloudslang.base.http.http_client_action:
            - url: '${url}'
            - destination_file: '${filename}'
            - method: GET
        navigate:
          - SUCCESS: remote_secure_copy
          - FAILURE: on_failure
  outputs:
    - filename: '${filename}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      extract_filename:
        x: 203
        y: 68
      get_file:
        x: 219
        y: 281
      remote_secure_copy:
        x: 417
        y: 274
        navigate:
          decf7156-f10b-2c48-efc9-d424b799bd06:
            targetId: f55b9196-30bc-7340-4226-0dec348785cf
            port: SUCCESS
    results:
      SUCCESS:
        f55b9196-30bc-7340-4226-0dec348785cf:
          x: 408
          y: 96
