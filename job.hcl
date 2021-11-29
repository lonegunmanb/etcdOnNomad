job "docs" {
  datacenters = ["dc1"]
  group "etcd" {
    network {
      port "adport1" {
        static = 2379
      }
      port "adport2" {
        static = 4001
      }
      port initAdPeerPort {
        static = 2380
      }
    }
    task "etcd" {
      driver = "docker"

      config {
        image = "quay.io/coreos/etcd:v3.5.1"
        command = "/usr/local/bin/etcd"
        args  = [
          "-name", "etcd0",
          "-advertise-client-urls", "http://${NOMAD_IP_adport1}:2379,http://${NOMAD_IP_adport2}:4001",
          "-listen-client-urls", "http://0.0.0.0:2379,http://0.0.0.0:4001",
          "-initial-advertise-peer-urls", "http://${NOMAD_IP_initAdPeerPort}:2380",
          "-listen-peer-urls", "http://0.0.0.0:2380",
          "-initial-cluster-token", "etcd-cluster-1",
          "-initial-cluster", "etcd0=http://${NOMAD_IP_initAdPeerPort}:2380",
          "-initial-cluster-state", "new"
        ]
        network_mode = "host"
      }
    }
  }
}