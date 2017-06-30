chef-cups
=========

[![Supermarket](http://img.shields.io/cookbook/v/cups.svg)][1]
[![Build Status](https://travis-ci.org/artem-sidorenko/chef-cups.svg?branch=master)][2]
[![Dependencies](http://img.shields.io/gemnasium/artem-sidorenko/chef-cups.svg)][4]

Installs the cups package, if needed, starts the cups service, and configures printers on target systems.

Attributes
----------

### cups::default

| Key                                | Type    | Default     | Description                                |
| ---------------------------------- | ------- | ----------- | ------------------------------------------ |
| ['cups']['printers']               | array   | []          | List of printers to configure on the system. See example in the usage section below. |
| ['cups']['systemgroups']           | string  | sys root    | Defines authorized system-group users in /etc/cups/cupsd.conf file. |
| ['cups']['share_printers']         | array   | ['@LOCAL']  | ACLs for printer access                    |
| ['cups']['require_encryption']     | boolean | false       | Should cups require SSL/TLS for client communication?  This requires both `['cups']['cert_file']` and `['cups']['key_file']` to be set. |
| ['cups']['cert_file']              | string  | nil         | The full path to the SSL certificate file to be used by cups. **Note:** if an intermediate certificate is required by the issuing certificate authority, the intermediate certificate must be appended to the server certificate file as cups does not support separate intermediate and certificate files. |
| ['cups']['key_file']               | string  | nil         | The full path to the SSL key file to be used by cups. |
| ['cups']['server_aliases']         | array   | []          | List of allowed domains for remote administration |
| ['cups']['require_authentication'] | boolean | false       | Specifies whether authentication is required to access the CUPS website and printers. |

### cups::default_printer

| Key                                | Type    | Default     | Description                                |
| ---------------------------------- | ------- | ----------- | ------------------------------------------ |
| ['cups']['default_printer']        | string  | nil         | Sets the system-wide default printer.      |

Usage
-----

### cups::default

Include `cups` in your node's `run_list`:

```json
{
  "name":"my_node",
  "run_list": [
    "recipe[cups]"
  ]
}
```

SAMPLE format for printer entries:

```json
"cups": {
  "printers": [
    {
      "printer1": {
        "uri": "lpd://FQDN",
        "desc": "HP LaserJet xx",
        "model": "textonly.ppd",    #textonly.ppd is set as the default by the recipe.
        "location": "Front Office"
      }
    },
    {
      "printer2": {
        "uri": "lpd://xxx.xxx.xxx.xxx"
      }
    },
    {
      "printer3": {
        "uri": "lpd://myprinter.mydomain"
      }
    }
  ]
}
```

#### Data bags

Set the attribute `node['cups']['printer_bag']` to the name of your data bag.

Data bag entries use this format:

```json
{
  "id": "printer1",
  "model": "textonly.ppd",
  "uri": "lpd://FQDN",
  "location": "Front Office",
  "desc": "HP LaserJet xx"
}
```

### cups::airprint

Configures CUPS to advertise printers via AirPrint.

### cups::default_printer

Sets the system-wide default printer (via the `node['cups']['default_printer']` attribute).

**CAUTION** -- in its current form, this will completely overwrite the /etc/cups/lpoptions file.

Thirdparty
----------

This cookbook includes [airprint-generate](https://github.com/tjfontaine/airprint-generate/blob/master/airprint-generate.py) script from [tjfontaine](https://github.com/tjfontaine), which is licended under MIT.

Contributing
------------

1. Fork the repository on Github
2. Create a named feature branch (like `add_component_x`)
3. Write you change
4. Write tests for your change (if applicable)
5. Run the tests, ensuring they all pass
6. Submit a Pull Request using Github

License and authors
-------------------

 Copyright 2015-2017, Biola University

 Copyright 2017, Artem Sidorenko and contributors

 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at

 http://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.

[1]: https://supermarket.getchef.com/cookbooks/cups
[2]: https://travis-ci.org/artem-sidorenko/chef-cups
[4]: https://gemnasium.com/artem-sidorenko/chef-cups
