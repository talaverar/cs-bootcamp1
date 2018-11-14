########################################################################################################################
#!!
#! @input host: host RT
#! @input username: username RT
#! @input password: password RT
#! @input artifact_url: artifact url RT
#! @input script_url: script url RT
#! @input parameters: parameters RT
#!!#
########################################################################################################################
namespace: Integrations.demo.aos.sub_flows
flow:
  name: initialize_artifact
  inputs:
    - host
    - username
    - password
    - artifact_url:
        required: false
    - script_url
    - parameters:
        required: false
  workflow:
    - is_artifact_given:
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${artifact_url}'
        navigate:
          - SUCCESS: copy_script
          - FAILURE: copy_artifact
    - copy_artifact:
        do:
          Integrations.demo.aos.sub_flows.remote_copy: []
        navigate:
          - SUCCESS: copy_script
          - FAILURE: on_failure
    - copy_script:
        do:
          Integrations.demo.aos.sub_flows.remote_copy: []
        navigate:
          - SUCCESS: execute_script
          - FAILURE: on_failure
    - execute_script:
        do:
          io.cloudslang.base.ssh.ssh_command: []
        navigate:
          - SUCCESS: delete_script
          - FAILURE: delete_script
    - delete_script:
        do:
          Integrations.demo.aos.tools.delete_file: []
        navigate:
          - SUCCESS: has_failed
          - FAILURE: on_failure
    - has_failed:
        do:
          io.cloudslang.base.utils.is_true:
            - bool_value: "str(command_return_code == '0')"
        navigate:
          - 'TRUE': SUCCESS
          - 'FALSE': FAILURE
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      is_artifact_given:
        x: 326
        y: 79
      copy_artifact:
        x: 95
        y: 221
      copy_script:
        x: 482
        y: 218
      execute_script:
        x: 81
        y: 387
      delete_script:
        x: 374
        y: 390
      has_failed:
        x: 591
        y: 374
        navigate:
          89fa4882-40a6-cbbc-f428-d74a841950d5:
            targetId: 0147fcaf-f273-5626-6ef2-0c4bd661badc
            port: 'FALSE'
          b7cb4d07-3b87-d380-f780-64f5f9ea2f87:
            targetId: b8916813-a544-87dd-656e-2b01a3d7e78a
            port: 'TRUE'
    results:
      SUCCESS:
        b8916813-a544-87dd-656e-2b01a3d7e78a:
          x: 776
          y: 294
      FAILURE:
        0147fcaf-f273-5626-6ef2-0c4bd661badc:
          x: 786
          y: 470
