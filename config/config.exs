# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

config :pw_demo, target: Mix.target()

# Customize non-Elixir parts of the firmware. See
# https://hexdocs.pm/nerves/advanced-configuration.html for details.

config :nerves, :firmware, rootfs_overlay: "rootfs_overlay"

# Use shoehorn to start the main application. See the shoehorn
# docs for separating out critical OTP applications such as those
# involved with firmware updates.

config :shoehorn,
  init: [:nerves_runtime, :nerves_init_gadget],
  app: Mix.Project.config()[:app]

# Use Ringlogger as the logger backend and remove :console.
# See https://hexdocs.pm/ring_logger/readme.html for more information on
# configuring ring_logger.

config :logger, backends: [RingLogger]

config :nerves_init_gadget,
  mdns_domain: "pw_demo.local",
  node_name: "rpi",
  node_host: :mdns_domain,
  # ifname: "usb0",
  # address_method: :dhcpd

  # To use wired Ethernet:
  # ifname: "eth0",
  # address_method: :dhcp

  # To use WiFi:
  ifname: "wlan0",
  address_method: :dhcp

# Configure wireless settings
key_mgmt = System.get_env("NERVES_NETWORK_KEY_MGMT") || "WPA-PSK"

config :nerves_network, :default,
  wlan0: [
    ssid: System.get_env("SSID_HOME"),
    psk: System.get_env("PSK_HOME"),
    key_mgmt: String.to_atom(key_mgmt)
  ]

config :nerves_firmware_ssh,
  authorized_keys: [
    File.read!(Path.join(System.user_home!, ".ssh/id_rsa.pub"))
  ]

if Mix.target() != :host do
  import_config "target.exs"
end
