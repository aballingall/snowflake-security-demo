# Snowflake Security Demo

## Prerequisites

### Python 3

If you don't have a recent version of python 3, follow [these instructions](https://opensource.com/article/19/5/python-3-default-mac) to install a modern version of python and set it as the default.

### Private Key for Snowflake

Create an encrypted RSA Key compatible with Snowflake. Instructions [here](https://docs.snowflake.com/en/user-guide/key-pair-auth.html).

### dbt Profile

Create a file `~/.dbt/profile.yml` to contain connection information for snowflake using the private key you generated above, containing:

```yml
dbtvault_snowflake_demo:
  target: dev
  outputs:
    dev:
      type: snowflake
      account: <account>.<region>.aws # e.g. RQ91142.eu-west-2.aws

      user: <snowflake user> # e.g. andyballingallvred 
      role: <ROLE> # e.g. SYSADMIN (just for this demo - not good practice generally)

      private_key_path: <path/to/private/key> # e.g. /Users/person/.ssh/id_rsa_sf_demo.p8
      private_key_passphrase: <passphrase> # e.g. peanuts

      database: DV_PROTOTYPE_DB
      warehouse: DV_PROTOTYPE_WH
      schema: DEMO
      threads: 1
      client_session_keep_alive: False
```

## First time install

After cloning, run:

```sh
make venv
```


### Resources:
- Learn more about dbt [in the docs](https://docs.getdbt.com/docs/introduction)
- Check out [Discourse](https://discourse.getdbt.com/) for commonly asked questions and answers
- Join the [chat](http://slack.getdbt.com/) on Slack for live discussions and support
- Find [dbt events](https://events.getdbt.com) near you
- Check out [the blog](https://blog.getdbt.com/) for the latest news on dbt's development and best practices
