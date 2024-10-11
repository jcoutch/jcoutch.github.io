# Loading additional ISO's within Packer.io

**Author:** Joe
<br/>**Date:** 04/30/2015 10:04:00

So, while building some dev VM's, I needed to be able to install Visual Studio into some Vagrant base images using Packer. &nbsp;No one had a method to dynamically add an ISO during the provisioning process, so I thought, why not add another virtual DVD drive during the VM creation process?<div><br></div><div>This example demonstrates how to add an additional CD drive in both Parallels and VirtualBox. &nbsp;Since I don't use VMWare or HyperV, I don't have an example to provide, but I imagine the process would be similar:<br><div><br></div>

<pre class="brush: javascript;">      // For Parallels
      "prlctl": [
        ["set", "{{.Name}}", "--device-add", "cdrom", "--image", "./iso/en_visual_studio_professional_2013_with_update_4_x86_dvd_5935322.iso"]
      ]

      // For VirtualBox
      "vboxmanage": [
        [
          "storagectl",
          "{{.Name}}",
          "--name",
          "SataController",
          "--add",
          "sata",
          "--controller",
          "IntelAHCI"
        ],
        [
          "storageattach",
          "{{.Name}}",
          "--storagectl",
          "SataController",
          "--port",
          "0",
          "--device",
          "0",
          "--type",
          "dvddrive",
          "--medium",
          "./iso/en_visual_studio_professional_2013_with_update_4_x86_dvd_5935322.iso"
        ]
      ]
</pre>
You would then be able to start the installation via a standard provisioning script.
</div>
