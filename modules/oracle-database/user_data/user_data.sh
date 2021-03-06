#!/usr/bin/env bash
set -x

yum install -y wget git python-pip
pip install -U pip
pip install ansible

cat << EOF > ~/getcreds
#!/usr/bin/env bash

PARAM=\$(aws ssm get-parameters \
--region eu-west-2 \
--with-decryption --name \
"/${route53_sub_domain}/${project_name}/${app_name}-database/db/oradb_sys_password" \
"/${route53_sub_domain}/${project_name}/${app_name}-database/db/oradb_system_password" \
"/${route53_sub_domain}/${project_name}/${app_name}-database/db/oradb_dbsnmp_password" \
"/${route53_sub_domain}/${project_name}/${app_name}-database/db/oradb_asmsnmp_password" \
--query Parameters)
export oradb_sys_password="\$(echo \$PARAM | jq '.[] | select(.Name | test("oradb_sys_password")) | .Value' --raw-output)"
export oradb_system_password="\$(echo \$PARAM | jq '.[] | select(.Name | test("oradb_system_password")) | .Value' --raw-output)"
export oradb_dbsnmp_password="\$(echo \$PARAM | jq '.[] | select(.Name | test("oradb_dbsnmp_password")) | .Value' --raw-output)"
export oradb_asmsnmp_password="\$(echo \$PARAM | jq '.[] | select(.Name | test("oradb_asmsnmp_password")) | .Value' --raw-output)"

EOF
chmod u+x ~/getcreds

# get ssm parameters for bootstrap ansible
. ~/getcreds

# log bootstrap after creds obtained
touch /var/log/user-data.log
chmod 600 /var/log/user-data.log
exec > >(tee /var/log/user-data.log|logger -t user-data ) 2>&1

echo BEGIN
date '+%Y-%m-%d %H:%M:%S'

cat << EOF >> /etc/environment
export HMPPS_ROLE="${app_name}"
export HMPPS_FQDN="${server_name}.${private_domain}"
export HMPPS_STACKNAME=${env_identifier}
export HMPPS_STACK="${short_env_identifier}"
export HMPPS_ENVIRONMENT="${route53_sub_domain}"
export HMPPS_ACCOUNT_ID="${account_id}"
export HMPPS_DOMAIN="${private_domain}"
export S3_ORACLEDB_BACKUPS_ARN="${s3_oracledb_backups_arn}"
export DEPENDENCIES_BUCKET_ARN="${dependencies_bucket_arn}"
export INSTANCE_ID="`curl http://169.254.169.254/latest/meta-data/instance-id`"
export REGION="${region}"
export APPLICATION="${application}"
EOF
## Ansible runs in the same shell that has just set the env vars for future logins so it has no knowledge of the vars we've
## just configured, so lets export them
export HMPPS_ROLE="${app_name}"
export HMPPS_FQDN="${server_name}.${private_domain}"
export HMPPS_STACKNAME="${env_identifier}"
export HMPPS_STACK="${short_env_identifier}"
export HMPPS_ENVIRONMENT="${route53_sub_domain}"
export HMPPS_ACCOUNT_ID="${account_id}"
export HMPPS_DOMAIN="${private_domain}"
export S3_ORACLEDB_BACKUPS_ARN="${s3_oracledb_backups_arn}"
export DEPENDENCIES_BUCKET_ARN="${dependencies_bucket_arn}"
export INSTANCE_ID="`curl http://169.254.169.254/latest/meta-data/instance-id`"
export REGION="${region}"
export APPLICATION="${application}"

cat << EOF > ~/requirements.yml
---

- name: bootstrap
  src: https://github.com/ministryofjustice/hmpps-bootstrap
  version: centos
- name: users
  src: singleplatform-eng.users
- name: oracle-db
  src: https://github.com/ministryofjustice/hmpps-delius-core-oracledb-bootstrap.git
- name: oracle-db-patches
  src: https://github.com/ministryofjustice/hmpps-oracle-database-patches.git
- name: oracle-db-parameters
  src: https://github.com/ministryofjustice/hmpps-oracle-database-parameters.git 
- name: oracle-db-autotasks
  src: https://github.com/ministryofjustice/hmpps-oracle-database-autotasks.git 
EOF
cat << EOF > ~/requirements_db.yml
---
- name: oracle-db
  src: https://github.com/ministryofjustice/hmpps-delius-core-oracledb-bootstrap.git
- name: oracle-db-patches
  src: https://github.com/ministryofjustice/hmpps-oracle-database-patches.git 
- name: oracle-db-parameters
  src: https://github.com/ministryofjustice/hmpps-oracle-database-parameters.git 
- name: oracle-db-autotasks
  src: https://github.com/ministryofjustice/hmpps-oracle-database-autotasks.git 
EOF

/usr/bin/curl -o ~/users.yml https://raw.githubusercontent.com/ministryofjustice/hmpps-delius-ansible/master/group_vars/${bastion_inventory}.yml

cat << EOF > ~/vars.yml
region: "${region}"

service_user_name: "${service_user_name}"
database_global_database_name: "${database_global_database_name}"
database_sid: "${database_sid}"
database_characterset: "${database_characterset}"
oracle_dbca_template_file: "${oracle_dbca_template_file}"

database_type: "${database_type}"
s3_oracledb_backups_arn: "${s3_oracledb_backups_arn}"
dependencies_bucket_arn: "${dependencies_bucket_arn}"
database_bootstrap_restore: "${database_bootstrap_restore}"
database_backup: "${database_backup}"
database_backup_sys_passwd: "${database_backup_sys_passwd}"
database_backup_location: "${database_backup_location}"
asm_disks_quantity: "${asm_disks_quantity}"
# These values are to be updated when the are injected and pulled from paramstore, consumed by oradb bootstrap
# oradb_sys_password
# oradb_system_password
# oradb_dbsnmp_password
# oradb_asmsnmp_password

# For user_update cron
remote_user_filename: "${bastion_inventory}"

EOF
cat << EOF > ~/bootstrap_users.yml
---

- hosts: localhost
  vars_files:
   - "{{ playbook_dir }}/vars.yml"
   - "{{ playbook_dir }}/users.yml"
  roles:
     - bootstrap
     - users
     - oracle-db
EOF
cat << EOF > ~/bootstrap_db.yml
---
- hosts: localhost
  vars_files:
   - "{{ playbook_dir }}/vars.yml"
   - "{{ playbook_dir }}/users.yml"
  roles:
     - oracle-db
EOF
cat << EOF > ~/runboot.sh
#!/usr/bin/env bash

. ~/getcreds

export ANSIBLE_LOG_PATH=\$HOME/.ansible.log
ansible-galaxy install -f -r ~/requirements_db.yml
ansible-playbook ~/bootstrap_db.yml \
--extra-vars "{\
'oradb_sys_password':'\$oradb_sys_password', \
'oradb_system_password':'\$oradb_system_password', \
'oradb_dbsnmp_password':'\$oradb_dbsnmp_password', \
'oradb_asmsnmp_password':'\$oradb_asmsnmp_password', \
}" \
-vvvv
EOF
chmod u+x ~/runboot.sh

export ANSIBLE_LOG_PATH=$HOME/.ansible.log

ansible-galaxy install -f -r ~/requirements.yml
CONFIGURE_SWAP=true SELF_REGISTER=true ansible-playbook ~/bootstrap_users.yml \
--extra-vars "{\
'oradb_sys_password':'$oradb_sys_password', \
'oradb_system_password':'$oradb_system_password', \
'oradb_dbsnmp_password':'$oradb_dbsnmp_password', \
'oradb_asmsnmp_password':'$oradb_asmsnmp_password', \
}" \
-v

if [[ $? -eq 0 ]]
then
    ## allow Ansible jobs polling for readyness time to disconnect
   /sbin/shutdown -r +1 "Rebooting in 1 minute"
fi
