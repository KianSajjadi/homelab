let
  kian-wsl = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFRpUd/ZkFdn1A5P2m1uoTvOmNz8LZOzth6rNlIV55lm kian@kian-pc";
  linux-server = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINJhJu2Ex2nRgRR7Ns4RJ+/Qt3q6SXHNHAxeoApEmv5K kian@linux-server";
  homelab-node-0 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILcOJeX+jtirabJd8qI4yM6GC0D/prZBCeHvEb2NZdaY kian@homelab-node-0";
  homelab-node-1 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKyHuT7d4qbMefm1amUYupRoGCafyTAeBAW+KhWQfUS+ kian@homelab-node-1";
  users = [ kian-wsl ];
  systems = [ homelab-node-0 homelab-node-1 linux-server];
in
{
  "k3s-token.age".publicKeys = users ++ systems;
  "k3s-url.age".publicKeys = users ++ systems;
}